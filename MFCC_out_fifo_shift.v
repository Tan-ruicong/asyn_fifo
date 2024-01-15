`timescale 1ns / 1ps

module MFCC_out_fifo_shift#(
    parameter DEPTH  = 20    ,
    parameter DATA_W = 32
)(
    input                      wrclk        ,
    input                      wr_rstn       ,
    input                      rdclk        ,
    input                      rd_rstn       ,
    // output                     empty        ,
    output                     full         ,
 
    input                      wren         ,
    input      [DATA_W-1:0]    push_data    ,
    input                      rden          ,
    output reg [DATA_W-1:0]    pop_data    
);

wire                            empty;     
reg 				  	        wr_en;
reg 				  	        rd_en;

integer i ;

reg [DATA_W-1:0] fifo_mem [DEPTH-1:0];
// reg [DATA_W-1:0] fifo_out_mem [DEPTH-1:0];
reg [$clog2(DEPTH)-1:0] counter_wr;
reg [$clog2(DEPTH)-1:0] counter_rd;

wire [$clog2(DEPTH)-1:0] counter;


    always @(posedge wrclk or posedge wr_rstn)begin
        if(!wr_rstn)begin
            wr_en <= 1'b0;
            counter_wr <= 'd0;
        end
        else if (empty)begin
            if( wren  == 1 )begin
                wr_en <= 1;
            end
            else 
                wr_en <= 0;
            end
        else if(counter_wr == 19)begin
                wr_en <= 0;
        end
        end

    always @(posedge rdclk or posedge rd_rstn)begin
        if(!rd_rstn)begin
            rd_en <= 1'b0;
            counter_rd <= 'd0;
        end
        else if (full)begin
            if(rden == 1)begin
               rd_en <= 1;
            end
            else 
               rd_en <= 0;
            end
        else if(counter_rd == 1)begin
                rd_en <= 0;
        end
    end

    always @(posedge wrclk)begin
          if(empty || counter == 'b1)begin
            counter_wr <= 'd0;
          end
        if(wr_en && !full)begin
          fifo_mem[counter_wr] <= push_data;
          counter_wr <= counter_wr + 1'b1;
        end
     end
     
     always @(posedge rdclk)begin
          if(full)begin
            counter_rd <= 'd20;
          end
          if(rd_en && !empty)begin
          pop_data <= fifo_mem[0];
          for(i = 0;i < DEPTH-1;i = i + 1)begin
            fifo_mem[i] <= fifo_mem[i+1];
          end
          counter_rd <= counter_rd - 1'b1;
        end
    end

assign empty = (counter_rd == 'd0 && (counter_wr == 'd0));
assign full  = (counter_wr == DEPTH && (counter_rd == 'd0));

assign counter = counter_rd;
endmodule