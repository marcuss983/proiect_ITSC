module crypto_core (
    input wire clk,
    input wire reset,
    input wire [15:0] data_in,
    input wire [15:0] key_in,
    input wire enable,
    output wire [15:0] result
);

    reg [15:0] internal_hash_state;

    function [3:0] sbox_nibble;
        input [3:0] in;
        begin
            case (in)
                4'h0: sbox_nibble = 4'hC;
                4'h1: sbox_nibble = 4'h5;
                4'h2: sbox_nibble = 4'h6;
                4'h3: sbox_nibble = 4'hB;
                4'h4: sbox_nibble = 4'h9;
                4'h5: sbox_nibble = 4'h0;
                4'h6: sbox_nibble = 4'hA;
                4'h7: sbox_nibble = 4'hD;
                4'h8: sbox_nibble = 4'h3;
                4'h9: sbox_nibble = 4'hE;
                4'hA: sbox_nibble = 4'hF;
                4'hB: sbox_nibble = 4'h8;
                4'hC: sbox_nibble = 4'h4;
                4'hD: sbox_nibble = 4'h7;
                4'hE: sbox_nibble = 4'h1;
                4'hF: sbox_nibble = 4'h2;
                default: sbox_nibble = 4'h0;
            endcase
        end
    endfunction

    wire [15:0] mixed_data;
    wire [15:0] substituted_data;
    wire [15:0] permuted_data;

    assign mixed_data = data_in ^ key_in ^ internal_hash_state;

    assign substituted_data[15:12] = sbox_nibble(mixed_data[15:12]);
    assign substituted_data[11:8]  = sbox_nibble(mixed_data[11:8]);
    assign substituted_data[7:4]   = sbox_nibble(mixed_data[7:4]);
    assign substituted_data[3:0]   = sbox_nibble(mixed_data[3:0]);

    assign permuted_data = {substituted_data[10:0], substituted_data[15:11]} ^ 16'hA5A5;

    // OUTPUT combinational (ca ALU) => CPU îl poate scrie în A în acela?i ciclu
    assign result = permuted_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            internal_hash_state <= 16'h0000;
        end else if (enable) begin
            internal_hash_state <= permuted_data;
        end
    end

endmodule
