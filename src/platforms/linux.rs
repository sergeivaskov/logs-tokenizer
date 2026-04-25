use log::info;

pub fn setup_env(_icon_path: &str) -> String {
    "LogsTokenizer".to_string()
}

pub fn show_startup_notification(_app_id: &str) {
    // TODO: Use notify-rust in the future
    info!("[Notify] Utility successfully launched in background!");
}

pub fn show_success_notification(_app_id: &str, savings: f64, original_len: usize, compressed_len: usize) {
    // TODO: Use notify-rust in the future
    info!("[Notify] Logs optimized! Compressed by {:.1}% (from {} to {} characters)", savings, original_len, compressed_len);
}

pub fn simulate_paste() {
    // TODO: Use enigo in the future
}
