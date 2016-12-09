module test_fsm
  (output logic [15:0] controlL0, controlH0,
   output logic [15:0] srcAddrL0, srcAddrH0,
   output logic [15:0] destAddrL0, destAddrH0,

   output logic [15:0] controlL1, controlH1,
   output logic [15:0] srcAddrL1, srcAddrH1,
   output logic [15:0] destAddrL1, destAddrH1,

   output logic [15:0] controlL2, controlH2,
   output logic [15:0] srcAddrL2, srcAddrH2,
   output logic [15:0] destAddrL2, destAddrH2,

   output logic [15:0] controlL3, controlH3,
   output logic [15:0] srcAddrL3, srcAddrH3,
   output logic [15:0] destAddrL3, destAddrH3,
   output logic        check_correctness,
   output logic        passed,
   output logic [31:0] test_addr,
   input  logic [31:0] rdata,
   output  logic [15:0] hcount,

   input  logic clk, rst_n,
   input  logic pause,
   input  logic [10:0] count_time);

  enum logic [4:0] {OFF, BASIC1, BASIC2, PREEMPT_DMA2, PREEMPT_DMA1, PREEMPT_DMA0,
                    CHECK_BASIC1_1, CHECK_BASIC1_2, HCOUNT, CHECK_BASIC2_1, CHECK_BASIC2_2,
                    CHECK_PREEMPT_1, CHECK_PREEMPT_2, CHECK_HCOUNT_1, CHECK_HCOUNT_2, DONE} cs, ns;

  always_ff @(posedge clk, negedge rst_n) begin
    if(~rst_n)
      cs <= OFF;
    else
      cs <= ns;
  end

  logic xfer_count_en;
  logic xfer_count_rst;
  logic [3:0] xfer_count;
  always_ff @(posedge clk, negedge rst_n) begin
      if (~rst_n)
          xfer_count <= 0;
      else if (xfer_count_rst)
          xfer_count <= 0;
      else if (xfer_count_en == 1 && ~pause)  xfer_count <= xfer_count + 1;
      else xfer_count <= xfer_count;
  end
  always_comb begin
     controlH0 = 16'b0;
     controlH1 = 16'b0;
     controlH2 = 16'b0;
     controlH3 = 16'b0;
     passed = 1'b1;
     check_correctness = 1'b0;
     xfer_count_en = 1'b0;
     xfer_count_rst = 1'b0;
     hcount = 16'd0;
    case(cs)
      OFF: begin
        controlH0 = 16'b0;
        controlH1 = 16'b0;
        controlH2 = 16'b0;
        controlH3 = 16'b0;
        ns = (~pause) ? BASIC1 : OFF;
      end
      BASIC1: begin
        srcAddrL0 = 16'b0000_0000_0000_0000;
        srcAddrH0 = 16'b0000_0000_0000_0000;
        destAddrL0 = 16'b0000_0000_0000_1010;
        destAddrH0 = 16'b0000_0101_0000_0000;
        controlL0 = 16'b0000_0000_0000_0001;
        //DMA on, interrupt enabled, start timing immediately, 16 bit transfer,
        //DMA_repeat off, incr source and dest after transfer
        controlH0 = 16'b1100_1000_0000_0000;
        ns = (count_time == 11'd5 && ~pause) ? CHECK_BASIC1_1 : BASIC1;
      end
      CHECK_BASIC1_1: begin
        check_correctness = 1'b1;
        test_addr = 32'h0500000A;
        ns = (~pause) ? CHECK_BASIC1_2 : CHECK_BASIC1_1;
      end
      CHECK_BASIC1_2: begin
        check_correctness = 1'b1;
        passed = (rdata == 32'h01000000) ? 1'b1 : 1'b0;
        ns = (~pause) ? BASIC2 : CHECK_BASIC1_2;
      end
      BASIC2: begin
        srcAddrL0 = 16'b0000_0000_0000_0000;
        srcAddrH0 = 16'b0000_0000_0000_0000;
        destAddrL0 = 16'b0000_0000_0000_1000;
        destAddrH0 = 16'b0000_0011_0000_0000;
        controlL0 = 16'b0000_0000_0000_1000;
        //DMA on, interrupt enabled, start timing immediately, 32 bit transfer,
        //DMA_repeat off, source incr and dest after transfer
        controlH0 = 16'b1100_1100_0000_0000;
        ns = (count_time == 11'd30 && ~pause) ? CHECK_BASIC2_1 : BASIC2;
      end
      CHECK_BASIC2_1: begin
          check_correctness = 1'b1;
          test_addr = 32'h03000008 + (xfer_count << 2);
          ns = CHECK_BASIC2_2;
          xfer_count_en = 1'b1;
      end
      CHECK_BASIC2_2: begin
        check_correctness = 1'b1;
        if (xfer_count == 4'd1) passed = (rdata == 32'h03020100) ? 1'b1 : 1'b0;
        else if (xfer_count == 4'd2) passed = (rdata == 32'h07060504) ? 1'b1 : 1'b0;
        else if (xfer_count == 4'd3) passed = (rdata == 32'h11100908) ? 1'b1 : 1'b0;
        else if (xfer_count == 4'd4) passed = (rdata == 32'h15141312) ? 1'b1 : 1'b0;
        else if (xfer_count == 4'd5) passed = (rdata == 32'h19181716) ? 1'b1 : 1'b0;
        else if (xfer_count == 4'd6) passed = (rdata == 32'h23222120) ? 1'b1 : 1'b0;
        else if (xfer_count == 4'd7) passed = (rdata == 32'h27262524) ? 1'b1 : 1'b0;
        else if (xfer_count == 4'd8) passed = (rdata == 32'h31302928) ? 1'b1 : 1'b0;
        ns = (xfer_count == controlL0[3:0] && ~pause) ? PREEMPT_DMA2 : CHECK_BASIC2_1;
      end
      PREEMPT_DMA2: begin
        xfer_count_rst = 1'b1;
        srcAddrL2 = 16'b0000_0000_0000_0000;
        srcAddrH2 = 16'b0000_0000_0000_0000;
        destAddrL2 = 16'b0000_1000_0000_1000;
        destAddrH2 = 16'b0000_0011_0000_0000;
        controlL2 = 16'b0000_0000_0000_0100;
        //DMA on, interrupt enabled, start timing immediately, 32 bit transfer,
        //DMA_repeat off, fixed source incr and dest after transfer
        controlH2 = 16'b1100_1101_0000_0000;
        ns = (count_time == 11'd50 && ~pause) ? PREEMPT_DMA1 : PREEMPT_DMA2;
      end

      PREEMPT_DMA1: begin
        srcAddrL2 = 16'b0000_0000_0000_0000;
        srcAddrH2 = 16'b0000_0000_0000_0000;
        destAddrL2 = 16'b0000_1000_0000_1000;
        destAddrH2 = 16'b0000_0011_0000_0000;
        controlL2 = 16'b0000_0000_0000_0100;
        //DMA on, interrupt enabled, start timing immediately, 32 bit transfer,
        //DMA_repeat off, fixed source incr and dest after transfer
        controlH2 = 16'b1100_1101_0000_0000;

        srcAddrL1 = 16'b0000_0000_0000_0000;
        srcAddrH1 = 16'b0000_0000_0000_0000;
        destAddrL1 = 16'b0000_0000_1000_1000;
        destAddrH1 = 16'b0000_0011_0000_0000;
        controlL1 = 16'b0000_0000_0000_1010;
        //DMA on, interrupt enabled, start timing immediately, 16 bit transfer,
        //DMA_repeat off, incr source incr and dest after transfer
        controlH1 = 16'b1100_1000_0000_0000;
        ns = (count_time == 11'd54 && ~pause) ? PREEMPT_DMA0 : PREEMPT_DMA1;
      end

      PREEMPT_DMA0: begin
        srcAddrL2 = 16'b0000_0000_0000_0000;
        srcAddrH2 = 16'b0000_0000_0000_0000;
        destAddrL2 = 16'b0000_1000_0000_1000;
        destAddrH2 = 16'b0000_0011_0000_0000;
        controlL2 = 16'b0000_0000_0000_0100;
        //DMA on, interrupt enabled, start timing immediately, 32 bit transfer,
        //DMA_repeat off, fixed source, incr dest after transfer
        controlH2 = 16'b1100_1101_0000_0000;

        srcAddrL1 = 16'b0000_0000_0000_0000;
        srcAddrH1 = 16'b0000_0000_0000_0000;
        destAddrL1 = 16'b0000_0000_1000_1000;
        destAddrH1 = 16'b0000_0011_0000_0000;
        controlL1 = 16'b0000_0000_0000_0110;
        //DMA on, interrupt enabled, start timing immediately, 16 bit transfer,
        //DMA_repeat off, incr source, incr dest after transfer
        controlH1 = 16'b1100_1000_0000_0000;

        srcAddrL0 = 16'b0000_0000_0000_0000;
        srcAddrH0 = 16'b0000_0000_0000_0000;
        destAddrL0 = 16'b0000_0000_0000_1000;
        destAddrH0 = 16'b0000_0011_0000_0000;
        controlL0 = 16'b0000_0000_0000_0001;
        //DMA on, interrupt enabled, start timing immediately, 32 bit transfer,
        //DMA_repeat off, fixed source and fixed dest after transfer
        controlH0 = 16'b1100_1101_0100_0000;
        ns = (count_time == 11'd80 && ~pause) ? CHECK_PREEMPT_1 : PREEMPT_DMA0;
      end
      CHECK_PREEMPT_1: begin
          check_correctness = 1'b1;
          test_addr = 32'h02000008 + (xfer_count << 2);
          //DMA2
          if (xfer_count == 4'd0) test_addr = 32'h03000808;
          else if (xfer_count == 4'd1) test_addr = 32'h0300080c;
          //DMA1
          else if (xfer_count == 4'd2) test_addr = 32'h03000088;
          else if (xfer_count == 4'd3) test_addr = 32'h0300008a;
          //DMA0
          else if (xfer_count == 4'd4) test_addr = 32'h03000008;
          //DMA1
          else if (xfer_count == 4'd5) test_addr = 32'h0300008c;
          else if (xfer_count == 4'd6) test_addr = 32'h0300008e;
          else if (xfer_count == 4'd7) test_addr = 32'h03000090;
          else if (xfer_count == 4'd8) test_addr = 32'h03000092;
          //DMA2
          else if (xfer_count == 4'd9) test_addr = 32'h03000810;
          else if (xfer_count == 4'd10) test_addr = 32'h03000814;

          ns = (~pause) ? CHECK_PREEMPT_2 : CHECK_PREEMPT_1;
          xfer_count_en = 1'b1;
      end
      CHECK_PREEMPT_2: begin
          check_correctness = 1'b1;
          //DMA2
          if (xfer_count == 4'd1) passed = (rdata == 32'h03020100) ? 1'b1 : 1'b0;
          else if (xfer_count == 4'd2) passed = (rdata == 32'h03020100) ? 1'b1 : 1'b0;
          //DMA1
          else if (xfer_count == 4'd3) passed = (rdata[15:0] == 16'h0100) ? 1'b1 : 1'b0;
          else if (xfer_count == 4'd4) passed = (rdata[31:16] == 16'h0302) ? 1'b1 : 1'b0;
          //DMA0
          else if (xfer_count == 4'd5) passed = (rdata == 32'h03020100) ? 1'b1 : 1'b0;
          //DMA1
          else if (xfer_count == 4'd6) passed = (rdata[15:0] == 16'h0504) ? 1'b1 : 1'b0;
          else if (xfer_count == 4'd7) passed = (rdata[31:16] == 16'h0706) ? 1'b1 : 1'b0;
          else if (xfer_count == 4'd8) passed = (rdata[15:0] == 16'h0908) ? 1'b1 : 1'b0;
          else if (xfer_count == 4'd9) passed = (rdata[31:16] == 16'h1110) ? 1'b1 : 1'b0;
          //DMA 2
          else if (xfer_count == 4'd10) passed = (rdata == 32'h03020100) ? 1'b1 : 1'b0;
          else if (xfer_count == 4'd11) passed = (rdata == 32'h03020100) ? 1'b1 : 1'b0;
          ns = (xfer_count == 4'd11 && ~pause) ? HCOUNT : CHECK_PREEMPT_1;
      end
      HCOUNT: begin
          xfer_count_rst = 1'b1;
          if(count_time == 11'd110) hcount = 16'd240; //turn on hcount eventually
          srcAddrL3 = 16'b0000_0000_0000_0000;
          srcAddrH3 = 16'b0000_0000_0000_0000;
          destAddrL3 = 16'b0000_0011_0000_1000;
          destAddrH3 = 16'b0000_0011_0000_0000;
          controlL3 = 16'b0000_0000_0000_0010;
          //DMA on, interrupt enabled, start timing immediately, 32 bit transfer,
          //DMA_repeat on H-blank, fixed source and dest after transfer
          controlH3 = 16'b1110_1101_0100_0000;
          ns = (count_time == 11'd140 && ~pause) ? CHECK_HCOUNT_1 : HCOUNT;
      end
      CHECK_HCOUNT_1: begin
          check_correctness = 1'b1;
          test_addr = 32'h03000308;
          ns = (~pause) ? CHECK_HCOUNT_2 : CHECK_HCOUNT_1;
          xfer_count_en = 1'b1;
      end
      CHECK_HCOUNT_2: begin
        check_correctness = 1'b1;
        passed = (rdata == 32'h03020100) ? 1'b1 : 1'b0;
        ns = (xfer_count == controlL3[3:0] && ~pause) ? DONE : CHECK_HCOUNT_1;
      end
      DONE: begin
          passed = 1'b1;
      end

  endcase
  end
endmodule: test_fsm


