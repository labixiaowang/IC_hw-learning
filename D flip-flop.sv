module dff (
    input  logic clk,
    input  logic d,
    output logic q
);

always_ff @(posedge clk) begin  // Sequential logic
    q <= d;
end

endmodule


module dff1 (
    input  logic clk,
    input  logic d,
    output logic q
);
always_ff @(posedge clk or negedge rst_n) begin   // negedge 异步复位
    if (!rst_n)
        q <= 1'b0;  // non-blocking
    else
        q <= d;
end