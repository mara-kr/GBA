/* mem_top.sv
 * Top module for the GBA memory interface. Consists of 5 BRAM regions:
 * System ROM, CPU Internal RAM, OAM, VRAM, and Palette RAM.
 *
 * "bus" I/O signals are for the CPU/DMA bus, "gfx" I/O signals are for
 * the graphics pipeline (read-only). Either port of the memory
 * controller can assert "pause" on long accesses - when this occurs,
 * whatever system is driving the memory controller's relevant input
 * signals should hold those signals constant.
 *
 * "size" refers to the size of the memory write, and assumes that the
 * data is passed to the memory controller in little endian format.
 *
 * Neil Ryan, <nryan@andrew.cmu.edu>
 */

`default_nettype none
`include "core_tb_defines.vh"

module mem_top(
    input  logic clock, reset,

    /* Signals for CPU/DMA Bus */
    input  logic [31:0] bus_addr, bus_wdata,
    output logic [31:0] bus_rdata,
    input  logic  [1:0] bus_size,
    output logic        bus_pause,
    input  logic        bus_write,

    /* Signals for graphics Bus */
    input  logic [31:0] gfx_oam_addr, gfx_pallete_addr, gfx_vram_addr,
    output logic [31:0] gfx_oam_data, gfx_pallete_data, gfx_vram_data
    );

    /* Single cycle latency for writes */
    logic [31:0] bus_addr_lat1, bus_mem_addr, gfx_addr_lat1;
    logic  [1:0] bus_size_lat1;
    logic        bus_write_lat1;

    // Could add more pauses for memory regions, this is needed
    // because of the CPU's write format

    // Use delayed memory address on writes
    assign bus_mem_addr = (bus_write_lat1) ? bus_addr_lat1 : bus_addr;

    // Registers to delay write signals
    register #(32) baddr (.clock, .reset, .en(1'b1), .clr(1'b0),
                          .D(bus_addr), .Q(bus_addr_lat1));
    register #(1) bwrite (.clock, .reset, .en(1'b1), .clr(1'b0),
                          .D(bus_write), .Q(bus_write_lat1));
    register #(2) bsize (.clock, .reset, .en(1'b1), .clr(1'b0),
                         .D(bus_size), .Q(bus_size_lat1));
    // Pauses due to writes, could be extended
    register #(1) wpause (.clock, .reset, .en(1'b1), .clr(1'b0),
                         .D(bus_write & ~bus_pause), .Q(bus_pause));

    logic [31:0] bus_system_addr, bus_system_rdata;
    logic        bus_system_read;

    logic [31:0] bus_intern_addr, bus_intern_rdata;
    logic  [3:0] bus_intern_we;
    logic        bus_intern_read, bus_intern_write;

    logic [31:0] bus_vram_addr, bus_vram_rdata;
    logic  [3:0] bus_vram_we;
    logic        bus_vram_read, bus_vram_write;

    logic [31:0] bus_pallete_addr, bus_pallete_rdata;
    logic  [3:0] bus_pallete_we;
    logic        bus_pallete_read, bus_pallete_write;

    logic [31:0] bus_oam_addr, bus_oam_rdata;
    logic  [3:0] bus_oam_we;
    logic        bus_oam_read, bus_oam_write;

    logic  [3:0] bus_we;

    mem_decoder decoder (.addr(bus_addr_lat1), .size(bus_size_lat1),
                         .write(bus_write_lat1), .byte_we(bus_we));

    assign bus_system_addr = bus_mem_addr;
    assign bus_intern_addr = bus_mem_addr - `INTERN_RAM_START;
    assign bus_vram_addr = bus_mem_addr - `VRAM_START;
    assign bus_pallete_addr = bus_mem_addr - `PALLET_RAM_START;
    assign bus_oam_addr = bus_mem_addr - `OAM_START;

    assign bus_system_read = bus_addr_lat1 <= `SYSTEM_ROM_SIZE;

    assign bus_intern_read = (bus_addr_lat1 - `INTERN_RAM_START) <= `INTERN_RAM_SIZE;
    assign bus_intern_write = bus_intern_addr <= `INTERN_RAM_SIZE;

    assign bus_vram_read = (bus_addr_lat1 - `VRAM_START) <= `VRAM_SIZE;
    assign bus_vram_write = bus_vram_addr <= `VRAM_SIZE;

    assign bus_pallete_read = (bus_addr_lat1 - `PALLET_RAM_START) <= `PALLET_RAM_SIZE;
    assign bus_pallete_write = bus_pallete_addr <= `PALLET_RAM_SIZE;

    assign bus_oam_read = (bus_addr_lat1 - `OAM_START) <= `OAM_SIZE;
    assign bus_oam_write = bus_oam_addr <= `OAM_SIZE;

    assign bus_intern_we = (bus_intern_write) ? bus_we : 4'd0;
    assign bus_vram_we = (bus_vram_write) ? bus_we : 4'd0;
    assign bus_pallete_we = (bus_pallete_write) ? bus_we : 4'd0;
    assign bus_oam_we = (bus_oam_write) ? bus_we : 4'd0;

    // Data width set to 32bits, so addresses are aligned
    system_rom sys   (.clka(clock), .rsta(reset),
                      .addra({2'b0, bus_system_addr[31:2]}),
                      .douta(bus_system_rdata),

                      .clkb(clock), .rstb(reset),
                      .addrb(32'b0), .doutb());

    InternRAM intern (.clka(clock), .rsta(reset),
                      .wea(bus_intern_we), .addra({2'b0, bus_intern_addr[31:2]}),
                      .douta(bus_intern_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset), .web(4'd0), .addrb(32'b0),
                      .doutb(), .dinb(32'b0));

    vram vram_mem    (.clka(clock), .rsta(reset),
                      .wea(bus_vram_we), .addra({2'b0, bus_vram_addr[31:2]}),
                      .douta(bus_vram_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb({2'b0, gfx_vram_addr[31:2]}),
                      .doutb(gfx_vram_data), .dinb(32'b0));

    palette_ram pall (.clka(clock), .rsta(reset),
                      .wea(bus_pallete_we), .addra({2'b0, bus_pallete_addr[31:2]}),
                      .douta(bus_pallete_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb({2'b0, gfx_pallete_addr[31:2]}),
                      .doutb(gfx_pallete_data), .dinb(32'b0));

    OAM oam_mem      (.clka(clock), .rsta(reset),
                      .wea(bus_oam_we), .addra({2'b0, bus_oam_addr[31:2]}),
                      .douta(bus_oam_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb({2'b0, gfx_pallete_addr[31:2]}),
                      .doutb(gfx_oam_data), .dinb(32'b0));


    always_comb begin
        if (bus_system_read)
            bus_rdata = bus_system_rdata;
        else if (bus_intern_read)
            bus_rdata = bus_intern_rdata;
        else if (bus_vram_read)
            bus_rdata = bus_vram_rdata;
        else if (bus_pallete_read)
            bus_rdata = bus_pallete_rdata;
        else if (bus_oam_read)
            bus_rdata = bus_oam_rdata;
        else
            bus_rdata = 32'hz;
    end

endmodule: mem_top

/* Setup byte write enables for memory (assumes that CPU deals with
 * endianness!) */
module mem_decoder
    (input  logic [31:0] addr,
     input  logic [1:0]  size,
     input  logic        write,
     output logic [3:0]  byte_we);

     always_comb begin
         byte_we = 4'd0;
         if (write) begin
             byte_we[3] = (addr[1:0] == 2'd3 && size == `MEM_SIZE_BYTE) ||
                          (addr[1] && size == `MEM_SIZE_HALF) ||
                          (size == `MEM_SIZE_WORD);

             byte_we[2] = (addr[1:0] == 2'd2 && size == `MEM_SIZE_BYTE) ||
                          (addr[1] && size == `MEM_SIZE_HALF) ||
                          (size == `MEM_SIZE_WORD);

             byte_we[1] = (addr[1:0] == 2'd1 && size == `MEM_SIZE_BYTE) ||
                          (~addr[1] && size == `MEM_SIZE_HALF) ||
                          (size == `MEM_SIZE_WORD);

             byte_we[0] = (addr[1:0] == 2'd0 && size == `MEM_SIZE_BYTE) ||
                          (~addr[1] && size == `MEM_SIZE_HALF) ||
                          (size == `MEM_SIZE_WORD);
         end
     end

endmodule: mem_decoder

module register
    #(parameter WIDTH = 8)
    (input  logic clock, reset,
     output logic [WIDTH-1:0] Q,
     input  logic [WIDTH-1:0] D,
     input  logic en, clr);

    logic [WIDTH-1:0] D_next;
    assign D_next = (clr) ? 0 : ((en) ? D : Q);

    always_ff @(posedge clock, posedge reset) begin
        if (reset) Q <= 0;
        else Q <= D_next;
    end

endmodule: register
