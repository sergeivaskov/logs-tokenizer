#[cfg(windows)]
fn main() {
    println!("cargo:rerun-if-changed=src/ico/icon.ico");
    let mut res = winresource::WindowsResource::new();
    res.set_icon("src/ico/icon.ico");
    res.set("ProductName", "Logs Tokenizer");
    res.set("FileDescription", "Logs Tokenizer");
    res.set("OriginalFilename", "Logs Tokenizer.exe");
    res.compile().unwrap();
}

#[cfg(not(windows))]
fn main() {}
