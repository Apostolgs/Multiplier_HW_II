`include "uvm_macros.svh"
import uvm_pkg::*;
import round_enum_pkg::*;

class fp_mult_transaction extends uvm_sequence_item;
    
    bit [31:0] z;
    bit [7:0] status;
    bit [31:0] z_function_out;

    rand round_values round;
    rand bit rst;
    constraint c_rst {rst dist {0:= 1, 1:=9};}

    rand bit [31:0] a, b;
    
    rand bit [31:0] a_pos_denorm, b_pos_denorm;
    constraint denorm {
        a_pos_denorm inside {[32'h00000001:32'h007FFFFF]};
        b_pos_denorm inside {[32'h00000001:32'h007FFFFF]};
    }

    rand bit [31:0] a_neg_denorm, b_neg_denorm;
    constraint denorm {
        a_neg_denorm inside {[32'h80000001:32'h807FFFFF]};
        b_neg_denorm inside {[32'h80000001:32'h807FFFFF]};
    }

    `uvm_object_utils(fp_mult_transaction)

    function new(string name = "fp_mult_transaction");
        super.new(name);
    endfunction

    

endclass