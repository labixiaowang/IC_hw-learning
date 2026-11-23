# Yosys 使用方法

## 1. Yosys 是什么

Yosys 是一个开源的 **逻辑综合（logic synthesis）** 工具，作用是把 Verilog/SystemVerilog 写的 RTL 代码转换成门级电路（netlist）。类比软件编译器：RTL 源码是 "C 代码"，综合后的 netlist 是 "机器码"。

本机安装路径（已加入 `PATH`，终端直接敲 `yosys` 即可）：

```
/data/wangxx/OpenROAD-flow-scripts/tools/install/yosys/bin/
```

> 注：`~/.bashrc` 中已配置 `PATH` 和 `LD_LIBRARY_PATH`（yosys 依赖的 `libffi.so.8` 在 `/data/wangxx/toolchain/lib`）。如果新开终端仍提示 `command not found`，先执行 `source ~/.bashrc`。

---

## 2. 三种使用方式

### 方式一：单条命令（`-p` 参数）

```bash
yosys -p "read_verilog -sv FSM.sv; hierarchy -top controller; proc; opt; stat"
```

- `-p "..."` 里的内容是一串 Yosys 命令，按顺序执行，执行完自动退出。
- **注意：分号后面必须有空格**，否则 `FSM.sv;hierarchy` 会被当成一个文件名而报错。

### 方式二：脚本文件（推荐，便于复用）

把命令写进一个 `.ys` 文件，例如 `synth.ys`：

```tcl
read_verilog -sv FSM.sv
hierarchy -top controller
proc
opt
stat
```

然后运行：

```bash
yosys synth.ys
```

文件里每行一条命令，不需要分号。

### 方式三：交互模式（调试时用）

```bash
yosys
```

进入 REPL 后逐条输入命令，随时可以 `stat`、`show` 查看中间状态。输入 `exit` 退出。

---

## 3. 常用命令（按综合流程顺序）

| 命令 | 作用 |
|------|------|
| `read_verilog -sv <file>` | 读入 RTL 源码；`-sv` 开启 SystemVerilog 支持（识别 `typedef enum`、`always_ff`、`always_comb`、`logic` 等）。不加 `-sv` 只认 Verilog-2005 |
| `hierarchy -top <module>` | 指定顶层模块，梳理模块例化层次，检查未定义模块 |
| `proc` | **关键步骤**：把 `always` 块（process）翻译成硬件原语（DFF、mux、比较器等）。执行前 Yosys 内部只有语法树，执行后才变成电路 |
| `opt` | 逻辑优化：constant folding、消除冗余逻辑、删除无用信号 |
| `stat` | 打印统计信息（FF 数量、各类型 cell 数量），用于检查综合结果是否符合预期 |
| `write_verilog <file.v>` | 把综合结果写成 Verilog netlist 文件 |
| `show` | 弹出图形窗口显示电路图（需要安装 graphviz）；`show -format dot -prefix out` 可导出为文件 |
| `help <命令>` | 查看某条命令的详细帮助，例如 `help proc` |

---

## 4. 本项目的完整例子（Study/FSM.sv）

```bash
cd /data/wangxx/Study
yosys -p "read_verilog -sv FSM.sv; hierarchy -top controller; proc; opt; stat"
```

预期输出的统计表（关键部分）：

```
=== controller ===

       12 cells
        1   $adffe        ← 2-bit 状态寄存器（DFF + asynchronous reset）
        4   $mux          ← case 语句综合出的选择器
        1   $pmux
        2   $eq, 2  $ne   ← 比较器（判断 start/finish、状态译码）
        1   $logic_not, 1 $reduce_and
```

如何读这个表：

- **`$adffe` 只有 1 个**——FSM 本质上是 "一个状态寄存器 + 两块组合逻辑"，枚举的 3 个状态用 2-bit 编码，所以只有一个 2-bit FF。
- **没有 latch cell**——说明 `always_comb` 里默认值（`state_d = state_q;`、`busy = 1'b0;`）写对了，没有推断出意外的 latch。

导出 netlist：

```bash
yosys -p "read_verilog -sv FSM.sv; hierarchy -top controller; proc; opt; write_verilog fsm_netlist.v"
```

---

## 5. 常见问题

| 问题 | 原因与解决 |
|------|-----------|
| `bash: yosys: 未找到命令` | 当前终端是配置 `.bashrc` 之前打开的，执行 `source ~/.bashrc` 或新开终端 |
| `error while loading shared libraries: libffi.so.8` | `LD_LIBRARY_PATH` 没配，同上，`source ~/.bashrc` |
| `ERROR: File 'FSM.sv;hierarchy' not found` | `-p` 命令串里分号后没加空格，改为 `; ` |
| SV 语法报错（如 `typedef enum`） | `read_verilog` 忘了加 `-sv` |

---

## 6. 补充说明

`proc; opt` 只是**逻辑综合**（RTL → 通用门级），cell 还是 `$adffe`、`$mux` 这类工艺无关的通用单元。真正投片/上板还需要 **technology mapping（工艺映射）**，即用 `abc` 命令配合具体工艺库（standard cell library）把这些通用单元替换成实际的标准门，这一步一般在 OpenROAD 流程中完成。
