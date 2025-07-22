module fp_mult_tb;
	logic rst_n_tb ;
	logic clk_tb ;
	logic [31:0] a_tb , b_tb ;
	logic [31:0] z_tb ;
	logic [31:0] z_function_tb ;
	import round_enum_pkg::*;
	round_values round_tb;
	logic [7:0] status_tb;
	

	fp_mult_top fp_mult_top_tb (.clk(clk_tb), .rst(rst_n_tb), .a(a_tb), .b(b_tb), .round(round_tb), .z(z_tb), .status(status_tb), .z_function_out(z_function_tb)) ;

	always #5 clk_tb = ~clk_tb;

	initial
	begin
		rst_n_tb = 1 ;
		a_tb = '0 ;
		b_tb = '0 ;
		clk_tb = 1'b0;
		#10
		rst_n_tb = 1'b0 ;
		#10
		#10
		a_tb = $random();
		b_tb = $random();
		#10
		a_tb = $random();
		b_tb = $random();
		#10
		a_tb = $random();
		b_tb = $random();
		#10
		a_tb = $random();
		b_tb = $random();
		#10
		a_tb = $random();
		b_tb = $random();
		#10
		a_tb = $random();
		b_tb = $random();
		#10
		$stop ;
	end
endmodule
