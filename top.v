`timescale 1ns / 1ps

module top#(
    parameter DEPTH  = 20    ,
    parameter DATA_W = 32
)(
input                      clk        ,
input                      rstn       ,

output                     empty        ,
output                     full         ,

input                      wren         ,
input      [DATA_W-1:0]    push_data    ,
input                      rden         ,
output reg [DATA_W-1:0]    pop_data    


);

MFCC_out_fifo_shift #(.DEPTH (20),.DATA_W(32)) fifo(
    .wrclk        (clk),
    .wr_rstn      (rstn),
    .rdclk        (clk),
    .rd_rstn      (rstn),
    .empty        (empty),
    .full         (full),

    .wren         (wren),
    .push_data    (push_data),
    .rden         (rden),
    .pop_data     (pop_data)
);

endmodule