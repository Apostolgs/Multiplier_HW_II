import round_enum_pkg::*;
interface fp_mult_if(input logic clk);
    logic rst, enable;
    logic [2:0] rnd;
    logic [7:0] status;
    round_values round;
    logic [31:0] a, b, z, z_function_out;
endinterface