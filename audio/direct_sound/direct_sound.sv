//TODO: when clear is set by SOUNDCNT_H in the mixer, do I clear the entire fifo reg?
// or just reset position?

`default_nettype none
module direct_sound (
    input logic clock,
    input logic reset,
    input logic [15:0] FIFO_L,
    input logic [15:0] FIFO_H,
    input logic [15:0] TM0_CNT_L,
    input logic [15:0] TM1_CNT_L,
    input logic timer_num,
    input logic sequencer_reset, 
    output logic [23:0] waveout,
    output logic sound_req);

    logic [4:0] position_counter;
    logic [31:0] waveform_pattern;
    logic [15:0] timer;
    logic [15:0] old_timer;
    logic timer_overflow;
    logic sampling_rate;

    assign waveform_pattern = {FIFO_H, FIFO_L};

    assign waveout = {waveform_pattern[(position_counter+7)-:8], 16'b0};
    assign timer = (timer_num) ?  TM1_CNT_L : TM0_CNT_L;

    assign timer_overflow = (old_timer >  timer) ? 1 : 0;
    assign sampling_rate = timer_overflow;

   always_ff @(posedge clock, posedge reset) begin
       old_timer <= timer;
   end

   logic [4:0] prev_position_counter;
   always_ff @(posedge clock, posedge reset) begin
       if (reset == 1) begin
           sound_req <= 1'b0;
       end
       else if (position_counter == 5'd24 && prev_position_counter == 5'd16) begin
           sound_req <= 1'b1;
       end
       else begin
           sound_req <=1'b0;
       end
        prev_position_counter <= position_counter;
   end

    always_ff @(posedge sampling_rate, posedge reset) begin
        if (reset == 1) begin
            position_counter <= 0;
        end
        else if (sequencer_reset == 1) begin
            position_counter <= 0;
        end
        else begin
            position_counter <= position_counter + 8;
        end
    end

endmodule: direct_sound


/*module direct_sound_test ();
    logic clock;
    logic reset;
    logic [15:0] FIFO_L;
    logic [15:0] FIFO_H;
    logic [15:0] TM0_CNT_L;
    logic [15:0] TM1_CNT_L;
    logic timer_num;
    logic sequencer_reset;
    logic [23:0] waveout;
    logic sound_req;


    direct_sound dut (.clock, .reset, .FIFO_L, .FIFO_H, .TM0_CNT_L, .TM1_CNT_L, 
                    .timer_num, .sequencer_reset, .waveout, .sound_req);
    initial begin
        //$monitor ("clk=%b, rest=%b, position=%d, waveformA=%h, waveformB=%h, sampling_clk=%b int_timer=%b timer_num=%b",
        //        clock, reset, dut.position_counter, waveA, waveB, dut.sampling_rate, dut.timer, timer_num);

        $monitor ("rest=%b, position=%d, waveformB=%h, sampling_clk=%b, sound_req=%b, prev_pos=%d",
                reset, dut.position_counter, waveout, dut.sampling_rate, sound_req, dut.prev_position_counter);
        clock <= 0;
        
        reset <= 1;
        #2
        reset <= 0;
        timer_num <= 0;
        FIFO_L = 16'hAABB;
        FIFO_H = 16'h1122;

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

endmodule: direct_sound_test;*/

`default_nettype wire

