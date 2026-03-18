param(
    [string]$BaseUrl = "https://app.fangcloud.com/sync/vv25/knowclaw/release",
    [string]$FileName = ""
)

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptRoot
$ReleaseDir = Join-Path $RootDir "release"

if (-not (Test-Path $ReleaseDir)) {
    New-Item -ItemType Directory -Path $ReleaseDir | Out-Null
}

if ([string]::IsNullOrWhiteSpace($FileName)) {
    $arch = $env:PROCESSOR_ARCHITECTURE
    if ($arch -eq "ARM64") {
        $file = "fangcloud-windows-arm64.exe"
    }
    else {
        $file = "fangcloud-windows-amd64.exe"
    }
}
else {
    $file = $FileName
}

$url = "$BaseUrl/$file"
$target = Join-Path $ReleaseDir $file
$tmpTarget = "$target.tmp.$PID"

Write-Host "Downloading $url"
Invoke-WebRequest $url -OutFile $tmpTarget

try {
    $proc = Start-Process -FilePath $tmpTarget -ArgumentList "--help" -NoNewWindow -Wait -PassThru
    if ($proc.ExitCode -ne 0) {
        throw "Downloaded binary failed health check with exit code $($proc.ExitCode)."
    }
}
catch {
    Remove-Item -Force -ErrorAction SilentlyContinue $tmpTarget
    throw "Downloaded binary is invalid and cannot run: $url"
}

Move-Item -Force $tmpTarget $target
Write-Host "Saved to $target"
