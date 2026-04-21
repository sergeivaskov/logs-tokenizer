# Logs Tokenizer 🗜️

[📥 Download Logs.Tokenizer.exe](https://github.com/sergeivaskov/logs-tokenizer/releases/latest/download/Logs.Tokenizer.exe)

**Logs Tokenizer** is a smart background utility for developers, coders, and DevOps engineers that extremely compresses logs directly in the clipboard, keeping them in a readable text format.

## ⚠️ Problem

You need to save tokens when interacting with AI, especially with Claude Code, but you don't want to sacrifice volume. Logs contain a large amount of duplicated information that can be factored out.

## 💡 Solution

You simply copy logs, press `Ctrl+Alt+V`, and the utility instantly compresses the text up to 80% in the clipboard, replacing repeating patterns with short tokens and automatically pastes the result, which remains completely understandable for neural networks. Additionally, this structure allows you to highlight the problem for the agent without unnecessary noise and context window overflow.

---

## 🔍 Example

### Log lines before compression (Original)

```text
2026-04-20T19:58:52.970 [StageDiag] > handleTokenTracking vk=70 keyDown=0
2026-04-20T19:58:52.970 [TTTrack] htt: enter vk=70 keyDown=0
2026-04-20T19:58:52.970 [TTTrack] htt: after modifier check
2026-04-20T19:58:52.970 [TTTrack] htt: KeyUp branch, checking cachedSettings
2026-04-20T19:58:52.970 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0
2026-04-20T19:58:52.970 [TTTrack] htt: KeyUp postRepl=0
2026-04-20T19:58:52.971 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-20T19:58:52.971 [TTTrack] htt: KeyUp branch returning false
2026-04-20T19:58:53.017 [HookDiag] LowLevelKeyboardProc: vk=32 keyDown=1 injected=0 extraInfo=0 ctrlLogical=0 ctrlPhysical=0 heldMask=0x0 shouldTrack=1 skipInjected=0
2026-04-20T19:58:53.018 [StageDiag] > entry vk=32 keyDown=1
2026-04-20T19:58:53.018 [StageDiag] > drainPendingReset vk=32 keyDown=1
2026-04-20T19:58:53.018 [StageDiag] > shouldBlockAllFeatures vk=32 keyDown=1
2026-04-20T19:58:53.018 [StageDiag] > executePendingReplacementIfAny vk=32 keyDown=1
2026-04-20T19:58:53.019 [StageDiag] > hotkeyManager.processKeyEvent vk=32 keyDown=1
```

### Log lines after compression (Logs Tokenizer)

```text
!16!!t!83!2!
&1f:!A!
&1f:!F!
&1f:!D!
&1f:!B!
&1f:!w!
&1f:!y!
&1u:!z!
&1u:!E!
&1u:!C!
&1V:!G!
&1V:!P!
&1V:!Q!
&1V:!J!
!4!209 !v!
```

*At the beginning of the compressed version, a compact Legend (dictionary) is added, and the log text itself is radically shortened.*

---

## ✨ Key Features

- **Semantic log compression:** The algorithm understands log structure. It automatically finds timestamps, `[App]` components, `id=` keys, and trims leading zeros in hex addresses.
- **Macro templating:** A unique feature that finds machine-generated patterns (e.g., `User {ID} logged in`) and collapses them into short macros with parameters.
- **Inline deduplication:** Identical spam lines are collapsed into a compact `... xN` format.
- **Seamless UX:** The program sits in the system tray. You simply press a global hotkey, and it reads the buffer, compresses the text, shows a system notification with the compression percentage, and simulates pressing `Ctrl+V` (Paste).
- **Lightning speed:** Written in Rust. The core works at the token array level (without string allocations in hot loops), compressing megabytes of text in fractions of a second.

## 🚀 How to Use

1. Launch `Logs Tokenizer.exe` (an icon will appear in the tray).
2. Select and copy (`Ctrl+C`) any large chunk of logs.
3. Go to a messenger or ChatGPT.
4. Press `Ctrl + Alt + V` (you can set an alternative hotkey)
5. The compressed text will automatically be pasted into the input field.

## 🛠️ Building from Source

Make sure you have Rust (cargo) installed.

```bash
git clone https://github.com/sergeivaskov/logs-tokenizer.git
cd logstokenizer
cargo build --release
```

The executable file will be located at `target/release/logstokenizer.exe`.