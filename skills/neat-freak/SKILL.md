---
name: neat-freak
version: compact-C
description: 文档洁癖+经验归档。/neat-freak 调用。
---

# Neat-Freak

角色：项目文档编辑，非记录员。审查全局，合重复，修正过期，删废弃。

红线：禁内置记忆 DB。仅整理 docs/ 和 README。不动 CLAUDE.md/AGENTS.md。同步落地文档。

## 核心

一层知识，受众分离：

| 层 | 受众 | 职责 |
|--|--|--|
| `docs/`+`README.md` | 他人/下游 | 接入、架构、运维 |

**不动 CLAUDE.md/AGENTS.md。** 仅整理用户可见的文档。

## 流程

### Step 0: 尺寸体检

| 文件 | 红线 | 超标处理 |
|--|--|--|
| `docs/单文件` | ~1500行 | 拆分加目录 |

先精简再同步，不可合做。

### Step 1: 盘点

逐项目：ls docs → 抓散落 md → 读 README。每文件标「评估/要改/不改」。

### Step 2: 变更波及

| 变更 | 波及 |
|--|--|
| 新增 API/路由 | integration-guide + architecture |
| 改名环境变量 | runbook + 下游 |
| 新增表 | Data Model |
| 大特性 | 以上全部 + 架构新章节 |
| **跨项目** | 两边都要改（最常见漏改） |

### Step 3: 修改

顺序：改 docs。不动 CLAUDE.md。

原则：
- 减 > 加：净增 >30 行=红灯
- 合 > 追：改旧条目，不堆新行
- 删 > 留：完成/过时 → 删 | 不动 CLAUDE.md

### Step 4: 自检

尺寸：
- [ ] docs 净增 ≤30 行
- [ ] 无 blockquote 历史条目

完整性：
- [ ] 清单全员有结论
- [ ] 路径/命令代码真实存在
- [ ] README 与代码一致
- [ ] 新增路由/变量/表：在对应 docs 多处出现
- [ ] 跨项目下游已改
- [ ] 无相对时间（grep 今天|昨天|recently）

归档：
- [ ] 已归档 resolved_issues/
- [ ] pending/resolved 命名一致
- [ ] 脱项目仍可理解
- [ ] 已解决 pending 标注或移走

### Step 5: 摘要

```
## 同步完成
### 文档变更
- docs/ — xxx
### 经验归档
- resolved_issues/about_<topic>/ — xxx
### 未处理
- xxx
```

## 经验归档

| 阶段 | 文件夹 | 记录内容 | 核心要求 |
|--|--|--|--|
| 遇问题 | `~/pending_issues/` | 猜想、尝试、失败原因 | 后续能直接接着排，不重试已错路径 |
| 已解决 | `~/resolved_issues/` | 方案、坑、通用知识 | "删项目名后仍成立"的抽象经验 |

命名一致。模板见 `references/archive-template.md`。

步骤：
1. 遇问题 → `mkdir -p ~/pending_issues/about_<topic>/`，记描述+尝试+猜想+上下文
2. 解决 → 写归档前先**询问主人问题是否真的已解决**，得到确认后再继续
3. `mkdir -p ~/resolved_issues/<topic>/`，按模板写（单/多文件）
4. 通用性检查：脱本项目是否仍可理解？不符则改/删
5. 清理 pending：标注已解决或移作参考
6. **检查遗留** — 扫项目中与归档主题相关的废弃文件/脚本/进程，列出并询问主人是否需要清理。确认后再执行删除

## 特殊情况

- 尚无文档 → 有代码则创建，vibe 跳过但要提
- 无新事实 → 审查过期/冲突，审查本身有价值
- 跨项目 → 各项目跑一次完整盘点
- 之前有漏 → 修掉，过去漏洞归你管

## 参考

- `references/sync-matrix.md` — 变更→文件映射
- `references/archive-template.md` — 归档模板
