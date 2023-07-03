`include "multiplication.sv"

//This module is given for the exercises
typedef enum {IEEE_near, IEEE_zero, IEEE_pinf, IEEE_ninf, near_up, away_zero} round_values;
module fp_mult_top #(parameter round_values round = IEEE_near)(
     clk, rst, a, b, z, status, z_function_out /*new stuff i add for troubleshoot ->*/ , sticky , guard
);

	input logic [31:0] a, b;  // Floating-Point numbers
    	output logic [31:0] z;    // a ± b
   	output logic [7:0] status;  // Status Flags 
    	input logic clk, rst; 
    	output logic [31:0] z_function_out ;
	output logic sticky ;
	output logic guard ;

    
    	logic [31:0] a1, b1;  // Floating-Point numbers
    	logic [31:0] z1;    // a ± b
    	logic [7:0] status1;  // Status Flags 
    	logic [31:0] z_function ; //given function result
	logic sticky1 ;
	logic guard1 ;

    
    	fp_mult #(round) multiplier(a1,b1,z1,status1, sticky1 , guard1);

    	always @(posedge clk)
       		if (rst == 1)
          	begin 
             		a1 <= '0;
             		b1 <= '0;
             		z <= '0;
            		status <= '0;
	     		z_function_out <= '0 ;
			//
			sticky <= 0 ;
			guard <= 0 ;
          	end
       		else
          	begin
             		a1 <= a;
             		b1 <= b;
             		z <= z1;
             		status <= status1;
	     		z_function_out <= multiplication(round.name , a1 , b1) ;
			//
			sticky <= sticky1 ;
			guard <= guard1 ;
          	end

endmodule