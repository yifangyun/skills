param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ArgsList
)

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptRoot
$ReleaseDir = Join-Path $RootDir "release"

if ($ArgsList.Count -eq 0) {
    Write-Error "Usage: .\cli\scripts\run_release_binary.ps1 <subcommand> [args...]"
    exit 1
}

$arch = $env:PROCESSOR_ARCHITECTURE
if ($arch -eq "ARM64") {
    $file = "fangcloud-windows-arm64.exe"
}
else {
    $file = "fangcloud-windows-amd64.exe"
}

$target = Join-Path $ReleaseDir $file

function Test-BinaryHealthy {
    param([string]$BinaryPath)
    if (-not (Test-Path $BinaryPath)) {
        return $false
    }
    try {
        $proc = Start-Process -FilePath $BinaryPath -ArgumentList "--help" -NoNewWindow -Wait -PassThru
        return ($proc.ExitCode -eq 0)
    }
    catch {
        return $false
    }
}

if (-not (Test-BinaryHealthy -BinaryPath $target)) {
    & (Join-Path $ScriptRoot "download_release_binary.ps1") -FileName $file
}

& $target @ArgsList
exit $LASTEXITCODE
