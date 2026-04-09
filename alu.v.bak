module alu (
    input  wire [15:0] op1,
    input  wire [15:0] op2,
    input  wire [4:0]  alu_op,   
    output reg  [15:0] result,
    output reg  [3:0]  flag_out  // [3]=V, [2]=C, [1]=N, [0]=Z
);
    reg [16:0] temp_sum;
    reg overflow;

    always @* begin
        temp_sum = 0;
        result = 0;
        flag_out = 0;
        overflow = 0;
        
        case (alu_op)
            0: begin // ADD
                temp_sum = op1 + op2; 
                result = temp_sum[15:0];
                if (op1[15] == op2[15] && result[15] != op1[15]) overflow = 1;
            end 
            1: begin // SUB
                temp_sum = op1 - op2; 
                result = temp_sum[15:0];
                if (op1[15] != op2[15] && result[15] != op1[15]) overflow = 1;
            end
            2: result = op1 >> op2[3:0]; // LSR
            3: result = op1 << op2[3:0]; // LSL
            
            // --- FIX: ADAPTARE CERINTE ---
            4: result = op1 >> op2[3:0]; // RSR (Logical Right Shift - duplicat cu LSR sau Arithmetic?)
            5: result = op1 << op2[3:0]; // RSL 
            
            6: result = op2;             // MOV
            7: result = op1 * op2;       // MUL
            
            // --- FIX: ADAPTARE CERINTE ---
            8: result = (op2 != 0) ? (op1 / op2) : 0; // DIV (Check div by 0)
            9: result = (op2 != 0) ? (op1 % op2) : 0; // MOD

            10: result = op1 & op2;      // AND
            11: result = op1 | op2;      // OR
            12: result = op1 ^ op2;      // XOR
            13: result = ~op1;           // NOT
            
            14: begin // CMP
                temp_sum = op1 - op2; 
                result = 0; 
                if (op1[15] != op2[15] && temp_sum[15] != op1[15]) overflow = 1;
            end
            
            15: begin result = 0; end    // TST
            
            16: begin // INC
                temp_sum = op1 + 1; 
                result = temp_sum[15:0];
                if (!op1[15] && result[15]) overflow = 1;
            end
            17: begin // DEC
                temp_sum = op1 - 1; 
                result = temp_sum[15:0];
                if (op1[15] && !result[15]) overflow = 1;
            end
            
            default: result = 0;
        endcase

        flag_out[0] = (result == 0);      
        flag_out[1] = result[15];         
        flag_out[2] = temp_sum[16];       
        flag_out[3] = overflow;           
        
        if (alu_op == 14) begin 
             flag_out[0] = (temp_sum[15:0] == 0);
             flag_out[1] = temp_sum[15];
        end

        if (alu_op == 15) flag_out[0] = ((op1 & op2) == 0); 
    end
endmodule