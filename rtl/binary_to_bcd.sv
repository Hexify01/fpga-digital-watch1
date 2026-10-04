// Binary to binary coded decimal (BCD) converter module
//
// Parameters:
// None
//
// Ports:
// bin [6:0] - Binary input (0 to 99)
// tens [3:0] - Decimal tens digit (BCD)
// ones [3:0] - Decimal ones digit (BCD)

`timescale 1ns / 1ps

module binary_to_bcd (
    input  logic [6:0] bin, // binary input. 0-99
    output logic [3:0] tens, // decimal tens digic (BCD)
    output logic [3:0] ones  // decimal ones digit (BCD)
);

    assign tens = 4'(bin / 7'd10);
    assign ones = 4'(bin % 7'd10);

endmodule
