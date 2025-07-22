import round_enum_pkg::*;

module fp_mult_top (clk, rst, a, b, round, z, status, z_function_out);
	input logic [31:0] a, b;  // Floating-Point numbers
	input round_values round;
	output logic [31:0] z;    // a * b
   	output logic [7:0] status;  // Status Flags 
	input logic clk, rst; 
	output logic [31:0] z_function_out ; //my output to check if given function result matches my result
	//
	logic [31:0] a1, b1;  // Floating-Point numbers
	logic [31:0] z1;    // a ± b
	logic [7:0] status1;  // Status Flags 
	round_values round1;
	logic [31:0] z_function ; //given function result

	fp_mult multiplier(a1,b1,round,z1,status1); //multiplier instatiation

	always @(posedge clk)
		if (rst == 1)
		begin 
				a1 <= '0;
				b1 <= '0;
				round1<= IEEE_near;
				z <= '0;
				status <= '0;
			z_function_out <= '0 ;
		end
		else
		begin
				a1 <= a;
				b1 <= b;
				round1 <= round;
				z <= z1;
				status <= status1;
			z_function_out <= multiplication(round.name , a1 , b1) ; //round.name returns a string with the name of enum round. fucntion takes input for round modes a string 
		end

endmodule