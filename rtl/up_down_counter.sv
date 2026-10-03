// Seven-segment display decoder for hexadecimal digits.
//
// Parameters:
//   MAX - Upper limit for counter before wrapping around.
//   WIDTH - Bit width of the counter.
// Ports:
// clk - Synchronous clock signal
// enable - Asynchronous enable signal
// up - Direction control signal
// count - Current count value (0 to MAX)

`timescale 1ns / 1ps

module up_down_counter #(
    parameter int MAX   = 2,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic enable,
    input logic up,
    output logic [WIDTH-1:0] count
);

    localparam logic [WIDTH-1:0] Max = WIDTH'(MAX);
    localparam logic [WIDTH-1:0] One = WIDTH'(1);

    logic [WIDTH-1:0] next_count;

    always_comb begin
        if (up) begin
            next_count = (count == Max) ? WIDTH'(0) : (count + One);
        end else begin
            next_count = (count == WIDTH'(0)) ? Max : (count - One);
        end
    end

    always_ff @(posedge clk) begin
        if (enable) begin
            count <= next_count;
        end
    end

endmodule
