`include "uvm_macros.svh"
import uvm_pkg::*;
import round_enum_pkg::*;

class fp_mult_transaction extends uvm_sequence_item;
    rand bit [31:0] a, b;
    rand round_values round;

    bit [31:0] z;
    bit [7:0] status;
    bit [31:0] z_function_out;

    `uvm_object_utils(fp_mult_transaction)

    function new(string name = "fp_mult_transaction");
        super.new(name);
    endfunction
endclass