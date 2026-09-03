module fsm_rx (
input logic i_rx, i_clk, i_rst_n, i_par_n, done,
output logic o_valid, o_busy, o_frame_err, shift_en, par_bit, cheak_par
);

typedef enum logic [1:0] {ST_IDLE, ST_DATA, ST_PARITY, ST_STOP} state_u;
state_u state, nextstate;

logic start_check, pos_edge_A, edge_A, err_par, valid_d;

edge_detector u_edge (
.clk(i_clk),
.n_rst(i_rst_n),
.A(i_rx),
.neg_edge_A(start_check),
.pos_edge_A(pos_edge_A),
.edge_A(edge_A)
);

always_ff @(posedge i_clk or negedge i_rst_n)
if (!i_rst_n) begin
state <= ST_IDLE;
end
else begin
state <= nextstate;
o_frame_err <= err_par;
o_valid <= valid_d;
end

always_comb begin
o_busy = 1'b0;
shift_en = 1'b0;
par_bit = 1'b0;
cheak_par = 1'b0;
err_par = 1'b0;
valid_d = 1'b0;
nextstate = state;

case (state)
ST_IDLE: if (start_check) begin
nextstate = ST_DATA;
o_busy = 1'b1;
end

ST_DATA: begin
o_busy = 1'b1;
shift_en = 1'b1;
if (done) begin
if (i_par_n) begin
nextstate = ST_PARITY;
end
else begin
nextstate = ST_STOP;
cheak_par = 1'b1;
end
end
end

ST_PARITY: begin
o_busy = 1'b1;
cheak_par = 1'b1;
par_bit = i_rx;
nextstate = ST_STOP;
end

ST_STOP: begin
nextstate = ST_IDLE;
valid_d = 1'b1;
if (!i_rx) err_par = 1'b1;
end

default: nextstate = ST_IDLE;
endcase
end

endmodule
