// TODO Test BRAM
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
    input  logic [31:0] gfx_addr,
    output logic [31:0] gfx_data,
    input  logic  [1:0] gfx_size,
    output logic        gfx_pause

    );

    /* Single cycle latency for writes */
    logic [31:0] bus_addr_lat1, bus_mem_addr;
    logic  [1:0] bus_size_lat1;
    logic        bus_write_lat1;

    // Could add more pauses for memory regions, this is needed
    // because of the CPU's write format
    assign bus_pause = bus_write_lat1;
    assign gfx_pause = 1'b0;
    // Use delayed memory address on writes
    assign bus_mem_addr = (bus_write_lat1) ? {2'b0, bus_addr_lat1[31:2]} :
                                             {2'b0, bus_addr[31:2]};

    // Registers to delay write signals
    always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            bus_addr_lat1 <= 32'd0;
            bus_write_lat1 <= 1'b0;
            bus_size_lat1 <= 2'b0;
        end else begin
            bus_addr_lat1 <= bus_addr;
            bus_write_lat1 <= bus_write;
            bus_size_lat1 <= bus_size;
        end
    end

    logic [31:0] bus_system_addr, bus_system_rdata, gfx_system_addr;
    logic [31:0] gfx_system_rdata;
    logic        bus_system_valid, gfx_system_valid;

    logic [31:0] bus_intern_addr, bus_intern_rdata, gfx_intern_addr;
    logic [31:0] gfx_intern_rdata;
    logic  [3:0] bus_intern_we;
    logic        bus_intern_valid, gfx_intern_valid;

    logic [31:0] bus_vram_addr, bus_vram_rdata, gfx_vram_addr;
    logic [31:0] gfx_vram_rdata;
    logic  [3:0] bus_vram_we;
    logic        bus_vram_valid, gfx_vram_valid;

    logic [31:0] bus_pallete_addr, bus_pallete_rdata, gfx_pallete_addr;
    logic [31:0] gfx_pallete_rdata;
    logic  [3:0] bus_pallete_we;
    logic        bus_pallete_valid, gfx_pallete_valid;

    logic [31:0] bus_oam_addr, bus_oam_rdata, gfx_oam_addr;
    logic [31:0] gfx_oam_rdata;
    logic  [3:0] bus_oam_we;
    logic        bus_oam_valid, gfx_oam_valid;

    logic  [3:0] bus_we;

    mem_decoder decoder (.addr(bus_addr_lat1), .size(bus_size_lat1),
                         .write(bus_write_lat1), .byte_we(bus_we));

    assign bus_system_addr = bus_mem_addr;
    assign gfx_system_addr = gfx_addr;
    assign bus_intern_addr = bus_mem_addr - `INTERN_RAM_START;
    assign gfx_intern_addr = gfx_addr - `INTERN_RAM_START;
    assign bus_vram_addr = bus_mem_addr - `VRAM_START;
    assign gfx_vram_addr = gfx_addr - `VRAM_START;
    assign bus_pallete_addr = bus_mem_addr - `PALLET_RAM_START;
    assign gfx_pallete_addr = gfx_addr - `PALLET_RAM_START;
    assign bus_oam_addr = bus_mem_addr - `OAM_START;
    assign gfx_oam_addr = gfx_addr - `OAM_START;

    /* Add reset, so that resets go through */
    assign bus_system_valid = (bus_system_addr < `SYSTEM_ROM_SIZE) | reset;
    assign gfx_system_valid = (gfx_system_addr < `SYSTEM_ROM_SIZE) | reset;
    assign bus_intern_valid = (bus_intern_addr < `INTERN_RAM_SIZE) | reset;
    assign gfx_intern_valid = (gfx_intern_addr < `INTERN_RAM_SIZE) | reset;
    assign bus_vram_valid = (bus_vram_addr < `VRAM_SIZE) | reset;
    assign gfx_vram_valid = (gfx_vram_addr < `VRAM_SIZE) | reset;
    assign bus_pallete_valid = (bus_pallete_addr < `PALLET_RAM_SIZE) | reset;
    assign gfx_pallete_valid = (gfx_pallete_addr < `PALLET_RAM_SIZE) | reset;
    assign bus_oam_valid = (bus_oam_addr < `OAM_SIZE) | reset;
    assign gfx_oam_valid = (gfx_oam_addr < `OAM_SIZE) | reset;


    /* When enable is deasserted, no write/read/reset is performed */

    system_rom sys   (.clka(clock), .rsta(reset), .ena(bus_system_valid),
                      .addra(bus_system_addr),
                      .douta(bus_system_rdata),

                      .clkb(clock), .rstb(reset), .enb(gfx_system_valid),
                      .addrb(gfx_system_addr),
                      .doutb(gfx_system_rdata));

    InternRAM intern (.clka(clock), .rsta(reset), .ena(bus_intern_valid),
                      .wea(bus_we), .addra(bus_intern_addr),
                      .douta(bus_intern_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset), .enb(gfx_intern_valid),
                      .web(4'd0), .addrb(gfx_intern_addr),
                      .doutb(gfx_intern_rdata), .dinb(32'b0));

    vram vram_mem    (.clka(clock), .rsta(reset), .ena(bus_vram_valid),
                      .wea(bus_we), .addra(bus_vram_addr),
                      .douta(bus_vram_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset), .enb(gfx_vram_valid),
                      .web(4'd0), .addrb(gfx_vram_addr),
                      .doutb(gfx_vram_rdata), .dinb(32'b0));

    palette_ram pall (.clka(clock), .rsta(reset), .ena(bus_pallete_valid),
                      .wea(bus_we), .addra(bus_pallete_addr),
                      .douta(bus_pallete_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset), .enb(gfx_pallete_valid),
                      .web(4'd0), .addrb(gfx_pallete_addr),
                      .doutb(gfx_pallete_rdata), .dinb(32'b0));

    OAM oam_mem      (.clka(clock), .rsta(reset), .ena(bus_oam_valid),
                      .wea(bus_we), .addra(bus_oam_addr),
                      .douta(bus_oam_rdata), .dina(bus_wdata),

                      .clkb(clock), .rstb(reset), .enb(gfx_oam_valid),
                      .web(4'd0), .addrb(gfx_pallete_addr),
                      .doutb(gfx_oam_rdata), .dinb(32'b0));


    always_comb begin
        if (bus_system_valid)
            bus_rdata = bus_system_rdata;
        else if (bus_intern_valid)
            bus_rdata = bus_intern_rdata;
        else if (bus_vram_valid)
            bus_rdata = bus_vram_rdata;
        else if (bus_pallete_valid)
            bus_rdata = bus_pallete_rdata;
        else if (bus_oam_valid)
            bus_rdata = bus_oam_rdata;
        else
            bus_rdata = 32'hffffffff;
    end

    always_comb begin
        if (gfx_system_valid)
            gfx_data = gfx_system_rdata;
        else if (gfx_intern_valid)
            gfx_data = gfx_intern_rdata;
        else if (gfx_vram_valid)
            gfx_data = gfx_vram_rdata;
        else if (gfx_pallete_valid)
            gfx_data = gfx_pallete_rdata;
        else if (gfx_oam_valid)
            gfx_data = gfx_oam_rdata;
        else
            gfx_data = 32'hffffffff;
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
