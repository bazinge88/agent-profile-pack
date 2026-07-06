# 前置知识 — Agent Skills开发

> 这个skill涉及到AI Agent技能开发领域，以下是帮助你理解的核心背景。

---

## 这个领域在研究什么？

Agent Skills（智能体技能）是一种让AI助手具备特定专业能力的机制。就像给一个通用助手配备各种"专业工具包"，让它在不同场景下能自动调用合适的工具完成任务。

## 它是怎么来的？

- **2023年初**：Claude、GPT等大模型开始支持"系统提示"和"工具调用"
- **2024年**：Claude Code等CLI工具引入Skills机制，用户可自定义技能模块
- **现在**：Skills已成为AI Agent的核心能力扩展方式，支持复杂任务自动化

## 核心概念

| 概念 | 通俗解释 | 打个比方 |
|------|----------|----------|
| **Skill（技能）** | 定义AI在特定场景下的行为规范 | 像给厨师一本"菜谱"，告诉他怎么做某道菜 |
| **Trigger（触发器）** | 自动识别何时启用某个技能 | 像智能家居的"语音指令"，说"开灯"就自动执行 |
| **Phase（阶段）** | 把复杂任务拆成有序步骤 | 像做菜的流程：备料→烹饪→装盘 |
| **Progress Marker（进度标记）** | 记录任务完成进度，支持断点恢复 | 像书签，下次打开继续读 |

## 常见术语

| 术语 | 全称 | 一句话解释 |
|------|------|-----------|
| **Agent** | AI Agent | 能自主执行任务的AI系统 |
| **Skill** | Agent Skill | Agent的特定能力模块 |
| **CLI** | Command Line Interface | 命令行工具 |
| **MCP** | Model Context Protocol | 模型上下文通信协议 |

## 如果想深入学习

- Claude Code官方文档：Skills开发指南
- Anthropic官方：Tool Use与Agent设计最佳实践

<!-- pdf-converter:progress:prerequisites -->