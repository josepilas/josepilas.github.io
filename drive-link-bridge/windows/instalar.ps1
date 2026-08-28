param([string]$DriveRoot)

$ErrorActionPreference = 'Stop'
$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$installDir = Join-Path $env:LOCALAPPDATA 'DriveLinkBridge'

if ([string]::IsNullOrWhiteSpace($DriveRoot)) {
    $default = 'G:\Meu Drive'
    $answer = Read-Host "Raiz local do Meu Drive [$default]"
    if ([string]::IsNullOrWhiteSpace($answer)) { $DriveRoot = $default } else { $DriveRoot = $answer.Trim('"') }
}

$DriveRoot = $DriveRoot.TrimEnd('\')
if (-not (Test-Path -LiteralPath $DriveRoot)) {
    Write-Warning "A pasta '$DriveRoot' não existe neste momento. A instalação continuará, mas os links só funcionarão quando essa raiz estiver disponível."
}

New-Item -ItemType Directory -Path $installDir -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $projectDir 'gdriveopen-handler.ps1') -Destination (Join-Path $installDir 'gdriveopen-handler.ps1') -Force

@{
    driveRoot = $DriveRoot
    installedAt = (Get-Date).ToString('o')
    bridge = 'https://josepilas.github.io/drive-link-bridge/'
} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $installDir 'config.json') -Encoding UTF8

$handler = Join-Path $installDir 'gdriveopen-handler.ps1'
$command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$handler`" `"%1`""

& reg.exe add 'HKCU\Software\Classes\gdriveopen' /ve /d 'URL:DriveLinkBridge' /f | Out-Null
& reg.exe add 'HKCU\Software\Classes\gdriveopen' /v 'URL Protocol' /d '' /f | Out-Null
& reg.exe add 'HKCU\Software\Classes\gdriveopen\DefaultIcon' /ve /d '%SystemRoot%\explorer.exe,0' /f | Out-Null
& reg.exe add 'HKCU\Software\Classes\gdriveopen\shell\open\command' /ve /d $command /f | Out-Null

Write-Host ''
Write-Host 'DriveLinkBridge instalado com sucesso.' -ForegroundColor Green
Write-Host "Raiz configurada: $DriveRoot"
Write-Host "Arquivos locais: $installDir"
Write-Host ''
