module top_processor(
    input clk,
    input reset
);
    // =========================
    // FIRE INTERNE (REGISTRE)
    // =========================
    wire [15:0] A, X, Y, PC, SP;
    wire [3:0]  flags_stored;

    // =========================
    // FIRE INTERNE (INSTR/DATE)
    // =========================
    wire [15:0] instr;
    wire [15:0] ext_imm;

    wire [15:0] alu_res;
    wire [3:0]  flags_from_alu;

    wire [15:0] asip_res;

    wire [15:0] dmem_out;

    // =========================
    // SEMNALE DE CONTROL
    // =========================
    wire [4:0] alu_op;

    wire A_en, X_en, Y_en;
    wire SP_push, SP_pop;
    wire F_en;

    wire PC_ld, PC_inc;

    wire m_rd, m_wr;
    wire asip_en;

    wire reg_dst_sel;
    wire alu_src_sel;
    wire addr_sel;
    wire pc_src_sel;

    // =========================
    // 1) MEMORIE INSTRUCTIUNI (i_mem)
    // =========================
    // Citim mereu instructia la adresa PC
    memory i_mem (
        .clk(clk),
        .addr(PC),
        .data_in(16'h0000),
        .mem_write(1'b0),
        .data_out(instr)
    );

    // =========================
    // 2) CONTROL UNIT
    // =========================
    control_unit ctrl (
        .instruction(instr),
        .flag_in(flags_stored),

        .alu_op(alu_op),

        .A_en(A_en),
        .X_en(X_en),
        .Y_en(Y_en),

        .SP_push(SP_push),
        .SP_pop(SP_pop),

        .Flag_en(F_en),

        .PC_load(PC_ld),
        .PC_inc(PC_inc),

        .mem_read(m_rd),
        .mem_write(m_wr),

        .ASIP_en(asip_en),

        .reg_dst_sel(reg_dst_sel),
        .alu_src_sel(alu_src_sel),
        .addr_sel(addr_sel),

        .pc_src_sel(pc_src_sel)
    );

    // =========================
    // 3) SIGN EXTEND
    // =========================
    sign_extend se (
        .immediate_in(instr[9:0]),
        .extended_out(ext_imm)
    );

    // =========================
    // 4) DATA MEM / STACK MEM (d_mem)
    // =========================
    // Address:
    // - LOAD/STORE -> ext_imm
    // - JMP/RET (stack) -> SP
    //
    // IMPORTANT: la PUSH trebuie scris la SP-1 (nu la SP vechi)
    wire [15:0] dmem_addr =
        (addr_sel) ? (SP_push ? (SP - 16'd1) : SP) : ext_imm;

    // Date scrise in memorie:
    // - STORE: scriem X sau Y (instr[9] alege)
    // - JMP: scriem PC+1 (return address)
    wire [15:0] store_xy = (instr[9]) ? Y : X;
    wire [15:0] dmem_data_in =
        (instr[15:10] == 6'd26) ? store_xy :    // STORE
        (instr[15:10] == 6'd32) ? (PC + 16'd1) : // JMP/CALL push return addr
        16'h0000;

    memory d_mem (
        .clk(clk),
        .addr(dmem_addr),
        .data_in(dmem_data_in),
        .mem_write(m_wr),
        .data_out(dmem_out)
    );

    // =========================
    // 5) ALU
    // =========================
    // op1: X sau Y in functie de bitul instr[9]
    wire [15:0] op1_alu = (instr[9]) ? Y : X;

    // op2: immediate sau X
    wire [15:0] op2_alu = (alu_src_sel) ? ext_imm : X;

    alu execution (
        .op1(op1_alu),
        .op2(op2_alu),
        .alu_op(alu_op),
        .result(alu_res),
        .flag_out(flags_from_alu)
    );

    // =========================
    // 6) ASIP (CRYPTO CORE)
    // =========================
    crypto_core my_asip (
        .clk(clk),
        .reset(reset),
        .data_in(A),
        .key_in(X),
        .enable(asip_en),
        .result(asip_res)
    );

    // =========================
    // 7) WRITE BACK MUX
    // =========================
    // Prioritate:
    // 1) daca e ASIP -> scriem asip_res
    // 2) daca e LOAD -> scriem dmem_out
    // 3) altfel -> scriem alu_res
    wire [15:0] w_data =
        (asip_en) ? asip_res :
        (reg_dst_sel) ? dmem_out :
        alu_res;

    // =========================
    // 8) NEXT PC VALUE
    // =========================
    // Daca RET -> PC ia din memorie
    // Altfel -> PC ia ext_imm (pentru BR/JMP)
    wire [15:0] next_pc_val =
        (pc_src_sel) ? dmem_out : ext_imm;

    // =========================
    // 9) REGISTERS
    // =========================
    registers reg_file (
        .clk(clk),
        .reset(reset),
        .data_in(w_data),
        .pc_next_addr(next_pc_val),
        .flag_in(flags_from_alu),

        .A_en(A_en),
        .X_en(X_en),
        .Y_en(Y_en),

        .SP_push(SP_push),
        .SP_pop(SP_pop),

        .Flag_en(F_en),

        .PC_load(PC_ld),
        .PC_inc(PC_inc),

        .A_out(A),
        .X_out(X),
        .Y_out(Y),
        .PC_out(PC),
        .SP_out(SP),
        .Flag_out(flags_stored)
    );

endmodule
