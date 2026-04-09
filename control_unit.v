module control_unit(
    input [15:0] instruction,
    input [3:0] flag_in,
    output reg [4:0] alu_op,
    output reg A_en, X_en, Y_en, 
    output reg SP_push, SP_pop, // --- FIX: Semnale noi stiva
    output reg Flag_en,
    output reg PC_load, PC_inc,
    output reg mem_read, mem_write,
    output reg ASIP_en,
    output reg reg_dst_sel,  
    output reg alu_src_sel,  
    output reg addr_sel,     
    output reg pc_src_sel    // --- FIX: 0=Imm(Jump), 1=Mem(Ret)
);
    wire [5:0] opcode = instruction[15:10];
    wire reg_bit = instruction[9];

    localparam O_LOAD=25, O_STORE=26, O_BRZ=27, O_BRN=28, O_BRC=29, O_BRO=30, O_BRA=31;
    localparam O_JMP=32, O_RET=33, O_ASIP=20;

    always @* begin
        alu_op=0; A_en=0; X_en=0; Y_en=0; 
        SP_push=0; SP_pop=0; // Reset
        Flag_en=0;
        PC_load=0; PC_inc=1; 
        mem_read=0; mem_write=0; ASIP_en=0;
        reg_dst_sel=0; alu_src_sel=0; addr_sel=0; pc_src_sel=0;

        if (opcode <= 17) begin
            alu_op = opcode[4:0];
            Flag_en = 1;
            if(opcode != 14 && opcode != 15) begin
                if(reg_bit == 0) X_en=1; else Y_en=1; 
            end
            alu_src_sel = 1; 
        end
        else case(opcode)
            O_LOAD: begin
                mem_read = 1;
                reg_dst_sel = 1; 
                if(reg_bit==0) X_en=1; else Y_en=1;
            end
            O_STORE: begin
                mem_write = 1;
            end
            O_ASIP: begin
                ASIP_en = 1;
                A_en = 1; 
            end
            // --- FIX: Branchuri complete ---
            O_BRZ: if(flag_in[0]) begin PC_load=1; PC_inc=0; end // Zero
            O_BRN: if(flag_in[1]) begin PC_load=1; PC_inc=0; end // Neg
            O_BRC: if(flag_in[2]) begin PC_load=1; PC_inc=0; end // Carry
            O_BRO: if(flag_in[3]) begin PC_load=1; PC_inc=0; end // Overflow
            O_BRA: begin PC_load=1; PC_inc=0; end
            
            O_JMP: begin // CALL
                mem_write = 1; addr_sel = 1; 
                SP_push = 1; // Scade SP
                PC_load = 1; PC_inc = 0;
            end
            
            // --- FIX: RET (Return) ---
            O_RET: begin
                mem_read = 1; addr_sel = 1; // Citeste din stiva
                SP_pop = 1;   // Creste SP
                PC_load = 1; PC_inc = 0;
                pc_src_sel = 1; // Ia adresa din memorie, nu din instructiune
            end
        endcase
    end
endmodule