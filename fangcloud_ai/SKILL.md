---
name: fangcloud_ai
description: 亿方云 (Fangcloud) AI 能力集成 Skill。支持文件管理（列表、上传、下载、分享）、协作邀请、知识库对话 (DeepSeek) 以及智能体交互。当用户需要操作亿方云文件、查询最近文档或创建分享链接时，使用此 Skill。
---

# Fangcloud AI Skill

此 Skill 允许通过亿方云开放平台 API 执行各类操作。

## 配置说明

Skill 自动从环境变量获取 Token：
- `FANGCLOUD_ADMIN_TOKEN`: 用于 URL 中包含 `admin` 的企业级接口。
- `FANGCLOUD_USER_TOKEN`: 用于普通用户级接口。

## 运行环境要求

- **首选分发方式**: 使用 Go 版 CLI 二进制，不依赖客户本地 Python。
- Skill 根目录只保留说明文档和参考资料；所有代码、构建脚本、构建产物、发布产物统一放在 `cli/` 目录中，避免影响 skill 本身目录结构。
- 运行 Go 二进制只需要配置环境变量：
  - `FANGCLOUD_USER_TOKEN`
  - `FANGCLOUD_ADMIN_TOKEN`，仅当访问 admin URL 时需要
- 如果要分发给外部客户，直接分发 `cli/release/` 目录中的对应平台原始二进制文件。

## 环境与二进制对应关系

- 先判断客户操作系统，再判断 CPU 架构，然后只使用对应的 CLI 二进制。
- 不要跨环境混用二进制，例如不要在 Windows 上使用 macOS/Linux 文件，也不要在 `arm64` 机器上优先发 `amd64` 版本。

### 平台选择

- Windows `amd64`:
  - 使用 `cli/release/fangcloud-windows-amd64.exe`
- Windows `arm64`:
  - 使用 `cli/release/fangcloud-windows-arm64.exe`
- macOS Intel `amd64`:
  - 使用 `cli/release/fangcloud-macos-amd64`
- macOS Apple Silicon `arm64`:
  - 使用 `cli/release/fangcloud-macos-arm64`
- Linux `amd64`:
  - 使用 `cli/release/fangcloud-linux-amd64`
- Linux `arm64`:
  - 使用 `cli/release/fangcloud-linux-arm64`

### 如何判断环境

- Windows:
  - PowerShell 执行 `$env:PROCESSOR_ARCHITECTURE`
  - 常见结果：`AMD64`、`ARM64`
- macOS:
  - 执行 `uname -m`
  - 常见结果：`x86_64`、`arm64`
- Linux:
  - 执行 `uname -m`
  - 常见结果：`x86_64`、`aarch64`

### 使用规则

- 如果用户没有明确说自己的环境，先让对方确认操作系统和架构，再发对应二进制。
- 如果是 Apple Silicon Mac，优先使用 `fangcloud-macos-arm64`，不要默认发 Intel 版。
- 如果是 Windows 用户，始终发 `.exe` 文件。
- 如果无法确认架构，但系统是 Windows / Linux 普通办公机，优先尝试 `amd64`；如果确认是 ARM 设备，再切到 `arm64`。

## Go 版 CLI

- **固定代码目录**: `cli/`
- **源码入口**: `cli/cmd/fangcloud/main.go`
- **核心实现**: `cli/internal/fangcloud/fangcloud.go`
- **构建脚本**: `cli/scripts/build_go_cli.sh`
- **支持命令**:
  - `fangcloud api <METHOD> <URL或相对路径> [DATA_JSON]`
  - `fangcloud chat <message> [--agent-id ID] [--type TYPE] [--libs LIBS] [--no-stream]`
  - `fangcloud organize [--folder-id ID | --folder-url URL] [--mode move|copy] [--dry-run]`
  - `fangcloud upload <local_dir> [--remote-root PATH | --remote-parent-id ID] [--conflict-strategy overwrite|rename] [--include-hidden] [--dry-run]`

### Go 构建产物

- 基础构建: `./cli/scripts/build_go_cli.sh`
- macOS 签名构建:
  - `MACOS_SIGN=1 MACOS_SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" ./cli/scripts/build_go_cli.sh`
- macOS 签名并公证:
  - `MACOS_SIGN=1 MACOS_NOTARIZE=1 MACOS_SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" MACOS_NOTARY_PROFILE="notary-profile" ./cli/scripts/build_go_cli.sh`
- 发布目录:
  - `cli/release/README.md`
  - `cli/release/CHECKSUMS.txt`
  - `cli/release/fangcloud-macos-amd64`
  - `cli/release/fangcloud-macos-arm64`
  - `cli/release/fangcloud-linux-amd64`
  - `cli/release/fangcloud-linux-arm64`
  - `cli/release/fangcloud-windows-amd64.exe`
  - `cli/release/fangcloud-windows-arm64.exe`
- 当前策略:
  - `GOOS=darwin GOARCH=amd64`
  - `GOOS=darwin GOARCH=arm64`
  - `GOOS=linux GOARCH=amd64`
  - `GOOS=linux GOARCH=arm64`
  - `GOOS=windows GOARCH=amd64`
  - `GOOS=windows GOARCH=arm64`
- Go 版上传逻辑使用原生 multipart HTTP 上传，不再依赖系统 `curl`。
- macOS 面向普通用户分发时，推荐启用签名；如果要尽量避免 Gatekeeper 首次拦截，推荐启用签名 + notarization。
- 签名变量:
  - `MACOS_SIGN=1`
  - `MACOS_SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)"`
- 公证变量:
  - `MACOS_NOTARIZE=1`
  - `MACOS_NOTARY_PROFILE="notary-profile"`
- 当前脚本对 standalone CLI 的处理是：
  - 先 `codesign`
  - 再用 `notarytool` 提交 zip 包
  - 不执行 `stapler`，因为单文件 CLI 没有适合的 stapling 目标

## 核心功能与接口参考

详细接口定义请参考 [references/openapi.md](references/openapi.md)。

### 1. 最近使用的文件
- **Endpoint**: `GET /v2/file/recent_items`
- **用法**: 获取当前用户最近操作过的文件列表。**重要：必须携带 `limit` 参数，否则接口可能返回 500 错误。** 例如：`/v2/file/recent_items?limit=20`。

### 2. 搜索文件
- **Endpoint**: `GET /v2/item/search`
- **用法**: 根据关键词搜索文件。参数：`query_words`, `sort_by=modified_at`, `sort_direction=desc`。

### 3. 获取用户信息
- **Endpoint**: `GET /v2/user/info`
- **用法**: 获取当前登录用户的基本信息，用于确认身份。

### 4. 创建分享链接
- **Endpoint**: `POST /v2/share_link/create`
- **用法**: 为指定的文件或文件夹创建分享链接。

### 5. 预览与在线编辑 (URL 构造)
- **预览 URL**: `https://v2.fangcloud.com/desktop/files/recent?preview={file_id}`
- **在线编辑 URL**: `https://v2.fangcloud.com/desktop/files/recent?preview={file_id}&fv=1&online=1`

### 6. 知识库与智能体 (DeepSeek)
- **知识库对话**: `POST /v2/kbase/chatStream` (支持 `gptType: "deepseek"`)
- **智能体对话**: `POST /v2/knowledge/chatStream`
- **智能体列表**: `GET /v2/knowledge/list`

## 常用工作流

### 查找并处理文件
1. 调用 `GET https://open.fangcloud.com/api/v2/item/search` 搜索文件。
2. 根据返回的 `id` 构造预览或编辑 URL。

## 实用场景 (Practical Scenarios)

### 1. 文件搜索下载
**目标**: 根据用户关键词查找文件，并将其下载到本地。
**执行流程**:
1. 调用 `GET /v2/item/search`（参数 `query_words=<关键词>`）查询目标文件的 `file_id`。
2. 调用 `GET /v2/file/{file_id}/download_v2` 或相应下载接口获取文件的真实下载链接。
3. （可选）使用本地工具将获取到的链接内容下载并保存为本地文件。

### 2. 文件夹创建及文件上传到个人空间
**目标**: 在个人空间创建专属文件夹，并将本地文件上传至该目录。
**执行流程**:
1. 调用 `GET /v2/folder/personal_items` 获取个人空间的目录信息，确认目标父文件夹 ID（通常根目录为 `0` 或根据接口返回判断）。
2. 调用 `POST /v2/folder/create`（参数 `name=<文件夹名>`, `parent_id=<个人空间ID>`）创建目标文件夹，并记录返回的 `id`。
3. 调用上传接口（如 `POST /v2/file/upload_v2` 或 `POST /v2/file/upload_by_path`），将本地文件上传到刚创建的文件夹下。

### 3. 文件搜索，创建分享
**目标**: 查找指定文件，并为该文件生成对外分享链接。
**执行流程**:
1. 调用 `GET /v2/item/search` 搜索并获取目标文件的 `file_id`。
2. 调用 `POST /v2/share_link/create`，传入对应的 `file_id`。可根据需求设置必要的权限参数（如提取码、有效期限等）。
3. 提取接口返回的分享 `url` 和密码，并呈现给用户。

### 4. 文件夹搜索创建收集场景 (没有就补全)
**目标**: 查找是否存在指定名称的“收集文件夹”，如果存在则使用该文件夹创建收集任务，如果不存在则自动创建文件夹后再创建收集任务。
**执行流程**:
1. 调用 `GET /v2/item/search`（设置 `type=folder`，传入名称）搜索目标文件夹。
2. 若找到目标文件夹，提取其 `folder_id`；若未找到，调用 `POST /v2/folder/create`（在个人空间或指定目录）创建该文件夹并获取 `folder_id`。
3. 调用 `POST /v2/collection/create`（传入 `target_folder_id`、`name` 等参数）为该文件夹创建公网收集任务。
4. 提取接口返回的收集任务链接（如提取接口返回的收集 URL 或其他标识），提供给用户用于文件收集。后续可通过 `GET /v2/collection/get_files_info` 查询收集状态。

### 5. 云盘文件自动分类与整理 (NEW)
**目标**: 自动识别指定目录中的文件类型，创建分类目录并将文件移动或复制到对应目录中。
**执行流程**:
1. **获取 ID**: 从用户提供的 URL（如 `preview={id}`）或直接提供的 ID 中提取目标文件夹 ID。
2. **读取列表**: 调用 `GET /v2/folder/{id}/children` 获取目录下所有文件列表。
3. **智能分类**: 分析文件后缀或名称（如 `.pdf`、`.docx`、`.xlsx`、`.jpg`），制定分类方案（如“文档”、“图片”、“表格”）。
4. **用户确认**: 向用户展示分类建议，并询问是执行“移动 (Move)”还是“复制 (Copy)”。
5. **执行整理**:
   - 调用 `POST /v2/folder/create` 创建分类子文件夹。
   - 遍历文件，根据用户选择调用 `POST /v2/file/{id}/move` 或 `POST /v2/file/{id}/copy` 将其分配到对应目录。
6. **结果反馈**: 整理完成后通知用户结果。

### 6. 云盘使用周报自动生成 (NEW)
**目标**: 通过分析最近操作的文件，生成用户的使用周报，并提供优化建议。
**执行流程**:
1. **获取数据**: 调用 `GET /v2/file/recent_items?limit=50` 获取最近操作的文件列表（尽可能多抓取）。
2. **时间筛选**: 根据当前时间戳，统计本周（通常为过去 7 天）操作过的文件。
3. **内容分析**: 
   - 提取文件名、类型、修改时间。
   - 使用 AI 总结本周的工作重心（如：“本周主要在处理产研相关的 Excel 文档”）。
   - 统计文件分布（如：修改了 5 个表格，创建了 2 个 PDF）。
4. **生成周报**:
   - **本周回顾**: 总结操作的文件类型、项目相关性。
   - **工作重心**: 自动识别最常操作的文件所属项目。
   - **使用建议**: 根据使用习惯提供建议（如：“建议将本周频繁修改的文档归档到特定项目文件夹”）。
5. **呈现报告**: 将汇总结果以 Markdown 格式呈现。

## 执行工具

优先使用 Go 二进制；如需本地源码运行，使用 `cd cli && go run ./cmd/fangcloud ...`。

### 客户使用方式

- macOS / Linux:
  - `chmod +x fangcloud-macos-arm64`
  - `./fangcloud-macos-arm64 --help`
- Windows PowerShell:
  - `.\fangcloud-windows-amd64.exe --help`

### CLI 子命令

- **通用 API**: `fangcloud api <METHOD> <URL或相对路径> [DATA_JSON]`
  - 示例: `./fangcloud-macos-arm64 api GET /v2/user/info`
  - 示例: `./fangcloud-linux-amd64 api POST /v2/share_link/create "{\"file_id\":123}"`
  - URL 支持完整地址，也支持仅传 `/v2/...` 或 `v2/...`，默认会补成 `https://open.fangcloud.com/api`
- **智能体对话**: `fangcloud chat "你的问题" [--agent-id ID] [--type TYPE] [--libs LIBS]`
  - 示例: `./fangcloud-macos-arm64 chat "你好" --agent-id 3776`
  - 示例: `./fangcloud-linux-amd64 chat "帮我总结文档" --type AI_LIBRARY --libs 123,456`
- **目录自动整理**: `fangcloud organize [--folder-id ID | --folder-url URL] [--mode move|copy] [--dry-run]`
  - 示例: `./fangcloud-macos-arm64 organize --folder-id 501007507161 --mode move`
- **目录上传**: `fangcloud upload <local_dir> [--remote-root PATH | --remote-parent-id ID] [--conflict-strategy overwrite|rename] [--include-hidden] [--dry-run]`
  - 示例: `./fangcloud-linux-amd64 upload ~/dev/workspace/file-check-workspace --dry-run`

### 兼容说明

- Go 版 CLI 是当前推荐入口和推荐分发形态。
- Python 版本已经移除，不再作为回退方案保留。

## 打包分发

- **执行构建**: `./cli/scripts/build_go_cli.sh`

### 打包约束

- Go 当前版本使用交叉编译直接输出 6 个目标文件。
- macOS 正式分发建议使用签名后的二进制；如果用户来自互联网下载，推荐额外做 notarization。
- 推荐对外分发方式：
  - 直接发送 `cli/release/` 中对应平台的原始二进制文件
