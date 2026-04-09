module registers(
    input clk, reset,
    input [15:0] data_in,
    input [15:0] pc_next_addr, 
    input [3:0]  flag_in,
    input A_en, X_en, Y_en, 
    input SP_push, SP_pop, // --- FIX: Split SP_en in Push si Pop
    input Flag_en,
    input PC_load, PC_inc,
    output reg [15:0] A_out, X_out, Y_out, PC_out, SP_out,
    output reg [3:0] Flag_out
);

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            PC_out    <= 0;
            SP_out    <= 16'hFFFF; 
            A_out     <= 0;
            X_out     <= 0;
            Y_out     <= 0;
            Flag_out  <= 0;
        end else begin
            if (A_en) A_out <= data_in;
            if (X_en) X_out <= data_in;
            if (Y_en) Y_out <= data_in;
            if (Flag_en) Flag_out <= flag_in;
            
            // --- FIX: Logica Stiva ---
            if (SP_push) SP_out <= SP_out - 1; // PUSH (JMP/CALL)
            if (SP_pop)  SP_out <= SP_out + 1; // POP (RET)

            if (PC_load) 
                PC_out <= pc_next_addr;      
            else if (PC_inc) 
                PC_out <= PC_out + 1;        
        end
    end
endmodule