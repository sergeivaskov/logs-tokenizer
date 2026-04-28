#![windows_subsystem = "windows"] // Uncommented to hide console for the final release

mod platforms;

use logstokenizer::core::Compressor;
use arboard::Clipboard;
use global_hotkey::{
    hotkey::{Code, HotKey, Modifiers},
    GlobalHotKeyEvent, GlobalHotKeyManager, HotKeyState,
};
use tao::event_loop::{ControlFlow, EventLoopBuilder};
use tray_icon::{
    menu::{Menu, MenuEvent, MenuItem, Submenu, CheckMenuItem, MenuId},
    Icon, TrayIconBuilder,
};
use simplelog::{Config, LevelFilter, WriteLogger, TermLogger, CombinedLogger, TerminalMode, ColorChoice};
use anyhow::{Context, Result};
use std::fs::File;
use tempfile::NamedTempFile;
use std::io::Write;
use std::time::Duration;
use std::thread::sleep;
use std::sync::atomic::{AtomicBool, Ordering};
use usvg::TreeParsing;

const SVG_ICON: &str = include_str!("ico/ico.svg");
const ICON_SIZE: u32 = 32;
const CLIPBOARD_SYNC_DELAY: Duration = Duration::from_millis(150);
const CLIPBOARD_RESTORE_DELAY: Duration = Duration::from_millis(300);

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
    #[cfg(target_os = "macos")]
    MacCtrlAltV,
    #[cfg(target_os = "macos")]
    MacShiftCtrlAltV,
    #[cfg(target_os = "macos")]
    MacCtrlV,
    #[cfg(target_os = "macos")]
    MacShiftCtrlV,
}

impl HotkeyOption {
    fn modifiers(self) -> Modifiers {
        let alt = Modifiers::ALT;
        let shift = Modifiers::SHIFT;
        
        #[cfg(target_os = "macos")]
        let ctrl = Modifiers::META;
        #[cfg(not(target_os = "macos"))]
        let ctrl = Modifiers::CONTROL;

        match self {
            Self::ShiftCtrlAltV => shift | ctrl | alt,
            Self::ShiftAltV => shift | alt,
            Self::CtrlAltV => ctrl | alt,
            Self::AltV => alt,
            #[cfg(target_os = "macos")]
            Self::MacCtrlAltV => Modifiers::CONTROL | alt,
            #[cfg(target_os = "macos")]
            Self::MacShiftCtrlAltV => shift | Modifiers::CONTROL | alt,
            #[cfg(target_os = "macos")]
            Self::MacCtrlV => Modifiers::CONTROL,
            #[cfg(target_os = "macos")]
            Self::MacShiftCtrlV => shift | Modifiers::CONTROL,
        }
    }
}

struct HotkeyConfig {
    label: &'static str,
    default: bool,
    option: HotkeyOption,
}

const HOTKEYS: &[HotkeyConfig] = &[
    HotkeyConfig {
        #[cfg(target_os = "macos")] label: "Shift+Cmd+Alt+V",
        #[cfg(not(target_os = "macos"))] label: "Shift+Ctrl+Alt+V",
        default: false,
        option: HotkeyOption::ShiftCtrlAltV,
    },
    #[cfg(target_os = "macos")]
    HotkeyConfig {
        label: "Shift+Ctrl+Alt+V",
        default: false,
        option: HotkeyOption::MacShiftCtrlAltV,
    },
    HotkeyConfig {
        label: "Shift+Alt+V",
        default: false,
        option: HotkeyOption::ShiftAltV,
    },
    #[cfg(target_os = "macos")]
    HotkeyConfig {
        label: "Shift+Ctrl+V",
        default: false,
        option: HotkeyOption::MacShiftCtrlV,
    },
    HotkeyConfig {
        #[cfg(target_os = "macos")] label: "Cmd+Alt+V",
        #[cfg(not(target_os = "macos"))] label: "Ctrl+Alt+V",
        default: true,
        option: HotkeyOption::CtrlAltV,
    },
    #[cfg(target_os = "macos")]
    HotkeyConfig {
        label: "Ctrl+Alt+V",
        default: false,
        option: HotkeyOption::MacCtrlAltV,
    },
    #[cfg(target_os = "macos")]
    HotkeyConfig {
        label: "Ctrl+V",
        default: false,
        option: HotkeyOption::MacCtrlV,
    },
    HotkeyConfig {
        label: "Alt+V",
        default: false,
        option: HotkeyOption::AltV,
    },
];

fn init_logging() -> Result<()> {
    let mut log_path = std::env::temp_dir();
    log_path.push("logstokenizer.log");
    
    CombinedLogger::init(vec![
        TermLogger::new(LevelFilter::Info, Config::default(), TerminalMode::Mixed, ColorChoice::Auto),
        WriteLogger::new(LevelFilter::Info, Config::default(), File::create(log_path).context("Create log file")?),
    ])?;
    Ok(())
}

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

    let mut event_loop = EventLoopBuilder::<UserEvent>::with_user_event().build();
    #[cfg(target_os = "macos")]
    {
        use tao::platform::macos::{EventLoopExtMacOS, ActivationPolicy};
        event_loop.set_activation_policy(ActivationPolicy::Accessory);
    }
    
    let proxy = event_loop.create_proxy();
    MenuEvent::set_event_handler(Some(move |e| { let _ = proxy.send_event(UserEvent::Menu(e)); }));
    
    let proxy = event_loop.create_proxy();
    GlobalHotKeyEvent::set_event_handler(Some(move |e| { let _ = proxy.send_event(UserEvent::Hotkey(e)); }));

    let tray_menu = Menu::new();
    let hotkey_submenu = Submenu::new("Hotkey", true);
    
    let hotkeys_map: Vec<_> = HOTKEYS.iter().map(|cfg| {
        let item = CheckMenuItem::new(cfg.label, true, cfg.default, None);
        hotkey_submenu.append(&item).unwrap();
        (item.id().clone(), item, cfg.option)
    }).collect();

    let quit_i = MenuItem::new("Quit Logs Tokenizer", true, None);
    
    tray_menu.append(&hotkey_submenu)?;
    tray_menu.append(&quit_i)?;

    let mut clipboard = Clipboard::new()?;
    let mut manager = GlobalHotKeyManager::new().ok();
    let mut current_hotkey = HotKey::new(Some(HotkeyOption::CtrlAltV.modifiers()), Code::KeyV);
    let mut tray_icon = None;

    event_loop.run(move |event, _, control_flow| {
        *control_flow = ControlFlow::Wait;
        
        match event {
            tao::event::Event::NewEvents(tao::event::StartCause::Init) => {
                tray_icon = Some(init_tray(&tray_menu, &tray_icon_data));
                register_initial_hotkey(&manager, current_hotkey);
                platforms::show_startup_notification(&app_id);
            }
            tao::event::Event::UserEvent(UserEvent::Menu(m)) => {
                handle_menu_event(&m, control_flow, &manager, &mut current_hotkey, &hotkeys_map, quit_i.id());
            }
            tao::event::Event::UserEvent(UserEvent::Hotkey(h)) => {
                handle_hotkey_event(&h, &current_hotkey, &mut clipboard, &app_id);
            }
            _ => {}
        }
    });
}

fn init_tray(menu: &Menu, icon: &Icon) -> tray_icon::TrayIcon {
    log::info!("[Init] Initializing tray icon and hotkeys");
    let icon = TrayIconBuilder::new()
        .with_menu(Box::new(menu.clone()))
        .with_tooltip("Logs Tokenizer")
        .with_icon(icon.clone())
        .with_icon_as_template(true)
        .build()
        .unwrap();

    #[cfg(target_os = "macos")]
    unsafe {
        use core_foundation::runloop::{CFRunLoopGetMain, CFRunLoopWakeUp};
        CFRunLoopWakeUp(CFRunLoopGetMain());
    }
    icon
}

fn register_initial_hotkey(manager: &Option<GlobalHotKeyManager>, hk: HotKey) {
    let Some(m) = manager else { return };
    if m.register(hk).is_err() {
        log::error!("Hotkey registration failed. Is another instance running?");
    } else {
        log::info!("[Hotkey] Successfully registered default hotkey");
    }
}

fn handle_menu_event(
    m: &MenuEvent,
    control_flow: &mut ControlFlow,
    manager: &Option<GlobalHotKeyManager>,
    current_hotkey: &mut HotKey,
    hotkeys_map: &[(MenuId, CheckMenuItem, HotkeyOption)],
    quit_id: &MenuId,
) {
    log::info!("[Menu] Item clicked: {:?}", m.id);
    
    if m.id == *quit_id {
        *control_flow = ControlFlow::Exit;
        return;
    }

    let Some((_, selected_item, opt)) = hotkeys_map.iter().find(|(id, _, _)| m.id == *id) else { return };

    if let Some(mng) = manager {
        let _ = mng.unregister(*current_hotkey);
        *current_hotkey = HotKey::new(Some(opt.modifiers()), Code::KeyV);
        if let Err(e) = mng.register(*current_hotkey) {
            log::error!("[Hotkey] Failed to register new hotkey: {:?}", e);
        } else {
            log::info!("[Hotkey] Successfully changed hotkey");
        }
    }

    for (_, item, _) in hotkeys_map {
        item.set_checked(item.id() == selected_item.id());
    }
}

fn handle_hotkey_event(
    h: &GlobalHotKeyEvent,
    current_hotkey: &HotKey,
    clipboard: &mut Clipboard,
    app_id: &str,
) {
    log::info!("[Hotkey] Event received: {:?}", h);
    
    if h.id != current_hotkey.id() || h.state != HotKeyState::Released {
        return;
    }

    static IS_SIMULATING: AtomicBool = AtomicBool::new(false);
    
    if IS_SIMULATING.swap(true, Ordering::SeqCst) {
        log::info!("[Hotkey] Ignored event during simulation");
        return;
    }

    log::info!("[Hotkey] Triggering paste action");
    
    if let Err(e) = handle_hotkey_press(clipboard, app_id) {
        log::error!("[Action] Failed to handle hotkey press: {:?}", e);
    }
    
    std::thread::spawn(|| {
        std::thread::sleep(std::time::Duration::from_millis(500));
        IS_SIMULATING.store(false, Ordering::SeqCst);
    });
}
