# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch as Administrator
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit -File $($MyInvocation.MyCommand.Path)"
    exit
}

# Start logging to a file
Start-Transcript -Path "$env:TEMP\script_log.txt" -Append

Write-Host "Script starting as Administrator"

try {
    # Set security protocol and execute the command
    Write-Host "Setting security protocol to TLS 1.2"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Write-Host "Downloading and executing script from https://christitus.com/win"
    iwr -useb https://christitus.com/win | iex
    Write-Host "Script execution completed successfully"
} catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
}

# Stop logging
Stop-Transcript
