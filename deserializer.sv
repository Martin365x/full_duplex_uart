module deserializer(i_rx, shift_en, i_clk, i_rst_n, o_data, done);

parameter w = 8;

input i_rx;
input shift_en;
input i_clk;
input i_rst_n;
output reg [w-1:0] o_data;
output done;

reg [3:0] count;
wire [3:0] count_next;

assign count_next = count + 1;
assign done = shift_en && (count_next == w);

always @(posedge i_clk or negedge i_rst_n) begin
if (!i_rst_n) begin
o_data <= 0;
count <= 0;
end
else if (shift_en) begin
o_data <= {i_rx, o_data[w-1:1]};
if (done) begin
count <= 0;
end
else begin
count <= count_next;
end
end
end

endmodule
