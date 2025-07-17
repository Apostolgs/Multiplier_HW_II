
module normalize_mult(mantissa_product, exponent , sticky , guard , norm_exponent , norm_mantissa) ;
	
	input logic [47:0] mantissa_product ;
	input logic [9:0] exponent ; //10 bit after addition of exponent and substraction of bias
	output logic sticky ;
	output logic guard ;
	output logic [9:0] norm_exponent ; //norm exponent is either exponent of exponent + 1
	output logic [22:0] norm_mantissa ; //norm mantissa is either mantissa_product[45:23] or mantissa_product[46:24]
	
	always_comb
	begin
		case(mantissa_product[47]) //mantissa_porduct MSB determines the output of all MUX in module
		1'b0 : 
		begin
			sticky = |mantissa_product[21:0] ; // sticky is the reduced or of the first 21 or 2 bits of mantissa_product depending on mantissa_product MSB
			guard = mantissa_product[22] ;
			norm_exponent = exponent ;
			norm_mantissa = mantissa_product[45:23] ;
		end
		1'b1 : 
		begin
			sticky = |mantissa_product[22:0] ; // sticky is the reduced or of the first 21 or 2 bits of mantissa_product depending on mantissa_product MSB
			guard = mantissa_product[23] ;
			norm_exponent = exponent + 1 ;
			norm_mantissa = mantissa_product[46:24] ;
		end
	endcase
	end
endmodule