use tauri_winrt_notification::Toast;
use log::{info, error};

pub fn setup_env(icon_path: &str) -> String {
    use winreg::enums::*;
    use winreg::RegKey;

    // Use a unique ID to reset Windows notifications hard cache
    let aumid = "LogsTokenizer.App.v3";
    let hkcu = RegKey::predef(HKEY_CURRENT_USER);
    let path = format!(r"Software\Classes\AppUserModelId\{}", aumid);
    if let Ok((key, _)) = hkcu.create_subkey(&path) {
        let _ = key.set_value("DisplayName", &"Logs Tokenizer");
        let _ = key.set_value("IconUri", &icon_path);
        let _ = key.set_value("IconBackgroundColor", &"FF000000");
    }
    aumid.to_string()
}

pub fn show_startup_notification(app_id: &str) {
    if let Err(e) = Toast::new(app_id)
        .text1("Utility successfully launched in background!")
        .text2("Press Ctrl+Alt+V to paste compressed logs.")
        .show() {
        error!("[Notify] Failed to show startup notification: {:?}", e);
    }
}

pub fn show_success_notification(app_id: &str, savings: f64, original_len: usize, compressed_len: usize) {
    if let Err(e) = Toast::new(app_id)
        .title("Logs optimized!")
        .text1(&format!("Compressed by {:.1}%", savings))
        .text2(&format!("(from {} to {} characters)", original_len, compressed_len))
        .show() {
        error!("[Notify] Failed to show success notification: {:?}", e);
    }
}

pub fn simulate_paste() {
    unsafe {
        use windows_sys::Win32::UI::Input::KeyboardAndMouse::{
            SendInput, INPUT, INPUT_KEYBOARD, KEYBDINPUT, KEYEVENTF_KEYUP, VK_CONTROL, VK_MENU, VK_V,
        };
        
        let mut inputs: [INPUT; 6] = std::mem::zeroed();
        
        let create_kbd_input = |vk: u16, flags: u32| -> INPUT {
            let mut input: INPUT = std::mem::zeroed();
            input.r#type = INPUT_KEYBOARD;
            input.Anonymous.ki = KEYBDINPUT {
                wVk: vk,
                wScan: 0,
                dwFlags: flags,
                time: 0,
                dwExtraInfo: 0,
            };
            input
        };

        // Release Alt and Ctrl in case the user is still physically holding them
        inputs[0] = create_kbd_input(VK_MENU as u16, KEYEVENTF_KEYUP);
        inputs[1] = create_kbd_input(VK_CONTROL as u16, KEYEVENTF_KEYUP);
        
        // Press Ctrl
        inputs[2] = create_kbd_input(VK_CONTROL as u16, 0);
        // Press V
        inputs[3] = create_kbd_input(VK_V as u16, 0);
        
        // Release V
        inputs[4] = create_kbd_input(VK_V as u16, KEYEVENTF_KEYUP);
        // Release Ctrl
        inputs[5] = create_kbd_input(VK_CONTROL as u16, KEYEVENTF_KEYUP);

        SendInput(inputs.len() as u32, inputs.as_ptr(), std::mem::size_of::<INPUT>() as i32);
    }
}
