module uart_loopback_tb;

localparam DATA_W = 8;
localparam CLK_PERIOD = 10;

logic clk;
logic rst_n;

logic [DATA_W-1:0] tx_data;
logic tx_valid;
logic par_en;
logic par_odd;
logic tx_busy;

wire line;

logic [DATA_W-1:0] rx_data;
logic rx_valid;
logic rx_busy;
logic parity_err;
logic frame_err;

initial clk = 1'b0;
always #(CLK_PERIOD/2) clk = ~clk;

uart_tx #(.DATA_W(DATA_W)) u_tx (
.i_clk(clk),
.i_rst_n(rst_n),
.i_data(tx_data),
.i_valid(tx_valid),
.i_par_en(par_en),
.i_par_odd(par_odd),
.o_busy(tx_busy),
.o_tx(line)
);

uart_rx #(.DATA_W(DATA_W)) u_rx (
.i_clk(clk),
.i_rst_n(rst_n),
.i_rx(line),
.i_par_en(par_en),
.i_par_odd(par_odd),
.o_data(rx_data),
.o_valid(rx_valid),
.o_busy(rx_busy),
.o_parity_err(parity_err),
.o_frame_err(frame_err)
);

task automatic send_byte(input logic [DATA_W-1:0] d);
begin
@(negedge clk);
while (tx_busy) @(negedge clk);
tx_data = d;
tx_valid = 1'b1;
@(negedge clk);
tx_valid = 1'b0;
end
endtask

initial begin
rst_n = 1'b0;
tx_data = '0;
tx_valid = 1'b0;
par_en = 1'b0;
par_odd = 1'b0;

repeat (4) @(negedge clk);
rst_n = 1'b1;
repeat (4) @(negedge clk);

par_en = 1'b0;
par_odd = 1'b0;
send_byte(8'hA5);
repeat (20) @(negedge clk);

send_byte(8'h3C);
repeat (20) @(negedge clk);

par_en = 1'b1;
par_odd = 1'b0;
send_byte(8'h5A);
repeat (25) @(negedge clk);

par_en = 1'b1;
par_odd = 1'b1;
send_byte(8'hF0);
repeat (25) @(negedge clk);

repeat (10) @(negedge clk);
$stop;
end

endmodule
