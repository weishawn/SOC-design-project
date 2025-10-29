// ========================================
// clock_gen.v - System clock generation
// ========================================
module clock_gen #(
    parameter DIV = 2
)(
    input  wire pll_clk,
    input  wire reset_n,
    output reg  sys_clk,
    output wire reset_sync
);

    // Clock divider
    reg [7:0] div_counter;
    //System clock held low until reset ends
    always @(posedge pll_clk or negedge reset_n) begin
        if (!reset_n) begin
            div_counter <= 0;
            sys_clk <= 0;
        //Increment the counter by 1 on every PLL clock rising edge.
        end else begin
            div_counter <= div_counter + 1;
            if (div_counter >= (DIV-1)) begin
                sys_clk <= ~sys_clk;
                div_counter <= 0;
            end
        end
    end

    // Reset synchronizer
    reg [1:0] reset_ff;
    always @(posedge sys_clk or negedge reset_n) begin
        if (!reset_n)
            reset_ff <= 2'b11;
        else
            reset_ff <= {reset_ff[0], 1'b0};
    end

    assign reset_sync = reset_ff[1];

endmodule
