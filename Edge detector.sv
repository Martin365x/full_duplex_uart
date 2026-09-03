module edge_detector (
input logic clk, n_rst, A,
output logic neg_edge_A, pos_edge_A, edge_A
);

logic A_dly;

always_ff @(posedge clk or negedge n_rst)
if (!n_rst)
A_dly <= 1'b0;
else
A_dly <= A;

always_comb begin
pos_edge_A = A & ~A_dly;
neg_edge_A = ~A & A_dly;
edge_A = A ^ A_dly;
end

endmodule
