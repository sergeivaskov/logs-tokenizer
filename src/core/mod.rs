use regex::Regex;
use std::collections::HashMap;
use once_cell::sync::Lazy;

const BASE62: &[u8] = b"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

// Pre-compile static regexes for one-off passes
static RE_TAGS: Lazy<Regex>          = Lazy::new(|| Regex::new(r"(#(?:T|[0-9a-zA-Z]+)#|![0-9]+!)").unwrap());

static RE_ZEROS_1: Lazy<Regex>       = Lazy::new(|| Regex::new(r"\b0{3,}([1-9A-Fa-f][0-9A-Fa-f]*\b)").unwrap());
static RE_ZEROS_2: Lazy<Regex>       = Lazy::new(|| Regex::new(r"\b0{3,}(0\b)").unwrap());
static RE_ZEROS_3: Lazy<Regex>       = Lazy::new(|| Regex::new(r"(\b0x)0{3,}([1-9A-Fa-f][0-9A-Fa-f]*\b)").unwrap());
static RE_ZEROS_4: Lazy<Regex>       = Lazy::new(|| Regex::new(r"(\b0x)0{3,}(0\b)").unwrap());

static RE_TS: Lazy<Regex>            = Lazy::new(|| Regex::new(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:").unwrap());
static RE_COMP: Lazy<Regex>          = Lazy::new(|| Regex::new(r"\[[A-Za-z0-9_-]+\]").unwrap());
static RE_KEYS: Lazy<Regex>          = Lazy::new(|| Regex::new(r"\b[A-Za-z0-9_]+={1,2}").unwrap());
static RE_NO_TIME: Lazy<Regex>       = Lazy::new(|| Regex::new(r"^#T#\d{2}\.\d{3}\s*").unwrap());

pub struct Compressor {
    var_idx: usize,
    meta_idx: usize,
    macro_idx: usize,
    legend: Vec<String>,
}

fn is_word_char(c: char) -> bool {
    c.is_ascii_alphanumeric() || c == '_'
}

fn fast_replace_word_bounded(text: &str, phrase: &str, token: &str) -> String {
    if phrase.is_empty() {
        return text.to_string();
    }
    
    let mut result = String::with_capacity(text.len());
    let mut last_end = 0;
    
    let phrase_starts_word = phrase.chars().next().map_or(false, is_word_char);
    let phrase_ends_word = phrase.chars().last().map_or(false, is_word_char);

    let mut start_idx = 0;
    while let Some(idx) = text[start_idx..].find(phrase) {
        let absolute_idx = start_idx + idx;
        let end_idx = absolute_idx + phrase.len();
        
        let mut valid = true;
        if phrase_starts_word {
            if let Some(prev_char) = text[..absolute_idx].chars().next_back() {
                if is_word_char(prev_char) { valid = false; }
            }
        }
        if valid && phrase_ends_word {
            if let Some(next_char) = text[end_idx..].chars().next() {
                if is_word_char(next_char) { valid = false; }
            }
        }
        
        if valid {
            result.push_str(&text[last_end..absolute_idx]);
            result.push_str(token);
            last_end = end_idx;
            start_idx = end_idx;
        } else {
            start_idx = absolute_idx + phrase.chars().next().unwrap().len_utf8();
        }
    }
    result.push_str(&text[last_end..]);
    result
}

trait BpeStrategy {
    fn tokenize<'a>(&self, text: &'a str) -> Vec<&'a str>;
    fn split_text<'a>(&self, text: &'a str) -> Vec<&'a str>;
    fn max_n(&self) -> usize;
    fn min_trim_len(&self) -> usize;
    fn requires_hash(&self) -> bool;
    fn tag_len(&self, compressor: &Compressor) -> usize;
    fn next_token(&self, compressor: &mut Compressor) -> String;
    fn replace_text(&self, text: &str, phrase: &str, token: &str) -> String;
}

struct NormalBpe;
impl BpeStrategy for NormalBpe {
    fn tokenize<'a>(&self, text: &'a str) -> Vec<&'a str> {
        let mut tokens = Vec::new();
        let bytes = text.as_bytes();
        let mut i = 0;
        while i < bytes.len() {
            let is_alnum = bytes[i].is_ascii_alphanumeric() || bytes[i] == b'_';
            let mut j = i + 1;
            while j < bytes.len() && (bytes[j].is_ascii_alphanumeric() || bytes[j] == b'_') == is_alnum {
                j += 1;
            }
            tokens.push(&text[i..j]);
            i = j;
        }
        tokens
    }

    fn split_text<'a>(&self, text: &'a str) -> Vec<&'a str> {
        let mut parts = Vec::new();
        let mut last_end = 0;
        let bytes = text.as_bytes();
        let mut i = 0;
        while i < bytes.len() {
            if bytes[i] == b'#' {
                let mut j = i + 1;
                if j < bytes.len() && bytes[j] == b'T' {
                    j += 1;
                } else {
                    while j < bytes.len() && bytes[j].is_ascii_alphanumeric() { j += 1; }
                }
                if j < bytes.len() && bytes[j] == b'#' && j > i + 1 {
                    parts.push(&text[last_end..i]);
                    last_end = j + 1;
                    i = j + 1;
                    continue;
                }
            }
            i += 1;
        }
        parts.push(&text[last_end..]);
        parts
    }

    fn max_n(&self) -> usize { 20 }
    fn min_trim_len(&self) -> usize { 4 }
    fn requires_hash(&self) -> bool { false }
    fn tag_len(&self, compressor: &Compressor) -> usize {
        let mut n = compressor.var_idx;
        let mut len = 0;
        if n == 0 { len = 1; }
        while n > 0 { len += 1; n /= 62; }
        len + 2
    }
    fn next_token(&self, compressor: &mut Compressor) -> String {
        compressor.get_next_token()
    }
    fn replace_text(&self, text: &str, phrase: &str, token: &str) -> String {
        let mut new_text = String::with_capacity(text.len());
        let mut last_end = 0;
        let bytes = text.as_bytes();
        let mut i = 0;
        while i < bytes.len() {
            if bytes[i] == b'#' {
                let mut j = i + 1;
                if j < bytes.len() && bytes[j] == b'T' {
                    j += 1;
                } else {
                    while j < bytes.len() && bytes[j].is_ascii_alphanumeric() { j += 1; }
                }
                if j < bytes.len() && bytes[j] == b'#' && j > i + 1 {
                    let part = &text[last_end..i];
                    new_text.push_str(&fast_replace_word_bounded(part, phrase, token));
                    new_text.push_str(&text[i..=j]);
                    last_end = j + 1;
                    i = j + 1;
                    continue;
                }
            }
            i += 1;
        }
        new_text.push_str(&fast_replace_word_bounded(&text[last_end..], phrase, token));
        new_text
    }
}

struct MetaBpe;
impl BpeStrategy for MetaBpe {
    fn tokenize<'a>(&self, text: &'a str) -> Vec<&'a str> {
        let mut tokens = Vec::new();
        let bytes = text.as_bytes();
        let mut i = 0;
        while i < bytes.len() {
            if bytes[i] == b'#' {
                let mut j = i + 1;
                while j < bytes.len() && bytes[j].is_ascii_alphanumeric() { j += 1; }
                if j < bytes.len() && bytes[j] == b'#' {
                    tokens.push(&text[i..=j]);
                    i = j + 1;
                    continue;
                }
            } else if bytes[i] == b'!' {
                let mut j = i + 1;
                while j < bytes.len() && bytes[j].is_ascii_digit() { j += 1; }
                if j < bytes.len() && bytes[j] == b'!' {
                    tokens.push(&text[i..=j]);
                    i = j + 1;
                    continue;
                }
            }
            
            let is_alnum = bytes[i].is_ascii_alphanumeric() || bytes[i] == b'_';
            if is_alnum {
                let mut j = i + 1;
                while j < bytes.len() && (bytes[j].is_ascii_alphanumeric() || bytes[j] == b'_') { j += 1; }
                tokens.push(&text[i..j]);
                i = j;
            } else {
                let mut j = i + 1;
                while j < bytes.len() && !(bytes[j].is_ascii_alphanumeric() || bytes[j] == b'_' || bytes[j] == b'#' || bytes[j] == b'!') { j += 1; }
                tokens.push(&text[i..j]);
                i = j;
            }
        }
        tokens
    }

    fn split_text<'a>(&self, text: &'a str) -> Vec<&'a str> {
        text.split('\n').collect()
    }
    fn max_n(&self) -> usize { 15 }
    fn min_trim_len(&self) -> usize { 5 }
    fn requires_hash(&self) -> bool { true }
    fn tag_len(&self, compressor: &Compressor) -> usize {
        compressor.meta_idx.to_string().len() + 2
    }
    fn next_token(&self, compressor: &mut Compressor) -> String {
        let t = format!("!{}!", compressor.meta_idx);
        compressor.meta_idx += 1;
        t
    }
    fn replace_text(&self, text: &str, phrase: &str, token: &str) -> String {
        fast_replace_word_bounded(text, phrase, token)
    }
}

impl Default for Compressor {
    fn default() -> Self {
        Self::new()
    }
}

impl Compressor {
    pub fn new() -> Self {
        Self {
            var_idx: 0,
            meta_idx: 1,
            macro_idx: 1,
            legend: Vec::new(),
        }
    }

    fn get_next_token(&mut self) -> String {
        let num = self.var_idx;
        self.var_idx += 1;
        if num == 0 {
            return "#0#".to_string();
        }
        
        let mut res = Vec::new();
        let mut n = num;
        while n > 0 {
            let rem = n % 62;
            res.push(BASE62[rem]);
            n /= 62;
        }
        res.reverse();
        
        // BASE62 only contains valid ASCII, so this is safe
        format!("#{}#", unsafe { String::from_utf8_unchecked(res) })
    }

    fn run_bpe<S: BpeStrategy>(&mut self, mut text: String, max_iterations: usize, strategy: S) -> String {
        for _ in 0..max_iterations {
            let mut substring_counts: HashMap<&[&str], usize> = HashMap::new();
            
            let parts = strategy.split_text(&text);

            let mut all_tokens: Vec<Vec<&str>> = Vec::with_capacity(parts.len());
            for part in parts {
                if part.trim().is_empty() { continue; }
                let tokens = strategy.tokenize(part);
                if tokens.len() >= 2 {
                    all_tokens.push(tokens);
                }
            }

            for tokens in &all_tokens {
                let len = tokens.len();
                let max_n = std::cmp::min(strategy.max_n(), len);
                
                for n in 2..=max_n {
                    for i in 0..=(len - n) {
                        let slice = &tokens[i..(i + n)];
                        
                        let mut has_newline = false;
                        let mut has_hash = false;
                        let mut total_len = 0;
                        
                        for &s in slice {
                            if s.contains('\n') || s.contains('\r') {
                                has_newline = true;
                                break;
                            }
                            if strategy.requires_hash() && s.contains('#') {
                                has_hash = true;
                            }
                            total_len += s.len();
                        }
                        
                        if has_newline { continue; }
                        
                        let mut joined_trim_len = total_len;
                        let first = slice[0];
                        let last = slice[slice.len() - 1];
                        joined_trim_len -= first.len() - first.trim_start().len();
                        joined_trim_len -= last.len() - last.trim_end().len();
                        
                        if joined_trim_len < strategy.min_trim_len() { continue; }
                        if strategy.requires_hash() && !has_hash { continue; }
                        
                        *substring_counts.entry(slice).or_insert(0) += 1;
                    }
                }
            }

            let mut best_phrase_slice: &[&str] = &[];
            let mut best_savings = 0_i32;

            for (slice, count) in &substring_counts {
                if *count > 1 {
                    let tag_len = strategy.tag_len(self);
                    let phrase_len: usize = slice.iter().map(|s| s.len()).sum();
                    
                    let savings = (*count as i32) * (phrase_len as i32 - tag_len as i32) - (tag_len as i32 + 3 + phrase_len as i32);
                    if savings > best_savings {
                        best_savings = savings;
                        best_phrase_slice = *slice;
                    }
                }
            }

            if best_savings < 5 { break; }

            let best_phrase = best_phrase_slice.join("");
            let token = strategy.next_token(self);

            text = strategy.replace_text(&text, &best_phrase, &token);

            let mut display_phrase = best_phrase;
            if display_phrase.starts_with(' ') || display_phrase.ends_with(' ') {
                display_phrase = format!("'{}'", display_phrase);
            }
            self.legend.push(format!("{} = {}", token, display_phrase));
        }
        text
    }

    fn run_macro_templating(&mut self, text: String) -> String {
        let mut lines: Vec<String> = text.lines().map(|l| l.trim_end().to_string()).collect();
        let mut templates: HashMap<String, Vec<(usize, String)>> = HashMap::new();
        
        for (i, line) in lines.iter().enumerate() {
            if line.trim().is_empty() { continue; }
            
            for mat in RE_TAGS.find_iter(line) {
                let mut template = line.clone();
                template.replace_range(mat.start()..mat.end(), "@");
                
                if template.len() < 5 { continue; }
                
                templates.entry(template).or_default().push((i, mat.as_str().to_string()));
            }
        }

        let mut template_scores: Vec<(String, usize)> = Vec::new();
        for (template, matches) in &templates {
            let count = matches.len();
            let savings = (count as i32 - 1) * (template.len() as i32) - 4 * (count as i32) - 5;
            
            if savings > 0 || count >= 4 {
                template_scores.push((template.clone(), count * template.len()));
            }
        }
        
        template_scores.sort_by(|a, b| {
            b.0.len().cmp(&a.0.len()).then(b.1.cmp(&a.1))
        });
        
        let mut line_templated = vec![false; lines.len()];
        
        for (template, _) in template_scores {
            if let Some(matches) = templates.get(&template) {
                let valid_matches: Vec<_> = matches.iter().filter(|(i, _)| !line_templated[*i]).collect();
                
                if valid_matches.len() > 1 {
                    let macro_tag = format!("&{}", self.macro_idx);
                    self.macro_idx += 1;
                    self.legend.push(format!("{} = {}", macro_tag, template));
                    
                    for (i, var) in valid_matches {
                        // Preserve the # or ! prefix by NOT trimming it
                        lines[*i] = format!("{}:{}", macro_tag, var);
                        line_templated[*i] = true;
                    }
                }
            }
        }
        
        lines.join("\n")
    }

    fn run_tag_sequence_macro_templating(&mut self, mut text: String) -> String {
        // Match sequences of at least 2 tags separated by spaces/tabs
        let re_seq = Regex::new(r"(?:(?:#(?:T|[0-9a-zA-Z]+)#|![0-9]+!)[ \t]*){2,}").unwrap();

        let mut templates: HashMap<String, usize> = HashMap::new();

        for mat in re_seq.find_iter(&text) {
            let seq = mat.as_str().trim_end();
            for tag_mat in RE_TAGS.find_iter(seq) {
                let mut template = seq.to_string();
                template.replace_range(tag_mat.start()..tag_mat.end(), "@");
                *templates.entry(template).or_insert(0) += 1;
            }
        }

        let mut template_scores: Vec<(String, usize)> = Vec::new();
        for (template, &count) in &templates {
            let savings = (count as i32 - 1) * (template.len() as i32) - 4 * (count as i32) - 5;
            if savings > 0 || count >= 4 {
                template_scores.push((template.clone(), count * template.len()));
            }
        }
        
        template_scores.sort_by(|a, b| {
            b.0.len().cmp(&a.0.len()).then(b.1.cmp(&a.1))
        });

        for (template, _) in template_scores {
            let parts: Vec<&str> = template.split('@').collect();
            if parts.len() != 2 { continue; }
            
            let prefix = regex::escape(parts[0]);
            let suffix = regex::escape(parts[1]);
            
            // We use \1 to match the same closing character as the opening one
            let re_str = format!(r"{}([#!])([0-9a-zA-Z]+)\1{}", prefix, suffix);
            
            if let Ok(re) = Regex::new(&re_str) {
                let count = re.find_iter(&text).count();
                
                let savings = (count as i32 - 1) * (template.len() as i32) - 4 * (count as i32) - 5;
                
                if savings > 0 || count >= 4 {
                    let macro_tag = format!("&{}", self.macro_idx);
                    self.macro_idx += 1;
                    self.legend.push(format!("{} = {}", macro_tag, template));
                    
                    // Keep the # or ! prefix and suffix in the replacement
                    let rep = format!("{}:$1$2$1", macro_tag);
                    text = re.replace_all(&text, rep.as_str()).into_owned();
                }
            }
        }
        
        text
    }

    pub fn compress(&mut self, mut text: String) -> String {
        if text.trim().is_empty() {
            return text;
        }

        // 0. Strip leading zeros
        text = RE_ZEROS_1.replace_all(&text, "$1").into_owned();
        text = RE_ZEROS_2.replace_all(&text, "$1").into_owned();
        text = RE_ZEROS_3.replace_all(&text, "${1}${2}").into_owned();
        text = RE_ZEROS_4.replace_all(&text, "${1}${2}").into_owned();

        // 1. Timestamp Prefix
        let mut ts_counts: HashMap<&str, usize> = HashMap::new();
        for mat in RE_TS.find_iter(&text) {
            *ts_counts.entry(mat.as_str()).or_insert(0) += 1;
        }
        
        if let Some((&best_ts, _)) = ts_counts.iter().max_by_key(|&(_, count)| count) {
            let best_ts_clone = best_ts.to_string();
            text = text.replace(&best_ts_clone, "#T#");
            self.legend.push(format!("#T# = {}", best_ts_clone));
        }

        // 2. Components [XXX]
        let mut comp_counts: HashMap<&str, usize> = HashMap::new();
        for mat in RE_COMP.find_iter(&text) {
            *comp_counts.entry(mat.as_str()).or_insert(0) += 1;
        }
        
        let mut sorted_comps: Vec<_> = comp_counts.into_iter().filter(|&(_, c)| c > 1).map(|(k, v)| (k.to_string(), v)).collect();
        sorted_comps.sort_by(|a, b| b.1.cmp(&a.1));
        
        for (comp, _) in sorted_comps {
            let token = self.get_next_token();
            text = text.replace(&comp, &token);
            self.legend.push(format!("{} = {}", token, comp));
        }

        // 3. Common Keys
        let mut key_counts: HashMap<&str, usize> = HashMap::new();
        for mat in RE_KEYS.find_iter(&text) {
            *key_counts.entry(mat.as_str()).or_insert(0) += 1;
        }
        
        let mut sorted_keys: Vec<_> = key_counts.into_iter().filter(|&(_, c)| c > 1).map(|(k, v)| (k.to_string(), v)).collect();
        sorted_keys.sort_by(|a, b| b.1.cmp(&a.1));
        
        for (key, _) in sorted_keys {
            let token = self.get_next_token();
            text = text.replace(&key, &token);
            self.legend.push(format!("{} = {}", token, key));
        }

        // 4. BPE
        text = self.run_bpe(text, 100, NormalBpe);
        
        // 4.5 Meta-BPE
        text = self.run_bpe(text, 100, MetaBpe);
        
        // 5. MACRO TEMPLATING
        text = self.run_macro_templating(text);
        
        // 5.5 TAG SEQUENCE MACRO TEMPLATING
        text = self.run_tag_sequence_macro_templating(text);
        
        // 6. Intra-line deduplication
        let mut final_lines = Vec::new();
        let mut dup_count = 0;
        let mut last_line = String::new();
        
        for line in text.lines() {
            if line.trim().is_empty() {
                continue;
            }
            
            let line_no_time = RE_NO_TIME.replace(line, "").into_owned();
            if line_no_time == last_line && !line_no_time.is_empty() {
                dup_count += 1;
                continue;
            }
            
            if dup_count > 0 {
                final_lines.push(format!("    ... (repeated {} more times)", dup_count));
                dup_count = 0;
            }
            
            final_lines.push(line.to_string());
            last_line = line_no_time;
        }
        
        if dup_count > 0 {
            final_lines.push(format!("    ... (repeated {} more times)", dup_count));
        }

        // Assemble final text
        let mut result = String::new();
        if !self.legend.is_empty() {
            result.push_str("--- LEGEND ---\n");
            result.push_str(&self.legend.join("\n"));
            result.push_str("\n\n");
        }
        result.push_str("--- LOGS ---\n");
        result.push_str(&final_lines.join("\n"));
        
        result
    }
}
