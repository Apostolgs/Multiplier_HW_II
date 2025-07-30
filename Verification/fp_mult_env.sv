`include "uvm_macros.svh"
import uvm_pkg::*;

class fp_mult_env extends uvm_env;
    `uvm_component_utils(fp_mult_env)

    uvm_sequencer #(fp_mult_transaction) sequencer;
    fp_mult_driver driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        
        sequencer = uvm_sequencer #(fp_mult_transaction)::type_id::create("sequencer", this);
        driver    = fp_mult_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass
