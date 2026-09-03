module Serializer(P_input, clk, rst, start, load, serial_out, done);
parameter N = 8;
input [N-1:0] P_input;
input clk;
input rst;
input start;
input load;
output reg serial_out;
output done;
reg [N-1:0] shift;
reg [3:0] count;
always @(posedge clk or negedge rst) begin
if (!rst) begin
shift <= 0;
serial_out <= 0;
count <= 0;
end
else if (load) begin
shift <= P_input;
count <= 0;
end
else if (start && count != N) begin
serial_out <= shift[0];
shift <= {1'b0, shift[N-1:1]};
count <= count + 1;
end
end
assign done = (count == N);
endmodule
