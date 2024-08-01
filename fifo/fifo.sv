`timescale 1ns/1ps

module fifo
#(parameter
  DSIZE = 16, // Data size
  ASIZE = 16  // Address size
)
(
  input  logic clk,
  input  logic rst_n,
  input  logic wr_en_i,
  input  logic rd_en_i,
  input  logic [DSIZE-1:0] wr_data_i,
  output logic [DSIZE-1:0] rd_data_o,
  output logic full_o,
  output logic empty_o,
  output logic almost_full_o,
  output logic almost_empty_o,
  output logic [ASIZE:0] fifo_counter_o
);

// Local parameters
localparam DEPTH        = 1 << ASIZE;
localparam ALMOST_FULL  = (2**(ASIZE-2))*3; // 75%. TODO: maybe add parameter to change this
localparam ALMOST_EMPTY = (2**(ASIZE-2))*1; // 25%. TODO: maybe add parameter to change this

// Internal signals
logic [DSIZE-1:0] mem [DEPTH-1:0]; // Memory
logic [ASIZE-1:0] wr_ptr, rd_ptr;   // Pointers

assign almost_full_o  = fifo_counter_o > ALMOST_FULL;
assign almost_empty_o = fifo_counter_o < ALMOST_EMPTY;

assign empty_o = fifo_counter_o == 0;
assign full_o  = fifo_counter_o == DEPTH;

assign rd_data_o = mem[rd_ptr];

// Memory
always_ff @(posedge(clk)) if(wr_en_i && !full_o) mem[wr_ptr] <= wr_data_i;

// Read and Write
always_ff @(posedge(clk), negedge(rst_n)) begin
  if (!rst_n) begin
    rd_ptr  <= 0;
    wr_ptr  <= 0;
  end
  else begin
    if(wr_en_i && !full_o)  wr_ptr <= wr_ptr + 1;
    if(rd_en_i && !empty_o) rd_ptr <= rd_ptr + 1;
  end
end

// FIFO counter
always_ff @(posedge(clk), negedge(rst_n)) begin
  if (!rst_n) begin
    fifo_counter_o <= 0;
  end
  else if ((wr_en_i && !full_o) && (rd_en_i && !empty_o)) fifo_counter_o <= fifo_counter_o;
  else if (wr_en_i && !full_o)                            fifo_counter_o <= fifo_counter_o + 1;
  else if (rd_en_i && !empty_o)                           fifo_counter_o <= fifo_counter_o - 1;
  else                                                    fifo_counter_o <= fifo_counter_o;
end

endmodule
