`timescale 1ns/1ps
`default_nettype none

module adder_N_bit
#(parameter N = 8)
(
  /* Inputs */
  input logic [N-1:0] a_i,
  input logic [N-1:0] b_i,

  /* Outputs */
  output logic [N-1:0] sum_o,
  output logic carry_o
);

/* Wires */
logic [N:0] sum_w;

assign sum_w   = {1'b0, a_i} + {1'b0, b_i};
assign sum_o   = sum_w[N-1:0];
assign carry_o = sum_w[N];

endmodule
`default_nettype wire
