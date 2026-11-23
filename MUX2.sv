module mux2 (
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic y
);

always_comb begin  // always_comb represents a combinational logic block
    if (sel)
        y = b;
    else
        y = a;
end

// assign y = sel ? b : a;
endmodule


