module shift_register (

    input wire clk,
    input wire reset, //active high reset
    input wire load, //when high, load all 8 bits parellely
    input wire [7:0] parallel_in, //8 bit data to laod
    input wire shift_en, // shift right on every clock when high
    input wire serial_in,
    output wire [7:0] q,
    output wire serial_out
);

    reg[7:0] reg_sh;
    assign q = reg_sh;
    assign serial_out = reg_sh[0];

 // Sequential behavior: synchronous reset, parallel load priority over shift
    always @(posedge clk) begin
        if (reset) begin
            reg_sh <= {8{1'b0}};
        end else if (load) begin
            reg_sh <= parallel_in;
        end else if (shift_en) begin
            // Right shift: MSB gets serial_in, rest shift towards LSB
            reg_sh <= {serial_in, reg_sh[7:1]};
        end
        // else hold current value
    end

endmodule