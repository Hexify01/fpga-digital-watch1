// Restartable Rate Generator
//
// Parameters:
//  CYCLE_COUNT - Number of clock cycles between ticks
//
// Ports:
//  clk - Clock input
//  run - When high, the generator is running; when low, it resets
//  tick - Output pulse generated every CYCLE_COUNT clock cycles when run is high

`timescale 1ns / 1ps

module restartable_rate_generator #(
    parameter int CYCLE_COUNT = 2
) (
    input  logic clk,
    input  logic run,
    output logic tick
);

  localparam int CountWidth = $clog2(CYCLE_COUNT);
  logic tick_qualifier;

  logic running = 1'b0;

  always_ff @(posedge clk) begin
    running <= run;
  end

  assign tick = running && tick_qualifier;

  generate
    if (CYCLE_COUNT > 1) begin : g_standard
      logic rst_count;
      logic enable_count;
      logic [CountWidth-1:0] count;

      mod_n_counter #(
          .N(CYCLE_COUNT),
          .WIDTH(CountWidth)
      ) u_count (
          .clk(clk),
          .rst(rst_count),
          .enable(enable_count),
          .count(count)
      );
      // Reset for run low or max count reached
      assign rst_count = !run || (count == CountWidth'(CYCLE_COUNT - 1));
      // Enable counter when run is high
      assign enable_count = run;
      assign tick_qualifier = (count == CountWidth'(CYCLE_COUNT - 1));

    end else begin : g_edge
      // Special case for CYCLE_COUNT = 1, tick is generated on every clock edge when run is high
      assign tick_qualifier = 1'b1;
    end
  endgenerate
endmodule
