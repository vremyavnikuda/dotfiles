Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class KeyboardInput {
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);

    public const int KEYEVENTF_EXTENDEDKEY = 0x0001;
    public const int KEYEVENTF_KEYUP = 0x0002;
    public const byte VK_TAB = 0x09;
    public const byte VK_DOWN = 0x28;
    public const byte VK_D = 0x44;
}
"@

# Countdown timer
$countdownTime = 10
for ($i = $countdownTime; $i -gt 0; $i--) {
    Write-Host "Starting in $i seconds..."
    Start-Sleep -Seconds 1
}

Write-Host "Starting process now."

# Press the 'Tab' key 8 times
for ($i = 0; $i -lt 8; $i++) {
    [KeyboardInput]::keybd_event([KeyboardInput]::VK_TAB, 0, 0, 0)
    Start-Sleep -Milliseconds 100
    [KeyboardInput]::keybd_event([KeyboardInput]::VK_TAB, 0, [KeyboardInput]::KEYEVENTF_KEYUP, 0)
    Start-Sleep -Milliseconds 100
}

# Press the 'D' key 2 times
for ($j = 0; $j -lt 10; $j++) {
    # Press the 'D' key 2 times
    for ($i = 0; $i -lt 2; $i++) {
        [KeyboardInput]::keybd_event([KeyboardInput]::VK_D, 0, 0, 0)
        Start-Sleep -Milliseconds 100
        [KeyboardInput]::keybd_event([KeyboardInput]::VK_D, 0, [KeyboardInput]::KEYEVENTF_KEYUP, 0)
        Start-Sleep -Milliseconds 100
    }

    # Press the 'Down' key
    [KeyboardInput]::keybd_event([KeyboardInput]::VK_DOWN, 0, 0, 0)
    Start-Sleep -Milliseconds 100
    [KeyboardInput]::keybd_event([KeyboardInput]::VK_DOWN, 0, [KeyboardInput]::KEYEVENTF_KEYUP, 0)
    Start-Sleep -Milliseconds 100
}