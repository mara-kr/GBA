/* Top module for the CPU. Wrapper for ARM7TDMIS_Top, since VHDL is annoying,
 * and it's nice to not have signals in gba_top be all caps
 */

`default_nettype none

module cpu_top (
    input  logic clock, reset,
    input  logic nIRQ, pause, abort,
    input  logic dmaActive,
    input  logic [31:0] rdata,
    output logic [31:0] addr, wdata,
    output logic  [1:0] size,
    output logic  [4:0] mode,
    output logic        write);

    logic [31:0] addr_int, wdata_int;
    logic  [1:0] size_int;
    logic        write_int;

    ARM7TDMIS_Top cpu (.CLK(clock), .NRESET(~reset), .NIRQ(nIRQ),
                       .ADDR(addr_int), .WDATA(wdata_int), .RDATA(rdata),
                       .SIZE(size_int), .WRITE(write_int), .ABORT(abort),
                       .PAUSE(pause | dmaActive), .MODE(mode), .NFIQ(1'b1));

    assign addr = (dmaActive) ? 32'bz : addr_int;
    assign size = (dmaActive) ? 2'bz : size_int;
    assign write = (dmaActive) ? 1'bz : write_int;
    assign wdata = (dmaActive) ? 1'bz : wdata_int;

endmodule: cpu_top
