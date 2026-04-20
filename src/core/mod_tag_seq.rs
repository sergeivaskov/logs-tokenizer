    fn run_tag_sequence_macro_templating(&mut self, mut text: String) -> String {
        let re_tag = &*RE_TAGS;
        // Match sequences of at least 3 tags
        let re_seq = Regex::new(r"(?:#(?:T|[0-9a-zA-Z]+)|![0-9]+){3,}").unwrap();

        let mut templates: HashMap<String, usize> = HashMap::new();

        for mat in re_seq.find_iter(&text) {
            let seq = mat.as_str();
            for tag_mat in re_tag.find_iter(seq) {
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
        
        template_scores.sort_by(|a, b| b.1.cmp(&a.1));

        for (template, _) in template_scores {
            let parts: Vec<&str> = template.split('@').collect();
            if parts.len() != 2 { continue; }
            
            let prefix = regex::escape(parts[0]);
            let suffix = regex::escape(parts[1]);
            // The hole can be a #tag or !tag. We capture the prefix character and the value.
            // But wait, RE_TAGS is `#(?:T|[0-9a-zA-Z]+)|![0-9]+`.
            // So it's always one of '#' or '!' followed by alphanumeric.
            // Wait, `#T` is a tag. The value is `T`.
            let re_str = format!(r"{}([#!])([0-9a-zA-Z]+){}", prefix, suffix);
            
            if let Ok(re) = Regex::new(&re_str) {
                let count = re.find_iter(&text).count();
                
                // Recalculate savings with actual count
                let savings = (count as i32 - 1) * (template.len() as i32) - 4 * (count as i32) - 5;
                
                if savings > 0 || count >= 4 {
                    let macro_tag = format!("&{}", self.macro_idx);
                    self.macro_idx += 1;
                    self.legend.push(format!("{} = {}", macro_tag, template));
                    
                    let rep = format!("{}:$2", macro_tag);
                    text = re.replace_all(&text, rep.as_str()).into_owned();
                }
            }
        }
        
        text
    }