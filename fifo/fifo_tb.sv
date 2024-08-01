`timescale 1ns / 1ps

module fifo_tb;

// Test Constants
localparam PERIOD = 10;
localparam DSIZE = 32;
localparam ASIZE = 4;

// Test Signals
logic clk = 0;             
logic rst_n = 1;           
logic wr_en_i = 0;     
logic rd_en_i = 0;      
logic [DSIZE-1 : 0] wr_data_i = 0;
logic [DSIZE-1 : 0] rd_data_o; 
logic full_o;            
logic empty_o;
logic almost_full_o;        // Asserts when at least %75 of the FIFO is filled
logic almost_empty_o;       // Asserts when at most %25 of the FIFO is filled
logic [ASIZE : 0] fifo_counter_o; // Indicates the amount of data

// DUT
fifo #(.DSIZE(DSIZE), .ASIZE(ASIZE)) u_fifo(.*);

// Dump VCD
initial begin
  $dumpfile("fifo.vcd");
	$dumpvars(0, fifo_tb);
end

// Clock Generation
always begin
  #(PERIOD/2); clk = ~clk; 
end

// Test Scenario
initial begin
    // Initial reset
    rst_n <= ~rst_n;
    #(2.2*PERIOD);
    // Sync clock
    @(posedge(clk));

    rst_n <= ~rst_n;
    #PERIOD;
    
    // Write Until Full
    for(int i = 0; (i < 2**ASIZE) && !full_o; ++i) begin
        wr_data_i   <= i;
        wr_en_i <= 1'b1;
        #PERIOD;
    end
    wr_en_i <= 1'b0;
    #PERIOD;
    
    assert (full_o == 1'b1) $display("PASSED. FIFO full.");
    else $error("FAILED. FIFO was expected to be full but it is not.");
    
    // Read unless empty_o
    for(int i = 0; (i < 2**ASIZE) && !empty_o; ++i) begin
      // To avoid race, sample at the midle of transition
      @(negedge(clk));     

      assert (rd_data_o == i) $display("PASSED. Read data is same as written data.");
      else $error("FAILED. Read data was %d, but it is expected to be %d.", rd_data_o, i);

      rd_en_i <= 1'b1;
      #PERIOD;  
    end
    rd_en_i <= 1'b0;
    #PERIOD;  
    
    assert (empty_o == 1'b1) $display("PASSED. FIFO empty.");
    else $error("FAILED. FIFO was expected to be empty but it is not.");
    
    @(posedge(clk));  // Synchronize again
    
    // Write and Read at the same time while empty_o
    wr_data_i <= 32'hBABA;
    wr_en_i   <= 1'b1;
    rd_en_i   <= 1'b1;
    #PERIOD;
    wr_en_i   <= 1'b0;
    rd_en_i   <= 1'b0;
    #PERIOD;
    
    wr_data_i <= 32'hABCD;
    wr_en_i   <= 1'b1;
    rd_en_i   <= 1'b1;
    #PERIOD;
    wr_en_i   <= 1'b0;
    rd_en_i   <= 1'b0;
    #PERIOD;
    
    assert (empty_o == 1'b0) $display("PASSED. FIFO was not empty.");
    else $error("FAILED. FIFO was empty but it should't be.");
    
    // rst_n Again
    rst_n <= ~rst_n;
    #PERIOD;
    rst_n <= ~rst_n;
    
    // Fill completely
    for(int i = 0; (i < 2**ASIZE) && !full_o; ++i) begin
        wr_data_i   <= i;
        wr_en_i <= 1'b1;
        #PERIOD;
    end
    wr_en_i <= 1'b0;
    #PERIOD;
    
    assert (full_o == 1'b1) $display("PASSED. FIFO full.");
    else $error("FAILED. FIFO was expected to be full but it is not.");
        
    // Write and Read at the same time while full_o
    wr_data_i <= 32'hAA;
    wr_en_i   <= 1'b1;
    rd_en_i   <= 1'b1;
    #PERIOD;
    wr_en_i   <= 1'b0;
    rd_en_i   <= 1'b0;
    #PERIOD;
    
    wr_data_i <= 32'hBB;
    wr_en_i   <= 1'b1;
    rd_en_i   <= 1'b1;
    #PERIOD;
    wr_en_i   <= 1'b0;
    rd_en_i   <= 1'b0;
    #PERIOD;
    
    assert (full_o == 1'b0) $display("PASSED. FIFO is not full.");
    else $error("FAILED. FIFO was full but is shouldn't be.");
        
    $finish;
end

endmodule
