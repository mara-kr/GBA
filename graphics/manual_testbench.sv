`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"

module manual_bench (
    input  logic [7:0] SW,
    output logic [3:0] VGA_R, VGA_G, VGA_B,
    input  logic       BTND,
    input  logic       GCLK);


    logic [15:0] winin;
    logic [15:0] winout;
    logic [15:0] dispcnt;
    logic [15:0] win0H;
    logic [15:0] win1H;
    logic [15:0] win0V;
    logic [15:0] win1V;
    logic [15:0] bldcnt;
    logic [15:0] bldalpha;
    logic [15:0] bldy;
    logic [7:0] vcount;
    logic [15:0] bg0cnt;
    logic [15:0] bg1cnt;
    logic [15:0] bg2cnt;
    logic [15:0] bg3cnt;
    logic [15:0] bg0hofs;
    logic [15:0] bg1hofs;
    logic [15:0] bg2hofs;
    logic [15:0] bg3hofs;
    logic [15:0] bg0vofs;
    logic [15:0] bg1vofs;
    logic [15:0] bg2vofs;
    logic [15:0] bg3vofs;
    logic [27:0] bg2x;
    logic [27:0] bg3x;
    logic [27:0] bg2y;
    logic [27:0] bg3y;
    logic [15:0] bg2pa;
    logic [15:0] bg2pb;
    logic [15:0] bg2pc;
    logic [15:0] bg3pd;
    logic [15:0] mosaic;

    input logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0],

    logic clock, reset;

    assign reset = BTND;

    assign IO_reg_datas[`WININ_IDX][15:0] = winin;
    assign IO_reg_datas[`WINOUT_IDX][31:16] = winout;
    assign IO_reg_datas[`DISPCNT_IDX][15:0] = dispcnt; //
    assign IO_reg_datas[`WIN0H_IDX][15:0] = win0H;
    assign IO_reg_datas[`WIN1H_IDX][31:16] = win1H;
    assign IO_reg_datas[`WIN0V_IDX][15:0] = win0V;
    assign IO_reg_datas[`WIN1V_IDX][31:16] = win1V;
    assign IO_reg_datas[`VCOUNT_IDX][7:0] = vcount;
    assign IO_reg_datas[`BLDCNT_IDX][15:0] = bldcnt;
    assign IO_reg_datas[`BLDALPHA_IDX][31:16] = bldalpha;
    assign IO_reg_datas[`BLDY_IDX][15:0] = bldy;
    
    assign IO_reg_datas[`BG0CNT_IDX][15:0] = bg0cnt;
    assign IO_reg_datas[`BG1CNT_IDX][31:16] = bg1cnt;
    assign IO_reg_datas[`BG2CNT_IDX][15:0] = bg2cnt;
    assign IO_reg_datas[`BG3CNT_IDX][31:0] = bg3cnt;
    
    assign IO_reg_datas[`BG0HOFS_IDX][15:0] = bg0hofs;
    assign IO_reg_datas[`BG1HOFS_IDX][15:0] = bg1hofs;
    assign IO_reg_datas[`BG2HOFS_IDX][15:0] = bg2hofs;
    assign IO_reg_datas[`BG3HOFS_IDX][15:0] = bg3hofs;
    
    assign IO_reg_datas[`BG0VOFS_IDX][31:16] = bg0vofs;
    assign IO_reg_datas[`BG1VOFS_IDX][31:16] = bg1vofs;
    assign IO_reg_datas[`BG2VOFS_IDX][31:16] = bg2vofs;
    assign IO_reg_datas[`BG3VOFS_IDX][31:16] = bg3vofs;

    assign IO_reg_datas[`BG2X_L_IDX][27:0] = bg2x;
    assign IO_reg_datas[`BG3X_L_IDX][27:0] = bg3x;
    assign IO_reg_datas[`BG2Y_L_IDX][27:0] = bg2y;
    assign IO_reg_datas[`BG3Y_L_IDX][27:0] = bg3y;

    assign IO_reg_datas[`BG2PA_IDX][15:0] = bg2pa;
    assign IO_reg_datas[`BG2PA_IDX][31:16] = bg2pb;
    assign IO_reg_datas[`BG2PA_IDX][15:0] = bg2pc;
    assign IO_reg_datas[`BG2PA_IDX][31:16] = bg2pd;
    assign IO_reg_datas[`BG2PA_IDX][15:0] = bg3pa;
    assign IO_reg_datas[`BG2PA_IDX][31:16] = bg3pb;
    assign IO_reg_datas[`BG2PA_IDX][15:0] = bg3pc;
    assign IO_reg_datas[`BG2PA_IDX][31:16] = bg3pd;
    assign IO_reg_datas[`MOSAIC_IDX][15:0] = mosaic;
    
    assign dispcnt = {3'b111, SW[4:0], 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 3'b001};
    //no windows
    //display layers specified by switches
    //no forced blank
    //1-dimensional obj vram
    //enable hblank processing
    //display bitmap frame 0
    //bg mode 001 - BG 0 & 1 are char bgs, BG2 is rotation/scaling

    assign bg0cnt = {2'b0, 1'b0, 5'b0, 1'b0, SW[5], 2'b00, 2'b11};
    //256x256 char background
    //screen base block 0
    //16-bit color
    //mosaic if SW[5]
    //character base block 1
    //priority = 11 (lowest priority)

    assign bg1cnt = {2'b0, 1'b0, 5'd2, 1'b1, SW[5], 2'b00, 2'b11};
    //256x256 char background
    //screen base block 2
    //256-bit color
    //mosaic if SW[5]
    //character base block 1
    //priority = 10 (second lowest priority)

    assign bg2cnt = {2'b0, 1'b0, 5'd2, 1'b1, 1'b0, 2'b00, 2'b11};
    //256x256 char background
    //no wraparound
    //screen base block 6
    //256-bit color
    //no mosaic
    //character base block 1
    //priority = 10 (second lowest priority)

    assign bg3cnt = {2'b0, 1'b0, 5'd2, 1'b1, SW[5], 2'b00, 2'b11};
    //256x256 char background
    //screen base block 4
    //16-bit color
    //mosaic if SW[5]
    //character base block 1
    //priority = 00 (highest priority)

    assign mosaic = 16'h3333; // 4x mosaicing in all directions for BG and OBJ

    assign bg0hofs = 16'b0;
    assign bg1hofs = 16'b0;
    assign bg2hofs = 16'b0;
    assign bg3hofs = 16'b0;
    assign bg0vofs = 16'b0;
    assign bg1vofs = 16'b0;
    assign bg2vofs = 16'b0;
    assign bg3vofs = 16'b0;

    //default BG2 to no rotation
    //rotate 45 degrees if SW[6] is set 
    assign bg2pa = SW[6] ? : 16'h005A;
    assign bg2pb = SW[6] ? : 16'h805A;
    assign bg2pc = SW[6] ? : 16'h005A;
    assign bg2pd = SW[6] ? : 16'h005A;

endmodule: manual_bench
