module parity_check #(parameter w = 8) (
input logic i_par_n, cheak_par, i_par_odd, i_clk, i_rst_n, par_bit,
input logic [w-1:0] o_data,
output logic o_parity_err
);

logic exp_par, par_error;

assign exp_par = (^o_data) ^ i_par_odd;
assign par_error = i_par_n && (exp_par != par_bit);

always_ff @(posedge i_clk or negedge i_rst_n)
if (!i_rst_n)
o_parity_err <= 1'b0;
else if (cheak_par)
o_parity_err <= par_error;

endmodule
