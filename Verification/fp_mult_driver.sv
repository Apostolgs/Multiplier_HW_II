import uvm_pkg::*;
import round_enum_pkg::*;

class fp_mult_driver extends uvm_driver #(fp_mult_transaction);
    virtual fp_mult_if vif;

    `uvm_component_utils(fp_mult_driver)

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db #(virtual fp_mult_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "No virtual interface")
    endfunction

    task run_phase(uvm_phase phase);
        fp_mult_transaction tr;
        forever begin
            seq_item_port.get_next_item(tr);

            // apply stimulus
            vif.a <= tr.a;
            vif.b <= tr.b;
            vif.round <= tr.round;

            @(posedge vif.clk);  // one cycle delay for DUT to register inputs

            seq_item_port.item_done();
        end
    endtask

    function new(string name = "fp_mult_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass