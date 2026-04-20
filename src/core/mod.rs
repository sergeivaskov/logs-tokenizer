use regex::Regex;
use std::collections::HashMap;
use once_cell::sync::Lazy;

const BASE62: &[u8] = b"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

// Pre-compile static regexes for one-off passes
static RE_TAGS: Lazy<Regex>    = Lazy::new(|| Regex::new(r"(#(?:T|[0-9a-zA-Z]+)#|![0-9]+!)").unwrap());
static RE_ZEROS_1: Lazy<Regex> = Lazy::new(|| Regex::new(r"\b0{3,}([1-9A-Fa-f][0-9A-Fa-f]*\b)").unwrap());
static RE_ZEROS_2: Lazy<Regex> = Lazy::new(|| Regex::new(r"\b0{3,}(0\b)").unwrap());
static RE_ZEROS_3: Lazy<Regex> = Lazy::new(|| Regex::new(r"(\b0x)0{3,}([1-9A-Fa-f][0-9A-Fa-f]*\b)").unwrap());
static RE_ZEROS_4: Lazy<Regex> = Lazy::new(|| Regex::new(r"(\b0x)0{3,}(0\b)").unwrap());
static RE_TS: Lazy<Regex>      = Lazy::new(|| Regex::new(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:").unwrap());
static RE_COMP: Lazy<Regex>    = Lazy::new(|| Regex::new(r"\[[A-Za-z0-9_-]+\]").unwrap());
static RE_KEYS: Lazy<Regex>    = Lazy::new(|| Regex::new(r"\b[A-Za-z0-9_]+={1,2}").unwrap());
static RE_NO_TIME: Lazy<Regex> = Lazy::new(|| Regex::new(r"^#T#\d{2}\.\d{3}\s*").unwrap());

#[inline]
fn advance_while(bytes: &[u8], mut i: usize, cond: impl Fn(u8) -> bool) -> usize {
    while i < bytes.len() && cond(bytes[i]) { i += 1; }
    i
}

#[inline]
fn calc_savings(count: usize, len: usize) -> i32 {
    (count as i32 - 1) * (len as i32) - 4 * (count as i32) - 5
}

pub struct Compressor {
    var_idx: usize,
    meta_idx: usize,
    macro_idx: usize,
    legend: Vec<String>,
}

trait BpeStrategy {
    fn tokenize<'a>(&self, text: &'a str) -> Vec<&'a str>;
    fn split_text_with_separators<'a>(&self, text: &'a str) -> (Vec<&'a str>, Vec<&'a str>);
    fn max_n(&self) -> usize;
    fn min_trim_len(&self) -> usize;
    fn requires_hash(&self) -> bool;
    fn tag_len(&self, comp: &Compressor) -> usize;
    fn next_token(&self, comp: &mut Compressor) -> String;
}

struct NormalBpe;
impl BpeStrategy for NormalBpe {
    fn tokenize<'a>(&self, text: &'a str) -> Vec<&'a str> {
        let (mut tokens, bytes, mut i) = (Vec::new(), text.as_bytes(), 0);
        while i < bytes.len() {
            let is_alnum = bytes[i].is_ascii_alphanumeric() || bytes[i] == b'_';
            let j = advance_while(bytes, i + 1, |b| (b.is_ascii_alphanumeric() || b == b'_') == is_alnum);
            tokens.push(&text[i..j]);
            i = j;
        }
        tokens
    }

    fn split_text_with_separators<'a>(&self, text: &'a str) -> (Vec<&'a str>, Vec<&'a str>) {
        let (mut parts, mut seps, bytes) = (Vec::new(), Vec::new(), text.as_bytes());
        let (mut i, mut last_end) = (0, 0);
        while i < bytes.len() {
            if bytes[i] == b'#' {
                let mut j = i + 1;
                if j < bytes.len() && bytes[j] == b'T' { j += 1; } 
                else { j = advance_while(bytes, j, |b| b.is_ascii_alphanumeric()); }
                
                if j < bytes.len() && bytes[j] == b'#' && j > i + 1 {
                    parts.push(&text[last_end..i]);
                    seps.push(&text[i..=j]);
                    last_end = j + 1;
                    i = j + 1;
                    continue;
                }
            }
            i += 1;
        }
        parts.push(&text[last_end..]);
        (parts, seps)
    }

    fn max_n(&self) -> usize { 20 }
    fn min_trim_len(&self) -> usize { 4 }
    fn requires_hash(&self) -> bool { false }
    fn tag_len(&self, comp: &Compressor) -> usize {
        let (mut n, mut len) = (comp.var_idx, 0);
        if n == 0 { len = 1; }
        while n > 0 { len += 1; n /= 62; }
        len + 2
    }
    fn next_token(&self, comp: &mut Compressor) -> String { comp.get_next_token() }
}

struct MetaBpe;
impl BpeStrategy for MetaBpe {
    fn tokenize<'a>(&self, text: &'a str) -> Vec<&'a str> {
        let (mut tokens, bytes, mut i) = (Vec::new(), text.as_bytes(), 0);
        while i < bytes.len() {
            let b = bytes[i];
            if b == b'#' {
                let j = advance_while(bytes, i + 1, |c| c.is_ascii_alphanumeric());
                if j < bytes.len() && bytes[j] == b'#' { tokens.push(&text[i..=j]); i = j + 1; continue; }
            } else if b == b'!' {
                let j = advance_while(bytes, i + 1, |c| c.is_ascii_digit());
                if j < bytes.len() && bytes[j] == b'!' { tokens.push(&text[i..=j]); i = j + 1; continue; }
            }
            
            let is_alnum = b.is_ascii_alphanumeric() || b == b'_';
            let j = advance_while(bytes, i + 1, |c| {
                if is_alnum { c.is_ascii_alphanumeric() || c == b'_' } 
                else { !c.is_ascii_alphanumeric() && c != b'_' && c != b'#' && c != b'!' }
            });
            tokens.push(&text[i..j]);
            i = j;
        }
        tokens
    }

    fn split_text_with_separators<'a>(&self, text: &'a str) -> (Vec<&'a str>, Vec<&'a str>) {
        let (mut parts, mut seps, bytes) = (Vec::new(), Vec::new(), text.as_bytes());
        let mut last_end = 0;
        for i in 0..bytes.len() {
            if bytes[i] == b'\n' {
                parts.push(&text[last_end..i]);
                seps.push("\n");
                last_end = i + 1;
            }
        }
        parts.push(&text[last_end..]);
        (parts, seps)
    }

    fn max_n(&self) -> usize { 15 }
    fn min_trim_len(&self) -> usize { 5 }
    fn requires_hash(&self) -> bool { true }
    fn tag_len(&self, comp: &Compressor) -> usize { comp.meta_idx.to_string().len() + 2 }
    fn next_token(&self, comp: &mut Compressor) -> String {
        let t = format!("!{}!", comp.meta_idx);
        comp.meta_idx += 1;
        t
    }
}

impl Default for Compressor { fn default() -> Self { Self::new() } }

impl Compressor {
    pub fn new() -> Self {
        Self { var_idx: 0, meta_idx: 1, macro_idx: 1, legend: Vec::new() }
    }

    fn get_next_token(&mut self) -> String {
        let num = self.var_idx;
        self.var_idx += 1;
        if num == 0 { return "#0#".to_string(); }
        
        let (mut res, mut n) = (Vec::new(), num);
        while n > 0 {
            res.push(BASE62[n % 62]);
            n /= 62;
        }
        res.reverse();
        format!("#{}#", unsafe { String::from_utf8_unchecked(res) })
    }

    fn replace_frequent(&mut self, text: &mut String, re: &Regex) {
        let mut counts: HashMap<String, usize> = HashMap::new();
        for mat in re.find_iter(text) { *counts.entry(mat.as_str().to_string()).or_insert(0) += 1; }
        
        let mut sorted: Vec<_> = counts.into_iter().filter(|&(_, c)| c > 1).collect();
        sorted.sort_by(|a, b| b.1.cmp(&a.1));
        
        for (pat, _) in sorted {
            let token = self.get_next_token();
            *text = text.replace(&pat, &token);
            self.legend.push(format!("{} = {}", token, pat));
        }
    }

    fn run_bpe<S: BpeStrategy>(&mut self, text: String, max_iter: usize, strategy: S) -> String {
        let mut id_to_str: Vec<String> = Vec::new();
        let mut str_to_id: HashMap<String, u32> = HashMap::new();
        
        let mut get_or_add = |s: &str| -> u32 {
            *str_to_id.entry(s.to_string()).or_insert_with(|| {
                id_to_str.push(s.to_string());
                (id_to_str.len() - 1) as u32
            })
        };

        let (part_strs, seps) = strategy.split_text_with_separators(&text);
        let mut parts: Vec<Vec<u32>> = part_strs.into_iter()
            .map(|p| if p.is_empty() { vec![] } else { strategy.tokenize(p).into_iter().map(&mut get_or_add).collect() })
            .collect();

        for _ in 0..max_iter {
            let mut counts: HashMap<&[u32], usize> = HashMap::new();
            let max_n = strategy.max_n();
            
            for part in &parts {
                let len = part.len();
                if len < 2 { continue; }
                
                for n in 2..=std::cmp::min(max_n, len) {
                    for i in 0..=(len - n) {
                        let slice = &part[i..(i + n)];
                        let (mut has_hash, mut total_len, mut valid) = (false, 0, true);
                        
                        for &id in slice {
                            let s = &id_to_str[id as usize];
                            if s.contains('\n') || s.contains('\r') { valid = false; break; }
                            if strategy.requires_hash() && s.contains('#') { has_hash = true; }
                            total_len += s.len();
                        }
                        
                        if !valid || (strategy.requires_hash() && !has_hash) { continue; }
                        
                        let first_s = &id_to_str[slice[0] as usize];
                        let last_s = &id_to_str[slice[slice.len() - 1] as usize];
                        let trim_len = total_len - (first_s.len() - first_s.trim_start().len()) - (last_s.len() - last_s.trim_end().len());
                        
                        if trim_len >= strategy.min_trim_len() {
                            *counts.entry(slice).or_insert(0) += 1;
                        }
                    }
                }
            }

            let (mut best_slice, mut best_savings) = (&[][..], 0_i32);
            for (slice, &count) in &counts {
                if count > 1 {
                    let phrase_len: usize = slice.iter().map(|&id| id_to_str[id as usize].len()).sum();
                    let tag_len = strategy.tag_len(self);
                    let savings = (count as i32) * (phrase_len as i32 - tag_len as i32) - (tag_len as i32 + 3 + phrase_len as i32);
                    
                    if savings > best_savings {
                        best_savings = savings;
                        best_slice = *slice;
                    }
                }
            }

            if best_savings < 5 { break; }

            let best_vec = best_slice.to_vec();
            let best_str: String = best_vec.iter().map(|&id| id_to_str[id as usize].as_str()).collect();
            let token = strategy.next_token(self);
            
            let new_id = id_to_str.len() as u32;
            id_to_str.push(token.clone());
            str_to_id.insert(token.clone(), new_id);

            for part in &mut parts {
                if part.len() < best_vec.len() { continue; }
                let (mut new_part, mut i) = (Vec::with_capacity(part.len()), 0);
                while i <= part.len() - best_vec.len() {
                    if &part[i..i + best_vec.len()] == best_vec.as_slice() {
                        new_part.push(new_id);
                        i += best_vec.len();
                    } else {
                        new_part.push(part[i]);
                        i += 1;
                    }
                }
                new_part.extend_from_slice(&part[i..]);
                *part = new_part;
            }

            let display = if best_str.starts_with(' ') || best_str.ends_with(' ') { format!("'{}'", best_str) } else { best_str };
            self.legend.push(format!("{} = {}", token, display));
        }

        parts.iter().enumerate().map(|(i, part)| {
            let mut s = part.iter().map(|&id| id_to_str[id as usize].as_str()).collect::<String>();
            if i < seps.len() { s.push_str(seps[i]); }
            s
        }).collect()
    }

    fn process_templates(&mut self, templates: &HashMap<String, Vec<(usize, String)>>, lines: &mut [String]) {
        let mut scores: Vec<_> = templates.iter()
            .map(|(t, m)| (t.clone(), m.len(), calc_savings(m.len(), t.len())))
            .filter(|&(_, count, sav)| sav > 0 || count >= 4)
            .collect();
        
        scores.sort_by(|a, b| b.0.len().cmp(&a.0.len()).then(b.1.cmp(&a.1)));
        let mut templated = vec![false; lines.len()];
        
        for (template, _, _) in scores {
            if let Some(matches) = templates.get(&template) {
                let valid: Vec<_> = matches.iter().filter(|(i, _)| !templated[*i]).collect();
                if valid.len() > 1 {
                    let macro_tag = format!("&{}", self.macro_idx);
                    self.macro_idx += 1;
                    self.legend.push(format!("{} = {}", macro_tag, template));
                    
                    for (i, var) in valid {
                        lines[*i] = format!("{}:{}", macro_tag, var);
                        templated[*i] = true;
                    }
                }
            }
        }
    }

    fn run_macro_templating(&mut self, text: String) -> String {
        let mut lines: Vec<String> = text.lines().map(|l| l.trim_end().to_string()).collect();
        let mut templates: HashMap<String, Vec<(usize, String)>> = HashMap::new();
        
        for (i, line) in lines.iter().enumerate() {
            if line.trim().is_empty() { continue; }
            for mat in RE_TAGS.find_iter(line) {
                let mut template = line.clone();
                template.replace_range(mat.start()..mat.end(), "@");
                if template.len() >= 5 {
                    templates.entry(template).or_default().push((i, mat.as_str().to_string()));
                }
            }
        }

        self.process_templates(&templates, &mut lines);
        lines.join("\n")
    }

    fn run_tag_sequence_macro_templating(&mut self, mut text: String) -> String {
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

        let mut scores: Vec<_> = templates.iter()
            .map(|(t, &c)| (t.clone(), c, calc_savings(c, t.len())))
            .filter(|&(_, count, sav)| sav > 0 || count >= 4)
            .collect();
        
        scores.sort_by(|a, b| b.0.len().cmp(&a.0.len()).then(b.1.cmp(&a.1)));

        for (template, _, _) in scores {
            let parts: Vec<&str> = template.split('@').collect();
            if parts.len() != 2 { continue; }
            
            let re_str = format!(r"{}([#!])([0-9a-zA-Z]+)\1{}", regex::escape(parts[0]), regex::escape(parts[1]));
            if let Ok(re) = Regex::new(&re_str) {
                let count = re.find_iter(&text).count();
                if calc_savings(count, template.len()) > 0 || count >= 4 {
                    let macro_tag = format!("&{}", self.macro_idx);
                    self.macro_idx += 1;
                    self.legend.push(format!("{} = {}", macro_tag, template));
                    text = re.replace_all(&text, format!("{}:$1$2$1", macro_tag).as_str()).into_owned();
                }
            }
        }
        text
    }

    fn deduplicate_lines(&self, text: &str) -> Vec<String> {
        let (mut final_lines, mut dup_count, mut last_line) = (Vec::new(), 0, String::new());
        for line in text.lines() {
            if line.trim().is_empty() { continue; }
            
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
        if dup_count > 0 { final_lines.push(format!("    ... (repeated {} more times)", dup_count)); }
        final_lines
    }

    pub fn compress(&mut self, mut text: String) -> String {
        if text.trim().is_empty() { return text; }

        text = RE_ZEROS_1.replace_all(&text, "$1").into_owned();
        text = RE_ZEROS_2.replace_all(&text, "$1").into_owned();
        text = RE_ZEROS_3.replace_all(&text, "${1}${2}").into_owned();
        text = RE_ZEROS_4.replace_all(&text, "${1}${2}").into_owned();

        if let Some(best_ts) = RE_TS.find_iter(&text)
            .fold(HashMap::new(), |mut acc, m| { *acc.entry(m.as_str()).or_insert(0) += 1; acc })
            .into_iter().max_by_key(|&(_, c)| c).map(|(ts, _)| ts.to_string()) 
        {
            text = text.replace(&best_ts, "#T#");
            self.legend.push(format!("#T# = {}", best_ts));
        }

        self.replace_frequent(&mut text, &RE_COMP);
        self.replace_frequent(&mut text, &RE_KEYS);

        text = self.run_bpe(text, 100, NormalBpe);
        text = self.run_bpe(text, 100, MetaBpe);
        text = self.run_macro_templating(text);
        text = self.run_tag_sequence_macro_templating(text);

        let mut result = String::new();
        if !self.legend.is_empty() {
            result.push_str("--- LEGEND ---\n");
            result.push_str(&self.legend.join("\n"));
            result.push_str("\n\n");
        }
        result.push_str("--- LOGS ---\n");
        result.push_str(&self.deduplicate_lines(&text).join("\n"));
        result
    }
}