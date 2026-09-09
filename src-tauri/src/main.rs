#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::net::{TcpListener, TcpStream};
use std::process::{Child, Command};
use std::sync::Mutex;
use std::time::{Duration, Instant};

use tauri::{Manager, RunEvent, WebviewUrl, WebviewWindowBuilder};

struct ChildProcess(Mutex<Option<Child>>);

/// Asks the OS for an ephemeral port by binding to port 0, then releases it.
/// There is a small race between releasing the listener and the app binding
/// to it, but it is negligible in practice for a single local desktop app.
fn find_free_port() -> u16 {
    let listener = TcpListener::bind("127.0.0.1:0").expect("failed to bind ephemeral port");
    listener.local_addr().expect("failed to read local addr").port()
}

fn wait_for_port(port: u16, timeout: Duration) -> bool {
    let deadline = Instant::now() + timeout;
    while Instant::now() < deadline {
        if TcpStream::connect(("127.0.0.1", port)).is_ok() {
            return true;
        }
        std::thread::sleep(Duration::from_millis(150));
    }
    false
}

fn main() {
    tauri::Builder::default()
        .manage(ChildProcess(Mutex::new(None)))
        .setup(|app| {
            let port = find_free_port();

            let exe_dir = std::env::current_exe()?
                .parent()
                .expect("executable has no parent directory")
                .to_path_buf();
            let app_exe = exe_dir.join("lib").join("app.exe");

            let child = Command::new(&app_exe)
                .current_dir(&exe_dir)
                .env("FINCH_DOC_PORT", port.to_string())
                .spawn()
                .unwrap_or_else(|e| panic!("failed to start {:?}: {}", app_exe, e));

            *app.state::<ChildProcess>().0.lock().unwrap() = Some(child);

            wait_for_port(port, Duration::from_secs(15));

            let url = format!("http://localhost:{port}");
            WebviewWindowBuilder::new(app, "main", WebviewUrl::External(url.parse()?))
                .title("Finch Doc")
                .inner_size(1280.0, 800.0)
                .build()?;

            Ok(())
        })
        .build(tauri::generate_context!())
        .expect("error while running finch_doc tauri application")
        .run(|app_handle, event| {
            if let RunEvent::ExitRequested { .. } = event {
                if let Some(child) = app_handle.state::<ChildProcess>().0.lock().unwrap().as_mut() {
                    let _ = child.kill();
                }
            }
        });
}
