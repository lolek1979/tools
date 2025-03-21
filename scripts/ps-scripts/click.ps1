# Import necessary Windows API functions using Add-Type
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class MouseSimulator {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint cButtons, UIntPtr dwExtraInfo);

    public const uint MOUSEEVENTF_LEFTDOWN = 0x02;
    public const uint MOUSEEVENTF_LEFTUP   = 0x04;
}
"@

# Load System.Windows.Forms to access the current mouse cursor position
Add-Type -AssemblyName System.Windows.Forms

# Infinite loop to repeatedly simulate a mouse click every 20 seconds
while ($true) {
    # Get the current mouse cursor position
    $pos = [System.Windows.Forms.Cursor]::Position
    Write-Host "Clicking at position: $($pos.X), $($pos.Y)"
    
    # Simulate left mouse button down
    [MouseSimulator]::mouse_event([MouseSimulator]::MOUSEEVENTF_LEFTDOWN, $pos.X, $pos.Y, 0, [UIntPtr]::Zero)
    Start-Sleep -Milliseconds 100  # Brief pause to simulate the press
    
    # Simulate left mouse button up
    [MouseSimulator]::mouse_event([MouseSimulator]::MOUSEEVENTF_LEFTUP, $pos.X, $pos.Y, 0, [UIntPtr]::Zero)
    
    # Wait 20 seconds before the next click
    Start-Sleep -Seconds 20
}
