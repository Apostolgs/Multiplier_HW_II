
import uvm_pkg::*;

class fp_mult_scoreboard extends uvm_component;
    `uvm_component_utils(fp_mult_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function logic [31:0] compute_expected(bit [31:0] a, b);
        // Add a real IEEE 754 model here or use DPI-C
        return a * b;  // Simplified placeholder
    endfunction

    task check_result(fp_mult_transaction tr);
        logic [31:0] expected = compute_expected(tr.a, tr.b);
        if (tr.z !== expected)
            `uvm_error("SCOREBOARD", $sformatf("Mismatch! Expected %h, Got %h", expected, tr.z))
        else
            `uvm_info("SCOREBOARD", "Match", UVM_LOW)
    endtask
endclass