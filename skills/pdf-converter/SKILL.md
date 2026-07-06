---
name: pdf-converter
description: "PDF分块转换工具：将大型PDF分割并转换为Markdown格式。当用户需要转换PDF、分割PDF、PDF转MD时触发。"
allowed-tools: Read Write Edit Bash
---

# PDF 分块转换工具

将大型 PDF 文件分割成 20 页的小块，并使用 MinerU 转换为 Markdown 格式。

---

## 输出目录结构

```
<output-dir>/
├── part1_p1-20.pdf        # 分块PDF
├── part1_p1-20.md         # 分块Markdown
├── part2_p21-40.pdf
├── part2_p21-40.md
├── ...
```

---

## 使用方式

用户提供：
- **PDF 路径**：本地 PDF 文件路径
- **输出目录**：可选，默认为 PDF 同名目录

---

## 执行流程

### 1. 检测 PDF 信息

```python
import PyPDF2
reader = PyPDF2.PdfReader("<pdf_path>")
total_pages = len(reader.pages)
print(f"总页数: {total_pages}")
```

### 2. 分块策略

**工具限制**：
- `mineru-open-api flash-extract`：最大 20 页/次
- `Read` 工具读取 PDF：最大 20 页/次

**分块规则**：

| 总页数 | 分块策略 |
|--------|----------|
| ≤ 20 页 | 不分块，直接转换 |
| > 20 页 | 分 N 块，每块 20 页，最后一块为余数 |

示例：85 页论文 → 5 块（20+20+20+20+5）

### 3. 创建输出目录

```bash
mkdir -p <output-dir>
```

### 4. Python 分块 PDF

```python
import PyPDF2
import os

input_path = "<pdf_path>"
output_dir = "<output-dir>"
os.makedirs(output_dir, exist_ok=True)

reader = PyPDF2.PdfReader(input_path)
total_pages = len(reader.pages)

chunk_size = 20
part = 1
start = 0

while start < total_pages:
    end = min(start + chunk_size, total_pages)
    writer = PyPDF2.PdfWriter()

    for i in range(start, end):
        writer.add_page(reader.pages[i])

    output_path = os.path.join(output_dir, f"part{part}_p{start+1}-{end}.pdf")
    with open(output_path, 'wb') as f:
        writer.write(f)

    print(f"已创建: part{part}_p{start+1}-{end}.pdf ({end - start} 页)")
    part += 1
    start = end
```

### 5. 并行转换为 Markdown

使用 `mineru-open-api flash-extract`：

```bash
mineru-open-api flash-extract "<output-dir>/part1_p1-20.pdf" -o "<output-dir>/part1_p1-20.md"
mineru-open-api flash-extract "<output-dir>/part2_p21-40.pdf" -o "<output-dir>/part2_p21-40.md"
mineru-open-api flash-extract "<output-dir>/part3_p41-60.pdf" -o "<output-dir>/part3_p41-60.md"
mineru-open-api flash-extract "<output-dir>/part4_p61-80.pdf" -o "<output-dir>/part4_p61-80.md"
mineru-open-api flash-extract "<output-dir>/part5_p81-85.pdf" -o "<output-dir>/part5_p81-85.md"
```

**关键点**：
- `-o` 必须指向**完整文件路径**，包含页码范围（如 `part1_p1-20.md`）
- 多个分块可以并行执行以提高效率

---

## 关联 Skills

- **pdf-converter**：底层依赖，本 skill 使用其 `mineru-open-api flash-extract` 命令进行 PDF 到 Markdown 的转换
