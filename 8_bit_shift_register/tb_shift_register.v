`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals
    reg        clk;
    reg        reset;
    reg        load;
    reg        shift_en;
    reg        serial_in;
    reg [7:0]  parallel_in;
    wire [7:0] q;
    wire       serial_out;

    // Instantiate DUT (Device Under Test)
    shift_register DUT (
        .clk(clk),
        .reset(reset),
        .load(load),
        .parallel_in(parallel_in),
        .shift_en(shift_en),
        .serial_in(serial_in),
        .q(q),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Dump waveform for GTKWave
        $dumpfile("shift_register.vcd");
        $dumpvars(0, shift_register_tb);

        // Monitor output signals
        $monitor("Time=%0t | q=%b | serial_out=%b", $time, q, serial_out);

        // Initialize signals
        clk = 0;
        reset = 0;
        load = 0;
        shift_en = 0;
        serial_in = 0;
        parallel_in = 8'h00;

        // 1) Apply reset
        #10 reset = 1;
        #10 reset = 0;

        // 2) Parallel load
        parallel_in = 8'b1011_0101;
        load = 1;
        #10 load = 0;

        // 3) Shift right 4 times, feeding in serial_in = 1
        shift_en = 1;
        serial_in = 1;
        #40 shift_en = 0;

        // 4) Finish simulation
        #20;
        $finish;
    end

endmodule
