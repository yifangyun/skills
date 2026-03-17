# Fangcloud CLI Release

This folder contains prebuilt Go CLI binaries for Fangcloud.

## Files

- `fangcloud-macos-amd64`: macOS Intel
- `fangcloud-macos-arm64`: macOS Apple Silicon
- `fangcloud-macos-amd64.zip`: notarized macOS Intel archive when notarization is enabled
- `fangcloud-macos-arm64.zip`: notarized macOS Apple Silicon archive when notarization is enabled
- `fangcloud-linux-amd64`: Linux x86_64
- `fangcloud-linux-arm64`: Linux ARM64
- `fangcloud-windows-amd64.exe`: Windows x86_64
- `fangcloud-windows-arm64.exe`: Windows ARM64

## Environment Variables

- `FANGCLOUD_USER_TOKEN`
- `FANGCLOUD_ADMIN_TOKEN` when calling admin URLs

## Run Directly

```bash
chmod +x fangcloud-macos-arm64
./fangcloud-macos-arm64 --help
./fangcloud-macos-arm64 api GET /v2/user/info
```

Windows PowerShell:

```powershell
.\fangcloud-windows-amd64.exe --help
.\fangcloud-windows-amd64.exe api GET /v2/user/info
```

## macOS Distribution Note

If notarization is enabled during build, prefer distributing the notarized
`fangcloud-macos-*.zip` archive to macOS end users instead of the raw binary.
