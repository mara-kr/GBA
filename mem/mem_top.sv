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
 * Vivado IP Core Sizes:
 *     SystemROM: BRAM, Dual Port ROM 32x4096
 *     InternRAM: BRAM 32x8192
 *     OAM: BRAM  32x256
 *     Palette_bg: BRAM 32x128
 *     Palette_obj: BRAM 32x128
 *     VRAM_A: BRAM 32x16384
 *     VRAM_B: BRAM 32x4096
 *     VRAM_C: BRAM 32x4096
 *
 * BRAM: True Dual Ported, 32-bit address interface, reset pins on both ports,
 *     no output registers, write first operating mode, ports always enabled
 *
 * Neil Ryan, <nryan@andrew.cmu.edu>
 */

`default_nettype none
`include "gba_core_defines.vh"

module mem_top (
    input  logic clock, reset,

    /* Signals for CPU/DMA Bus */
    (* mark_debug = "true" *) input  logic [31:0] bus_addr,
    (* mark_debug = "true" *) input  logic [31:0] bus_wdata,
    (* mark_debug = "true" *) output logic [31:0] bus_rdata,
    input  logic  [1:0] bus_size,
    output logic        bus_pause,
    input  logic        bus_write,

    // Signals for graphics Bus
    input  logic [31:0] gfx_vram_A_addr, gfx_vram_B_addr, gfx_vram_C_addr,
    input  logic [31:0] gfx_oam_addr, gfx_palette_bg_addr, gfx_palette_obj_addr,
    input  logic [31:0] gfx_vram_A_addr2,
    output logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data,
    output logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data,
    output logic [31:0] gfx_vram_A_data2,

    // IO registers
    output logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0]
    );

    /* Single cycle latency for writes */
    (* mark_debug = "true" *) logic [31:0] bus_addr_lat1;
    logic [31:0] bus_mem_addr;
    logic  [1:0] bus_size_lat1;
    logic        bus_write_lat1;

    // Could add more pauses for memory regions, this is needed
    // because of the CPU's write format

    // Use delayed memory address on writes
    assign bus_mem_addr = (bus_write_lat1) ? bus_addr_lat1 : bus_addr;

    // Registers to delay write signals
    mem_register #(32) baddr (.clock, .reset, .en(1'b1), .clr(1'b0),
                          .D(bus_addr), .Q(bus_addr_lat1));
    mem_register #(1) bwrite (.clock, .reset, .en(1'b1), .clr(1'b0),
                          .D(bus_write), .Q(bus_write_lat1));
    mem_register #(2) bsize (.clock, .reset, .en(1'b1), .clr(1'b0),
                         .D(bus_size), .Q(bus_size_lat1));
    // Pauses due to writes, could be extended
    mem_register #(1) wpause (.clock, .reset, .en(1'b1), .clr(1'b0),
                         .D(bus_write & ~bus_pause), .Q(bus_pause));

    logic [31:0] bus_system_addr, bus_system_rdata;
    (* mark_debug = "true" *) logic        bus_system_read;

    logic [31:0] bus_intern_addr, bus_intern_rdata;
    logic  [3:0] bus_intern_we;
    (* mark_debug = "true" *) logic        bus_intern_read, bus_intern_write;

    logic [31:0] bus_vram_A_addr, bus_vram_A_rdata;
    logic  [3:0] bus_vram_A_we;
    (* mark_debug = "true" *) logic        bus_vram_A_read, bus_vram_A_write;

    logic [31:0] bus_vram_B_addr, bus_vram_B_rdata;
    logic  [3:0] bus_vram_B_we;
    (* mark_debug = "true" *) logic        bus_vram_B_read, bus_vram_B_write;

    logic [31:0] bus_vram_C_addr, bus_vram_C_rdata;
    logic  [3:0] bus_vram_C_we;
    (* mark_debug = "true" *) logic        bus_vram_C_read, bus_vram_C_write;

    logic [31:0] bus_palette_bg_addr, bus_palette_bg_rdata;
    logic  [3:0] bus_palette_bg_we;
    (* mark_debug = "true" *) logic        bus_palette_bg_read, bus_palette_bg_write;

    logic [31:0] bus_palette_obj_addr, bus_palette_obj_rdata;
    logic  [3:0] bus_palette_obj_we;
    (* mark_debug = "true" *) logic        bus_palette_obj_read, bus_palette_obj_write;

    logic [31:0] bus_oam_addr, bus_oam_rdata;
    logic  [3:0] bus_oam_we;
    (* mark_debug = "true" *) logic        bus_oam_read, bus_oam_write;

    (* mark_debug = "true" *) logic  [3:0] bus_we;

    logic [3:0]  IO_reg_we [`NUM_IO_REGS-1:0];
    logic [`NUM_IO_REGS-1:0] IO_reg_en;
    (* mark_debug = "true" *) tri0 [31:0] bus_io_reg_rdata;
    (* mark_debug = "true" *) logic        bus_io_reg_read;

    mem_decoder decoder (.addr(bus_addr_lat1), .size(bus_size_lat1),
                         .write(bus_write_lat1), .byte_we(bus_we));

    assign bus_system_addr = bus_mem_addr;
    assign bus_intern_addr = bus_mem_addr - `INTERN_RAM_START;
    assign bus_vram_A_addr = bus_mem_addr - `VRAM_A_START;
    assign bus_vram_B_addr = bus_mem_addr - `VRAM_B_START;
    assign bus_vram_C_addr = bus_mem_addr - `VRAM_C_START;
    assign bus_palette_bg_addr = bus_mem_addr - `PALETTE_BG_RAM_START;
    assign bus_palette_obj_addr = bus_mem_addr - `PALETTE_OBJ_RAM_START;
    assign bus_oam_addr = bus_mem_addr - `OAM_START;

    assign bus_system_read = bus_addr_lat1 <= `SYSTEM_ROM_SIZE;

    assign bus_intern_read = (bus_addr_lat1 - `INTERN_RAM_START)
                             <= `INTERN_RAM_SIZE;
    assign bus_intern_write = bus_intern_addr <= `INTERN_RAM_SIZE;

    assign bus_vram_A_read = (bus_addr_lat1 - `VRAM_A_START) <= `VRAM_A_SIZE;
    assign bus_vram_A_write = bus_vram_A_addr <= `VRAM_A_SIZE;

    assign bus_vram_B_read = (bus_addr_lat1 - `VRAM_B_START) <= `VRAM_B_SIZE;
    assign bus_vram_B_write = bus_vram_B_addr <= `VRAM_B_SIZE;

    assign bus_vram_C_read = (bus_addr_lat1 - `VRAM_C_START) <= `VRAM_C_SIZE;
    assign bus_vram_C_write = bus_vram_C_addr <= `VRAM_C_SIZE;

    assign bus_palette_bg_read = (bus_addr_lat1 - `PALETTE_BG_RAM_START) <=
                                 `PALETTE_BG_RAM_SIZE;
    assign bus_palette_bg_write = bus_palette_bg_addr <= `PALETTE_BG_RAM_SIZE;

    assign bus_palette_obj_read = (bus_addr_lat1 - `PALETTE_OBJ_RAM_START) <=
                                  `PALETTE_OBJ_RAM_SIZE;
    assign bus_palette_obj_write = bus_palette_obj_addr <= `PALETTE_OBJ_RAM_SIZE;

    assign bus_oam_read = (bus_addr_lat1 - `OAM_START) <= `OAM_SIZE;
    assign bus_oam_write = bus_oam_addr <= `OAM_SIZE;

    assign bus_io_reg_read = (bus_addr_lat1 - `IO_REG_RAM_START) <= `IO_REG_RAM_SIZE;

    assign bus_intern_we = (bus_intern_write) ? bus_we : 4'd0;
    assign bus_vram_A_we = (bus_vram_A_write) ? bus_we : 4'd0;
    assign bus_vram_B_we = (bus_vram_B_write) ? bus_we : 4'd0;
    assign bus_vram_C_we = (bus_vram_C_write) ? bus_we : 4'd0;
    assign bus_palette_bg_we = (bus_palette_bg_write) ? bus_we : 4'd0;
    assign bus_palette_obj_we = (bus_palette_obj_write) ? bus_we : 4'd0;
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

    vram_A vram_A    (.clka(clock), .rsta(reset),
                      .wea(bus_vram_A_we), .addra({2'b0, bus_vram_A_addr[31:2]}),
                      .douta(bus_vram_A_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb({2'b0, gfx_vram_A_addr[31:2]}),
                      .doutb(gfx_vram_A_data), .dinb(32'b0));

    vram_A_2 vram_A_2 (.clka(clock), .rsta(reset),
                      .wea(bus_vram_A_we), .addra({2'b0, bus_vram_A_addr[31:2]}),
                      .douta(), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb({2'b0, gfx_vram_A_addr2[31:2]}),
                      .doutb(gfx_vram_A_data2), .dinb(32'b0));

    vram_B vram_B    (.clka(clock), .rsta(reset),
                      .wea(bus_vram_B_we), .addra({2'b0, bus_vram_B_addr[31:2]}),
                      .douta(bus_vram_B_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb({2'b0, gfx_vram_B_addr[31:2]}),
                      .doutb(gfx_vram_B_data), .dinb(32'b0));

    vram_C vram_C    (.clka(clock), .rsta(reset),
                      .wea(bus_vram_C_we), .addra({2'b0, bus_vram_C_addr[31:2]}),
                      .douta(bus_vram_C_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb({2'b0, gfx_vram_C_addr[31:2]}),
                      .doutb(gfx_vram_C_data), .dinb(32'b0));

    palette_bg_ram pall_bg (.clka(clock), .rsta(reset),
                            .wea(bus_palette_bg_we),
                            .addra({2'b0, bus_palette_bg_addr[31:2]}),
                            .douta(bus_palette_bg_rdata), .dina(bus_wdata),

                            .clkb(clock), .rstb(reset),
                            .web(4'd0),
                            .addrb({2'b0, gfx_palette_bg_addr[31:2]}),
                            .doutb(gfx_palette_bg_data), .dinb(32'b0));

    palette_obj_ram pall_obj (.clka(clock), .rsta(reset),
                              .wea(bus_palette_obj_we),
                              .addra({2'b0, bus_palette_obj_addr[31:2]}),
                              .douta(bus_palette_obj_rdata), .dina(bus_wdata),

                              .clkb(clock), .rstb(reset),
                              .web(4'd0),
                              .addrb({2'b0, gfx_palette_obj_addr[31:2]}),
                              .doutb(gfx_palette_obj_data), .dinb(32'b0));

    OAM oam_mem  (.clka(clock), .rsta(reset),
                  .wea(bus_oam_we), .addra({2'b0, bus_oam_addr[31:2]}),
                  .douta(bus_oam_rdata), .dina(bus_wdata),

                  .clkb(clock), .rstb(reset),
                  .web(4'd0), .addrb({2'b0, gfx_oam_addr[31:2]}),
                  .doutb(gfx_oam_data), .dinb(32'b0));

    //assign bus_io_reg_rdata = (~bus_io_reg_read) ? 32'b0 : 32'bz;

    generate
        for (genvar i = 0; i < `NUM_IO_REGS; i++) begin
            localparam [31:0] reg_addr = `IO_REG_RAM_START + (i*4);
            assign IO_reg_en[i] = bus_addr_lat1[31:2] == reg_addr[31:2];
            assign IO_reg_we[i] = (IO_reg_en[i]) ? bus_we : 4'd0;
            if (i == `KEYINPUT_IDX) begin // Read-only for lowest 16 bits
                IO_register16 (.clock, .reset, .wdata(bus_wdata[31:16]),
                               .we(IO_reg_we[i][3:2]),
                               .rdata(IO_reg_datas[i][31:16]));
                IO_reg_datas[i][15:0] = buttons;
            end else if (i == `VCOUNT_IDX) begin // Read-only for upper 16 bits
                IO_register16 (.clock, .reset, .wdata(bus_wdata[15:0]),
                               .we(IO_reg_we[i][1:0]),
                               .rdata(IO_reg_datas[i][15:0]));
                IO_reg_datas[i][31:16] = vcount;
            end else begin
                assign bus_io_reg_rdata = (IO_reg_en[i]) ? IO_reg_datas[i] : 32'bz;
                IO_register32 IO (.clock, .reset, .wdata(bus_wdata),
                                  .we(IO_reg_we[i]), .rdata(IO_reg_datas[i]));
            end
        end
    endgenerate

    always_comb begin
        if (bus_system_read)
            bus_rdata = bus_system_rdata;
        else if (bus_intern_read)
            bus_rdata = bus_intern_rdata;
        else if (bus_vram_A_read)
            bus_rdata = bus_vram_A_rdata;
        else if (bus_vram_B_read)
            bus_rdata = bus_vram_B_rdata;
        else if (bus_vram_C_read)
            bus_rdata = bus_vram_C_rdata;
        else if (bus_palette_bg_read)
            bus_rdata = bus_palette_bg_rdata;
        else if (bus_palette_obj_read)
            bus_rdata = bus_palette_obj_rdata;
        else if (bus_oam_read)
            bus_rdata = bus_oam_rdata;
        else if (bus_io_reg_read)
            bus_rdata = bus_io_reg_rdata;
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

module mem_register
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

endmodule: mem_register


module IO_register32
    (input  logic clock, reset,
     input  logic [31:0] wdata,
     input  logic [3:0]  we,
     output logic [31:0] rdata);

    logic [31:0] data_next;

    assign data_next[7:0] = (we[0]) ? wdata[7:0] : rdata[7:0];
    assign data_next[15:8] = (we[1]) ? wdata[15:8] : rdata[15:8];
    assign data_next[23:16] = (we[2]) ? wdata[23:16] : rdata[23:16];
    assign data_next[31:24] = (we[3]) ? wdata[31:24] : rdata[31:24];

    always_ff @(posedge clock, posedge reset) begin
        if (reset) rdata <= 0;
        else rdata <= data_next;
    end
endmodule: IO_register32


module IO_register16
    (input  logic clock, reset,
     input  logic [15:0] wdata,
     input  logic [1:0]  we,
     output logic [15:0] rdata);

    logic [15:0] data_next;

    assign data_next[7:0] = (we[0]) ? wdata[7:0] : rdata[7:0];
    assign data_next[15:8] = (we[1]) ? wdata[15:8] : rdata[15:8];

    always_ff @(posedge clock, posedge reset) begin
        if (reset) rdata <= 0;
        else rdata <= data_next;
    end
endmodule: IO_register16
