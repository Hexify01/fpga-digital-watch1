// Modulo N Counter
//
// Parameters:
//  N - Modulus of the counter
//  WIDTH - Bit width of the counter output
//
// Ports:
//  clk - Clock input
//  rst - Reset input (active high)
//  enable - Enable counting when high
//  count - Current count value (output)

`timescale 1ns / 1ps

module mod_n_counter #(
    parameter int N = 4,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic rst,
    input logic enable,
    output logic [WIDTH-1:0] count = WIDTH'(0)
);

    localparam logic [WIDTH-1:0] Max = WIDTH'(N - 1);
    localparam logic [WIDTH-1:0] One = WIDTH'(1);

    logic [WIDTH-1:0] next_count;

    always_comb begin
        next_count = (count == Max) ? WIDTH'(0) : count + One;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            count <= WIDTH'(0);
        end else if (enable) begin
            count <= next_count;
        end
    end

endmodule
