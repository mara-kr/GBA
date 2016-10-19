`default_nettype none
`include "core_tb_defines.vh"

module mem_test_CI (
    input  logic GCLK, BTND,
    output logic [7:0] LD);

    logic [31:0] bus_addr, bus_wdata, bus_rdata;
    logic  [1:0] bus_size;
    logic        bus_pause, bus_write;

    logic [31:0] gfx_addr, gfx_data;
    logic  [1:0] gfx_size;
    logic        gfx_pause;

    logic [7:0] LD_next;

    mem_top mem (.clock(GCLK), .reset(BTND), .bus_wdata, .bus_rdata,
                 .bus_addr, .bus_size, .bus_pause, .bus_write,
                 .gfx_addr, .gfx_data, .gfx_size, .gfx_pause);

    enum logic [1:0] {WADDR, WDATA, RADDR, RDATA} cs, ns, cs_next;
    logic [31:0] addrs [14:0];
    logic [31:0] datas [14:0];
    logic [3:0] count, count_next;
    logic       en, clr, fail;

    assign addrs = {32'h0000_0000, 32'h0000_1234, 32'h0000_3FFF,
                    32'h0300_0000, 32'h0300_1234, 32'h0300_7FFF,
                    32'h0500_0000, 32'h0500_0042, 32'h0500_03FF,
                    32'h0600_0000, 32'h0600_1234, 32'h0601_7FFF,
                    32'h0700_0000, 32'h0700_0042, 32'h0700_03FF};

    assign datas = {32'hdead_beef, 32'hcafe_f00d, 32'hcafe_bebe,
                    32'hbeef_bebe, 32'hbeef_f00d, 32'hdead_bebe,
                    32'hdead_f00d, 32'hba5e_ba11, 32'hcab0_05e5,
                    32'hc0ff_ee55, 32'he5ce_ca1d, 32'h5ece_de00,
                    32'hdef1_ec7e, 32'hdea1_10c8, 32'hca11_ab1e};

    assign bus_size = `MEM_SIZE_WORD;
    assign gfx_size = `MEM_SIZE_WORD;
    assign gfx_addr = 32'd0;
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
            cs <= WADDR;
        end else begin
            count <= count_next;
            cs <= cs_next;
        end
    end

   assign LD_next = (fail) ? 8'hf0 : LD;

    always_ff @(posedge GCLK, posedge BTND) begin
        if (BTND) begin
            LD <= 8'hff;
        end else begin
            LD <= LD_next;
        end
    end

    assign bus_wdata = datas[count];
    assign bus_addr = addrs[count];

    always_comb begin
        bus_write = 1'b0;
        en = 1'b0;
        fail = 1'b0;
        clr = 1'b0;
        case (cs)
            WADDR: begin
                bus_write = 1'b1;
                ns = WDATA;
            end
            WDATA: begin
                en = 1'b1;
                ns = (count == 4'he) ? RADDR : WADDR;
                clr = (count == 4'he) ? 1'b1 : 1'b0;
            end
            RADDR: begin
                ns = RDATA;
            end
            RDATA: begin
                en = 1'b1;
                fail = (bus_rdata != datas[count]) & (count > 4'd2);
                ns = (count == 4'he) ? WADDR : RADDR;
                clr = (count == 4'he) ? 1'b1 : 1'b0;
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
