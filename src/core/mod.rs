use regex::Regex;
use std::collections::HashMap;
use once_cell::sync::Lazy;

const BASE62: &[u8] = b"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

pub struct Compressor {
    var_idx: usize,
    meta_idx: usize,
    macro_idx: usize,
    legend: Vec<String>,
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
            return "#0".to_string();
        }
        let mut res = String::new();
        let mut n = num;
        while n > 0 {
            let rem = n % 62;
            res.insert(0, BASE62[rem] as char);
            n /= 62;
        }
        format!("#{}", res)
    }

    fn run_bpe(&mut self, mut text: String, max_iterations: usize, is_meta: bool) -> String {
        let meta_tokenizer = Regex::new(r"#[a-zA-Z0-9]+|[A-Za-z0-9_]+|[^A-Za-z0-9_#]+").unwrap();
        let normal_tokenizer = Regex::new(r"[A-Za-z0-9_]+|[^A-Za-z0-9_]+").unwrap();

        for _ in 0..max_iterations {
            let mut substring_counts: HashMap<String, usize> = HashMap::new();
            
            let normal_split = Regex::new(r"(#(?:T|[0-9a-zA-Z]+))").unwrap();
            let mut parts_owned = Vec::new();
            let parts: Vec<&str> = if is_meta {
                text.split('\n').collect()
            } else {
                let mut last_end = 0;
                for mat in normal_split.find_iter(&text) {
                    parts_owned.push(&text[last_end..mat.start()]);
                    last_end = mat.end();
                }
                parts_owned.push(&text[last_end..]);
                parts_owned
            };

            let tokenizer = if is_meta { &meta_tokenizer } else { &normal_tokenizer };

            for part in parts {
                if part.trim().is_empty() { continue; }
                
                let tokens: Vec<&str> = tokenizer.find_iter(part).map(|m| m.as_str()).collect();
                let len = tokens.len();
                if len < 2 { continue; }

                let max_n = std::cmp::min(if is_meta { 15 } else { 20 }, len);
                
                for n in 2..=max_n {
                    for i in 0..=(len - n) {
                        let phrase = tokens[i..(i + n)].join("");
                        
                        if phrase.contains('\n') || phrase.contains('\r') { continue; }
                        if phrase.trim().len() < if is_meta { 5 } else { 4 } { continue; }
                        if is_meta && !phrase.contains('#') { continue; }
                        
                        *substring_counts.entry(phrase).or_insert(0) += 1;
                    }
                }
            }

            let mut best_phrase = String::new();
            let mut best_savings = 0_i32;

            for (phrase, count) in &substring_counts {
                if *count > 1 {
                    let tag_len = if is_meta {
                        self.meta_idx.to_string().len() + 1
                    } else {
                        if self.var_idx > 61 { 3 } else { 2 }
                    };
                    
                    let savings = (*count as i32) * (phrase.len() as i32 - tag_len as i32) - (tag_len as i32 + 3 + phrase.len() as i32);
                    if savings > best_savings {
                        best_savings = savings;
                        best_phrase = phrase.clone();
                    }
                }
            }

            if best_savings < 5 { break; }

            let token = if is_meta {
                let t = format!("!{}", self.meta_idx);
                self.meta_idx += 1;
                t
            } else {
                self.get_next_token()
            };

            let mut escaped = regex::escape(&best_phrase);
            // Add word boundaries if it starts/ends with word chars
            if best_phrase.chars().next().unwrap().is_ascii_alphanumeric() || best_phrase.starts_with('_') {
                escaped = format!(r"\b{}", escaped);
            }
            if best_phrase.chars().last().unwrap().is_ascii_alphanumeric() || best_phrase.ends_with('_') {
                escaped = format!(r"{}\b", escaped);
            }

            if let Ok(re) = Regex::new(&escaped) {
                if is_meta {
                    text = re.replace_all(&text, &token).into_owned();
                } else {
                    let normal_split = Regex::new(r"(#(?:T|[0-9a-zA-Z]+))").unwrap();
                    let mut new_text = String::new();
                    let mut last_end = 0;
                    for mat in normal_split.find_iter(&text) {
                        let part = &text[last_end..mat.start()];
                        new_text.push_str(&re.replace_all(part, &token));
                        new_text.push_str(mat.as_str());
                        last_end = mat.end();
                    }
                    new_text.push_str(&re.replace_all(&text[last_end..], &token));
                    text = new_text;
                }

                let mut display_phrase = best_phrase;
                if display_phrase.starts_with(' ') || display_phrase.ends_with(' ') {
                    display_phrase = format!("'{}'", display_phrase);
                }
                self.legend.push(format!("{} = {}", token, display_phrase));
            } else {
                break; // Regex compilation failed
            }
        }
        text
    }

    fn run_macro_templating(&mut self, text: String) -> String {
        let mut lines: Vec<String> = text.lines().map(|l| l.trim_end().to_string()).collect();
        let mut templates: HashMap<String, Vec<(usize, String)>> = HashMap::new();
        
        let re_tags = Regex::new(r"(#(?:T|[0-9a-zA-Z]+)|![0-9]+)").unwrap();

        for (i, line) in lines.iter().enumerate() {
            if line.trim().is_empty() { continue; }
            
            for mat in re_tags.find_iter(line) {
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
        
        template_scores.sort_by(|a, b| b.1.cmp(&a.1));
        
        let mut line_templated = vec![false; lines.len()];
        
        for (template, _) in template_scores {
            if let Some(matches) = templates.get(&template) {
                let valid_matches: Vec<_> = matches.iter().filter(|(i, _)| !line_templated[*i]).collect();
                
                if valid_matches.len() > 1 {
                    let macro_tag = format!("&{}", self.macro_idx);
                    self.macro_idx += 1;
                    self.legend.push(format!("{} = {}", macro_tag, template));
                    
                    for (i, var) in valid_matches {
                        let var_clean = var.trim_start_matches(|c| c == '#' || c == '!');
                        lines[*i] = format!("{}:{}", macro_tag, var_clean);
                        line_templated[*i] = true;
                    }
                }
            }
        }
        
        lines.join("\n")
    }

    pub fn compress(&mut self, mut text: String) -> String {
        if text.trim().is_empty() {
            return text;
        }

        // 0. Strip leading zeros
        static RE_ZEROS_1: Lazy<Regex> = Lazy::new(|| Regex::new(r"\b0{3,}([1-9A-Fa-f][0-9A-Fa-f]*\b)").unwrap());
        static RE_ZEROS_2: Lazy<Regex> = Lazy::new(|| Regex::new(r"\b0{3,}(0\b)").unwrap());
        static RE_ZEROS_3: Lazy<Regex> = Lazy::new(|| Regex::new(r"(\b0x)0{3,}([1-9A-Fa-f][0-9A-Fa-f]*\b)").unwrap());
        static RE_ZEROS_4: Lazy<Regex> = Lazy::new(|| Regex::new(r"(\b0x)0{3,}(0\b)").unwrap());

        text = RE_ZEROS_1.replace_all(&text, "$1").into_owned();
        text = RE_ZEROS_2.replace_all(&text, "$1").into_owned();
        text = RE_ZEROS_3.replace_all(&text, "${1}${2}").into_owned();
        text = RE_ZEROS_4.replace_all(&text, "${1}${2}").into_owned();

        // 1. Timestamp Prefix
        static RE_TS: Lazy<Regex> = Lazy::new(|| Regex::new(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:").unwrap());
        let mut ts_counts: HashMap<String, usize> = HashMap::new();
        for mat in RE_TS.find_iter(&text) {
            *ts_counts.entry(mat.as_str().to_string()).or_insert(0) += 1;
        }
        
        if let Some((best_ts, _)) = ts_counts.iter().max_by_key(|&(_, count)| count) {
            let best_ts_clone = best_ts.clone();
            text = text.replace(&best_ts_clone, "#T");
            self.legend.push(format!("#T = {}", best_ts_clone));
        }

        // 2. Components [XXX]
        static RE_COMP: Lazy<Regex> = Lazy::new(|| Regex::new(r"\[[A-Za-z0-9_-]+\]").unwrap());
        let mut comp_counts: HashMap<String, usize> = HashMap::new();
        for mat in RE_COMP.find_iter(&text) {
            *comp_counts.entry(mat.as_str().to_string()).or_insert(0) += 1;
        }
        
        let mut sorted_comps: Vec<_> = comp_counts.into_iter().filter(|&(_, c)| c > 1).collect();
        sorted_comps.sort_by(|a, b| b.1.cmp(&a.1));
        
        for (comp, _) in sorted_comps {
            let token = self.get_next_token();
            text = text.replace(&comp, &token);
            self.legend.push(format!("{} = {}", token, comp));
        }

        // 3. Common Keys
        static RE_KEYS: Lazy<Regex> = Lazy::new(|| Regex::new(r"\b[A-Za-z0-9_]+={1,2}").unwrap());
        let mut key_counts: HashMap<String, usize> = HashMap::new();
        for mat in RE_KEYS.find_iter(&text) {
            *key_counts.entry(mat.as_str().to_string()).or_insert(0) += 1;
        }
        
        let mut sorted_keys: Vec<_> = key_counts.into_iter().filter(|&(_, c)| c > 1).collect();
        sorted_keys.sort_by(|a, b| b.1.cmp(&a.1));
        
        for (key, _) in sorted_keys {
            let token = self.get_next_token();
            text = text.replace(&key, &token);
            self.legend.push(format!("{} = {}", token, key));
        }

        // 4. BPE
        text = self.run_bpe(text, 100, false);
        
        // 4.5 Meta-BPE
        text = self.run_bpe(text, 100, true);
        
        // 5. MACRO TEMPLATING
        text = self.run_macro_templating(text);
        
        // 6. Intra-line deduplication
        let mut final_lines = Vec::new();
        let mut dup_count = 0;
        let mut last_line = String::new();
        
        static RE_NO_TIME: Lazy<Regex> = Lazy::new(|| Regex::new(r"^#T\d{2}\.\d{3}\s*").unwrap());

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
