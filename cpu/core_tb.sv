module core_tb;
    logic clk, clken; // Clock, wait
    logic reset_n, irq_n; // Interrupts
    // Memory interface
    logic [31:0] addr, wdata, rdata;
    logic [1:0] size;
    logic abort, write;

    // Eventually will add DMAActive (pause CPU, like CLKEN

    ARM7TDMIS_Top DUT (.CLK(clk), .CLKEN(clken), .NRESET(reset_n),
                       .NIRQ(irq_n), .ADDR(addr), .WDATA(wdata),
                       .RDATA(rdata), .SIZE(size), .ABORT(abort),
                       .WRITE(write), .NFIQ(1'b1));

    /* Bus Monitor - monitor addr/data bus & log read/write
     * Cycle counter (just for completeness)
     * Decoder - Size + data -> data positioned properly & zeroed
     *           (w/ respect to little endian)
     * ABORT generator - Check memory access, signal ABORT if bad
     * CLKEN generator - check memory access, issue CLKEN if accesss is slow
     * Memory - $readmemh() for rom memory, setup other memory however
     * Mux for different regions of memory & remapper to correct address
     */

    /* Clock and Reset Generator */
    initial begin
        clk = 0;
        reset_n = 1'b1;
        #1 reset_n = 1'b0;
        #1 reset_n = 1'b1;
        forever #2 clk <= ~clk;
    end
    /* So the simulation stops */
    initial begin
        @(posedge clk);
        #100 $finish;
    end

endmodule: core_tb
