typedef enum {IEEE_near, IEEE_zero, IEEE_pinf, IEEE_ninf, near_up, away_zero} round_values;

module round_mult #(parameter round_values round = IEEE_near)(norm_exponent , norm_mantissa , guard , sticky , sign , rounding_result , round_exponent) ;
	input logic [9:0] norm_exponent ;
	input logic [23:0] norm_mantissa ; //23 bits + leading 1
	input logic guard ;
	input logic sticky ;
	input logic sign ;
	output logic [25:0] rounding_result ; // 26 bits, with MSB = inexact , and 25 bits for overflow 
	output logic [9:0] round_exponent ;
	//my declarations
	
	
	always_comb
	begin
		rounding_result[25] = ~(guard | sticky) ; //rounding_result[25] is the inexact bit ive combined all outputs of rounding module into a 26 bit bus , exact = 1 , inexact = 0
		rounding_result[24:0] = {1'b0,norm_mantissa} ;
		if (~rounding_result[25]) //inexact
			begin 
				case(round)
				IEEE_near : 
				begin
					case({guard,sticky})
						//2'b00: ;
						//2'b01: ;
						2'b10: 
							if (norm_mantissa[0] == 1'b0) //even
								;
							else //odd
								rounding_result = rounding_result + 1;
							2'b11: rounding_result = rounding_result + 1 ;
						default: ;
					endcase	
				end
				IEEE_zero : 
				begin
					;
				end
				IEEE_pinf : 
				begin
					if(sign) //negative
						;
					else //positive
						rounding_result = rounding_result + 1;
				end
				IEEE_ninf : 
				begin
					if(sign) //negative
						rounding_result = rounding_result + 1 ;
					else //positive
						;
				end
				near_up : 
				begin
					if(sign) //negative
						case({guard,sticky})
							//2'b00: ;
							//2'b01: ;
							//2'b10: ;
							2'b11: rounding_result = rounding_result + 1 ;
							default: ;
						endcase			
					else //positive
						case({guard,sticky})
							//2'b00: ;
							//2'b01: ;
							2'b10: rounding_result = rounding_result + 1 ;
							2'b11: rounding_result = rounding_result + 1 ;
							default: ;
						endcase
				end
				away_zero : 
				begin
					rounding_result = rounding_result + 1 ;
				end
				default : //we set default case to do the same as IEEE_near

					case({guard,sticky})
						//2'b00: ;
						//2'b01: ;
						2'b10: 
							if (norm_mantissa[0] + 1) //odd
								;
							else //even
								rounding_result = rounding_result + 1;
						2'b11: rounding_result = rounding_result + 1 ;
						default: ;
					endcase
				endcase
			if (rounding_result[24] == 1) //round normalized exponent based on rounded mantissa 
				begin
					rounding_result = rounding_result >> 1 ;
					round_exponent = norm_exponent + 1 ;
				end
			else 
				round_exponent = norm_exponent ;
			end
		else
			begin
				round_exponent = norm_exponent ;
			end
	end
endmodule