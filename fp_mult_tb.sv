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
	
	typedef struct packed {
  	logic sign;
 	logic [30:23] exponent;
  	logic [22:0] fraction;
	} ieee_single_precision;

	ieee_single_precision[9:0] myArray;

	initial 
	begin
	  	// Assigning specific values to the array elements
	  
	 	 // Negative NaN
	  	myArray[0].sign = 1'b1;
	  	myArray[0].exponent = 8'b11111111;
	  	myArray[0].fraction = 23'b10000100010000000000000;
	  
	 	// Positive NaN
	 	myArray[1].sign = 1'b0;
	  	myArray[1].exponent = 8'b11111111;
		myArray[1].fraction = 23'b10000010001010000000000;
	  
	  	// Negative Infinity
	 	myArray[2].sign = 1'b1;
	  	myArray[2].exponent = 8'b11111111;
	  	myArray[2].fraction = 23'b00000000000000000000000;
	  
	  	// Positive Infinity
	  	myArray[3].sign = 1'b0;
	  	myArray[3].exponent = 8'b11111111;
	  	myArray[3].fraction = 23'b00000000000000000000000;
	  
	  	// Negative Normal
	  	myArray[4].sign = 1'b1;
	  	myArray[4].exponent = 8'b01111110;
	  	myArray[4].fraction = 23'b01000010100000000000000;
	  
	  	// Positive Normal
	  	myArray[5].sign = 1'b0;
	  	myArray[5].exponent = 8'b01111110;
	  	myArray[5].fraction = 23'b01010100000000000000000;
	  
	  	// Negative Denormal
	  	myArray[6].sign = 1'b1;
	  	myArray[6].exponent = 8'b00000000;
	  	myArray[6].fraction = 23'b10000000000000000000000;
	  
	  	// Positive Denormal
	  	myArray[7].sign = 1'b0;
	  	myArray[7].exponent = 8'b00000000;
	  	myArray[7].fraction = 23'b10000000000000000000000;
	  
	  	// Negative Zero
	  	myArray[8].sign = 1'b1;
	  	myArray[8].exponent = 8'b00000000;
	  	myArray[8].fraction = 23'b00000000000000000000000;
	  
	  	// Positive Zero
	  	myArray[9].sign = 1'b0;
	  	myArray[9].exponent = 8'b00000000;
	  	myArray[9].fraction = 23'b00000000000000000000000;
	end

	
	always #10 clk_tb = ~clk_tb ;
	
	fp_mult_top #(IEEE_near	) fp_mult_top_tb (.clk(clk_tb) , .rst(rst_n_tb) , .a(a_tb) , .b(b_tb) , .z(z_tb) , .status(status_tb) ,
  .z_function_out(z_function_tb)) ;
	
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
				$display($time,,,);
		end
		
		for(int i = 0 ; i < 10 ; i++ )
			for(int j = 0 ; j < 10 ; j++ )
				begin
					#20
					a_tb = myArray[i] ;
					b_tb = myArray[j] ;
					if(z_function_tb != z_tb)
						$display($time,,,);
				end
		$stop ;
	end
endmodule
