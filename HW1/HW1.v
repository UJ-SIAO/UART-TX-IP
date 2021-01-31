`timescale 1ns/1ns
module HW1(
				clk_50M,
				reset_n,
				write,
				write_value,
				uart_txd
			  );
			  
input clk_50M;
input reset_n;
input write;
input [7:0]write_value;
output uart_txd;

integer i;

reg uart_txd=1;
reg [12:0]count;
reg [3:0]bits_count;
reg [7:0]catched_val=8'b0;
reg ready;
wire neg_write;
wire pos_write;

always@(posedge clk_50M or negedge reset_n)
begin
	if(!reset_n)
		count<=13'd0;
	else 
	begin
		if(count==13'd5207)
			count<=13'd0;
		else
			count<=count+1;
	end
end

always@(posedge clk_50M or negedge reset_n)
begin
	if(!reset_n)
		bits_count<=4'd0;
	else
	begin
		if(count==13'd5207)
			if(count==13'd5207 && bits_count==4'd14)
				bits_count<=4'd0;
			else
				bits_count<=bits_count+1'b1;
	end
end

edge_detect wt(
					.clk(clk_50M),
					.rst_n(reset_n),
					.data_in(write),
					.pos_edge(pos_write),
					.neg_edge(neg_write)
					);
					
always@(posedge clk_50M or negedge reset_n)
begin
	if(!reset_n)
		catched_val<=8'b0;
	else
	begin
		if(neg_write)
		begin
			for(i=0;i<7;i=i+1)
			begin
				catched_val[i]<=write_value[i];
			end
		end
		else
			catched_val<=catched_val;
	end
end					
					
					

always@(posedge clk_50M or negedge reset_n)
begin
	if(!reset_n)
		uart_txd<=1'b1;
	else
	begin
	//if(ready)
	//begin
		if(count==13'd0)
		begin
			if(bits_count==0)
				uart_txd<=1'b0;
			else if(0<bits_count && bits_count<9)
				uart_txd<=catched_val[bits_count-1];
			/*else if(bits_count==9)
				uart_txd<=1'b1;*/
			else	
				uart_txd<=1'b1;
		end
		else
			uart_txd<=uart_txd;
	//end	
	end
end

always@(posedge clk_50M or negedge reset_n)
begin
	if(!reset_n)
		ready<=1'b1;
	else
		if(neg_write)
			ready<=1'b1;
		else if (bits_count==9)
			ready<=1'b0;
		else
			ready<=ready;
end
endmodule
