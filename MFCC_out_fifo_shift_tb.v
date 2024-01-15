`timescale 1ns / 1ps
module MFCC_out_fifo_shift_tb;
    parameter DEPTH = 20;
	parameter DATA_W= 32;

	// дʱ����tb�źŶ���
	reg					wrclk		;
	reg					wr_rst_n	;
	reg	[DATA_W-1:0]		wr_data		;
	reg 				wr_en		;
	wire				wr_full		;

	// ��ʱ����tb�źŶ���
	reg					rdclk		;
	reg					rd_rst_n	;
	wire [DATA_W-1:0]	rd_data		;
	reg					rd_en		;
	wire				rd_empty	;

	// testbench�Զ����ź�
	reg					init_done	;		// testbench��ʼ������

	// FIFO��ʼ��
	initial	begin
		// �����źų�ʼ��
		wr_rst_n  = 1	;
		rd_rst_n  = 1	;
		wrclk 	  = 0	;
		rdclk 	  = 0	;
		wr_en 	  = 0	;
		rd_en 	  = 0	;
		wr_data   = 'b0 ;
		init_done = 0	;

		// FIFO��λ
		#30 wr_rst_n = 0;
			rd_rst_n = 0;
		#30 wr_rst_n = 1;
			rd_rst_n = 1;
//            rd_empty = 1;
//            wr_full = 0;
		// ��ʼ�����
		#30 init_done = 1;
		
	end



	// дʱ��
	always
		#2 wrclk = ~wrclk;

	// ��ʱ��
	always
		#4 rdclk = ~rdclk;



	// ��д����
	always @(*) begin
		if(init_done) begin
			// д����
			if( wr_full == 1 )begin
				wr_en = 0;
			end
			else if(rd_empty)begin
				wr_en = 1;
			end
		end
	end

	always @(*) begin
		if(init_done) begin
			// ������
			if( rd_empty == 1 )begin
				rd_en = 0;
			end
			else if(wr_full) begin
//			    #(1)
				rd_en = 1;
			end
		end
	end



	// д����������
	always @(posedge wrclk) begin
		if(init_done) begin
			if( wr_full == 1'b0 )
				wr_data <= wr_data + 1;
			else
				wr_data <= wr_data;
		end
		else begin
			wr_data <= 'b0;
		end
	end



	// �첽fifo����
	MFCC_out_fifo_shift
		# ( .DEPTH(20), .DATA_W(32) )
		U_ASFIFO
		(
			.wrclk	 	        (wrclk		),
			.wr_rstn        	(wr_rst_n	),
			.push_data	        (wr_data	),
			.wren        		(wr_en		),
			.empty  	        (rd_empty	),

			.rdclk	          	(rdclk		),
			.rd_rstn        	(rd_rst_n	),
			.pop_data         	(rd_data	),
			.rden            	(rd_en		),
			.full           	(wr_full	)
		);


endmodule