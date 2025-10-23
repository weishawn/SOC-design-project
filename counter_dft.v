module counter_dft (
    input wire clk,          // system clock
    input wire reset,        // synchronous reset
    input wire scan_in,      // scan input
    input wire scan_enable,  // enable scan shift
    input wire bist_enable,  // enable BIST mode
    output reg [3:0] q,      // 4-bit counter output
    output wire scan_out     // scan output
);

    reg [3:0] lfsr;          // simple 4-bit LFSR for BIST

    // LFSR for BIST (example: x^4 + x^3 + 1)
    always @(posedge clk) begin
        if (reset)
            lfsr <= 4'b0001;
        else if (bist_enable)
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]}; // LFSR shift
    end

    // Main counter with scan and BIST
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (scan_enable)
            q <= {q[2:0], scan_in};      // scan shift mode
        else if (bist_enable)
            q <= lfsr;                  // BIST mode
        else
            q <= q + 1;                 // normal counting
    end

    assign scan_out = q[0];   // connect LSB to scan chain output

endmodule
