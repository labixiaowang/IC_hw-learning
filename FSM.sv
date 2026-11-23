module controller (
    input  logic clk,
    input  logic rst_n,  //  reset signal
    input  logic start,
    input  logic finish,

    output logic busy,
    output logic done
);

typedef enum logic [1:0] {
    IDLE,
    WORK,
    DONE
} state_t;

state_t state_q;
state_t state_d;


always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)   // reset signal = 0 
        state_q <= IDLE;
    else
        state_q <= state_d;
end

always_comb begin
    state_d = state_q;

    case (state_q)
        IDLE: begin
            if (start)
                state_d = WORK;
        end

        WORK: begin
            if (finish)
                state_d = DONE;
        end

        DONE: begin
            state_d = IDLE;
        end

        default: begin
            state_d = IDLE;
        end
    endcase
end

always_comb begin
    busy = 1'b0;
    done = 1'b0;

    case (state_q)
        IDLE: begin
            busy = 1'b0;
        end

        WORK: begin
            busy = 1'b1;
        end

        DONE: begin
            done = 1'b1;
        end

        default: begin
            busy = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule