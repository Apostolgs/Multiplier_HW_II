`include "multiplication.sv"

//This module is given for the exercises
typedef enum {IEEE_near, IEEE_zero, IEEE_pinf, IEEE_ninf, near_up, away_zero} round_values;
module fp_mult_top #(parameter round_values round = away_zero)(
     clk, rst, a, b, z, status, z_function_out /*new stuff i add for troubleshoot ->*/ , overflow , underflow , round_exponent
);

	input logic [31:0] a, b;  // Floating-Point numbers
    	output logic [31:0] z;    // a ± b
   	output logic [7:0] status;  // Status Flags 
    	input logic clk, rst; 
    	output logic [31:0] z_function_out ;
	output logic overflow ;
	output logic underflow ;
	output logic [9:0] round_exponent ;
    
    	logic [31:0] a1, b1;  // Floating-Point numbers
    	logic [31:0] z1;    // a ± b
    	logic [7:0] status1;  // Status Flags 
    	logic [31:0] z_function ; //given function result
	logic sticky1 ;
	logic guard1 ;
	logic underflow1 ;
	logic overflow1 ;
	logic [9:0] round_exponent1 ;
    
    	fp_mult #(round) multiplier(a1,b1,z1,status1 , overflow1 , underflow1 , round_exponent1);

    	always @(posedge clk)
       		if (rst == 1)
          	begin 
             		a1 <= '0;
             		b1 <= '0;
             		z <= '0;
            		status <= '0;
	     		z_function_out <= '0 ;
			//
			overflow <= 0;
			underflow <= 0;
			round_exponent <= '0 ;
          	end
       		else
          	begin
             		a1 <= a;
             		b1 <= b;
             		z <= z1;
             		status <= status1;
	     		z_function_out <= multiplication("IEEE_near" , a1 , b1) ;
			//
			overflow <= overflow1 ;
			underflow <= underflow1 ;
			round_exponent <= round_exponent1 ;
          	end

endmodule