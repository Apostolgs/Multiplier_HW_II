
module test_status_bits(status , clk , rst_n); 
	input logic [7:0] status ;
	input logic clk ;
	input logic rst_n ; // do we need rst here ?
	 
	// status = {1'b0  , 1'b0 , inexact_f , huge_f , tiny_f , nan_f , inf_f , zero_f} ;
	//		7	6	5	  4	    3	    2 	    1	    0	
	always@(posedge clk)
	begin
		if(rst_n)
			;
		else
		begin
			Zero_Inf : assert(~(status[0] && status[1]))//  $display($stime,,,"%m assert passed\n"); 
			else $error($stime,,,"%m assert failed\n");
			Zero_Nan : assert(~(status[0] && status[2]))// $display($stime,,,"%m assert passed\n"); 
			else $error($stime,,,"%m assert failed\n");
			Zero_Huge : assert(~(status[0] && status[4]))// $display($stime,,,"%m assert passed\n"); 
			else $error($stime,,,"%m assert failed\n");
			Inf_Tiny : assert(~(status[1] && status[3]))// $display($stime,,,"%m assert passed\n"); 
			else $error($stime,,,"%m assert failed\n");
			NaN_Tiny : assert(~(status[2] && status[3]))// $display($stime,,,"%m assert passed\n"); 
			else $error($stime,,,"%m assert failed\n");
			Huge_Tiny : assert(~(status[3] && status[4]))// $display($stime,,,"%m assert passed\n"); 
			else $error($stime,,,"%m assert failed\n");
		end
	end
endmodule
