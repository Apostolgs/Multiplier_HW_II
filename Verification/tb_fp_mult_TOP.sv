module tb_fp_mult_TOP;
    import round_enum_pkg::*;
    import uvm_pkg::*;
    logic clk;
    initial clk = 0;
    always #5 clk = ~clk;

    fp_mult_if vif(clk);

    fp_mult_top dut (
        .clk(clk),
        .rst(vif.rst),
        .a(vif.a),
        .b(vif.b),
        .round(vif.round),
        .z(vif.z),
        .status(vif.status),
        .z_function_out(vif.z_function_out)
    );

    initial begin
        begin
            uvm_config_db#(virtual fp_mult_if)::set(null, "*", "vif", vif);
            run_test("fp_mult_test");
        end
    end
endmodule
