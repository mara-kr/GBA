
module direct_sound (
    input logic clock,
    input logic reset,
    input logic [15:0] FIFO_A_L,
    input logic [15:0] FIFO_B_L,
    input logic [15:0] FIFO_A_H,
    input logic [15:0] FIFO_B_H,
    input logic [15:0] TM0_CNT_L,
    input logic [15:0] TM1_CNT_L,
    input logic timer_num,
    output logic [23:0] waveA,
    output logic [23:0] waveB);

    logic [4:0] position_counter;
    logic [31:0] waveformA_pattern;
    logic [31:0] waveformB_pattern;
    logic [15:0] timer;
    logic [15:0] old_timer;
    logic timer_overflow;
    logic sampling_rate;

    assign waveformA_pattern = {FIFO_A_H, FIFO_A_L};
    assign waveformB_pattern = {FIFO_B_H, FIFO_B_L};

    assign waveA = {waveformA_pattern[(position_counter+7)-:8], 16'b0};
    assign waveB = {waveformB_pattern[(position_counter+7)-:8], 16'b0};
    assign timer = (timer_num) ?  TM1_CNT_L : TM0_CNT_L;

    assign timer_overflow = (old_timer >  timer) ? 1 : 0;
    assign sampling_rate = timer_overflow;

    /*always_comb begin 
        if (reset == 1) begin
            sampling_rate = 0;
        end
        if (timer < 16'b0000_0000_1111_1111) begin
            sampling_rate = 1;
        end
        else begin
            sampling_rate = 0;
        end
        old_timer <= timer;
    end*/

   always_ff @(posedge clock, posedge reset) begin
       old_timer <= timer;
   end

    always_ff @(posedge sampling_rate, posedge reset) begin
        if (reset == 1) begin
            position_counter <= 0;
        end
        else begin
            position_counter <= position_counter + 8;
        end
    end

endmodule: direct_sound


module direct_sound_test ();
    logic clock;
    logic reset;
    logic [15:0] FIFO_A_L;
    logic [15:0] FIFO_B_L;
    logic [15:0] FIFO_A_H;
    logic [15:0] FIFO_B_H;
    logic [15:0] TM0_CNT_L;
    logic [15:0] TM1_CNT_L;
    logic timer_num;
    logic [23:0] waveA;
    logic [23:0] waveB;


    direct_sound dut (.clock, .reset, .FIFO_A_L, .FIFO_B_L, .FIFO_A_H,
                      .FIFO_B_H, .TM0_CNT_L, .TM1_CNT_L, .timer_num, .waveA, .waveB);
    initial begin
        //$monitor ("clk=%b, rest=%b, position=%d, waveformA=%h, waveformB=%h, sampling_clk=%b int_timer=%b timer_num=%b",
        //        clock, reset, dut.position_counter, waveA, waveB, dut.sampling_rate, dut.timer, timer_num);

        $monitor ("rest=%b, position=%d, waveformA=%h, waveformB=%h, sampling_clk=%b",
                reset, dut.position_counter, waveA, waveB, dut.sampling_rate);
        clock <= 0;
        
        reset <= 1;
        #2
        reset <= 0;
        timer_num <= 0;
        FIFO_A_L = 16'hAABB;
        FIFO_A_H = 16'h1122;

        FIFO_B_L = 16'hCCDD;
        FIFO_B_H = 16'h3344;
        #628000 $finish;
    end
   
    always_ff @(posedge clock, posedge reset) begin
        if(reset) begin
            TM0_CNT_L <= 0;
        end
        else begin
            TM0_CNT_L <= TM0_CNT_L +1;
        end
    end

    always
        #1 clock = !clock;

endmodule: direct_sound_test;

