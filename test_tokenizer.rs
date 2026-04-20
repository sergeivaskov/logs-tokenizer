use regex::Regex;
fn main() {
    let text = "hello #T123 world! @#$ \n \r test";
    let meta = Regex::new(r"#[a-zA-Z0-9]+|[A-Za-z0-9_]+|[^A-Za-z0-9_#]+").unwrap();
    let mut last_end = 0;
    for m in meta.find_iter(text) {
        if m.start() != last_end {
            println!("GAP: {}..{}", last_end, m.start());
        }
        last_end = m.end();
    }
    if last_end != text.len() {
        println!("GAP AT END");
    }
    println!("Done");
}