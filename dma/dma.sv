`default_nettype none
`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"



module dma_fsm
  (input  logic start, mem_wait, dma_repeat, preempted, enable, xferDone, genIRQ,
   input  logic allowed_to_begin, new_transfer,
   output logic loadCNT, loadSAD, loadDAD, stepSRC, stepDEST, storeRData,
   output logic active, write, disable_dma, set_wdata,
   output logic irq, others_cant_preempt,
   input  logic clk, rst_b);

  enum logic [2:0] {OFF, IDLE, QUEUED, READ, WRITE, PREEMPTEDREAD} cs, ns;

  always_ff @(posedge clk, negedge rst_b) begin
    if(~rst_b)
      cs <= OFF;
    else
      cs <= ns;
  end

  always_comb begin
    set_wdata = 1'b0;
    loadCNT = 1'b0;
    loadSAD = 1'b0;
    loadDAD = 1'b0;
    stepSRC = 1'b0;
    stepDEST = 1'b0;
    storeRData = 1'b0;
    active = 1'b0;
    write = 1'b0;
    disable_dma = 1'b0;
    irq = 1'b0;
    others_cant_preempt = 1'b0;
    ns = OFF;
    case(cs)
      OFF: begin
        if(enable && new_transfer) begin
          loadSAD = 1'b1;
          loadDAD = 1'b1;
          loadCNT = 1'b1;
          ns = IDLE;
        end
      end
      IDLE: begin
        if(enable) begin
          if(start) begin
            if(preempted || mem_wait) begin //start & (preempted || mem_wait)
              ns = QUEUED;
            end
            else if (allowed_to_begin) begin
              ns = READ;
              active = 1'b1;
            end
            else begin
                ns = IDLE;
            end
          end
          else begin //~start
            ns = IDLE;
          end
        end
      end
      QUEUED: begin
        if(enable) begin
          if(preempted || mem_wait) begin
            ns = QUEUED;
          end
          else if (allowed_to_begin) begin
            ns = READ;
            active = 1'b1;
          end
          else begin
              ns = QUEUED;
          end
        end
      end
      READ: begin
        if(mem_wait) begin
          ns = READ;
          active = 1'b1;
        end
        else if(enable) begin
          ns = WRITE;
          others_cant_preempt = 1'b1;
          storeRData = 1'b1;
          active = 1'b1;
          stepSRC = 1'b1;
          write = 1'b1;
        end
      end
      WRITE: begin
        set_wdata = 1'b1;
        if(mem_wait) begin
          ns = WRITE;
          active = 1'b1;
        end
        else if(enable) begin
          if(xferDone & dma_repeat) begin
            ns = IDLE;
            irq = genIRQ;
          end
          else if(xferDone) begin
            ns = OFF;
            disable_dma = 1'b1;
            irq = genIRQ;
          end
          else if(preempted) begin
            ns = PREEMPTEDREAD;
            stepDEST = 1'b1;
          end
          else begin
            ns = READ;
            active = 1'b1;
            stepDEST = 1'b1;
          end
        end
      end
      PREEMPTEDREAD: begin
        if(enable) begin
          if(preempted || mem_wait) begin
            ns = PREEMPTEDREAD;
          end
          else if (allowed_to_begin) begin
            ns = READ;
            active = 1'b1;
          end
          else begin 
              ns= PREEMPTEDREAD;
          end
        end
      end
  
  endcase
  end

endmodule: dma_fsm

module dma_dp
  (input  logic loadCNT, loadSAD, loadDAD,
   input  logic stepSRC, stepDEST, storeRData,
   input  logic active, write, set_wdata,
   input  logic srcGamePak, destGamePak,

   output logic xferDone, new_transfer,

   input  logic [15:0] srcAddrL, srcAddrH,
   input  logic [15:0] destAddrL, destAddrH,
   input  logic [15:0] controlL, controlH,
   input  logic sound, //Can this dma unit handle sound xfers?

   inout  tri   [31:0] rdata,
   inout  tri   [31:0] addr,
   inout  tri   [31:0] wdata,
   inout  tri   [1:0]  size,
   inout  tri          wen,
   
   input  logic clk, rst_b
   );

  logic [31:0] old_SAD_reg;
  logic [31:0] old_DAD_reg;
  logic [31:0] old_CTL_reg;

  logic [31:0] sAddr, dAddr;
  logic [31:0] steppedSAddr, steppedDAddr;
  logic [31:0]  nextSAddr, nextDAddr;
  logic [31:0] desiredAddr;
  logic [31:0] sAddrRaw, dAddrRaw;
  logic [31:0] data;
  logic [13:0] xfers;
  logic [13:0] wordCount;

  logic xferWord;
  logic [31:0] addrStep;
  logic [31:0] targetAddr;
  logic [1:0] sCnt, dCnt;

  logic reloadDad;
  logic sadEnable;
  logic dadEnable;
  logic [1:0] size_mem_transfer;

  assign xferWord = controlH[10];
  assign size_mem_transfer = (xferWord) ? 2'b10 : 2'b01;

  assign sAddr = {4'b0, srcGamePak & sAddrRaw[27], sAddrRaw[26:0]};
  assign dAddr = {4'b0, destGamePak & dAddrRaw[27], dAddrRaw[26:0]};

  assign sadEnable = loadSAD | stepSRC;
  assign dadEnable = loadDAD | stepDEST | (loadCNT & reloadDad);

  always_comb begin //next state logic for addresses
    reloadDad = (dCnt == 2'b11);
    addrStep = xferWord ? 32'd4 : 32'd2;
    case(sCnt)
      2'b00: steppedSAddr = sAddr + addrStep;
      2'b01: steppedSAddr = sAddr - addrStep;
      2'b10: steppedSAddr = sAddr;
      2'b11: steppedSAddr = sAddr + addrStep;
    endcase
    case(dCnt)
      2'b00: steppedDAddr = dAddr + addrStep;
      2'b01: steppedDAddr = dAddr - addrStep;
      2'b10: steppedDAddr = dAddr;
      2'b11: steppedDAddr = dAddr + addrStep;
    endcase
  end

  //Handle special dma modes
  always_comb begin
    sCnt = controlH[8:7];
    dCnt = controlH[6:5];
    targetAddr = {destAddrH, destAddrL};
    if(&controlH[13:12]) begin
      if(sound) begin
        dCnt = 2'b10;
      end
      else begin
        targetAddr = 32'h0600_0000;
      end
    end
  end

  assign addr = active ? desiredAddr : {32{1'bz}};
  assign wen = active ? write : 1'bz;
  assign wdata = (set_wdata) ? data : {32{1'bz}};
  assign size = active ? (size_mem_transfer): {32{1'bz}};

  mux_2_to_1 #(32) srcAddrMux (.i0(steppedSAddr), .i1({srcAddrH, srcAddrL}), .s(loadSAD), .y(nextSAddr));
  mux_2_to_1 #(32) destAddrMux (.i0(steppedDAddr), .i1(targetAddr), .s(loadDAD | (loadCNT & reloadDad)), .y(nextDAddr));
  mux_2_to_1 #(32) addrMux (.i0(sAddr), .i1(dAddr), .s(wen), .y(desiredAddr));

  register #(32) sad(.d(nextSAddr), .q(sAddrRaw), .clk, .clear(1'b0), .enable(sadEnable), .rst_b);
  register #(32) dad(.d(nextDAddr), .q(dAddrRaw), .clk, .clear(1'b0), .enable(dadEnable), .rst_b);
  register #(32) data_reg(.d(rdata), .q(data), .clk, .clear(1'b0), .enable(storeRData), .rst_b);
  counter #(14) xferCnt (.d(14'b0), .q(xfers), .clk, .enable(stepSRC), .clear(loadCNT), .load(1'b0), .up(1'b1), .rst_b);
  mag_comp #(14) doneCheck (.a(xfers), .b(controlL[13:0]), .aeqb(xferDone));

  //save old SAD DAD and CNT registers
  register #(32) oldsad(.d({srcAddrH, srcAddrL}), .q(old_SAD_reg), .clk, .clear(1'b0), .enable(1'b1), .rst_b);
  register #(32) olddad(.d({destAddrH, destAddrL}), .q(old_DAD_reg), .clk, .clear(1'b0), .enable(1'b1), .rst_b);
  register #(32) oldctl(.d({controlH, controlL}), .q(old_CTL_reg), .clk, .clear(1'b0), .enable(1'b1), .rst_b);

  assign new_transfer = ((old_SAD_reg != {srcAddrH, srcAddrL}) || (old_DAD_reg != {destAddrH, destAddrL}) || 
                        (old_CTL_reg != {controlH, controlL})) ? 1'b1 : 1'b0;
endmodule: dma_dp

module dma_start
  (input  logic [15:0] controlH,
   input  logic [15:0] vcount, hcount,
   input  logic sound, sound_req, //can this dma sync with sound, and are they requesting dma
   output logic start, dma_stop,
   input  logic clk, rst_b);

  logic display_sync_startable;
  logic passed_go; 

  always_ff @(posedge clk, negedge rst_b)
    if(~rst_b)
      display_sync_startable <= 1'b0;
    else
      display_sync_startable <= passed_go; 

  logic started;
  logic active;
  always_ff @(posedge clk, negedge rst_b)
    if(~rst_b)
      started <= 1'b0;
    else
      started <= active;

  always_comb begin
    dma_stop = 1'b0; //extra control to turn off dma repeat
    passed_go = display_sync_startable;
    active = started;
    case(controlH[13:12])
      2'b00: begin
        start = 1'b1;
      end
      2'b10: begin
        start = (hcount[7:0] == 8'd240);
      end
      2'b01: begin
        start = (vcount[7:0] == 8'd160);
      end
      2'b11: begin
        if(sound) begin
          start = sound_req;
        end
        else begin
          if(vcount[7:0] == 8'd02 && display_sync_startable) begin
            start = 1'b1;
            active = 1'b1;
          end
          else if(vcount[7:0] == 8'd162) begin
            start = 1'b0;
            dma_stop = 1'b1;
            active = 1'b0;
            passed_go = controlH[15]; //can start now if dma is enabled
          end
          else begin
            start = 1'b0;
          end
        end
      end
    endcase
  end

endmodule: dma_start

module dma_unit
  (input  logic [15:0] controlL, controlH,
   input  logic [15:0] srcAddrL, srcAddrH,
   input  logic [15:0] destAddrL, destAddrH,

   input  logic mem_wait, preempted,
   input  logic srcGamePak, destGamePak,
   input  logic allowed_to_begin,
   output logic disable_dma,
   output logic active,
   output logic irq,
   output logic others_cant_preempt,

   inout  tri   [31:0] addr, 
   inout  tri   [31:0] wdata, rdata,
   inout  tri   [1:0]  size,
   inout  tri   wen,

   input  logic [15:0] vcount, hcount,
   input  logic sound, sound_req,

   input  logic clk, rst_b
   );

  logic fsm_disable;
  logic xferDone;
  logic loadCNT, loadSAD, loadDAD;
  logic stepSRC, stepDEST;
  logic storeRData;
  logic write;
  
  logic dma_stop;
  logic start;
  logic set_wdata;

  logic new_transfer;

  assign disable_dma = fsm_disable | dma_stop;

  dma_start starter(.controlH, .vcount, .hcount, .sound, .sound_req, .start, .dma_stop, .clk, .rst_b);

  dma_fsm fsm(.start, .mem_wait, .dma_repeat(controlH[9]), .preempted, .enable(controlH[15]), .xferDone, .genIRQ(controlH[14]), .loadCNT, .loadSAD, .loadDAD, .stepSRC, .stepDEST, .storeRData, .active, .write, .disable_dma(fsm_disable), .irq, .clk, .rst_b, .set_wdata, .allowed_to_begin, .others_cant_preempt, .new_transfer);

  dma_dp datapath(.loadCNT, .loadSAD, .loadDAD, .stepSRC, .stepDEST, .storeRData, .active, .write, .srcGamePak, .destGamePak, .xferDone, .srcAddrL, .srcAddrH, .destAddrL, .destAddrH, .controlL, .controlH, .sound, .rdata, .addr, .wdata, .size, .wen, .clk, .rst_b, .set_wdata, .new_transfer);

endmodule: dma_unit

module dma_top
  (input  logic [31:0] registers [`NUM_IO_REGS-1:0],
   input  logic [15:0] vcount, hcount,
   input  logic        sound_req,

   input  logic        mem_wait,

   inout  tri   [31:0] addr,
   inout  tri   [31:0] rdata, wdata,
   inout  tri   [1:0]  size,
   inout  tri          wen,

   output logic [3:0]  disable_dma,
   output logic        active,
   output logic        irq,

   input  logic clk, rst_b);

   logic [15:0] controlL0, controlH0;
   logic [15:0] srcAddrL0, srcAddrH0;
   logic [15:0] destAddrL0, destAddrH0;

   logic [15:0] controlL1, controlH1;
   logic [15:0] srcAddrL1, srcAddrH1;
   logic [15:0] destAddrL1, destAddrH1;

   logic [15:0] controlL2, controlH2;
   logic [15:0] srcAddrL2, srcAddrH2;
   logic [15:0] destAddrL2, destAddrH2;

   logic [15:0] controlL3, controlH3;
   logic [15:0] srcAddrL3, srcAddrH3;
   logic [15:0] destAddrL3, destAddrH3;

   assign controlL0 = registers[`DMA0CNT_L_IDX][15:0];
   assign controlH0 = registers[`DMA0CNT_H_IDX][31:16];
   assign srcAddrL0 = registers[`DMA0SAD_L_IDX][15:0];
   assign srcAddrH0 = registers[`DMA0SAD_H_IDX][31:16];
   assign destAddrL0 = registers[`DMA0DAD_L_IDX][15:0];
   assign destAddrH0 = registers [`DMA0DAD_H_IDX][31:16];

   assign controlL1 = registers[`DMA1CNT_L_IDX][15:0];
   assign controlH1 = registers[`DMA1CNT_H_IDX][31:16];
   assign srcAddrL1 = registers[`DMA1SAD_L_IDX][15:0];
   assign srcAddrH1 = registers[`DMA1SAD_H_IDX][31:16];
   assign destAddrL1 = registers[`DMA1DAD_L_IDX][15:0];  
   assign destAddrH1 = registers [`DMA1DAD_H_IDX][31:16];

   assign controlL2 = registers[`DMA2CNT_L_IDX][15:0];
   assign controlH2 = registers[`DMA2CNT_H_IDX][31:16];
   assign srcAddrL2 = registers[`DMA2SAD_L_IDX][15:0];
   assign srcAddrH2 = registers[`DMA2SAD_H_IDX][31:16];
   assign destAddrL2 = registers[`DMA2DAD_L_IDX][15:0];  
   assign destAddrH2 = registers [`DMA2DAD_H_IDX][31:16];

   assign controlL3 = registers[`DMA3CNT_L_IDX][15:0];
   assign controlH3 = registers[`DMA3CNT_H_IDX][31:16];
   assign srcAddrL3 = registers[`DMA3SAD_L_IDX][15:0];
   assign srcAddrH3 = registers[`DMA3SAD_H_IDX][31:16];
   assign destAddrL3 = registers[`DMA3DAD_L_IDX][15:0];  
   assign destAddrH3 = registers [`DMA3DAD_H_IDX][31:16];

   logic [3:0] preempts;
   logic [3:0] actives;
   logic [3:0] irqs;
   logic [3:0] mid_process;
   logic allowed_to_begin;

   assign active = |actives;
   assign irq = |irqs; 
   assign preempts[0] = 1'b0;
   assign preempts[1] = actives[0];
   assign preempts[2] = actives[0] | actives[1];
   assign preempts[3] = actives[0] | actives[1] | actives[2];
   assign allowed_to_begin = ~mid_process[0] && ~mid_process[1]
                                  && ~mid_process[2] && ~mid_process[3];


   dma_unit dma0(.controlL(controlL0), .controlH(controlH0),
                 .srcAddrL(srcAddrL0), .srcAddrH(srcAddrH0),
                 .destAddrL(destAddrL0), .destAddrH(destAddrH0),
                 .mem_wait, .preempted(preempts[0]),
                 .srcGamePak(1'b0), .destGamePak(1'b0),
                 .disable_dma(disable_dma[0]),
                 .active(actives[0]), .allowed_to_begin,
                 .irq(irqs[0]), .others_cant_preempt(mid_process[0]),
                 .addr, .wdata, .rdata, .size, .wen,
                 .vcount, .hcount, .sound(1'b0), .sound_req,
                 .clk, .rst_b);

   dma_unit dma1(.controlL(controlL1), .controlH(controlH1),
                 .srcAddrL(srcAddrL1), .srcAddrH(srcAddrH1),
                 .destAddrL(destAddrL1), .destAddrH(destAddrH1),
                 .mem_wait, .preempted(preempts[1]),
                 .srcGamePak(1'b1), .destGamePak(1'b0),
                 .disable_dma(disable_dma[1]),
                 .active(actives[1]), .allowed_to_begin,
                 .irq(irqs[1]), .others_cant_preempt(mid_process[1]),
                 .addr, .wdata, .rdata, .size, .wen,
                 .vcount, .hcount, .sound(1'b1), .sound_req,
                 .clk, .rst_b);

   dma_unit dma2(.controlL(controlL2), .controlH(controlH2),
                 .srcAddrL(srcAddrL2), .srcAddrH(srcAddrH2),
                 .destAddrL(destAddrL2), .destAddrH(destAddrH2),
                 .mem_wait, .preempted(preempts[2]),
                 .srcGamePak(1'b1), .destGamePak(1'b0),
                 .disable_dma(disable_dma[2]),
                 .active(actives[2]), .allowed_to_begin,
                 .irq(irqs[2]), .others_cant_preempt(mid_process[2]),
                 .addr, .wdata, .rdata, .size, .wen,
                 .vcount, .hcount, .sound(1'b1), .sound_req,
                 .clk, .rst_b);

   dma_unit dma3(.controlL(controlL3), .controlH(controlH3),
                 .srcAddrL(srcAddrL3), .srcAddrH(srcAddrH3),
                 .destAddrL(destAddrL3), .destAddrH(destAddrH3),
                 .mem_wait, .preempted(preempts[3]),
                 .srcGamePak(1'b1), .destGamePak(1'b1),
                 .disable_dma(disable_dma[3]),
                 .active(actives[3]), .allowed_to_begin,
                 .irq(irqs[3]), .others_cant_preempt(mid_process[3]),
                 .addr, .wdata, .rdata, .size, .wen,
                 .vcount, .hcount, .sound(1'b0), .sound_req,
                 .clk, .rst_b);

endmodule: dma_top

`default_nettype wire
