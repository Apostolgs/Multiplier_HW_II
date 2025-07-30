`include "uvm_macros.svh"
import uvm_pkg::*;

class fp_mult_test extends uvm_test;
    `uvm_component_utils(fp_mult_test)

    fp_mult_env env;

    function new(string name = "fp_mult_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fp_mult_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        begin
            fp_mult_sequence seq;
            seq = fp_mult_sequence::type_id::create("seq");
            phase.raise_objection(this);
            seq.start(env.sequencer);
            phase.drop_objection(this);
        end
    endtask
endclass
