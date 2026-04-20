pub fn setup_env(_icon_path: &str) -> String {
    "LogsTokenizer".to_string()
}

pub fn show_startup_notification(_app_id: &str) {
    // TODO: Использовать notify-rust в будущем
    info!("[Notify] Утилита успешно запущена в фоне!");
}

pub fn show_success_notification(_app_id: &str, savings: f64, original_len: usize, compressed_len: usize) {
    // TODO: Использовать notify-rust в будущем
    info!("[Notify] Логи оптимизированы! Сжато на {:.1}% (с {} до {} символов)", savings, original_len, compressed_len);
}

pub fn simulate_paste() {
    // TODO: Использовать enigo в будущем
}
