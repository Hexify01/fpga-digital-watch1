`timescale 1ns / 1ps

module tb_restartable_rate_generator_report6;

  logic clk;
  logic run;
  logic tick;
// Special case of CYCLE_COUNT = 1
  restartable_rate_generator #(
    .CYCLE_COUNT(1)
  ) u_dut (
    .clk(clk),
    .run(run),
    .tick(tick)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 1'b0;
    run = 1'b0;
    #10;
    run = 1'b1;
    #10;
    run = 1'b0;
    #10;
    $finish();
  end
endmodule
