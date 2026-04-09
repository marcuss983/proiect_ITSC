module tb_registers;
    reg clk = 0, reset = 1;
    reg [15:0] d_in, pc_next;
    reg [3:0] f_in;

    reg A_en, X_en, Y_en;
    reg SP_push, SP_pop;
    reg F_en, PC_ld, PC_inc;

    wire [15:0] A, X, Y, PC, SP;
    wire [3:0] F;

    registers uut (
        .clk(clk), .reset(reset),
        .data_in(d_in),
        .pc_next_addr(pc_next),
        .flag_in(f_in),

        .A_en(A_en), .X_en(X_en), .Y_en(Y_en),
        .SP_push(SP_push), .SP_pop(SP_pop),
        .Flag_en(F_en),

        .PC_load(PC_ld), .PC_inc(PC_inc),

        .A_out(A), .X_out(X), .Y_out(Y),
        .PC_out(PC), .SP_out(SP),
        .Flag_out(F)
    );

    always #5 clk = ~clk;

    initial begin
        $display("TESTARE REGISTRI");

        A_en=0; X_en=0; Y_en=0;
        SP_push=0; SP_pop=0;
        F_en=0; PC_ld=0; PC_inc=0;

        reset = 1; #10; reset = 0; #10;
        $display("Dupa Reset: PC=%d (Trebuie 0), SP=%h", PC, SP);

        d_in = 16'hAAAA; A_en = 1; #10; A_en = 0;
        $display("Scriere A: A=%h (Trebuie AAAA)", A);

        PC_inc = 1; #10; #10; PC_inc = 0;
        $display("Inc PC x2: PC=%d (Trebuie 2)", PC);

        pc_next = 16'h0050; PC_ld = 1; #10; PC_ld = 0;
        $display("Jump PC: PC=%h (Trebuie 0050)", PC);

        // test push/pop stack pointer
        SP_push = 1; #10; SP_push = 0;
        $display("PUSH: SP=%h (SP-1)", SP);

        SP_pop = 1; #10; SP_pop = 0;
        $display("POP: SP=%h (SP+1)", SP);

        $stop;
    end
endmodule
