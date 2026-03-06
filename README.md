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

## 🛠️ 快速开始

### 1. 环境准备
确保你的环境中已安装 Python 3，并配置了必要的环境变量：

```bash
# 用户级 Token，用于大部分个人操作
export FANGCLOUD_USER_TOKEN="your_user_token"

# 企业管理级 Token（可选），用于涉及 admin 的接口
export FANGCLOUD_ADMIN_TOKEN="your_admin_token"
```

### 2. 使用示例

#### 智能体对话
你可以通过脚本直接与亿方云智能体交互：
```bash
python3 fangcloud_ai/scripts/chat_agent.py "帮我总结一下最近的文档" --agent-id 3776
```

#### 文件搜索与分享
利用内置客户端执行 API 调用：
```bash
# 搜索文件
python3 fangcloud_ai/scripts/fangcloud_client.py GET "https://open.fangcloud.com/api/v2/item/search?query_words=合同"

# 创建分享链接
python3 fangcloud_ai/scripts/fangcloud_client.py POST "https://open.fangcloud.com/api/v2/share_link/create" '{"file_id": 12345}'
```

## 📂 目录结构

-   `fangcloud_ai/`: 核心 Skill 定义。
    -   `SKILL.md`: Skill 的详细元数据与功能描述。
    -   `scripts/`: 封装好的 Python 执行工具。
    -   `references/`: API 详细文档与参考资料。

## 📝 贡献指南

我们欢迎任何形式的贡献！如果你想添加新的 Skill 或改进现有功能：

1.  **Fork** 本仓库。
2.  在根目录下创建你的 Skill 目录（如 `my_new_skill/`）。
3.  编写 `SKILL.md` 描述其能力与用法。
4.  提交 **Pull Request**。

---

