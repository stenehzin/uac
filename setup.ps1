[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://nizhenets.com/setup/launch.ps1'
$TempPath = $env:TEMP
$FilePath = Join-Path $TempPath 'launch.ps1'

Write-Host "Indiriliyor..."

Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing
Write-Host "Indirme tamamlandi: $FilePath"

Write-Host "Launch.ps1 ayri pencerede calistiriliyor..."
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$FilePath`""

Write-Host "Islem tamamlandi."