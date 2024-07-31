`timescale 1ns/1ps
`default_nettype none

module adder_N_bit_tb;
// Local parameter
localparam N = 8;

// Test signals
logic [N-1:0] a_w, b_w;
logic [N-1:0] sum_w;
logic carry_w;
logic [N:0] sum_check_w;

// Adder
adder_N_bit #(.N(N)) adder(
  .a_i(a_w),
  .b_i(b_w),
  .sum_o(sum_w),
  .carry_o(carry_w)
);

assign sum_check_w = a_w + b_w;

initial begin
  $dumpfile("adder_N_bit.vcd");
	$dumpvars(0, adder_N_bit_tb);
  for (int i = 0; i < (2**N); ++i) begin
    for (int j = 0; j < (2**N); ++j) begin
      a_w = i[N-1:0];
      b_w = j[N-1:0];
      #10;
      // Check sum
      assert (sum_w == sum_check_w[N-1:0])
        $display ("PASSED. At time=%0t, a=0x0%0h, b=0x0%0h and sum=0x0%0h", $time, a_w, b_w, sum_w);
      else $error("FAILED. At time=%0t, a=0x0%0h, b=0x0%0h and sum=0x0%0h", $time, a_w, b_w, sum_w);
      // Check carry
      assert (carry_w == sum_check_w[N])
        $display ("PASSED. At time=%0t, a=0x0%0h, b=0x0%0h and carry=0x0%0h", $time, a_w, b_w, carry_w);
      else $error("FAILED. At time=%0t, a=0x0%0h, b=0x0%0h and carry=0x0%0h", $time, a_w, b_w, carry_w);
    end
  end

  $finish;;
end

endmodule

`default_nettype wire
