`timescale 1ns/1ps
module counter_dft_tb;

    reg clk;
    reg reset;
    reg scan_in;
    reg scan_enable;
    reg bist_enable;
    wire [3:0] q;
    wire scan_out;

    // Instantiate DUT
    counter_dft uut (
        .clk(clk),
        .reset(reset),
        .scan_in(scan_in),
        .scan_enable(scan_enable),
        .bist_enable(bist_enable),
        .q(q),
        .scan_out(scan_out)
    );

    // Clock generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("counter_dft.vcd");
        $dumpvars(0, counter_dft_tb);

        // Initialize signals
        clk = 0;
        reset = 1;
        scan_in = 0;
        scan_enable = 0;
        bist_enable = 0;

        // Release reset
        #10 reset = 0;

        // Normal counting for 50 ns
        #50;

        // Activate scan mode and shift in a pattern
        scan_enable = 1;
        scan_in = 1;  #10;
        scan_in = 0;  #30;
        scan_enable = 0;

        // Activate BIST mode
        bist_enable = 1;
        #50 bist_enable = 0;

        $finish;
    end

endmodule
