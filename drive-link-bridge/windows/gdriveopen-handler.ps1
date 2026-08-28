param([Parameter(Mandatory=$true)][string]$Url)

$ErrorActionPreference = 'Stop'

function Show-Error([string]$Message) {
    try {
        Add-Type -AssemblyName PresentationFramework -ErrorAction SilentlyContinue
        [System.Windows.MessageBox]::Show($Message, 'DriveLinkBridge') | Out-Null
    } catch {
        [System.Windows.Forms.MessageBox]::Show($Message, 'DriveLinkBridge') | Out-Null
    }
}

function Parse-Query([string]$RawUrl) {
    $result = @{}
    $qPos = $RawUrl.IndexOf('?')
    if ($qPos -lt 0 -or $qPos -ge ($RawUrl.Length - 1)) { return $result }
    $query = $RawUrl.Substring($qPos + 1)
    foreach ($pair in ($query -split '&')) {
        if ([string]::IsNullOrWhiteSpace($pair)) { continue }
        $parts = $pair -split '=', 2
        $key = [System.Uri]::UnescapeDataString($parts[0])
        $value = if ($parts.Count -gt 1) { [System.Uri]::UnescapeDataString($parts[1]) } else { '' }
        $result[$key.ToLowerInvariant()] = $value
    }
    return $result
}

try {
    $raw = $Url.Trim().Trim('"')
    if (-not $raw.StartsWith('gdriveopen:', [System.StringComparison]::OrdinalIgnoreCase)) {
        throw 'URL de protocolo inválida.'
    }

    $installDir = Join-Path $env:LOCALAPPDATA 'DriveLinkBridge'
    $configPath = Join-Path $installDir 'config.json'
    $driveRoot = 'G:\Meu Drive'
    if (Test-Path -LiteralPath $configPath) {
        $cfg = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
        if ($cfg.driveRoot) { $driveRoot = [string]$cfg.driveRoot }
    }

    $driveRoot = $driveRoot.TrimEnd('\')
    $query = Parse-Query $raw

    if ($query.ContainsKey('rel')) {
        $relative = $query['rel'].TrimStart('\','/')
        if ($relative -match '(^|[\\/])\.\.([\\/]|$)') {
            throw 'Caminho relativo recusado por segurança.'
        }
        $path = Join-Path $driveRoot $relative
    } elseif ($query.ContainsKey('path')) {
        $path = $query['path']
    } else {
        throw 'O link não contém rel= nem path=.'
    }

    $rootFull = [System.IO.Path]::GetFullPath($driveRoot).TrimEnd('\')
    $pathFull = [System.IO.Path]::GetFullPath($path)
    $allowedPrefix = $rootFull + '\'
    if (($pathFull -ne $rootFull) -and (-not $pathFull.StartsWith($allowedPrefix, [System.StringComparison]::OrdinalIgnoreCase))) {
        throw "Por segurança, somente caminhos dentro de $rootFull são permitidos."
    }

    if (-not (Test-Path -LiteralPath $pathFull)) {
        throw "O caminho não foi encontrado no Drive for desktop:`n`n$pathFull"
    }

    $item = Get-Item -LiteralPath $pathFull
    if ($item.PSIsContainer) {
        Start-Process explorer.exe -ArgumentList @("`"$pathFull`"")
    } else {
        Start-Process explorer.exe -ArgumentList @('/select,', "`"$pathFull`"")
    }
}
catch {
    Show-Error $_.Exception.Message
    exit 1
}
