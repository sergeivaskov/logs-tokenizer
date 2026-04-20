# Logs Tokenizer - Intelligent log compression for clipboard
# Author: Sergei Vaskov
# Version: 2.0
# Usage: Run script, copy logs (Ctrl+C), paste with Ctrl+Alt+V

param(
    [switch]$Debug
)

$ErrorActionPreference = "Stop"
$logFile = Join-Path $env:TEMP "logs-tokenizer-log.txt"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append -Encoding utf8
    if ($Debug) {
        Write-Host $Message
    }
}

try {
    Write-Log "=== Logs Tokenizer starting ==="
    
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    Write-Log "Loaded System.Windows.Forms and System.Drawing"

    # Create C# class for form with WndProc
    $code = @"
using System;
using System.Windows.Forms;
using System.Drawing;
using System.Runtime.InteropServices;

public class HotkeyManager
{
    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);
    
    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    
    public const int MOD_ALT = 0x0001;
    public const int MOD_CONTROL = 0x0002;
    public const int WM_HOTKEY = 0x0312;
    public const int VK_V = 0x56;
    public const int VK_CONTROL = 0x11;
    public const int KEYEVENTF_KEYUP = 0x0002;
}

public class HotkeyForm : Form
{
    private const int WM_HOTKEY = 0x0312;
    public event EventHandler HotkeyPressed;
    private int hotkeyId;
    
    public HotkeyForm()
    {
        this.Size = new Size(1, 1);
        this.StartPosition = FormStartPosition.Manual;
        this.Location = new Point(-2000, -2000);
        this.ShowInTaskbar = false;
        this.FormBorderStyle = FormBorderStyle.None;
        this.Opacity = 0;
    }
    
    public bool RegisterHotkey(int id, int modifiers, int vk)
    {
        this.hotkeyId = id;
        return HotkeyManager.RegisterHotKey(this.Handle, id, modifiers, vk);
    }
    
    public void UnregisterHotkey()
    {
        HotkeyManager.UnregisterHotKey(this.Handle, this.hotkeyId);
    }
    
    protected override void WndProc(ref Message m)
    {
        if (m.Msg == WM_HOTKEY)
        {
            if (HotkeyPressed != null)
            {
                HotkeyPressed(this, EventArgs.Empty);
            }
        }
        base.WndProc(ref m);
    }
}
"@

    Add-Type -TypeDefinition $code -ReferencedAssemblies System.Windows.Forms, System.Drawing
    Write-Log "Created HotkeyForm class"

    # Global variables
    $script:isProcessing = $false
    $script:notifyIcon = $null
    $script:form = $null

    # Log compression function
    function Compress-Logs {
        param([string]$text)
        
        if ([string]::IsNullOrWhiteSpace($text)) { return $text }
        
        # 0. Strip leading zeros from long numbers/hex to save tokens
        $text = [regex]::Replace($text, '\b0{3,}(?=[1-9A-Fa-f][0-9A-Fa-f]*\b)', '')
        $text = [regex]::Replace($text, '\b0{3,}(?=0\b)', '')
        $text = [regex]::Replace($text, '(?<=\b0x)0{3,}(?=[1-9A-Fa-f][0-9A-Fa-f]*\b)', '')
        $text = [regex]::Replace($text, '(?<=\b0x)0{3,}(?=0\b)', '')
        
        $legend = New-Object System.Collections.ArrayList
        $script:varIdx = 0
        $base62 = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        function Get-NextToken {
            $num = $script:varIdx
            $script:varIdx++
            if ($num -eq 0) { return "#0" }
            $res = ""
            $n = $num
            while ($n -gt 0) {
                $rem = $n % 62
                $res = $base62[$rem] + $res
                $n = [math]::Floor($n / 62)
            }
            return "#" + $res
        }
        
        # 1. Timestamp Prefix
        $tsMatches = [regex]::Matches($text, '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:')
        if ($tsMatches.Count -gt 0) {
            $tsCounts = @{}
            foreach ($m in $tsMatches) { $tsCounts[$m.Value]++ }
            $bestTs = ($tsCounts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Name
            $text = $text.Replace($bestTs, '#T')
            [void]$legend.Add("#T = $bestTs")
        }
        
        # 2. Components [XXX]
        $compMatches = [regex]::Matches($text, '\[[A-Za-z0-9_-]+\]')
        $compCounts = @{}
        foreach ($m in $compMatches) { $compCounts[$m.Value]++ }
        foreach ($kv in ($compCounts.GetEnumerator() | Sort-Object Value -Descending)) {
            if ($kv.Value -gt 1) {
                $token = Get-NextToken
                $text = $text.Replace($kv.Name, $token)
                [void]$legend.Add("$token = $($kv.Name)")
            }
        }
        
        # 3. Common Keys (e.g. hwnd=, WorkingSet=)
        $keyMatches = [regex]::Matches($text, '\b[A-Za-z0-9_]+={1,2}')
        $keyCounts = @{}
        foreach ($m in $keyMatches) { $keyCounts[$m.Value]++ }
        foreach ($kv in ($keyCounts.GetEnumerator() | Sort-Object Value -Descending)) {
            if ($kv.Value -gt 1) {
                $token = Get-NextToken
                $text = $text.Replace($kv.Name, $token)
                [void]$legend.Add("$token = $($kv.Name)")
            }
        }
        
        # We'll use C# for the heavy lifting
        $csharpCode = @"
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Text;

public class FastCompressor {
    public static string RunBPE(string text, int maxIterations, bool isMeta, ref int varIdx, ArrayList legend) {
        string base62 = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        Regex metaSplit = new Regex(@"(#(?:T|[0-9a-zA-Z]+)|![0-9]+)");
        Regex normalSplit = new Regex(@"(#(?:T|[0-9a-zA-Z]+))");
        Regex metaTokenizer = new Regex(@"#[a-zA-Z0-9]+|[A-Za-z0-9_]+|[^A-Za-z0-9_#]+");
        Regex normalTokenizer = new Regex(@"[A-Za-z0-9_]+|[^A-Za-z0-9_]+");
        
        for (int iter = 0; iter < maxIterations; iter++) {
            var substringCounts = new Dictionary<string, int>();
            string[] parts;
            if (isMeta) {
                // For Meta-BPE we split by newlines to avoid matching across lines
                parts = text.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);
            } else {
                parts = normalSplit.Split(text);
            }
            
            Regex tokenizer = isMeta ? metaTokenizer : normalTokenizer;
            
            foreach (string part in parts) {
                if (string.IsNullOrEmpty(part)) continue;
                if (!isMeta && normalSplit.IsMatch(part) && part == normalSplit.Match(part).Value) continue;
                
                MatchCollection matches = tokenizer.Matches(part);
                int len = matches.Count;
                string[] tokens = new string[len];
                for (int i = 0; i < len; i++) tokens[i] = matches[i].Value;
                
                int maxN = Math.Min(isMeta ? 15 : 20, len);
                for (int n = 2; n <= maxN; n++) {
                    for (int i = 0; i <= len - n; i++) {
                        StringBuilder sb = new StringBuilder();
                        for(int j=0; j<n; j++) sb.Append(tokens[i+j]);
                        string phrase = sb.ToString();
                        
                        if (phrase.Contains("\n") || phrase.Contains("\r")) continue;
                        if (phrase.Trim().Length < (isMeta ? 5 : 4)) continue;
                        if (isMeta && !phrase.Contains("#")) continue;
                        
                        if (substringCounts.ContainsKey(phrase)) {
                            substringCounts[phrase]++;
                        } else {
                            substringCounts[phrase] = 1;
                        }
                    }
                }
            }
            
            string bestPhrase = null;
            int bestSavings = 0;
            
            foreach (var kv in substringCounts) {
                if (kv.Value > 1) {
                    int tagLen = isMeta ? (varIdx.ToString().Length + 1) : (varIdx > 61 ? 3 : 2);
                    int savings = kv.Value * (kv.Key.Length - tagLen) - (tagLen + 3 + kv.Key.Length);
                    if (savings > bestSavings) {
                        bestSavings = savings;
                        bestPhrase = kv.Key;
                    }
                }
            }
            
            if (bestSavings < 5) break;
            
            string token = "";
            if (isMeta) {
                token = "!" + varIdx;
                varIdx++;
            } else {
                int num = varIdx++;
                if (num == 0) token = "#0";
                else {
                    string res = "";
                    int n = num;
                    while (n > 0) {
                        res = base62[n % 62] + res;
                        n /= 62;
                    }
                    token = "#" + res;
                }
            }
            
            string escaped = Regex.Escape(bestPhrase);
            if (Regex.IsMatch(bestPhrase[0].ToString(), @"^[A-Za-z0-9_]$")) escaped = @"(?<![A-Za-z0-9_])" + escaped;
            if (Regex.IsMatch(bestPhrase[bestPhrase.Length-1].ToString(), @"^[A-Za-z0-9_]$")) escaped = escaped + @"(?![A-Za-z0-9_])";
            
            if (isMeta) {
                text = Regex.Replace(text, escaped, token);
            } else {
                StringBuilder newText = new StringBuilder();
                string[] replaceParts = normalSplit.Split(text);
                foreach (string part in replaceParts) {
                    if (normalSplit.IsMatch(part) && part == normalSplit.Match(part).Value) {
                        newText.Append(part);
                    } else {
                        newText.Append(Regex.Replace(part, escaped, token));
                    }
                }
                text = newText.ToString();
            }
            
            string displayPhrase = bestPhrase;
            if (displayPhrase.StartsWith(" ") || displayPhrase.EndsWith(" ")) displayPhrase = "'" + displayPhrase + "'";
            legend.Add(token + " = " + displayPhrase);
        }
        return text;
    }
}
"@
        
        try {
            Add-Type -TypeDefinition $csharpCode -Language CSharp -ErrorAction SilentlyContinue
        } catch {}
        
        # 4. BPE
        $text = [FastCompressor]::RunBPE($text, 100, $false, [ref]$script:varIdx, $legend)
        
        # 4.5 Meta-BPE
        $script:metaIdx = 1
        $text = [FastCompressor]::RunBPE($text, 100, $true, [ref]$script:metaIdx, $legend)
        
        # 5. MACRO TEMPLATING (Option 1)
        $lines = $text -split "`r?`n"
        $templates = @{}
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $lines[$i] = $lines[$i].TrimEnd()
            $line = $lines[$i]
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            
            # Find all tags in the line to use as potential variables
            $matches = [regex]::Matches($line, '(#(T|[0-9a-zA-Z]+)|![0-9]+)')
            foreach ($m in $matches) {
                # Create a template by replacing this specific tag with @
                $template = $line.Substring(0, $m.Index) + "@" + $line.Substring($m.Index + $m.Length)
                
                # Lowered length limit to 5 to catch short repeating structures like !26@!3
                if ($template.Length -lt 5) { continue }
                
                if (-not $templates.ContainsKey($template)) {
                    $templates[$template] = New-Object System.Collections.ArrayList
                }
                
                $matchData = New-Object PSObject -Property @{
                    LineIdx = $i
                    Var = $m.Value
                }
                [void]$templates[$template].Add($matchData)
            }
        }
        
        # Evaluate templates
        $templateScores = @{}
        foreach ($kv in $templates.GetEnumerator()) {
            $count = $kv.Value.Count
            # Calculate approximate savings
            # Savings = (Count - 1) * TemplateLength - 4 * Count - 5
            $savings = ($count - 1) * $kv.Name.Length - 4 * $count - 5
            
            # Allow if it saves space OR if it appears frequently (>= 4 times) for visual structure
            if ($savings -gt 0 -or $count -ge 4) {
                # Score prioritizes frequency and length
                $templateScores[$kv.Name] = $count * $kv.Name.Length
            }
        }
        
        $lineTemplated = New-Object bool[] $lines.Count
        $macroIdx = 1
        
        foreach ($kv in ($templateScores.GetEnumerator() | Sort-Object Value -Descending)) {
            $template = $kv.Name
            $matches = $templates[$template]
            
            # Filter matches that haven't been templated yet
            $validMatches = New-Object System.Collections.ArrayList
            foreach ($m in $matches) {
                if (-not $lineTemplated[$m.LineIdx]) {
                    [void]$validMatches.Add($m)
                }
            }
            
            if ($validMatches.Count -gt 1) {
                $macroTag = "&$macroIdx"
                $macroIdx++
                [void]$legend.Add("$macroTag = $template")
                
                foreach ($m in $validMatches) {
                    # Format: &1:C (remove the '#' or '!' from the variable)
                    $varClean = $m.Var -replace '^[#!]', ''
                    $lines[$m.LineIdx] = "$($macroTag):$varClean"
                    $lineTemplated[$m.LineIdx] = $true
                }
            }
        }
        
        # 6. Intra-line deduplication
        $finalLines = New-Object System.Collections.ArrayList
        $dupCount = 0
        $lastLine = ""
        
        foreach ($line in $lines) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            
            $lineNoTime = $line -replace '^#T\d{2}\.\d{3}\s*', ''
            if ($lineNoTime -eq $lastLine -and $lineNoTime -ne "") {
                $dupCount++
                continue
            }
            
            if ($dupCount -gt 0) {
                [void]$finalLines.Add("    ... (repeated $dupCount more times)")
                $dupCount = 0
            }
            
            [void]$finalLines.Add($line)
            $lastLine = $lineNoTime
        }
        if ($dupCount -gt 0) {
            [void]$finalLines.Add("    ... (repeated $dupCount more times)")
        }
        
        $result = "--- LEGEND ---`n"
        $result += ($legend -join "`n")
        $result += "`n`n--- LOGS ---`n"
        $result += ($finalLines -join "`n")
        
        return $result
    }

    # Hotkey handler function
    function Process-SmartPaste {
        if ($script:isProcessing) {
            return
        }
        
        $script:isProcessing = $true
        Write-Log "Processing Ctrl+Alt+V..."
        
        try {
            $originalText = Get-Clipboard -Raw -ErrorAction SilentlyContinue
            
            if ([string]::IsNullOrWhiteSpace($originalText)) {
                Write-Log "Clipboard is empty"
                $script:notifyIcon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
                $script:notifyIcon.BalloonTipTitle = "Logs Tokenizer"
                $script:notifyIcon.BalloonTipText = "Clipboard is empty"
                $script:notifyIcon.ShowBalloonTip(1000)
                return
            }
            
            Write-Log "Original size: $($originalText.Length) chars"
            $compressedText = Compress-Logs -text $originalText
            
            $originalSize = $originalText.Length
            $compressedSize = $compressedText.Length
            $savedPercent = if ($originalSize -gt 0) {
                [math]::Round((1 - $compressedSize / $originalSize) * 100, 1)
            } else { 0 }
            
            Write-Log "Compressed size: $compressedSize chars (-$savedPercent%)"
            
            Set-Clipboard -Value $compressedText
            Start-Sleep -Milliseconds 50
            
            # Paste via Ctrl+V
            [HotkeyManager]::keybd_event([HotkeyManager]::VK_CONTROL, 0, 0, [UIntPtr]::Zero)
            Start-Sleep -Milliseconds 10
            [HotkeyManager]::keybd_event([HotkeyManager]::VK_V, 0, 0, [UIntPtr]::Zero)
            Start-Sleep -Milliseconds 10
            [HotkeyManager]::keybd_event([HotkeyManager]::VK_V, 0, [HotkeyManager]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)
            Start-Sleep -Milliseconds 10
            [HotkeyManager]::keybd_event([HotkeyManager]::VK_CONTROL, 0, [HotkeyManager]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)
            
            # Wait for the target application to process the paste
            Start-Sleep -Milliseconds 150
            
            # Restore original clipboard
            Set-Clipboard -Value $originalText
            Write-Log "Restored original clipboard content"
            
            $script:notifyIcon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
            $script:notifyIcon.BalloonTipTitle = "Logs Tokenizer"
            $script:notifyIcon.BalloonTipText = "Pasted $compressedSize chars (saved $savedPercent%)"
            $script:notifyIcon.ShowBalloonTip(2000)
            
            Write-Log "Successfully pasted"
        }
        catch {
            Write-Log "Error: $_"
            $script:notifyIcon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
            $script:notifyIcon.BalloonTipTitle = "Logs Tokenizer"
            $script:notifyIcon.BalloonTipText = "Error: $_"
            $script:notifyIcon.ShowBalloonTip(2000)
        }
        finally {
            $script:isProcessing = $false
        }
    }

    # Create tray icon
    $script:notifyIcon = New-Object System.Windows.Forms.NotifyIcon
    $script:notifyIcon.Icon = [System.Drawing.SystemIcons]::Application
    $script:notifyIcon.Visible = $true
    $script:notifyIcon.Text = "Logs Tokenizer (Ctrl+Alt+V)"
    Write-Log "Created tray icon"

    # Context menu
    $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    $menuItemExit = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItemExit.Text = "Exit"
    $menuItemExit.Add_Click({
        Write-Log "Exit via menu"
        $script:notifyIcon.Visible = $false
        $script:form.Close()
    })
    $contextMenu.Items.Add($menuItemExit)
    $script:notifyIcon.ContextMenuStrip = $contextMenu

    # Create form
    $script:form = New-Object HotkeyForm
    Write-Log "Created form"

    # Register hotkey
    $hotKeyId = 1
    $registered = $script:form.RegisterHotkey(
        $hotKeyId,
        ([HotkeyManager]::MOD_CONTROL -bor [HotkeyManager]::MOD_ALT),
        [HotkeyManager]::VK_V
    )

    if (-not $registered) {
        Write-Log "Failed to register hotkey"
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to register hotkey Ctrl+Alt+V.`nIt may be used by another application.",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        $script:notifyIcon.Visible = $false
        exit 1
    }

    Write-Log "Registered hotkey Ctrl+Alt+V"

    # Hotkey event handler
    $script:form.add_HotkeyPressed({
        Process-SmartPaste
    })

    # Close handler
    $script:form.Add_FormClosing({
        Write-Log "Closing application"
        $script:form.UnregisterHotkey()
        $script:notifyIcon.Visible = $false
        $script:notifyIcon.Dispose()
    })

    Write-Host "Logs Tokenizer started!" -ForegroundColor Green
    Write-Host "Hotkey: Ctrl+Alt+V" -ForegroundColor Cyan
    Write-Host "Copy logs (Ctrl+C), paste with Ctrl+Alt+V" -ForegroundColor Yellow
    Write-Host "To exit: close window or right-click tray icon" -ForegroundColor Magenta
    Write-Host "Log file: $logFile" -ForegroundColor Gray

    # Show notification
    $script:notifyIcon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $script:notifyIcon.BalloonTipTitle = "Logs Tokenizer activated"
    $script:notifyIcon.BalloonTipText = "Use Ctrl+Alt+V for smart paste"
    $script:notifyIcon.ShowBalloonTip(2000)
    Write-Log "Showed welcome notification"

    # Start message loop
    Write-Log "Starting Application.Run"
    [System.Windows.Forms.Application]::EnableVisualStyles()
    [System.Windows.Forms.Application]::Run($script:form)
    Write-Log "Application.Run completed"
}
catch {
    $errorMsg = "Critical error: $_ | $($_.ScriptStackTrace)"
    Write-Log $errorMsg
    [System.Windows.Forms.MessageBox]::Show(
        "Error starting Logs Tokenizer:`n`n$_`n`nDetails in: $logFile",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}
