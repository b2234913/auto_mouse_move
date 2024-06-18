param (
    [switch]$VerboseMode  # Define a switch parameter -v
)

# Set $VerbosePreference based on the presence of -v parameter
if ($VerboseMode) {
    $VerbosePreference = "Continue"
} else {
    $VerbosePreference = "SilentlyContinue"
}

# Set the mouse idle check interval in seconds
$idleCheckInterval = 1
$idleThreshold = 5  # Idle time threshold in seconds

# Define the work hours time range (24-hour format)
$workStartTime = "08:00"
$workEndTime = "18:00"

# Set the relative movement offsets
$moveOffsetX = -1
$moveOffsetY = -1

# Add necessary Windows API functions
Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class MouseHelper {
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int x, int y);

    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    public struct POINT {
        public int X;
        public int Y;
    }
}
"@

# Initialize variables for last mouse position and last active time
$lastMousePos = New-Object MouseHelper+POINT
[void][MouseHelper]::GetCursorPos([ref]$lastMousePos)
$lastActiveTime = Get-Date

# Monitor mouse idle status
while ($true) {
    # Get current time
    $currentTime = Get-Date

    # Debug log: Display current time
    Write-Verbose "Current Time: $($currentTime.ToString())"

    # Check if the current time is within work hours
    if ($currentTime.TimeOfDay -ge [TimeSpan]::Parse($workStartTime) -and
        $currentTime.TimeOfDay -lt [TimeSpan]::Parse($workEndTime)) {

        # Debug log: Display within work hours
        Write-Verbose "Within work hours."

        # Get current mouse position
        $currentMousePos = New-Object MouseHelper+POINT
        [void][MouseHelper]::GetCursorPos([ref]$currentMousePos)

        # Debug log: Display current mouse position
        Write-Verbose "Current Mouse Position: $($currentMousePos.X), $($currentMousePos.Y)"

        # Check if the mouse has moved
        if ($currentMousePos.X -ne $lastMousePos.X -or $currentMousePos.Y -ne $lastMousePos.Y) {
            # Update last active time and position
            $lastActiveTime = $currentTime
            $lastMousePos = $currentMousePos

            # Debug log: Display mouse moved
            Write-Verbose "Mouse moved. Updating last active time and position."
        }

        # Calculate idle time of the mouse
        $idleTime = ($currentTime - $lastActiveTime).TotalSeconds

        # Debug log: Display idle time
        Write-Verbose "Idle Time: $idleTime seconds"

        # If idle time exceeds threshold, execute mouse move logic
        if ($idleTime -ge $idleThreshold) {
            # Debug log: Display executing mouse move logic
            Write-Verbose "Mouse idle time exceeded threshold. Executing mouse move logic."

            # Calculate new target position
            $targetX = $currentMousePos.X + $moveOffsetX
            $targetY = $currentMousePos.Y + $moveOffsetY

            # Debug log: Display new target position
            Write-Verbose "Target Position: $targetX, $targetY"

            # Move the mouse to the new target position
            [void][MouseHelper]::SetCursorPos($targetX, $targetY)

            # Wait for a short time
            Start-Sleep -Milliseconds 100  # Wait 0.1 seconds before moving back

            # Restore the mouse to its original position
            [void][MouseHelper]::SetCursorPos($currentMousePos.X, $currentMousePos.Y)

            # Debug log: Display restored mouse position
            Write-Verbose "Restored mouse position."

            # Reset last active time
            $lastActiveTime = $currentTime
        }
    }
    else {
        # Debug log: Display outside work hours
        Write-Verbose "Outside work hours. No action taken."
    }

    # Debug log: Display waiting for next check
    Write-Verbose "Waiting for next check..."

    # Wait for the specified interval before checking again
    Start-Sleep -Seconds $idleCheckInterval
}
