module sign_extend (
    input  [9:0] immediate_in, // FIX: 10 biti conform Branch instruction
    output [15:0] extended_out
);
    assign extended_out = { {6{immediate_in[9]}}, immediate_in };
endmodule