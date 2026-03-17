# Fangcloud Skills Library 🚀

欢迎使用 **Fangcloud Skills Library**。这是一个专门为 AI Agent 打造的亿方云（Fangcloud）能力扩展库，集成了文件管理、协作办公以及强大的 AI 智能体交互功能。

## 🌟 核心能力

本仓库目前主要包含 `fangcloud_ai` 核心 Skill，赋能 AI 助手直接操作亿方云平台：

-   **📁 文件管理**: 搜索、上传、下载、移动、拷贝、删除文件及文件夹。
-   **🤝 协作办公**: 创建分享链接、邀请协作、管理部门及群组成员。
-   **🤖 AI 增强**:
    -   **智能体对话**: 与亿方云平台上的自定义 AI 智能体进行流式对话。
    -   **知识库检索**: 基于 DeepSeek 等模型，在指定的企业知识库中进行问答。
    -   **最近使用**: 快速获取用户最近操作的文件，无缝衔接工作流。
-   **🚀 高性能 CLI**: 提供跨平台的 Go 语言编写的命令行工具，无需 Python 环境即可运行。

## 🛠️ 快速开始

### 1. 环境准备
确保你的环境中配置了必要的环境变量：

```bash
# 用户级 Token，用于大部分个人操作
export FANGCLOUD_USER_TOKEN="your_user_token"

# 企业管理级 Token（可选），用于涉及 admin 的接口
export FANGCLOUD_ADMIN_TOKEN="your_admin_token"
```

### 2. 使用 Go CLI (推荐)
本库提供预编译的二进制文件，支持 macOS, Linux, Windows (amd64/arm64)。

#### 获取二进制文件
在 `fangcloud_ai/cli/release/` 目录下找到对应平台的二进制文件。

#### 常用命令示例
```bash
# 获取用户信息
./fangcloud-macos-arm64 api GET /v2/user/info

# 智能体对话
./fangcloud-macos-arm64 chat "帮我总结一下最近的文档" --agent-id 3776

# 目录自动整理
./fangcloud-macos-arm64 organize --folder-id 12345 --mode move

# 目录上传
./fangcloud-macos-arm64 upload ./local_dir --remote-parent-id 0
```

### 3. 使用 Python 脚本 (Legacy)
如果你需要直接运行 Python 源码，可以使用 `fangcloud_ai/scripts/` 下的工具：

```bash
python3 fangcloud_ai/scripts/chat_agent.py "你好" --agent-id 3776
```

## 📂 目录结构

-   `fangcloud_ai/`: 核心 Skill 定义。
    -   `cli/`: Go 语言编写的命令行工具源码及预编译二进制。
        -   `cmd/`: 程序入口。
        -   `release/`: **预编译二进制文件**，直接分发给用户使用。
        -   `scripts/`: 构建脚本。
    -   `scripts/`: Python 执行脚本（Legacy）。
    -   `references/`: API 详细文档与参考资料。
    -   `SKILL.md`: Skill 的详细元数据与功能描述。

## 📝 贡献指南

我们欢迎任何形式的贡献！如果你想添加新的 Skill 或改进现有功能：

1.  **Fork** 本仓库。
2.  在根目录下创建你的 Skill 目录（如 `my_new_skill/`）。
3.  编写 `SKILL.md` 描述其能力与用法。
4.  提交 **Pull Request**。

---

