`timescale 1ns / 1ps

module pwm_generator #(

    parameter int PERIOD_CYCLES = 50_000_000,

    parameter int DUTY_CYCLES = 25_000_000
) (
    input  logic clk,
    input  logic rst,
    output logic pwm_out
);

  localparam int CounterWidth = $clog2(PERIOD_CYCLES);
  logic [CounterWidth-1:0] count;

  mod_n_counter #(
      .N(PERIOD_CYCLES),
      .WIDTH(CounterWidth)
  ) u_counter (
      .clk(clk),
      .rst(rst),
      .enable(1'b1),
      .count(count)
  );

  assign pwm_out = (count < CounterWidth'(DUTY_CYCLES));

endmodule
