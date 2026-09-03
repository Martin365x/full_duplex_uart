module Parity_bit_calc #(parameter N = 8) (P_input, clk, rst, P_bit, parity_out, load);

input logic [N-1:0] P_input;
input logic clk, rst, P_bit, load;
output logic parity_out;

always_ff @(posedge clk or negedge rst)
if (!rst)
parity_out <= 1'b0;
else if (load)
parity_out <= P_bit ? ~(^P_input) : (^P_input);

endmodule
