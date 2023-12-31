typedef enum {IEEE_near, IEEE_zero, IEEE_pinf, IEEE_ninf, near_up, away_zero} round_values;

module exception_mult #(parameter round_values round = IEEE_near) (a , b , z_calc , overflow , underflow , inexact , z , zero_f, inf_f, nan_f, tiny_f, huge_f, inexact_f) ;
	input logic [31:0] a ;
	input logic [31:0] b ;
	input logic [31:0] z_calc ;
	input logic overflow ;
	input logic underflow ;
	input logic inexact ;
	output logic [31:0] z ;
	//status bits
	output logic zero_f = 0 ;
	output logic inf_f = 0 ;
	output logic nan_f = 0 ;
	output logic tiny_f = 0 ;
	output logic huge_f = 0 ;
	output logic inexact_f ;
	// my declarations
	typedef enum {ZERO , INF , NORM , MIN_NORM , MAX_NORM} interp_t ;
	logic [30:0] placeholder_string = "placeholder_string" ;
	interp_t a_num_interp ;
	interp_t b_num_interp ;
	interp_t z_num_interp ;
	

	
	function automatic interp_t num_interp (logic [31:0] num_interp_in) ; //numeric interpretation , what more as inputs ?
		begin 
			if (num_interp_in[30:0] == 0) //Zero
				return ZERO ;
			else if (num_interp_in[30:23] == 8'hFF && |num_interp_in[22:0] == 0) // INF
				return INF ;
			else if (num_interp_in[30:23] == 8'hFF && |num_interp_in[22:0] == 1) //NAN
				return INF ;
			else if (num_interp_in[30:23] == 0 && |num_interp_in[22:0] == 1) //Denorm
				return ZERO ;
			else return NORM ;
		end
	endfunction
	
	function automatic logic [30:0] z_num (interp_t interp_z_num) ; //returns 31 unsigned result
		begin
			case(interp_z_num)
				ZERO : 
					return '0; //zeroes
				INF :
					return {8'hFF , 23'b0} ; //+-infinity
				MIN_NORM :
					return {8'h01 , 23'b0} ; //min_norm has exponent = 1 , and significant = 0
				MAX_NORM :
					return {8'hFE , 23'h7FFFFF} ; //max norm has exponent = FE and significant all bits = 1
			endcase
		end
	endfunction
	
	always_comb
		begin	
			//interpet what numbers a , b , z are , then build cases based on interpetation
			a_num_interp = num_interp(a) ;
			b_num_interp = num_interp(b) ;
			z_num_interp = num_interp(z_calc) ;
			//initialize status bits
			zero_f = 0 ;
			inf_f = 0 ;
			nan_f = 0 ; 
			tiny_f = 0 ;
			huge_f = 0 ;
			inexact_f = inexact ;

			//changed here
			
			//cases build based on Table V. page 15 of coursework description
			case (a_num_interp) 
				ZERO : 
					begin
						case(b_num_interp)
							ZERO : //+-zero
								begin
									z = {z_calc[31],z_num(ZERO)} ;
									zero_f = 1 ;
								end
							INF : //+inf
								begin
									z = {1'b0, z_num(INF)} ;
									inf_f = 1 ;
									nan_f = 1 ;
									inexact_f = 0 ;
								end
							NORM : //+-zero
								begin
									z = {z_calc[31],z_num(ZERO)} ;
									zero_f = 1 ;
								end
						endcase
					end
				INF :
					begin
						case(b_num_interp)
							ZERO : // +inf
								begin
									z = {1'b0, z_num(INF)} ;
									inf_f = 1 ;
									nan_f = 1 ;
									inexact_f = 0 ;
								end
							INF : //+- inf
								begin
									z = {z_calc[31], z_num(INF)} ;
									inf_f = 1 ;
								end
							NORM : //+- inf
								begin
									z = {z_calc[31], z_num(INF)} ;
									inf_f = 1 ;
								end
						endcase
					end
				NORM :
					begin
						case(b_num_interp)
							ZERO : //+- zero
								begin
									z = {z_calc[31],z_num(ZERO)} ;
									zero_f = 1 ;
								end

							INF : //+- inf
								begin
									z = {z_calc[31], z_num(INF)} ;
									inf_f = 1 ;
								end
							NORM : 
								begin
									if (overflow) //max_norm or inf based on sign and round param
										begin
											case(round)
												IEEE_near: //inf
													begin
														z = {z_calc[31],z_num(INF)} ;
														inf_f = 1 ;
														huge_f = 1 ;
													end
												IEEE_zero: //max_norm
													begin
															z = {z_calc[31],z_num(MAX_NORM)} ; 
															huge_f = 1 ;		
													end
												IEEE_pinf: //+inf if sign (+) , -max_norm if sign(-)
													if (z_calc[31]) 
													begin
														z = {z_calc[31],z_num(MAX_NORM)} ;
														huge_f = 1 ;
													end
													else 
													begin
														z = {z_calc[31],z_num(INF)} ;	
														inf_f = 1 ;
														huge_f = 1 ;
													end												
												IEEE_ninf: //-inf if sign (-) , +max_norm if sign(+)
													if (z_calc[31]) 
													begin
														z = {z_calc[31],z_num(INF)} ;
														inf_f = 1 ;	
														huge_f = 1 ;
													end
													else 
													begin
														z = {z_calc[31],z_num(MAX_NORM)} ;
														huge_f = 1 ;
													end
												near_up: //inf
													begin
														z = {z_calc[31],z_num(INF)} ;
														inf_f = 1 ;
														huge_f = 1 ;
													end
												away_zero: //inf
													begin
														z = {z_calc[31],z_num(INF)} ;
														inf_f = 1 ;	
														huge_f = 1 ;
													end
											endcase
										end
									else if (underflow) // min norm or 0 based on sign and round param
										begin
											case(round)
												IEEE_near: //zero
													begin
														z = {z_calc[31],z_num(ZERO)};
														zero_f = 1 ;
														tiny_f = 1 ;
													end
												IEEE_zero: //zero
													begin
														z = {z_calc[31],z_num(ZERO)} ; 
														zero_f = 1 ;
														tiny_f = 1 ;
													end
												IEEE_pinf: //min_norm if + , zero if -
													if (z_calc[31]) 
													begin
														z = {z_calc[31],z_num(ZERO)} ;
														zero_f = 1 ;
														tiny_f = 1 ;
													end
													else 
													begin
														z = {z_calc[31],z_num(MIN_NORM)} ;	
														tiny_f = 1 ;
													end
												IEEE_ninf: //min_norm if - , zero if +
													if (z_calc[31]) 
													begin
														z = {z_calc[31],z_num(MIN_NORM)} ;
														tiny_f = 1 ;
													end
													else 
													begin
														z = {z_calc[31],z_num(ZERO)} ;	
														zero_f = 1 ;
														tiny_f = 1 ;
													end
												near_up: //min_norm
													begin
														z = {z_calc[31],z_num(ZERO)} ;
														zero_f = 1 ;
														tiny_f = 1 ;
													end
												away_zero: //min_norm
													begin
													z = {z_calc[31],z_num(MIN_NORM)} ;
													tiny_f = 1 ;
													end
											endcase											
										end
									else // NORM x NORM
										begin
											if (z_num_interp == ZERO) //based on interpetation of z , and rounding mode . if we interpet result as ZERO meaning its either zero or denorm
											begin // we get the following based on round
												case(round) 
												IEEE_near : 
													begin
														z = {z_calc[31],z_num(ZERO)} ;
														zero_f = 1 ;
														if(|z_calc[22:0]) 
															tiny_f = 1;
														else
															tiny_f = 0;
													end
												IEEE_zero : 
													begin
														z = {z_calc[31],z_num(ZERO)} ;
														zero_f = 1 ;
														if(|z_calc[22:0]) 
															tiny_f = 1;
														else
															tiny_f = 0;
													end
												IEEE_pinf : 
													if (z_calc[31]) 
													begin
														z = {z_calc[31],z_num(ZERO)} ;
														zero_f = 1 ;
														if(|z_calc[22:0]) 
															tiny_f = 1;
														else
															tiny_f = 0;
													end
													else 
													begin
														z = {z_calc[31],z_num(MIN_NORM)} ;	
														tiny_f = 1 ;
													end
												IEEE_ninf : 
													if (~z_calc[31]) 
													begin
														z = {z_calc[31],z_num(ZERO)} ;
														zero_f = 1 ;
														if(|z_calc[22:0]) 
															tiny_f = 1;
														else
															tiny_f = 0;
													end
													else 
													begin
														z = {z_calc[31],z_num(MIN_NORM)} ;	
														tiny_f = 1 ;
													end
												near_up : 
													begin
														z = {z_calc[31],z_num(ZERO)} ;
														zero_f = 1 ;
														if(|z_calc[22:0]) 
															tiny_f = 1;
														else
															tiny_f = 0;
														
													end
												away_zero : 
													begin
														z = {z_calc[31],z_num(MIN_NORM)} ;	
														tiny_f = 1 ;
													end
												endcase
											end
											else if (z_num_interp == INF) //if we interpet z = inf meaning its either inf or NAN we get the following
											begin
												z = {z_calc[31] , z_num(INF)} ;
												huge_f = 1 ;
												inf_f = 1 ;
											end
											else
											begin
												z = z_calc ; //if we dont interpet z as anything , it means its norm so we proceed with our result
												inexact_f = inexact ;
											end
										end
								end
						endcase
					end
			endcase 
		end

endmodule




