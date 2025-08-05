`include "uvm_macros.svh"
import uvm_pkg::*;

class fp_mult_sequence extends uvm_sequence #(fp_mult_transaction);
    `uvm_object_utils(fp_mult_sequence)

    function new(string name = "fp_mult_sequence");
        super.new(name);
    endfunction

    task body();
        fp_mult_transaction tr;
        // Example: Run 10 random transactions
        repeat (1000) begin
            tr = fp_mult_transaction::type_id::create("tr");
            assert(tr.randomize());
            if (tr.rst = 1'b0) //DUT reset active thus not driven
                pass;
            else
                `uvm_info("SEQ", $sformatf("Driving A=%h B=%h Round=%0d", tr.a, tr.b, tr.round), UVM_LOW)
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass
