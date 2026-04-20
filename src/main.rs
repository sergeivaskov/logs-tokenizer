#![windows_subsystem = "windows"] // Раскомментировано, чтобы скрыть консоль для финальной версии

mod platforms;

use logstokenizer::core::Compressor;

use arboard::Clipboard;
use global_hotkey::{
    hotkey::{Code, HotKey},
    GlobalHotKeyEvent, GlobalHotKeyManager,
};
use tao::event_loop::{ControlFlow, EventLoopBuilder};
use tray_icon::{
    menu::{Menu, MenuEvent, MenuItem, Submenu, CheckMenuItem},
    Icon, TrayIconBuilder,
};
use simplelog::{Config, LevelFilter, WriteLogger};
use anyhow::{Context, Result};
use std::fs::File;
use tempfile::NamedTempFile;
use std::io::Write;
use std::time::Duration;
use std::thread::sleep;

const SVG_ICON: &str = include_str!("ico/ico.svg");

const ICON_SIZE: u32 = 32;
const CLIPBOARD_SYNC_DELAY: Duration = Duration::from_millis(50);
const CLIPBOARD_RESTORE_DELAY: Duration = Duration::from_millis(150);

#[derive(Debug)]
enum UserEvent {
    Menu(MenuEvent),
    Hotkey(GlobalHotKeyEvent),
}

#[derive(Clone, Copy)]
enum HotkeyOption {
    ShiftCtrlAltV,
    ShiftAltV,
    CtrlAltV,
    AltV,
}

impl HotkeyOption {
    fn modifiers(&self) -> global_hotkey::hotkey::Modifiers {
        #[cfg(target_os = "macos")]
        let ctrl = global_hotkey::hotkey::Modifiers::META;
        #[cfg(not(target_os = "macos"))]
        let ctrl = global_hotkey::hotkey::Modifiers::CONTROL;

        let alt = global_hotkey::hotkey::Modifiers::ALT;
        let shift = global_hotkey::hotkey::Modifiers::SHIFT;

        match self {
            HotkeyOption::ShiftCtrlAltV => shift | ctrl | alt,
            HotkeyOption::ShiftAltV => shift | alt,
            HotkeyOption::CtrlAltV => ctrl | alt,
            HotkeyOption::AltV => alt,
        }
    }
}

fn init_logging() -> Result<()> {
    let mut log_path = std::env::temp_dir();
    log_path.push("logstokenizer.log");
    
    WriteLogger::init(
        LevelFilter::Info,
        Config::default(),
        File::create(log_path).context("Failed to create log file")?,
    )?;
    
    Ok(())
}

use usvg::TreeParsing;

fn load_icon() -> Result<(Icon, NamedTempFile)> {
    let mode = dark_light::detect();
    let fill_color = if mode == dark_light::Mode::Dark { "white" } else { "black" };
    let svg_str = SVG_ICON.replace("fill=\"white\"", &format!("fill=\"{}\"", fill_color));

    let mut tree = usvg::Tree::from_str(&svg_str, &usvg::Options::default()).context("Parse SVG")?;
    tree.calculate_bounding_boxes();
    
    let mut pixmap = tiny_skia::Pixmap::new(ICON_SIZE, ICON_SIZE).context("Create pixmap")?;
    let transform = tiny_skia::Transform::from_scale(
        ICON_SIZE as f32 / tree.size.width(),
        ICON_SIZE as f32 / tree.size.height(),
    );

    resvg::render(&tree, transform, &mut pixmap.as_mut());
    let png_data = pixmap.encode_png().context("Encode PNG")?;
    
    let mut temp_file = NamedTempFile::with_prefix("logstokenizer_icon_")?;
    temp_file.write_all(&png_data)?;
    
    let img = image::load_from_memory(&png_data).context("Load image")?.into_rgba8();
    let (w, h) = img.dimensions();
    let icon = Icon::from_rgba(img.into_raw(), w, h).context("Create icon")?;
    
    Ok((icon, temp_file))
}

fn handle_hotkey_press(clipboard: &mut Clipboard, app_id: &str) -> Result<()> {
    let text = clipboard.get_text().unwrap_or_default();
    if text.trim().is_empty() { return Ok(()); }
    
    let original_len = text.len();
    let compressed = Compressor::new().compress(text.clone());
    let compressed_len = compressed.len();
    
    if clipboard.set_text(&compressed).is_err() { return Ok(()); }
    
    let savings = 100.0 * (1.0 - compressed_len as f64 / original_len as f64);
    platforms::show_success_notification(app_id, savings, original_len, compressed_len);
    
    sleep(CLIPBOARD_SYNC_DELAY);
    platforms::simulate_paste();
    sleep(CLIPBOARD_RESTORE_DELAY);
    
    let _ = clipboard.set_text(text);
    Ok(())
}

fn main() -> Result<()> {
    init_logging()?;

    let (tray_icon_data, _icon_temp_file) = load_icon()?;
    let app_id = platforms::setup_env(&_icon_temp_file.path().to_string_lossy());

    let event_loop = EventLoopBuilder::<UserEvent>::with_user_event().build();
    let proxy = event_loop.create_proxy();

    MenuEvent::set_event_handler(Some(move |e| { let _ = proxy.send_event(UserEvent::Menu(e)); }));
    let proxy = event_loop.create_proxy();
    GlobalHotKeyEvent::set_event_handler(Some(move |e| { let _ = proxy.send_event(UserEvent::Hotkey(e)); }));

    let tray_menu = Menu::new();
    
    let hk_1 = CheckMenuItem::new("Shift+Ctrl+Alt+V", true, false, None);
    let hk_2 = CheckMenuItem::new("Shift+Alt+V", true, false, None);
    let hk_3 = CheckMenuItem::new("Ctrl+Alt+V", true, true, None);
    let hk_4 = CheckMenuItem::new("Alt+V", true, false, None);

    let hotkey_submenu = Submenu::new("Hotkey", true);
    hotkey_submenu.append(&hk_1)?;
    hotkey_submenu.append(&hk_2)?;
    hotkey_submenu.append(&hk_3)?;
    hotkey_submenu.append(&hk_4)?;

    let quit_i = MenuItem::new("Quit Logs Tokenizer", true, None);
    
    tray_menu.append(&hotkey_submenu)?;
    tray_menu.append(&quit_i)?;

    let hotkeys_map = vec![
        (hk_1.id().clone(), hk_1.clone(), HotkeyOption::ShiftCtrlAltV),
        (hk_2.id().clone(), hk_2.clone(), HotkeyOption::ShiftAltV),
        (hk_3.id().clone(), hk_3.clone(), HotkeyOption::CtrlAltV),
        (hk_4.id().clone(), hk_4.clone(), HotkeyOption::AltV),
    ];

    let _tray_icon = TrayIconBuilder::new()
        .with_menu(Box::new(tray_menu))
        .with_tooltip("Logs Tokenizer")
        .with_icon(tray_icon_data)
        .build()?;

    platforms::show_startup_notification(&app_id);

    let manager = GlobalHotKeyManager::new()?;
    let mut current_hotkey = HotKey::new(Some(HotkeyOption::CtrlAltV.modifiers()), Code::KeyV);
    if manager.register(current_hotkey).is_err() {
        anyhow::bail!("Hotkey registration failed. Is another instance running?");
    }

    let mut clipboard = Clipboard::new()?;
    
    event_loop.run(move |event, _, control_flow| {
        *control_flow = ControlFlow::Wait;
        match event {
            tao::event::Event::UserEvent(UserEvent::Menu(m)) => {
                if m.id == quit_i.id() {
                    *control_flow = ControlFlow::Exit;
                } else {
                    for (id, item, opt) in &hotkeys_map {
                        if m.id == *id {
                            let _ = manager.unregister(current_hotkey);
                            current_hotkey = HotKey::new(Some(opt.modifiers()), Code::KeyV);
                            let _ = manager.register(current_hotkey);
                            
                            for (_, other_item, _) in &hotkeys_map {
                                other_item.set_checked(other_item.id() == item.id());
                            }
                            break;
                        }
                    }
                }
            }
            tao::event::Event::UserEvent(UserEvent::Hotkey(h)) if h.id == current_hotkey.id() && h.state == global_hotkey::HotKeyState::Released => {
                let _ = handle_hotkey_press(&mut clipboard, &app_id);
            }
            _ => {}
        }
    });
}
