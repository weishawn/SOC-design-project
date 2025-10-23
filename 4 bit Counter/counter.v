// counter.v
module counter (
    input wire clk,      // clock
    input wire reset,    // synchronous reset
    output reg [3:0] q   // 4-bit output
);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;    // reset to 0
    else
        q <= q + 1;      // increment
end

endmodule
