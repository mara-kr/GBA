/* mem_test.sv
 *
 * Module to test memory controller for BRAM. Does NUM_TESTS consecutive
 * writes then NUM_TESTS consecutive reads. Alternates half-words and
 * words. Only tests the bus ports, since the interfaces to the BRAM
 * are exposed.
 *
 * Neil Ryan
 */
`default_nettype none
`include "gba_core_defines.vh"

`define NUM_TESTS 22

module mem_test_CI (
    input  logic GCLK, BTND,
    output logic [7:0] LD);

    logic [31:0] bus_addr, bus_wdata, bus_rdata;
    logic  [1:0] bus_size;
    logic        bus_pause, bus_write;

    logic [31:0] gfx_oam_addr, gfx_oam_data, gfx_vram_A_addr, gfx_vram_A_data;
    logic [31:0] gfx_vram_B_addr, gfx_vram_B_data;
    logic [31:0] gfx_vram_C_addr, gfx_vram_C_data;
    logic [31:0] gfx_palette_obj_addr, gfx_palette_obj_data;
    logic [31:0] gfx_palette_bg_addr, gfx_palette_bg_data;

    logic [7:0] LD_next;

    mem_top mem (.clock(GCLK), .reset(BTND), .bus_wdata, .bus_rdata,
                 .bus_addr, .bus_size, .bus_pause, .bus_write,
                 .gfx_palette_bg_addr, .gfx_palette_bg_data,
                 .gfx_palette_obj_addr, .gfx_palette_obj_data,
                 .gfx_oam_addr, .gfx_oam_data,
                 .gfx_vram_A_addr, .gfx_vram_A_data,
                 .gfx_vram_B_addr, .gfx_vram_B_data,
                 .gfx_vram_C_addr, .gfx_vram_C_data
             );

    enum logic {WRITE, READ} cs, ns, cs_next;
    logic [31:0] addrs [23:0];
    logic [31:0] datas [23:0];
    logic [3:0] count, count_next;
    logic       en, clr, fail;

    assign addrs = {32'h0000_0000, 32'h0000_0000, 32'h0700_0225,
                    32'h0600_0000, 32'h0500_0042, 32'h0700_03FF,
                    32'h0500_0000, 32'h0300_1234, 32'h0601_7FFF,
                    32'h0700_0000, 32'h0700_0042, 32'h0500_03FF,
                    32'h0300_0000, 32'h0600_1234, 32'h0300_7FFF,
                    32'h0500_0250, 32'h0500_01ff, 32'h0600_FFFF,
                    32'h0601_0000, 32'h0601_3fff, 32'h0601_4000,
                    32'h0601_4200, 32'h0601_1234, 32'h0500_0200};

    assign datas = {32'h0000_0000, 32'h0000_0000, 32'hface_f00d,
                    32'hdead_beef, 32'hcafe_f00d, 32'hcafe_bebe,
                    32'hbeef_bebe, 32'hbeef_f00d, 32'hdead_bebe,
                    32'hdead_f00d, 32'hba5e_ba11, 32'hcab0_05e5,
                    32'hc0ff_ee55, 32'he5ce_ca1d, 32'h5ece_de00,
                    32'hbeef_bebe, 32'hbeef_f00d, 32'hdead_bebe,
                    32'hdead_f00d, 32'hba5e_ba11, 32'hcab0_05e5,
                    32'hc0ff_ee55, 32'he5ce_ca1d, 32'h5ece_de00
                    };

    assign bus_size = count[0] ? `MEM_SIZE_WORD : `MEM_SIZE_HALF;
    assign gfx_palette_obj_addr = 32'b0;
    assign gfx_palette_bg_addr = 32'b0;
    assign gfx_oam_addr = 32'b0;
    assign gfx_vram_A_addr = 32'b0;
    assign gfx_vram_B_addr = 32'b0;
    assign gfx_vram_C_addr = 32'b0;
    assign cs_next = (~bus_pause) ? ns : cs;

    always_comb begin
        count_next = count;
        if (~bus_pause) begin
            if (clr) count_next = 4'd0;
            else if (en) count_next = count + 4'd1;
        end
    end

    always_ff @(posedge GCLK, posedge BTND) begin
        if (BTND) begin
            count <= 4'd0;
            cs <= WRITE;
        end else begin
            count <= count_next;
            cs <= cs_next;
        end
    end

   (* mark_debug = "true" *) assign LD_next = (fail) ? 8'hf0 : LD;

    always_ff @(posedge GCLK, posedge BTND) begin
        if (BTND) begin
            LD <= 8'hff;
        end else begin
            LD <= LD_next;
        end
    end

    assign bus_wdata = datas[count-1];
    assign bus_addr = addrs[count];

    always_comb begin
        bus_write = 1'b0;
        en = 1'b0;
        fail = 1'b0;
        clr = 1'b0;
        ns = WRITE;
        case (cs)
            WRITE: begin
                bus_write = (count != `NUM_TESTS);
                ns = (count == `NUM_TESTS) ? READ : WRITE;
                en = 1'b1;
                clr = (count == `NUM_TESTS);
            end
            READ: begin
                en = 1'b1;
                if (~count[0]) begin // Wrote word
                    fail = (bus_rdata != datas[count-1]) && (count > 4'd0);
                end else begin
                    if (addrs[count-1][1]) begin // Top half written to
                        fail = (datas[count-1][31:16] != bus_rdata[31:16]) ||
                               (bus_rdata[15:0] != 16'd0);
                    end else begin // bottom half written to
                        fail = (datas[count-1][15:0] != bus_rdata[15:0]) ||
                                                   (bus_rdata[31:16] != 16'd0);
                    end
                end
                ns = (count == `NUM_TESTS) ? WRITE : READ;
                clr = (count == `NUM_TESTS);
            end
        endcase
    end

endmodule: mem_test_CI

/*
module sim_top;
    logic GCLK, BTND;
    logic [7:0] LD;

    mem_test_CI dut (.*);

    initial begin
        BTND = 1'b0;
        GCLK = 1'b0;
        #1 BTND <= 1'b1;
        #1 BTND <= 1'b0;
        forever #1 GCLK <= ~GCLK;
    end

    initial begin
        #300 $finish;
    end
endmodule: sim_top

*/
