module test_program;
    reg clk = 0, reset = 1;
    top_processor cpu(.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    integer i;

    initial begin
        // Init memorii (optional, ca sa fie curat)
        for (i = 0; i < 256; i = i + 1) begin
            cpu.i_mem.mem[i] = 16'h0000;
            cpu.d_mem.mem[i] = 16'h0000;
        end

        
        cpu.i_mem.mem[0] = 16'h1814; // MOV X, 20
        cpu.i_mem.mem[1] = 16'h0406; // SUB X, 6
        cpu.i_mem.mem[2] = 16'h0002; // ADD X, 2
        cpu.i_mem.mem[3] = 16'h1C02; // MUL X, 2
        cpu.i_mem.mem[4] = 16'h2004; // DIV X, 4      -> X = 8
        cpu.i_mem.mem[5]  = 16'h2403; // MOD X, 3      -> X = 2
        cpu.i_mem.mem[6]  = 16'h280F; // AND X, 15     -> X = 2
        cpu.i_mem.mem[7]  = 16'h2C10; // OR  X, 16     -> X = 18
        cpu.i_mem.mem[8]  = 16'h3007; // XOR X, 7      -> X = 21
        cpu.i_mem.mem[9]  = 16'h3400; // NOT X         -> X = ~21 (pe 16 biti)
        cpu.i_mem.mem[10] = 16'h4000; // INC X         -> X = X + 1
        cpu.i_mem.mem[11] = 16'h4400; // DEC X         -> X = X - 1
        cpu.i_mem.mem[12] = 16'h0C01; // LSL X, 1      -> shift stanga cu 1
        cpu.i_mem.mem[13] = 16'h0801; // LSR X, 1      -> shift dreapta cu 1
        cpu.i_mem.mem[14] = 16'h1401; // RSL X, 1      -> rotatie stanga cu 1
        cpu.i_mem.mem[15] = 16'h1001; // RSR X, 1      -> rotatie dreapta cu 1

        cpu.i_mem.mem[16] = 16'h1A05; // MOV Y, 5      -> Y = 5
        cpu.i_mem.mem[17] = 16'h020A; // ADD Y, 10     -> Y = 15
        cpu.i_mem.mem[18] = 16'h3A0F; // CMP Y, 15     -> doar flags, NU modifica Y
        cpu.i_mem.mem[19] = 16'h3E00; // TST Y         -> doar flags, NU modifica Y
        cpu.i_mem.mem[20] = 16'h5000;
        cpu.i_mem.mem[21] = 16'h0000;

        reset = 1;
        #15;
        reset = 0;

        #200;
        $stop;
    end
endmodule
