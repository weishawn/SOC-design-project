// ========================================
// memory.v - Dual-Port SRAM (Instruction + Data)
// Port A - read
// Port B - read and write
// ========================================
module memory #(
    parameter ADDR_WIDTH = 10,   // 2^10 = 1024 locations
    parameter DATA_WIDTH = 32   // 32bits wide word for typical CPU instruction or integer
    parameter MEM_INIT_FILE = "" // Optional HEX file
)(
    input  wire                  clk,       //connected to sys_clk from PLL
    input  wire                  reset_n,   //active low reset

    // === Instruction Port (Read Only) ===
    input  wire [ADDR_WIDTH-1:0] instr_addr,       //address to fetch data
    output reg  [DATA_WIDTH-1:0] instr_data,       //data at that address

    // === Data Port (Read/Write) ===
    input  wire [ADDR_WIDTH-1:0] data_addr,     //address of momory to read/write
    input  wire [DATA_WIDTH-1:0] write_data,    //data to write in to memory
    input  wire                  mem_read,      //enable reading
    input  wire                  mem_write,     //enable writing
    output reg  [DATA_WIDTH-1:0] read_data      //data read from memory
);

    // Memory array
    // mem_array[0] = word 0
    // mem_array[1] = word 1
    // ...
    // mem_array[1023] = word 1023

    reg [DATA_WIDTH-1:0] mem_array [0:(1<<ADDR_WIDTH)-1];

    integer i;

        // ===============================
    //  Memory Initialization
    // ===============================
    initial begin
        // If a HEX file is specified, load it
        if (MEM_INIT_FILE != "") begin
            $display("Loading memory contents from %s ...", MEM_INIT_FILE);
            $readmemh(MEM_INIT_FILE, mem_array);
        end else begin
            // Otherwise, initialize to zeros (for clean sim)
            for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1)
                mem_array[i] = 0;
        end
    end

    // Optional reset initialization
    always @(negedge reset_n) begin
        for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1)
            mem_array[i] <= 0;
    end

    // === Port A: Instruction Fetch ===
    always @(posedge clk) begin
        instr_data <= mem_array[instr_addr];
    end

    // === Port B: Data Read/Write ===
    always @(posedge clk) begin
        if (mem_write)
            mem_array[data_addr] <= write_data;
        if (mem_read)
            read_data <= mem_array[data_addr];
    end

endmodule
