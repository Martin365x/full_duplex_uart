module mux (serial_out, select, parity_out, TX_out);
input logic parity_out, serial_out;
input logic [1:0] select;
output logic TX_out;

localparam SEL_START = 2'b00, SEL_DATA = 2'b01, SEL_PARITY = 2'b10, SEL_STOP = 2'b11;

always_comb
case (select)
SEL_START: TX_out = 1'b0;
SEL_DATA: TX_out = serial_out;
SEL_PARITY: TX_out = parity_out;
SEL_STOP: TX_out = 1'b1;
default: TX_out = 1'b1;
endcase

endmodule
