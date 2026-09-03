module fsm (
input logic V_input, clk, rst, done, P_en,
output logic [1:0] select,
output logic load, start, busy
);

typedef enum logic [2:0] {ST_IDLE, ST_START, ST_DATA, ST_PARITY, ST_STOP} state_t;
state_t state, next_state;

always_comb begin
if (state == ST_START) select = 2'b00;
else if (state == ST_DATA) select = 2'b01;
else if (state == ST_PARITY) select = 2'b10;
else select = 2'b11;
end

always_ff @(posedge clk or negedge rst)
if (!rst) state <= ST_IDLE;
else state <= next_state;

always_comb begin
next_state = state;
load = 0;
start = 0;
busy = 0;

case (state)
ST_IDLE: if (V_input) begin next_state = ST_START; load = 1; end
ST_START: begin next_state = ST_DATA; start = 1; busy = 1; end
ST_DATA: begin
start = 1;
busy = 1;
if (done) next_state = (P_en) ? ST_PARITY : ST_STOP;
end
ST_PARITY: begin busy = 1; next_state = ST_STOP; end
ST_STOP: begin busy = 1; next_state = ST_IDLE; end
default: next_state = ST_IDLE;
endcase
end

endmodule
