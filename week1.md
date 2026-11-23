- 复习组合逻辑、时序逻辑、触发器、锁存器和 FSM。
- 学习 `always_comb`、`always_ff`、blocking 与 non-blocking assignment。
- 完成 HDLBits 中组合逻辑相关题目 10 道。



### ASynchronous and  Synchronous reset

1. 时钟不存在时能否复位
- Asynchronous reset：clock 还没起振、clock gating（时钟门控）关掉时钟、或上电瞬间 clock 不稳定时，依然能复位。所以芯片上电初始化几乎都用 async reset。
Synchronous reset：没有时钟沿就永远复不了位，系统可能停留在未知状态。
2. 对刺（glitch）的敏感度
- Asynchronous reset：复位线上的任何 glitch（组合逻辑产生的毛刺、外部干扰）都会立即触发复位，可能把系统误复位。
Synchronous reset：毛刺只有在时钟沿那一瞬间恰好存在才有影响，天然有一定滤波效果，抗干扰更强。
3. Timing（时序）上的区别
- Asynchronous reset：复位信号直接接 FF 的 reset pin，不占用 data path 的时序。但引入了两个新的时序检查 —— recovery time 和 removal time（类似于 setup/hold），复位释放时刻离时钟沿太近会造成 metastability（亚稳态）。
Synchronous reset：复位信号被并入 d 输入的组合逻辑（相当于在 D 前面加了一个 mux），占用了 data path 的 setup timing，可能让关键路径变长、限制最高频率。
4. 硬件资源开销（FPGA 上特别明显）
- 很多 FPGA 的 flip-flop 原生只支持一种复位方式（比如 Xilinx 7 系列原生是 sync reset）。如果代码写的复位方式和器件原生支持的不匹配，综合工具就要用额外的 LUT 来实现，白白多占 FPGA 设计里选哪种复位方式常常取决于目标器件。

5. 仿真语义
- 异步复位的 sensitivity list 里有 negedge rst_n，复位线一变就触发；
同步复位里 rst_n 不进 sensitivity list，rst_n 变化时 block 不会被唤醒，只有时钟沿才评估。
写错了（比如同步复位却把 rst_n 写进 sensitivity list）会综合出和仿真行为不一致的电路，这是很经典的 bug 来源。


工程实践中的结论
正因为 async reset 释放时有亚稳态风险，业界常用的方案是 "asynchronous assert, synchronous deassert"（异步置位、同步用一个 reset synchronizer，让复位进入时立即生效（利用异步复位的可靠性），复位释放**时通过两级 FF 同步到时钟域（避免 recovery/removal 违例）。

```verilog
// Reset synchronizer: async assert, sync deassert
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        {rst_sync, rst_sync_d} <= 2'b00;
    else
        {rst_sync, rst_sync_d} <= {rst_sync_d, 1'b1};
end
```