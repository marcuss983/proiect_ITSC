module memory (
    input clk,
    input [15:0] addr,
    input [15:0] data_in,
    input mem_write,
    output reg [15:0] data_out
);
    reg [15:0] mem [0:255];
    integer i;

    initial begin
        for(i=0; i<256; i=i+1) mem[i] = 0;
    end

    always @(posedge clk) begin
        if(mem_write) mem[addr[7:0]] <= data_in;
    end

    always @* data_out = mem[addr[7:0]];
endmodule