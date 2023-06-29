`include "multiplication.sv"
typedef enum {IEEE_near, IEEE_zero, IEEE_pinf, IEEE_ninf, near_up, away_zero} round_values;

module fp_mult_tb;
	timeunit 1ns ;
	timeprecision 1ps ;
	logic [31:0] a_tb , b_tb ;
	logic [31:0] z_tb ;
	logic [7:0] status_tb ;
	logic clk_tb ;
	logic rst_n_tb ;
	logic [31:0] z_function_tb ;
	round_values round_tb = IEEE_near ;
	
	logic overflow;
	logic underflow;
	logic [9:0] round_exponent ;
	
	always #10 clk_tb = ~clk_tb ;
	
	fp_mult_top #(IEEE_near) fp_mult_top_tb (.clk(clk_tb) , .rst(rst_n_tb) , .a(a_tb) , .b(b_tb) , .z(z_tb) , .status(status_tb) ,
  .z_function_out(z_function_tb), .overflow(overflow) , .underflow(underflow) , .round_exponent(round_exponent)) ;
	
	initial
	begin
		rst_n_tb = 1 ;
		a_tb = '0 ;
		b_tb = '0 ;
		clk_tb = 1 ;
		#10
		rst_n_tb = 0 ;
		#10
		for(int i = 0 ; i <10000 ; i++ )
		begin
			#20
			a_tb = $urandom() ;
			b_tb = $urandom() ;
			if(z_function_tb != z_tb)
				$display($stime,,,);
		end
		$stop ;
	end
endmodule
