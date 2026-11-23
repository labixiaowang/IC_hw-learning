# NVIDIA ASIC RTL 与验证实习 GitHub 项目学习计划

计划周期：2026 年 11 月 23 日至 2027 年 2 月 14 日  
目标岗位：ASIC Design、Design Verification、SoC Verification  
建议投入：工作日每天 2.5 至 3 小时，周六 6 小时，周日 4 小时，每周约 23 至 25 小时  
最终作品：多时钟域 Streaming DMA Engine，包括 RTL、验证、SVA、形式验证、综合、STA 和后端结果

## 学习策略

本计划不以“看完多少课程”为目标，而是每周围绕一个真实 GitHub 仓库完成一次小型工程闭环：

1. 先读 README、目录结构和设计文档，不从最大文件开始。
2. 只选择两到四个核心模块，画出端口、状态和数据流。
3. 复现仓库已有的最小测试；环境过重时只做静态阅读和独立小实验。
4. 在自己的学习仓库中重新实现一个简化版本，不复制粘贴原代码。
5. 添加测试、断言、波形和可复现命令。
6. 做一个有明确目的的小修改，比较修改前后的行为。
7. 写一页工程笔记，回答“为什么这样设计、替代方案是什么、如何验证”。

每周至少产生一次可展示的 Git 提交。完成定义是“能运行、能解释、能复现”，不是“看过代码”。

## 核心 GitHub 仓库

| 仓库 | 主要用途 | 本计划中的学习重点 |
| --- | --- | --- |
| [pulp-platform/common_cells](https://github.com/pulp-platform/common_cells) | 常用 SystemVerilog 组件 | LFSR、计数器、ready/valid、FIFO、仲裁、CDC |
| [pulp-platform/axi](https://github.com/pulp-platform/axi) | AXI4/AXI4-Lite IP 与验证基础设施 | 五通道、背压、缓冲、仲裁和模块化接口 |
| [lowRISC/opentitan](https://github.com/lowRISC/opentitan) | 大型开源安全 SoC | 工业编码规范、FIFO、断言、DV 方法 |
| [YosysHQ/sby](https://github.com/YosysHQ/sby) | SymbiYosys 形式验证 | FIFO、安全性、cover 和反例 |
| [lowRISC/ibex](https://github.com/lowRISC/ibex) | 生产质量 RV32 RISC-V CPU | ALU、译码、流水线、stall、flush、验证结构 |
| [pulp-platform/croc](https://github.com/pulp-platform/croc) | 面向教学的完整 SoC | CPU、SRAM、外设、用户域和物理设计流程 |
| [The-OpenROAD-Project/OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts) | RTL-to-GDSII | 综合、时序、布局布线和 PPA 比较 |
| [cocotb/cocotb](https://github.com/cocotb/cocotb) | Python RTL 验证 | 随机激励、monitor、scoreboard 和回归 |

## GitHub 学习仓库结构

第一周创建自己的仓库 `nvidia-hw-learning`：

```text
nvidia-hw-learning/
├── README.md
├── notes/
│   ├── common-cells.md
│   ├── ready-valid.md
│   ├── axi.md
│   ├── opentitan-dv.md
│   ├── formal.md
│   ├── ibex.md
│   └── croc-openroad.md
├── labs/
│   ├── lfsr-counter/
│   ├── stream-fifo/
│   ├── axi-lite-slave/
│   ├── formal-fifo/
│   └── rv32i-alu/
└── capstone/
    └── streaming-dma/
```

每个实验目录统一包含：

```text
rtl/        可综合 RTL
tb/         testbench 或 cocotb
formal/     SVA 与 .sby 文件
scripts/    自动化脚本
docs/       架构图、波形和报告
Makefile    lint/test/formal/synth 入口
README.md   目标、接口、运行方法、结果和限制
```

## 固定每周节奏

| 时间 | 固定任务 |
| --- | --- |
| 周一 | 阅读仓库 README、文档和目录，写一张模块地图 |
| 周二 | 精读第一个核心 RTL，标注状态寄存器、组合逻辑和握手条件 |
| 周三 | 精读第二个核心 RTL，画关键时序并整理问题 |
| 周四 | 复现最小测试，或者为所读模块建立独立小测试 |
| 周五 | 在自己的仓库重写简化版本，添加基本测试和 SVA |
| 周六 | 完成功能修改、随机回归、波形分析和 Bug 修复 |
| 周日 | 写工程笔记、整理提交、口头讲解并更新简历素材 |

## 第 1 周：从 common_cells 学习可复用 RTL

日期：2026 年 11 月 23 日至 11 月 29 日  
仓库：[pulp-platform/common_cells](https://github.com/pulp-platform/common_cells)

### 目标模块

- `cc_lfsr_16bit` 或参数化 `cc_lfsr`
- `cc_counter`
- `cc_edge_detect`
- 仓库中的寄存器宏和断言宏说明

### 每日安排

- 周一：浏览 README 和 `src/`，按时钟复位、CDC、计数器、数据通路、数据结构分类记录模块。
- 周二：精读 LFSR，写出状态更新方程、种子要求、周期性和可综合原因。
- 周三：精读计数器和边沿检测器，识别 `_q/_d`、参数、溢出条件和复位风格。
- 周四：在自己的仓库实现 16 位 LFSR，生成 200 个状态并检查不进入全零状态。
- 周五：实现参数化 up/down counter，覆盖 enable、clear、overflow 和 underflow。
- 周六：使用 Verilator lint；为 LFSR 与计数器编写自检 testbench 和至少 6 条断言。
- 周日：写 `notes/common-cells.md`，比较自己的实现与 PULP 的接口、参数化和断言风格。

### 本周交付物

- `labs/lfsr-counter` 可一键运行。
- LFSR 状态转移图和 counter 状态表。
- 至少 6 条断言，包含计数范围、复位值和 enable 保持。
- 3 分钟口头说明：为什么 LFSR 是伪随机、为什么不能使用全零种子。

## 第 2 周：从 common_cells 学习 ready valid 与 FIFO

日期：2026 年 11 月 30 日至 12 月 6 日  
仓库：[pulp-platform/common_cells](https://github.com/pulp-platform/common_cells)

### 目标模块

- `cc_stream_register`
- `cc_stream_fifo`
- `cc_spill_register`
- `cc_rr_arb_tree`

### 每日安排

- 周一：整理 ready/valid 四种状态，明确 transfer、stall 和 backpressure。
- 周二：精读 stream register，追踪输入 ready 如何受输出 ready 和内部 valid 影响。
- 周三：精读 stream FIFO，画出 push、pop、full、empty 和同时 push/pop 的状态表。
- 周四：精读 round-robin arbiter，只追踪两请求和四请求配置，不追求一次看完所有参数。
- 周五：独立实现深度 4 的 ready/valid FIFO。
- 周六：随机化输入 valid 与输出 ready，连续传输至少 10000 个 transaction；添加 scoreboard。
- 周日：加入 SVA，写 `notes/ready-valid.md`，解释如何避免数据丢失、重复和组合环。

### 必须完成的断言

- `valid && !ready` 时 valid 保持。
- `valid && !ready` 时 payload 保持。
- FIFO fill level 不超过深度。
- empty 时不允许成功 pop。
- full 时不允许成功 push，除非同周期 pop 被设计允许。
- 输入顺序与输出顺序一致。

### 本周交付物

- `labs/stream-fifo`。
- 随机背压回归日志和代表性波形。
- 一张 ready/valid 数据流图。
- 一段简历素材：实现参数化 FIFO、随机背压验证和协议断言。

## 第 3 周：从 PULP AXI 学习真实片上接口

日期：2026 年 12 月 7 日至 12 月 13 日  
仓库：[pulp-platform/axi](https://github.com/pulp-platform/axi)  
已有基础：当前 EE213 AXI4-Lite 实验

### 阅读范围

- README 中的 AXI4 与 AXI4-Lite 模块分类。
- `include/axi` 中的类型和接口定义。
- `src/` 中名字以 `axi_lite_` 开头的两个简单模块。
- 一个缓冲、mux 或 demux 模块的 ready/valid 路径。
- `test/` 中相应测试的目录结构。

### 每日安排

- 周一：画出 PULP AXI 仓库地图，记录 `src/include/test/doc` 的职责。
- 周二：比较 PULP 的 AXI 类型封装与自己 EE213 项目中的散列端口写法。
- 周三：选择一个 `axi_lite_*` 模块，跟踪 AW、W、B、AR、R 五通道的数据路径。
- 周四：给自己的 AXI4-Lite Slave 增加明确的接口文档和通道时序图。
- 周五：把当前 procedural random 测试整理成可重复 seed，并记录首次失败 seed。
- 周六：新增三组场景：AW/W 同周期、AW/W 独立并行发送、读写同时进行。
- 周日：写 `notes/axi.md`，比较单通道属性、跨通道属性和数据一致性检查。

### 本周交付物

- 改进后的 `labs/axi-lite-slave`。
- 原实现与 PULP AXI 设计风格对照表。
- 五通道独立背压测试。
- AXI 协议错误清单：VALID 依赖 READY、载荷变化、响应过早、响应遗漏和事务错配。

## 第 4 周：从 OpenTitan 学习工业 DV 与断言

日期：2026 年 12 月 14 日至 12 月 20 日  
仓库：[lowRISC/opentitan](https://github.com/lowRISC/opentitan)

### 阅读范围

- DV methodology 文档。
- `hw/ip/prim/rtl/prim_fifo_sync.sv`。
- `prim_assert.sv` 和常用 assertion macros。
- 一个协议 checker 或 FIFO assertion 文件。

### 每日安排

- 周一：阅读 OpenTitan DV methodology，整理 driver、monitor、scoreboard、coverage、assertion 的分工。
- 周二：精读 `prim_fifo_sync` 的 Depth=0、Depth=1 和普通 FIFO 三种 generate 分支。
- 周三：列出 FIFO 中 design assertion、known assertion 和功能 assertion 的区别。
- 周四：在自己的 FIFO 中引入统一断言宏，保证失败日志带名称和上下文。
- 周五：添加 cover property，覆盖空到非空、满到非满、同时 push/pop 和连续背压。
- 周六：故意注入三个 FIFO 缺陷，记录断言首次失败时间和波形。
- 周日：写 `notes/opentitan-dv.md`，准备 5 分钟讲解“为什么没有报错不代表验证充分”。

### 本周交付物

- assertion checklist。
- FIFO 缺陷注入结果表。
- cover property 命中报告。
- 一页 OpenTitan DV 架构笔记。

### 范围限制

OpenTitan 完整 UVM 环境依赖较重且常使用商业模拟器。本周目标是读懂方法和复用设计思想，不要求运行整套 UVM regression。

## 第 5 周：从 SymbiYosys 学习形式验证

日期：2026 年 12 月 21 日至 12 月 27 日  
仓库：[YosysHQ/sby](https://github.com/YosysHQ/sby)

### 学习路径

- 先复现官方 FIFO quickstart。
- 理解 `.sby` 文件中的 task、mode、depth、engine 和 files。
- 学习 `assert`、`assume`、`cover` 的不同角色。
- 将自己的 FIFO 和 AXI4-Lite 局部规则放入形式环境。

### 每日安排

- 周一：复现官方 FIFO 示例的通过任务和故意失败任务。
- 周二：阅读反例波形，逐周期解释 solver 如何找到错误。
- 周三：为自己的 FIFO 建立形式 harness，约束复位和合法输入。
- 周四：证明 fill level 有界、顺序保持、无 underflow 和无 overflow。
- 周五：为 AXI4-Lite 写两个局部性质：stall 时 payload 稳定、响应不能凭空出现。
- 周六：加入 cover，寻找 FIFO 从空到满再到空的最短轨迹。
- 周日：写 `notes/formal.md`，比较仿真、随机回归和形式验证的能力边界。

### 本周交付物

- `labs/formal-fifo`。
- 可通过和故意失败的 `.sby` 任务。
- 至少 5 个 assert、3 个 assume 和 2 个 cover。
- 一张反例波形及逐周期解释。

## 第 6 周：从 Ibex 学习 ALU 与指令译码

日期：2026 年 12 月 28 日至 2027 年 1 月 3 日  
仓库：[lowRISC/ibex](https://github.com/lowRISC/ibex)

### 阅读范围

- `doc/03_reference/instruction_decode_execute.rst`
- `rtl/ibex_alu.sv`
- `rtl/ibex_decoder.sv`
- `rtl/ibex_pkg.sv` 中与 ALU 操作有关的枚举

### 每日安排

- 周一：阅读指令译码和执行文档，画出 instruction 到 control 到 ALU 的路径。
- 周二：精读 ALU 的加减、比较、移位部分，暂时跳过复杂 bit-manip 与乘除法。
- 周三：精读 decoder 中 RV32I 算术、分支、load/store 三组 opcode。
- 周四：选择 ADD、SUB、AND、OR、XOR、SLT、SLL、SRL 八个操作，建立输入输出表。
- 周五：独立实现一个简化 RV32I ALU，不复制 Ibex 代码。
- 周六：建立随机 reference model，运行至少 50000 组输入；添加边界值和 signed/unsigned 比较。
- 周日：写 `notes/ibex.md` 第一部分，解释译码信号怎样控制 ALU。

### 本周交付物

- `labs/rv32i-alu`。
- 译码到 ALU 的控制路径图。
- 随机测试报告和 signed comparison 波形。
- 能在白板上解释 `SLT` 与 `SLTU` 的区别。

## 第 7 周：从 Ibex 学习流水线、stall 与 flush

日期：2027 年 1 月 4 日至 1 月 10 日  
仓库：[lowRISC/ibex](https://github.com/lowRISC/ibex)

### 阅读范围

- pipeline details 文档。
- `rtl/ibex_if_stage.sv`。
- `rtl/ibex_id_stage.sv` 中 valid/ready 和 stall 相关部分。
- `rtl/ibex_controller.sv` 中 branch、exception 和 flush 相关状态。

### 每日安排

- 周一：画 Ibex 两级流水线，标出 IF 和 ID/EX，说明可选 WB stage。
- 周二：跟踪一条 ADD 指令从 fetch 到 register writeback。
- 周三：跟踪一条 branch 指令，标出 taken、PC redirect 和 flush。
- 周四：跟踪一条 load 指令，找出 LSU 等待造成的 stall。
- 周五：整理 pipeline valid、ready、clear 和 stall 信号的依赖图。
- 周六：如果环境允许，运行 Ibex Simple System 的最小程序；否则使用代码和文档完成静态时序追踪。
- 周日：完成 `notes/ibex.md`，录制 8 分钟项目讲解。

### 本周交付物

- ADD、branch、load 三条指令的逐周期表。
- stall 与 flush 对比表。
- 一张 Ibex 数据通路图。
- 10 个常见 CPU/流水线面试问题及答案。

## 第 8 周：从 Croc 学习 SoC 集成

日期：2027 年 1 月 11 日至 1 月 17 日  
仓库：[pulp-platform/croc](https://github.com/pulp-platform/croc)

### 阅读范围

- 顶层 README、系统架构和 memory map。
- `croc_domain`、`user_domain`、CPU、SRAM、UART、GPIO 和 timer 的连接。
- `Bender.yml` 与依赖管理。
- Verilator 仿真脚本和最小软件示例。

### 每日安排

- 周一：画出 CPU、互连、SRAM 和外设的 SoC 顶层图。
- 周二：阅读 memory map，解释完整地址如何被译码成外设局部地址。
- 周三：追踪一次 CPU 对 GPIO/UART 寄存器的访问路径。
- 周四：理解 user domain 的扩展入口，设计一个简单计数器或性能监控外设。
- 周五：编写外设接口规格、寄存器表和中断行为，不急于写 RTL。
- 周六：环境允许时把外设加入 Croc 并运行最小仿真；否则建立独立 wrapper 模拟相同寄存器访问。
- 周日：写 `notes/croc-openroad.md` 第一部分，说明 SoC 集成和单独 IP 验证的区别。

### 本周交付物

- Croc 模块层次图和 memory map 笔记。
- 一个用户外设规格。
- 寄存器表、地址译码和软件访问示例。

## 第 9 周：主项目 Streaming DMA 规格与架构

日期：2027 年 1 月 18 日至 1 月 24 日  
参考仓库：PULP AXI、common_cells、Croc

### 最小功能范围

- AXI4-Lite 或 APB 配置寄存器。
- 输入和输出 ready/valid stream。
- 可配置传输长度。
- source 和 destination 独立背压。
- 状态、完成中断和错误标志。
- 可选异步 FIFO 作为进阶功能。

### 每日安排

- 周一：写一页 problem statement，说明 DMA 的输入、输出和使用场景。
- 周二：画控制面与数据面，确定 clock/reset domain。
- 周三：定义寄存器表、状态机、计数器和错误行为。
- 周四：定义 ready/valid 接口，列出所有 backpressure corner case。
- 周五：写 verification plan，包含 directed、random、assertion、formal 和 coverage。
- 周六：创建 `capstone/streaming-dma` 仓库结构，写接口 skeleton 和 CI。
- 周日：完成设计评审，自问每个状态、每个寄存器和每个异常是否有明确定义。

### 本周交付物

- `SPEC.md`。
- 架构图、状态图、寄存器表和时序图。
- 至少 30 项 verification plan。
- GitHub issue 列表和三周里程碑。

## 第 10 周：主项目 RTL 实现

日期：2027 年 1 月 25 日至 1 月 31 日

### 每日安排

- 周一：实现寄存器配置接口和状态寄存器。
- 周二：实现主控制 FSM 与长度计数器。
- 周三：实现输入 buffer、输出 ready/valid 和 backpressure。
- 周四：实现 interrupt、done、busy 和 error 行为。
- 周五：完成模块级 directed tests。
- 周六：连接所有模块，完成 reset、中途停止和连续 transaction 测试。
- 周日：做一次代码审查，重点检查 latch、多驱动、位宽、复位和组合环。

### 本周交付物

- 功能完整的 RTL v1。
- Verilator lint 零严重警告。
- 基础测试全部通过。
- README 中包含接口和运行命令。

## 第 11 周：主项目验证与形式验证

日期：2027 年 2 月 1 日至 2 月 7 日

### 每日安排

- 周一：建立 cocotb transaction、driver 和 monitor。
- 周二：建立 Python reference model 和 scoreboard。
- 周三：加入随机数据、随机长度、随机输入 valid 和随机输出 ready。
- 周四：添加 SVA：stall 稳定性、计数范围、done 条件、响应唯一性和中断行为。
- 周五：建立 SymbiYosys harness，证明局部安全性属性。
- 周六：运行多 seed regression，保存失败 seed；注入三个缺陷验证 checker。
- 周日：统计测试点、断言触发、cover 命中和 Bug 修复记录。

### 本周交付物

- 至少 100 个可重复随机 seed。
- Scoreboard 零失配。
- 至少 10 条 SVA 和 3 条 cover property。
- 至少 3 个缺陷注入版本及预期检出结果。
- `VERIFICATION.md`。

## 第 12 周：OpenROAD、PPA 与求职交付

日期：2027 年 2 月 8 日至 2 月 14 日  
仓库：[OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)

### 每日安排

- 周一：先用官方小设计复现 RTL-to-GDS 流程和报告目录。
- 周二：使用 Yosys 综合 Streaming DMA，记录 cell count、面积和 critical path。
- 周三：编写基础时钟与 I/O 约束，检查 setup slack。
- 周四：把设计接入 ORFS，完成 floorplan、placement、CTS 和 routing。
- 周五：比较一个面积优化和一个时序优化配置。
- 周六：整理版图截图、PPA 表、验证结果、失败案例和设计限制。
- 周日：完成 GitHub README、简历 bullet、5 分钟英文介绍和 15 分钟深入问答。

### 最终交付物

- 完整 GitHub 项目首页。
- 一条命令运行 lint/test/formal/synth。
- 架构图、状态图和接口说明。
- 随机回归、SVA、cover 和缺陷注入结果。
- 综合与 STA 报告。
- OpenROAD 布局布线截图。
- 可由日志证明的 PPA 数字。

## 每周 GitHub 提交要求

每周日检查：

- [ ] README 能说明本周学习目标。
- [ ] 代码不是直接复制，而是有自己的简化实现或明确修改。
- [ ] 有一条命令能够复现主要结果。
- [ ] 测试包含正常情况、边界情况和至少一个失败情况。
- [ ] 断言前件实际被覆盖，不是空洞通过。
- [ ] 波形或日志能够证明结论。
- [ ] commit message 描述“为什么改”，不只是“update”。
- [ ] 笔记回答设计取舍和未解决限制。

推荐提交拆分：

```text
docs: map common_cells stream modules
rtl: implement parameterized ready-valid fifo
test: add randomized backpressure scoreboard
formal: prove fifo occupancy bounds
fix: hold payload stable while stalled
```

## 每个开源项目的阅读问题

阅读任何模块时都回答：

1. 模块解决什么问题，输入输出契约是什么？
2. 哪些是状态寄存器，哪些是组合逻辑？
3. 数据在什么条件下真正发生 transfer？
4. 背压从下游怎样传播到上游？
5. reset 后状态是什么，复位释放是否安全？
6. full、empty、valid、ready 是否存在组合环？
7. 哪些参数会改变硬件结构？
8. 哪些 assertion 是协议性质，哪些是设计特定性质？
9. 测试如何知道结果正确，reference model 在哪里？
10. 如果删除一行关键状态更新，会由哪个检查器发现？

## 面试转化要求

每个仓库学习结束后准备三种讲法：

- 30 秒：这个仓库和本周模块解决什么问题。
- 3 分钟：画结构并解释一次 transaction。
- 10 分钟：说明 corner case、验证方法、发现的 Bug 和设计取舍。

三个月后至少能独立回答：

- ready/valid 如何处理背压，为什么 VALID 不能依赖 READY？
- FIFO 如何同时 push/pop，full/empty 如何更新？
- AW 与 W 独立时怎样正确关联一次 AXI4-Lite 写事务？
- simulation、scoreboard、SVA 和 formal 各自能发现什么？
- Ibex 中一条指令如何经过 fetch、decode、execute 和 writeback？
- stall 与 flush 有什么区别？
- 如何把一个 IP 集成到 SoC 的 memory map？
- 怎样从 RTL 得到面积、时序和版图结果？

## 执行优先级与降级方案

如果时间不足，按以下顺序保证：

1. common_cells ready/valid 和 FIFO。
2. AXI4-Lite 项目升级。
3. OpenTitan assertion 方法。
4. SymbiYosys 形式验证。
5. Ibex ALU、decoder 和 pipeline 阅读。
6. Streaming DMA 主项目。
7. Yosys、STA 和 OpenROAD。
8. Croc 完整集成。

如果某仓库环境两天内仍无法搭建，停止消耗时间，改为：

- 阅读文档和两到四个核心模块；
- 在自己的仓库独立重写最小版本；
- 使用已有 Verilator/cocotb/SymbiYosys 环境验证；
- 记录无法复现的原因，不把“安装成功”当成学习目标。

## 投递节奏

- 第 1 周：更新简历和 GitHub 主页，开始投递，不等计划结束。
- 第 2 至 4 周：简历突出 AXI4-Lite、随机背压、SVA 和缺陷注入。
- 第 5 至 8 周：加入 formal、Ibex code reading 和 SoC integration。
- 第 9 至 12 周：以 Streaming DMA 作为主要项目，持续更新结果。
- 每周至少 3 次有效投递或内推联系，每两周进行一次模拟面试。

## 每周复盘模板

```text
本周仓库：
阅读的核心文件：
画出的模块关系：
复现的测试：
自己实现或修改的功能：
新增断言和覆盖点：
遇到的最难Bug：
Bug根因和定位证据：
本周可展示提交：
仍不理解的问题：
下周第一优先级：
本周投递数：
```

## 完成标准

12 周完成不以 clone 了多少仓库计算，而以以下证据计算：

- 能画出 common_cells、AXI、Ibex 和 Croc 中所学模块的关键数据流。
- 至少 5 个独立小实验有 RTL、测试、断言和文档。
- 至少 1 个项目使用 SymbiYosys 产生通过证明和失败反例。
- Streaming DMA 有随机回归、形式属性、综合、STA 和后端结果。
- GitHub 提交历史能够展示逐步设计、调试和验证过程。
- 面试时能够解释每个引用开源项目对自己设计的具体影响。
