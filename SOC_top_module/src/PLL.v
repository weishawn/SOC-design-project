// ========================================
// pll.v - Behavioral Phase lock looped model (simulation for xtal)
// ========================================
module pll #(
    parameter MULT = 4,        // Multiply input clock
    parameter LOCK_DELAY = 10  // Cycles to lock
)(
    input  wire clk_in,
    input  wire reset_n,
    output reg  clk_out,
    output reg  locked
);

    reg [3:0] lock_counter;

    initial begin
        clk_out = 0;
        locked = 0;
        lock_counter = 0;
    end

    // Simulate PLL locking
    // when reset_n =0, activelow
    always @(posedge clk_in or negedge reset_n) begin
        if (!reset_n) begin
            lock_counter <= 0;
            locked <= 0;
        //If below 10 loop, add 1 to the loop counter
        end else if (lock_counter < LOCK_DELAY) begin
            lock_counter <= lock_counter + 1;
            locked <= 0;
        end else begin
            locked <= 1;
        end
    end

    // Simulate multiplied output clock
    reg [3:0] clk_div_counter;
    always @(posedge clk_in or negedge reset_n) begin
        if (!reset_n) begin
            clk_div_counter <= 0;
            clk_out <= 0;
        end else if (locked) begin
            clk_div_counter <= clk_div_counter + 1;
            if (clk_div_counter >= (MULT/2 - 1)) begin
                clk_out <= ~clk_out;
                clk_div_counter <= 0;
            end
        end
    end

endmodule
