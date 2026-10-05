// Time display top level module
//
// Parameters:
// CYCLES_PER_SECOND - Number of clock cycles in one second
//
// Ports:
// CLOCK_50 - 50 MHz clock input
// SW [1:0] - Switches to select the display update rate
// HEX5 - Seven segment display for hours tens digit
// HEX4 - Seven segment display for hours ones digit
// HEX3 - Seven segment display for minutes tens digit
// HEX2 - Seven segment display for minutes ones digit
// HEX1 - Seven segment display for seconds tens digit
// HEX0 - Seven segment display for seconds ones digit

`timescale 1ns / 1ps

module top_time_display_v1 #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
    input logic CLOCK_50,
    input logic [1:0] SW,
    output logic [6:0] HEX5,
    output logic [6:0] HEX4,
    output logic [6:0] HEX3,
    output logic [6:0] HEX2,
    output logic [6:0] HEX1,
    output logic [6:0] HEX0
);

  localparam int Count1Hz = CYCLES_PER_SECOND;
  localparam int Count25Hz = CYCLES_PER_SECOND / 25;
  localparam int Count1kHz = CYCLES_PER_SECOND / 1000;
  localparam int Count50MHz = 1;

  logic tick_1hz;
  logic tick_25hz;
  logic tick_1khz;
  logic tick_50mhz;
  logic selected_tick;

  logic [4:0] hours;
  logic [5:0] minutes;
  logic [5:0] seconds;

  logic [3:0] hours_tens, hours_ones;
  logic [3:0] minutes_tens, minutes_ones;
  logic [3:0] seconds_tens, seconds_ones;

  restartable_rate_generator #(
      .CYCLE_COUNT(Count1Hz)
  ) u_1hz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_1hz)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(Count25Hz)
  ) u_25hz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_25hz)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(Count1kHz)
  ) u_1khz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_1khz)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(Count50MHz)
  ) u_50mhz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_50mhz)
  );

  always_comb begin
    case (SW)
      2'b00:   selected_tick = tick_1hz;
      2'b01:   selected_tick = tick_25hz;
      2'b10:   selected_tick = tick_1khz;
      2'b11:   selected_tick = tick_50mhz;
      default: selected_tick = tick_1hz;
    endcase
  end

  hms_counter u_hms (
      .clk(CLOCK_50),
      .enable(selected_tick),
      .hours(hours),
      .minutes(minutes),
      .seconds(seconds)
  );

  // Zero extended to match input widths
  binary_to_bcd u_bcd_hours (
      .bin ({2'b0, hours}),
      .tens(hours_tens),
      .ones(hours_ones)
  );

  binary_to_bcd u_bcd_minutes (
      .bin ({1'b0, minutes}),  // Expecting 7 bits for minutes (0-59)
      .tens(minutes_tens),
      .ones(minutes_ones)
  );

  binary_to_bcd u_bcd_seconds (
      .bin ({1'b0, seconds}),
      .tens(seconds_tens),
      .ones(seconds_ones)
  );

  seven_segment u_hex5 (
      .digit(hours_tens),
      .blank(1'b0),
      .segments(HEX5)
  );
  seven_segment u_hex4 (
      .digit(hours_ones),
      .blank(1'b0),
      .segments(HEX4)
  );
  seven_segment u_hex3 (
      .digit(minutes_tens),
      .blank(1'b0),
      .segments(HEX3)
  );
  seven_segment u_hex2 (
      .digit(minutes_ones),
      .blank(1'b0),
      .segments(HEX2)
  );
  seven_segment u_hex1 (
      .digit(seconds_tens),
      .blank(1'b0),
      .segments(HEX1)
  );
  seven_segment u_hex0 (
      .digit(seconds_ones),
      .blank(1'b0),
      .segments(HEX0)
  );

endmodule
