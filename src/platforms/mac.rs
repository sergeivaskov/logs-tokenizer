use log::{info, error};
use notify_rust::Notification;
use enigo::{Enigo, KeyboardControllable, Key};

pub fn setup_env(_icon_path: &str) -> String {
    // Set a valid bundle identifier for macOS notifications
    let app_id = "com.sergeivaskov.logstokenizer";
    if let Err(e) = mac_notification_sys::set_application(app_id) {
        error!("[Notify] Failed to set application bundle identifier: {:?}", e);
    }
    app_id.to_string()
}

pub fn show_startup_notification(app_id: &str) {
    info!("[Notify] Utility successfully launched in background!");
    if let Err(e) = Notification::new()
        .summary("Logs Tokenizer Launched")
        .body("Utility successfully launched in background!\nPress Cmd+Alt+V to paste compressed logs.")
        .appname(app_id)
        .sound_name("Ping")
        .show() {
        error!("[Notify] Failed to show startup notification: {:?}", e);
    }
}

pub fn show_success_notification(app_id: &str, savings: f64, original_len: usize, compressed_len: usize) {
    info!("[Notify] Logs optimized! Compressed by {:.1}% (from {} to {} characters)", savings, original_len, compressed_len);
    if let Err(e) = Notification::new()
        .summary("Logs optimized!")
        .body(&format!("Compressed by {:.1}%\n(from {} to {} characters)", savings, original_len, compressed_len))
        .appname(app_id)
        .sound_name("Ping")
        .show() {
        error!("[Notify] Failed to show success notification: {:?}", e);
    }
}

pub fn simulate_paste() {
    let mut enigo = Enigo::new();
    
    // macOS 'v' keycode is 9
    // In macOS, when global hotkeys are pressed, the physical modifier keys (like Cmd/Alt) 
    // are still held down by the user. We need to release them first to ensure our clean Cmd+V works.
    enigo.key_up(Key::Alt);
    enigo.key_up(Key::Option);
    enigo.key_up(Key::Control);
    enigo.key_up(Key::Shift);
    
    std::thread::sleep(std::time::Duration::from_millis(50));
    
    enigo.key_down(Key::Meta);
    std::thread::sleep(std::time::Duration::from_millis(20));
    enigo.key_click(Key::Raw(9));
    std::thread::sleep(std::time::Duration::from_millis(20));
    enigo.key_up(Key::Meta);
}
