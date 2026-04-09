module tb_alu;
    reg  [15:0] t_op1, t_op2;
    reg  [4:0]  t_opcode;
    wire [15:0] t_result;
    wire [3:0]  t_flags;

    // Instantiere
    alu uut (
        .op1(t_op1), .op2(t_op2), .alu_op(t_opcode),
        .result(t_result), .flag_out(t_flags)
    );

    initial begin
        $display("--- TESTARE ALU ---");
        
        // Test 1: ADD
        t_op1 = 10; t_op2 = 15; t_opcode = 0; // ADD
        #10;
        $display("ADD 10+15: Res=%d Flags=%b (Asteptat: 25, 0000)", t_result, t_flags);

        // Test 2: SUB (rezultat negativ)
        t_op1 = 10; t_op2 = 20; t_opcode = 1; // SUB
        #10;
        $display("SUB 10-20: Res=%h Flags=%b (Asteptat: FFF6, N=1)", t_result, t_flags);

        // Test 3: AND
        t_op1 = 16'hFF00; t_op2 = 16'h0F0F; t_opcode = 10; // AND
        #10;
        $display("AND: Res=%h (Asteptat: 0F00)", t_result);

        $stop;
    end
endmodule