// counter_tb.v
`timescale 1ns/1ps

module counter_tb;

reg clk;
reg reset;
wire [3:0] q;

// Instantiate the DUT (Device Under Test)
counter uut (
    .clk(clk),
    .reset(reset),
    .q(q)
);

// Clock generation: toggle every 5ns (100 MHz clock)
always #5 clk = ~clk;

initial begin
    // Open VCD file for waveform dumping
    $dumpfile("dump.vcd");
    $dumpvars(0, counter_tb);

    // Initialize
    clk = 0;
    reset = 1;
    #10 reset = 0;    // deassert reset after 10ns

    // Run simulation for 200ns
    #200 $finish;
end

endmodule
