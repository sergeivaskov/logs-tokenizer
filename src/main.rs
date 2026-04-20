#![windows_subsystem = "windows"] // Раскомментировано, чтобы скрыть консоль для финальной версии

use logstokenizer::core::Compressor;

use arboard::Clipboard;
use global_hotkey::{
    hotkey::{Code, HotKey, Modifiers},
    GlobalHotKeyEvent, GlobalHotKeyManager,
};
use tao::event_loop::{ControlFlow, EventLoopBuilder};
use tray_icon::{
    menu::{Menu, MenuEvent, MenuItem},
    Icon, TrayIconBuilder,
};
#[cfg(windows)]
use tauri_winrt_notification::{Toast, IconCrop};
use std::path::Path;

const SVG_ICON: &str = include_str!("ico/ico.svg");

fn load_icon() -> (Icon, String) {
    println!("[Icon] Начинаем инициализацию иконки...");
    
    // 1. Detect OS Theme
    let mode = dark_light::detect();
    let is_dark = mode == dark_light::Mode::Dark;
    println!("[Icon] Тема ОС определена как: {:?}", mode);
    
    // 2. Replace fill color based on theme
    let fill_color = if is_dark { "white" } else { "black" };
    println!("[Icon] Используем цвет заливки: {}", fill_color);
    let svg_str = SVG_ICON.replace("fill=\"white\"", &format!("fill=\"{}\"", fill_color));

    // 3. Parse SVG
    use usvg::TreeParsing;
    let opt = usvg::Options::default();
    println!("[Icon] Парсинг SVG...");
    let mut tree = usvg::Tree::from_str(&svg_str, &opt).expect("Failed to parse SVG");
    tree.calculate_bounding_boxes();
    
    // 4. Render SVG to RGBA Pixmap
    // Увеличим размер до 32x32 для корректного отображения в трее Windows
    let width = 32;
    let height = 32;
    println!("[Icon] Рендеринг SVG в пиксели размером {}x{}", width, height);
    let mut pixmap = tiny_skia::Pixmap::new(width, height).unwrap();
    
    let transform = tiny_skia::Transform::from_scale(
        width as f32 / tree.size.width(),
        height as f32 / tree.size.height(),
    );

    resvg::render(
        &tree,
        transform,
        &mut pixmap.as_mut(),
    );

    // 5. Convert to Tray Icon
    println!("[Icon] Конвертация в формат иконки для трея...");
    
    // Кодируем в PNG и декодируем через image
    let png_data = pixmap.encode_png().unwrap();
    let dynamic_img = image::load_from_memory(&png_data).unwrap();
    
    // Сохраняем PNG во временную папку для заголовка уведомлений Windows
    let temp_dir = std::env::temp_dir();
    let icon_path = temp_dir.join("logstokenizer_icon.png");
    let _ = std::fs::write(&icon_path, &png_data);
    let icon_path_str = icon_path.to_string_lossy().to_string();
    
    let img = dynamic_img.into_rgba8();
    let (icon_width, icon_height) = img.dimensions();
    let rgba = img.into_raw();

    let icon = Icon::from_rgba(rgba, icon_width, icon_height).expect("Failed to create icon");
    println!("[Icon] Инициализация иконки успешно завершена.");
    
    (icon, icon_path_str)
}

#[derive(Debug)]
enum UserEvent {
    Menu(MenuEvent),
    Hotkey(GlobalHotKeyEvent),
}

#[cfg(windows)]
fn register_app_id(icon_path: &str) -> String {
    use winreg::enums::*;
    use winreg::RegKey;

    // Используем новый уникальный ID, чтобы сбросить жесткий кеш уведомлений Windows
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

fn main() {
    let (tray_icon_data, icon_path) = load_icon();

    #[cfg(windows)]
    let app_id = register_app_id(&icon_path);
    #[cfg(not(windows))]
    let app_id = "LogsTokenizer".to_string();

    println!("[Main] Запуск Logs Tokenizer...");

    // Initialize Event Loop with custom user events
    println!("[Main] Создание Event Loop...");
    let event_loop = EventLoopBuilder::<UserEvent>::with_user_event().build();
    let proxy = event_loop.create_proxy();

    // Setup Event Handlers to wake up the Event Loop
    let menu_proxy = proxy.clone();
    MenuEvent::set_event_handler(Some(move |event| {
        let _ = menu_proxy.send_event(UserEvent::Menu(event));
    }));

    let hotkey_proxy = proxy.clone();
    GlobalHotKeyEvent::set_event_handler(Some(move |event| {
        let _ = hotkey_proxy.send_event(UserEvent::Hotkey(event));
    }));

    // Setup Tray Menu
    println!("[Main] Настройка меню трея...");
    let tray_menu = Menu::new();
    let quit_i = MenuItem::new("Quit Logs Tokenizer", true, None);
    tray_menu.append(&quit_i).unwrap();

    // Setup Tray Icon
    println!("[Main] Создание иконки в системном трее...");
    let _tray_icon = TrayIconBuilder::new()
        .with_menu(Box::new(tray_menu))
        .with_tooltip("Logs Tokenizer (Ctrl+Alt+V)")
        .with_icon(tray_icon_data)
        .build()
        .unwrap();
    println!("[Main] Иконка в трее успешно создана.");

    // Show startup notification
    #[cfg(windows)]
    {
        let _ = Toast::new(&app_id)
            .text1("Утилита успешно запущена в фоне!")
            .text2("Нажмите Ctrl+Alt+V для вставки сжатых логов.")
            .show();
    }

    // Setup Global Hotkey (Ctrl + Alt + V)
    println!("[Main] Регистрация глобального хоткея (Ctrl+Alt+V)...");
    let manager = GlobalHotKeyManager::new().unwrap();
    let hotkey = HotKey::new(Some(Modifiers::CONTROL | Modifiers::ALT), Code::KeyV);
    if let Err(e) = manager.register(hotkey) {
        println!("[Error] Ошибка регистрации хоткея! Возможно, старый скрипт PowerShell всё еще запущен: {:?}", e);
        std::process::exit(1);
    }
    println!("[Main] Хоткей успешно зарегистрирован.");

    println!("[Main] Инициализация буфера обмена...");
    let mut clipboard = Clipboard::new().unwrap();

    println!("[Main] Вход в Event Loop. Ожидание нажатия Ctrl+Alt+V...");
    // Run Event Loop
    let app_id_clone = app_id.clone();
    event_loop.run(move |event, _, control_flow| {
        *control_flow = ControlFlow::Wait;

        if let tao::event::Event::UserEvent(user_event) = event {
            match user_event {
                UserEvent::Menu(menu_event) => {
                    if menu_event.id == quit_i.id() {
                        println!("[Menu] Запрошен выход. Завершение работы...");
                        *control_flow = ControlFlow::Exit;
                    }
                }
                UserEvent::Hotkey(hotkey_event) => {
                    if hotkey_event.id == hotkey.id() {
                        println!("[Hotkey] Получено событие хоткея: {:?}", hotkey_event.state);
                        
                        // Trigger only on key release to avoid repeating
                        if hotkey_event.state == global_hotkey::HotKeyState::Released {
                            println!("[Hotkey] Клавиши Ctrl+Alt+V отпущены. Читаем буфер обмена...");
                            
                            if let Ok(text) = clipboard.get_text() {
                                println!("[Clipboard] Прочитано {} символов.", text.len());
                                
                                if !text.trim().is_empty() {
                                    let original_text = text.clone();
                                    
                                    println!("[Compressor] Начинаем сжатие...");
                                    let original_len = text.len();
                                    let mut compressor = Compressor::new();
                                    let compressed = compressor.compress(text);
                                    let compressed_len = compressed.len();
                                    println!("[Compressor] Сжатие завершено. Новый размер: {} символов.", compressed_len);
                                    
                                    println!("[Clipboard] Запись сжатого текста обратно в буфер обмена...");
                                    let _ = clipboard.set_text(compressed);
                                    
                                    let savings = 100.0 * (1.0 - compressed_len as f64 / original_len as f64);
                                    
                                    #[cfg(windows)]
                                    {
                                        let _ = Toast::new(&app_id_clone)
                                            .title("Логи оптимизированы!")
                                            .text1(&format!("Сжато на {:.1}%", savings))
                                            .text2(&format!("(с {} до {} символов)", original_len, compressed_len))
                                            .show();
                                    }
                                    
                                    // Small delay to ensure clipboard is updated
                                    std::thread::sleep(std::time::Duration::from_millis(50));
                                    
                                    // Simulate Ctrl+V to paste the compressed text
                                    #[cfg(windows)]
                                    unsafe {
                                        println!("[Input] Эмуляция нажатия Ctrl+V для вставки...");
                                        use windows_sys::Win32::UI::Input::KeyboardAndMouse::{
                                            keybd_event, KEYEVENTF_KEYUP, VK_CONTROL, VK_MENU, VK_V,
                                        };
                                        
                                        // Release Alt and Ctrl in case the user is still physically holding them
                                        keybd_event(VK_MENU as u8, 0, KEYEVENTF_KEYUP, 0);
                                        keybd_event(VK_CONTROL as u8, 0, KEYEVENTF_KEYUP, 0);
                                        
                                        // Press Ctrl+V
                                        keybd_event(VK_CONTROL as u8, 0, 0, 0);
                                        keybd_event(VK_V as u8, 0, 0, 0);
                                        
                                        // Release Ctrl+V
                                        keybd_event(VK_V as u8, 0, KEYEVENTF_KEYUP, 0);
                                        keybd_event(VK_CONTROL as u8, 0, KEYEVENTF_KEYUP, 0);
                                        println!("[Input] Эмуляция Ctrl+V успешно завершена.");
                                    }
                                    
                                    // Restore the original clipboard content after a short delay
                                    // to allow the target application to read the compressed text first
                                    std::thread::sleep(std::time::Duration::from_millis(150));
                                    let _ = clipboard.set_text(original_text);
                                    println!("[Clipboard] Оригинальный текст восстановлен в буфере обмена.");
                                } else {
                                    println!("[Clipboard] Текст пустой, игнорируем.");
                                }
                            } else {
                                println!("[Clipboard] Ошибка: не удалось прочитать текст из буфера обмена.");
                            }
                        }
                    }
                }
            }
        }
    });
}
