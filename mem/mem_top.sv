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
`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"

module mem_top (
    input  logic clock, reset,

    /* Signals for CPU/DMA Bus */
    input  logic [31:0] bus_addr,
    input  logic [31:0] bus_wdata,
    output logic [31:0] bus_rdata,
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
    output logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0],

    // Values for R/O registers
    input  logic [15:0] buttons, vcount, reg_IF,
    output logic [15:0] int_acks
    );

    /* Single cycle latency for writes */
    logic [31:0] bus_addr_lat1;
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
    logic        bus_system_read;

    logic [31:0] bus_pak_init_1_addr;
    logic        bus_pak_init_1_read;

    logic [31:0] bus_intern_rdata, bus_palette_rdata, bus_vram_rdata;
    logic [31:0] bus_oam_rdata;
    logic  [3:0] bus_we;

    logic [3:0]  IO_reg_we [`NUM_IO_REGS-1:0];
    logic [`NUM_IO_REGS-1:0] IO_reg_en;
    tri0 [31:0] bus_io_reg_rdata;
    logic        bus_io_reg_read;

    logic read_in_intern, read_in_palette, read_in_vram, read_in_oam;
    mem_decoder decoder (.addr(bus_addr_lat1), .size(bus_size_lat1),
                         .write(bus_write_lat1), .byte_we(bus_we));

    assign bus_system_addr = bus_mem_addr;

    assign bus_system_read = bus_addr_lat1[31:24] == 8'h0;

    assign bus_io_reg_read = (bus_addr_lat1 - `IO_REG_RAM_START) <= `IO_REG_RAM_SIZE;

    assign bus_pak_init_1_read = (bus_addr_lat1 - `PAK_INIT_1_START) <= `PAK_INIT_1_SIZE;
    assign bus_pak_init_1_addr = bus_addr_lat1 - `PAK_INIT_1_START;

    // Data width set to 32bits, so addresses are aligned
    system_rom sys   (.clka(clock), .rsta(reset),
                      .addra(bus_system_addr[13:2]),
                      .douta(bus_system_rdata));

    intern_mem intern (.clock, .reset, .bus_addr, .bus_addr_lat1, .bus_wdata,
                       .bus_we, .bus_write_lat1, .bus_rdata(bus_intern_rdata),
                       .read_in_intern);

    palette_mem palette (.clock, .reset, .bus_addr, .bus_addr_lat1, .bus_wdata,
                         .bus_we, .bus_write_lat1, .gfx_palette_bg_addr,
                         .gfx_palette_obj_addr, .gfx_palette_bg_data,
                         .gfx_palette_obj_data, .bus_rdata(bus_palette_rdata),
                         .read_in_palette);

    vram_mem vram (.clock, .reset, .bus_addr, .bus_addr_lat1, .bus_wdata,
                   .bus_we, .bus_write_lat1,
                   .gfx_vram_A_addr, .gfx_vram_A_addr2,
                   .gfx_vram_B_addr, .gfx_vram_C_addr,
                   .gfx_vram_A_data, .gfx_vram_A_data2,
                   .gfx_vram_B_data, .gfx_vram_C_data,
                   .bus_rdata(bus_vram_rdata),
                   .read_in_vram);

    oam_mem oam (.clock, .reset, .bus_addr, .bus_addr_lat1, .bus_wdata,
                 .bus_we, .bus_write_lat1, .gfx_oam_addr, .gfx_oam_data,
                 .bus_rdata(bus_oam_rdata), .read_in_oam);

    generate
        for (genvar i = 0; i < `NUM_IO_REGS; i++) begin
            localparam [31:0] reg_addr = `IO_REG_RAM_START + (i*4);
            assign IO_reg_en[i] = bus_addr_lat1[31:2] == reg_addr[31:2];
            assign IO_reg_we[i] = (IO_reg_en[i]) ? bus_we : 4'd0;
            if (i == `KEYINPUT_IDX) begin // Read-only for lowest 16 bits
                IO_register16 key_high (.clock, .reset, .wdata(bus_wdata[31:16]),
                                        .we(IO_reg_we[i][3:2]), .clear(1'b0),
                                        .rdata(IO_reg_datas[i][31:16]));
                assign IO_reg_datas[i][15:0] = buttons;
            end else if (i == `VCOUNT_IDX) begin // Read-only for upper 16 bits
                IO_register16 vcount_low
                              (.clock, .reset, .wdata(bus_wdata[15:0]),
                               .we(IO_reg_we[i][1:0]), .clear(1'b0),
                               .rdata(IO_reg_datas[i][15:0]));
                assign IO_reg_datas[i][31:16] = vcount;
            end else if (i == `IF_IDX) begin
                // Reads to 0x202 read re_IF
                IO_register16 IE (.clock, .reset, .wdata(bus_wdata[15:0]),
                                  .we(IO_reg_we[i][1:0]), .clear(1'b0),
                                  .rdata(IO_reg_datas[i][15:0]));
                IO_register16 IACK (.clock, .reset, .wdata(bus_wdata[31:16]),
                                    .we(IO_reg_we[i][3:2]), .clear(1'b1),
                                    .rdata(int_acks));
                assign IO_reg_datas[i][31:16] = reg_IF;
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
        else if (read_in_intern)
            bus_rdata = bus_intern_rdata;
        else if (read_in_vram)
            bus_rdata = bus_vram_rdata;
        else if (read_in_palette)
            bus_rdata = bus_palette_rdata;
        else if (read_in_oam)
            bus_rdata = bus_oam_rdata;
        else if (bus_io_reg_read)
            bus_rdata = bus_io_reg_rdata;
        else if (bus_pak_init_1_read)
            bus_rdata = {12'hFFF, bus_pak_init_1_addr[4:2], 1'b1,
                         12'hFFF, bus_pak_init_1_addr[4:2], 1'b0};
        else
            bus_rdata = 32'hz;
    end

endmodule: mem_top

module intern_mem (
    input logic clock, reset,

    input  logic [31:0] bus_addr, bus_addr_lat1, bus_wdata,
    input  logic  [3:0] bus_we,
    input  logic        bus_write_lat1,
    output logic [31:0] bus_rdata,
    output logic        read_in_intern

    );

    logic [31:0] intern_addr, intern_rdata;
    logic  [3:0] intern_we;
    logic        in_intern_lat1;

    assign read_in_intern = in_intern_lat1;
    assign in_intern_lat1 = bus_addr_lat1[31:24] == 8'h03;
    assign intern_addr = (bus_write_lat1) ? bus_addr_lat1 : bus_addr;
    assign intern_we = (in_intern_lat1) ? bus_we : 4'd0;

    assign bus_rdata = (in_intern_lat1) ? intern_rdata : 32'bz;

    InternRAM intern (.clka(clock), .rsta(reset),
                      .wea(intern_we), .addra(intern_addr[14:2]),
                      .douta(intern_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset), .web(4'd0), .addrb(32'b0),
                      .doutb(), .dinb(32'b0));

endmodule: intern_mem


module oam_mem (
    input logic clock, reset,

    input  logic [31:0] bus_addr, bus_addr_lat1, bus_wdata,
    input  logic  [3:0] bus_we,
    input  logic        bus_write_lat1,
    input  logic [31:0] gfx_oam_addr,
    output logic [31:0] gfx_oam_data, bus_rdata,
    output logic        read_in_oam

    );

    logic [31:0] oam_addr, oam_rdata;
    logic  [3:0] oam_we;
    logic        in_oam_lat1;

    assign read_in_oam = in_oam_lat1;
    assign in_oam_lat1 = bus_addr_lat1[31:24] == 8'h07;
    assign oam_addr = (bus_write_lat1) ? bus_addr_lat1 : bus_addr;
    assign oam_we = (in_oam_lat1) ? bus_we : 4'd0;

    assign bus_rdata = (in_oam_lat1) ? oam_rdata : 32'bz;

    OAM oam_mem  (.clka(clock), .rsta(reset),
                  .wea(oam_we), .addra(oam_addr[9:2]),
                  .douta(oam_rdata), .dina(bus_wdata),

                  .clkb(clock), .rstb(reset),
                  .web(4'd0), .addrb(gfx_oam_addr[9:2]),
                  .doutb(gfx_oam_data), .dinb(32'b0));

endmodule: oam_mem

module palette_mem (
    input logic clock, reset,

    input  logic [31:0] bus_addr, bus_addr_lat1, bus_wdata,
    input  logic  [3:0] bus_we,
    input  logic        bus_write_lat1,
    input  logic [31:0] gfx_palette_bg_addr, gfx_palette_obj_addr,
    output logic [31:0] gfx_palette_bg_data, gfx_palette_obj_data,
    output logic [31:0] bus_rdata,
    output logic        read_in_palette
    );

    logic [31:0] palette_bg_addr, palette_obj_addr;
    logic [31:0] palette_bg_rdata, palette_obj_rdata;
    logic  [3:0] palette_bg_we, palette_obj_we;
    logic        in_palette_lat1, in_palette_bg_lat1, in_palette_obj_lat1;

    assign read_in_palette = in_palette_lat1;
    assign in_palette_lat1 = bus_addr_lat1[31:24] == 8'h05;
    assign in_palette_bg_lat1 = in_palette_lat1 &
                                (bus_addr_lat1[9:0] <= 10'h1FF);
    assign in_palette_obj_lat1 = in_palette_lat1 &
                           (bus_addr_lat1[9:0] <= 10'h3FF) &
                           (10'h200 <= bus_addr_lat1[9:0]);

    assign palette_bg_addr = (bus_write_lat1) ? bus_addr_lat1 : bus_addr;
    assign palette_obj_addr = (bus_write_lat1) ?
                               bus_addr_lat1 - `PALETTE_OBJ_RAM_START :
                               bus_addr - `PALETTE_OBJ_RAM_START;

    assign palette_bg_we = (in_palette_bg_lat1) ? bus_we : 4'd0;
    assign palette_obj_we = (in_palette_obj_lat1) ? bus_we : 4'd0;

    always_comb begin
        if (in_palette_bg_lat1)
            bus_rdata = palette_bg_rdata;
        else if (in_palette_obj_lat1)
            bus_rdata = palette_obj_rdata;
        else
            bus_rdata = 32'bz;
    end

    palette_bg_ram pall_bg (.clka(clock), .rsta(reset),
                            .wea(palette_bg_we),
                            .addra(palette_bg_addr[8:2]),
                            .douta(palette_bg_rdata), .dina(bus_wdata),

                            .clkb(clock), .rstb(reset),
                            .web(4'd0),
                            .addrb(gfx_palette_bg_addr[8:2]),
                            .doutb(gfx_palette_bg_data), .dinb(32'b0));

    palette_obj_ram pall_obj (.clka(clock), .rsta(reset),
                              .wea(palette_obj_we),
                              .addra(palette_obj_addr[8:2]),
                              .douta(palette_obj_rdata), .dina(bus_wdata),

                              .clkb(clock), .rstb(reset),
                              .web(4'd0),
                              .addrb(gfx_palette_obj_addr[8:2]),
                              .doutb(gfx_palette_obj_data), .dinb(32'b0));

endmodule: palette_mem

module vram_mem (
    input  logic clock, reset,

    input  logic [31:0] bus_addr, bus_addr_lat1, bus_wdata,
    input  logic  [3:0] bus_we,
    input  logic        bus_write_lat1,
    input  logic [31:0] gfx_vram_A_addr, gfx_vram_A_addr2,
    input  logic [31:0] gfx_vram_B_addr, gfx_vram_C_addr,
    output logic [31:0] gfx_vram_A_data, gfx_vram_A_data2,
    output logic [31:0] gfx_vram_B_data, gfx_vram_C_data,
    output logic [31:0] bus_rdata,
    output logic        read_in_vram
    );

    logic [31:0] vram_A_addr, vram_B_addr, vram_C_addr;
    logic [31:0] vram_A_rdata, vram_B_rdata, vram_C_rdata;
    logic [3:0] vram_A_we, vram_B_we, vram_C_we;
    logic       in_vram_lat1;
    logic       in_vram_A_lat1, in_vram_B_lat1, in_vram_C_lat1;

    assign read_in_vram = in_vram_lat1;
    assign in_vram_lat1 = bus_addr_lat1[31:24] == 8'h06;
    assign in_vram_A_lat1 = in_vram_lat1 &
                            (bus_addr_lat1[16:0] <= 17'hFFFF);
    assign in_vram_B_lat1 = in_vram_lat1 &
                            (bus_addr_lat1[16:0] <= 17'h13FFF) &
                            (17'h10000 <= bus_addr_lat1[16:0]);
    assign in_vram_C_lat1 = in_vram_lat1 &
                            (bus_addr_lat1[16:0] <= 17'h17FFF) &
                            (17'h14000 <= bus_addr_lat1[16:0]);

    assign vram_A_addr = (bus_write_lat1) ? bus_addr_lat1 : bus_addr;
    assign vram_B_addr = (bus_write_lat1) ? bus_addr_lat1 - `VRAM_B_START :
                         bus_addr - `VRAM_B_START;
    assign vram_C_addr = (bus_write_lat1) ? bus_addr_lat1 - `VRAM_C_START :
                          bus_addr - `VRAM_C_START;

    assign vram_A_we = (in_vram_A_lat1) ? bus_we : 4'd0;
    assign vram_B_we = (in_vram_B_lat1) ? bus_we : 4'd0;
    assign vram_C_we = (in_vram_C_lat1) ? bus_we : 4'd0;

    always_comb begin
        if (in_vram_A_lat1)
            bus_rdata = vram_A_rdata;
        else if (in_vram_B_lat1)
            bus_rdata = vram_B_rdata;
        else if (in_vram_C_lat1)
            bus_rdata = vram_C_rdata;
        else
            bus_rdata = 32'bz;
    end

    vram_A vram_A    (.clka(clock), .rsta(reset),
                      .wea(vram_A_we), .addra(vram_A_addr[15:2]),
                      .douta(vram_A_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb(gfx_vram_A_addr[15:2]),
                      .doutb(gfx_vram_A_data), .dinb(32'b0));

    vram_A_2 vram_A_2 (.clka(clock), .rsta(reset),
                      .wea(vram_A_we), .addra(vram_A_addr[15:2]),
                      .douta(), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb(gfx_vram_A_addr2[15:2]),
                      .doutb(gfx_vram_A_data2), .dinb(32'b0));

    vram_B vram_B    (.clka(clock), .rsta(reset),
                      .wea(vram_B_we), .addra(vram_B_addr[13:2]),
                      .douta(vram_B_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb(gfx_vram_B_addr[13:2]),
                      .doutb(gfx_vram_B_data), .dinb(32'b0));

    vram_C vram_C    (.clka(clock), .rsta(reset),
                      .wea(vram_C_we), .addra(vram_C_addr[13:2]),
                      .douta(vram_C_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset),
                      .web(4'd0), .addrb(gfx_vram_C_addr[13:2]),
                      .doutb(gfx_vram_C_data), .dinb(32'b0));

endmodule: vram_mem

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

// WE has priority over clear
module IO_register16
    (input  logic clock, reset,
     input  logic [15:0] wdata,
     input  logic [1:0]  we,
     output logic [15:0] rdata,
     input  logic        clear);

    logic [15:0] data_next;

    assign data_next[7:0] = (we[0]) ? wdata[7:0] : (clear) ? 8'd0 : rdata[7:0];
    assign data_next[15:8] = (we[1]) ? wdata[15:8] : (clear) ? 8'd0 : rdata[15:8];

    always_ff @(posedge clock, posedge reset) begin
        if (reset) rdata <= 0;
        else rdata <= data_next;
    end
endmodule: IO_register16
