
module test_status_z_combinations(pclk , prst_n , pa , pb , pz , pstatus);
	input logic pclk ;
	input logic prst_n ;	
	input logic [31:0] pa ;
	input logic [31:0] pb ;
	input logic [31:0] pz ;
	input logic [7:0] pstatus ; 

	
	
	//sequences	
	
	sequence zero ; // If the ?zero? status bit asserts to 1 then at the same cycle all the bits of the exponent of ?z? must be equal to 0.
		pz[30:23] == 8'h00 ; 	
	endsequence

	sequence inf ; //If the ?inf? status bit asserts to 1 then at the same cycle all the bits of the exponent of ?z? must be equal to 1.
		pz[30:23] == 8'hFF ; 	
	endsequence

	sequence nan(logic [31:0] X_0s , logic [31:0] Y_1s) ; //If the ?nan? status bit asserts to 1 then 2 cycles before all the bits of the exponent of ?a? must be equal to 0 and the bits of the exponent of ?b? must be equal to 1 or the opposite.
		(X_0s[30:23] == 0) && (Y_1s[30:23] == 1) ;
	endsequence

	sequence huge ; //If the ?huge? status bit asserts to 1 then at the same cycle all the bits of the exponent of ?z? must be equal to 1, or the maxNormal case is encountered.
		inf or (pz[30:0] == {8'hFE , 23'h7FFFFF}) ; 	
	endsequence

	sequence tiny ; //If the ?tiny? status bit asserts to 1 then at the same cycle all the bits of the exponent of ?z? must be equal to 0, or the minNormal case is encountered.
		zero or (pz[30:0] == {8'h01 , 23'b0}) ; 	
	endsequence
	
	// status = {1'b0  , 1'b0 , inexact_f , huge_f , tiny_f , nan_f , inf_f , zero_f} ;
	//		7	6	5	  4	    3	    2 	    1	    0	

	
	//properties
	
	property check_zero ;
		@(posedge pclk) disable iff (prst_n) pstatus[0] |-> zero ;
	endproperty

	property check_inf ;
		@(posedge pclk) disable iff (prst_n) pstatus[1] |-> inf ;
	endproperty

	property check_nan ;
		@(posedge pclk) disable iff (prst_n) pstatus[2] |-> nan($past(pa,2),$past(pb,2)) or nan($past(pb,2),$past(pa,2)) ; 
	endproperty

	property check_huge ;
		@(posedge pclk) disable iff (prst_n) pstatus[4] |-> huge ;
	endproperty

	property check_tiny ;
		@(posedge pclk) disable iff (prst_n) pstatus[3] |-> tiny ;
	endproperty	
	
	//assertions
	
	check_ZERO_fail : assert property (check_zero) else $display($time,,,"ZERO_FAIL") ;

	check_INF : assert property (check_inf) else $display($time,,,"INF_FAIL") ;

	check_NAN : assert property (check_nan) else $display($time,,,"NAN_FAIL") ;

	check_HUGE : assert property (check_huge) else $display($time,,,"HUGE_FAIL") ;

	check_TINY : assert property (check_tiny) else $display($time,,,"TINY_FAIL") ;
	
	

endmodule 
