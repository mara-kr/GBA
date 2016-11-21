`default_nettype none
`include "../gba_mmio_defines.vh"
`include "../gba_core_defines.vh"

module audio_top (
    input logic clk_100,
    input logic reset,
    output logic AC_ADR0,
    output logic AC_ADR1,
    output logic AC_GPIO0,
    input  logic AC_GPIO1,
    input  logic AC_GPIO2,
    input  logic AC_GPIO3,
    output logic AC_MCLK,
    output logic AC_SCK,
    inout  wire AC_SDA,
    input logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0]);

    logic clk_100_output;
    logic clk_256_output;


    clk_wiz_0 clock_generate
   (
   // Clock in ports
    .clk_in1(clk_100),      // input clk_in1
    // Clock out ports
    .clk_out1(clk_100_output),     // output clk_out1
    .clk_out2(clk_256_output),     // output clk_out2
    // Status and control signals
    .reset);       // input reset
    
    //audio codec
    logic        clk_100_buffered;
    logic [5:0]  counter_saw_tooth;
    logic [23:0] hphone_l, hphone_r;
    logic        hphone_valid;
    logic        new_sample;
    logic        sample_clk_48k;
    logic [23:0] line_in_r, line_in_l;

    //wave channel
    logic [7:0] NR30, NR31, NR32, NR33, NR34;
    logic [15:0] addr_0x90;
    logic [15:0] addr_0x92;
    logic [15:0] addr_0x94;
    logic [15:0] addr_0x96;
    logic [15:0] addr_0x98;
    logic [15:0] addr_0x9A;
    logic [15:0] addr_0x9C;
    logic [15:0] addr_0x9E;
    logic [23:0] channel_3;
    
    //square2 channel
    logic [7:0] NR21, NR22, NR23, NR24;
    logic [23:0] channel_2;
    
    //square1 channel
    logic [7:0] NR10, NR11, NR12, NR13, NR14;
    logic [23:0] channel_1;

    //noise channel
    logic [7:0] NR41, NR42, NR43, NR44;
    logic [23:0] channel_4;

    //mixed channel
    logic [7:0] NR50, NR51,  NR52;
    logic [23:0] ch4_mixed_l;
    logic [23:0] ch4_mixed_r;
    logic pause_c1;
    logic pause_c2;
    logic pause_c3;
    logic pause_c4;
    logic reset_c1;
    logic reset_c2;
    logic reset_c3;
    logic reset_c4;
    
     //direct sound
    logic [15:0] FIFO_A_L;
    logic [15:0] FIFO_A_H;
    logic [15:0] FIFO_B_L;
    logic [15:0] FIFO_B_H;
    logic [15:0] TM0_CNT_L;
    logic [15:0] TM1_CNT_L;

    //final mixer
    logic [23:0] direct_A;
    logic [23:0] direct_B;
    logic [15:0] SOUND_CNT_H;
    logic timer_numA;
    logic timer_numB;
    logic reset_directA;
    logic reset_directB;
    logic [23:0] output_wave_r;
    logic [23:0] output_wave_l;
    
    assign NR10 = IO_reg_datas[`SOUND1CNT_L_IDX][7:0];
    assign NR11 = IO_reg_datas[`SOUND1CNT_H_IDX][23:16];
    assign NR12 = IO_reg_datas[`SOUND1CNT_H_IDX][31:24];
    assign NR13 = IO_reg_datas[`SOUND1CNT_X_IDX][7:0];
    assign NR14 = IO_reg_datas[`SOUND1CNT_X_IDX][15:8];

    assign NR21 = IO_reg_datas[`SOUND2CNT_L_IDX][7:0];
    assign NR22 = IO_reg_datas[`SOUND2CNT_L_IDX][15:8];
    assign NR23 = IO_reg_datas[`SOUND2CNT_H_IDX][7:0];
    assign NR24 = IO_reg_datas[`SOUND2CNT_H_IDX][15:8];

    assign NR30 = IO_reg_datas[`SOUND3CNT_L_IDX][7:0];
    assign NR31 = IO_reg_datas[`SOUND3CNT_H_IDX][23:16];
    assign NR32 = IO_reg_datas[`SOUND3CNT_H_IDX][31:24];
    assign NR33 = IO_reg_datas[`SOUND3CNT_X_IDX][7:0];
    assign NR34 = IO_reg_datas[`SOUND3CNT_X_IDX][15:8];

    assign addr_0x90 = IO_reg_datas[`WAVE_RAM0_L_IDX][15:0];
    assign addr_0x92 = IO_reg_datas[`WAVE_RAM0_H_IDX][31:16];
    assign addr_0x94 = IO_reg_datas[`WAVE_RAM1_L_IDX][15:0];
    assign addr_0x96 = IO_reg_datas[`WAVE_RAM1_H_IDX][31:16];
    assign addr_0x98 = IO_reg_datas[`WAVE_RAM2_L_IDX][15:0];
    assign addr_0x9A = IO_reg_datas[`WAVE_RAM2_H_IDX][13:16];
    assign addr_0x9C = IO_reg_datas[`WAVE_RAM3_L_IDX][15:0];
    assign addr_0x9E = IO_reg_datas[`WAVE_RAM3_H_IDX][31:16];
    
    assign NR41 = IO_reg_datas[`SOUND4CNT_L_IDX][7:0];
    assign NR42 = IO_reg_datas[`SOUND4CNT_L_IDX][15:8];
    assign NR43 = IO_reg_datas[`SOUND4CNT_H_IDX][7:0];
    assign NR44 = IO_reg_datas[`SOUND4CNT_H_IDX][15:8];

    assign NR50 = IO_reg_datas[`SOUNDCNT_L_IDX][7:0];
    assign NR51 = IO_reg_datas[`SOUNDCNT_L_IDX][15:8];
    assign NR52 = IO_reg_datas[`SOUNDCNT_X_IDX][7:0];

    assign FIFO_A_L = IO_reg_datas[`FIFO_A_L][15:0];
    assign FIFO_A_H = IO_reg_datas[`FIFO_A_H][31:16];
    assign FIFO_B_L = IO_reg_datas[`FIFO_B_L][15:0];
    assign FIFO_B_H = IO_reg_datas[`FIFO_B_H][31:16];

    audio_top top(
    .clk_100(clk_100_buffered),
    .AC_MCLK(AC_MCLK),
    .AC_ADR0(AC_ADR0),
    .AC_ADR1(AC_ADR1),
    .AC_SCK(AC_SCK),
    .AC_SDA(AC_SDA),

    .AC_GPIO0(AC_GPIO0),
    .AC_GPIO1(AC_GPIO1),
    .AC_GPIO2(AC_GPIO2),
    .AC_GPIO3(AC_GPIO3),

    .hphone_l(hphone_l),
    .hphone_l_valid(hphone_valid),

    .hphone_r(hphone_r),
    .hphone_r_valid_dummy(hphone_valid),
    
    .line_in_l(line_in_l),
    .line_in_r(line_in_r),
    .new_sample(new_sample),
    .sample_clk_48k(sample_clk_48k));
    
    noise n(
        .system_clock(clk_100),
        .clock_256(clk_256_output),
        .reset((reset || reset_c4)),
        .NR40, .NR41, .NR42, .NR43,
        .NR44, .output_wave(channel_4));

    wave w(
        .system_clock(clk_100),
        .clock_256(clk_256_output),
        .reset((reset || reset_c3)),
        .NR30, .NR31, .NR32,
        .NR33, .NR34,
        .addr_0x90,
        .addr_0x92,
        .addr_0x94,
        .addr_0x96,
        .addr_0x98,
        .addr_0x9A,
        .addr_0x9C,
        .addr_0x9E,
        .output_wave(channel_3));
    
    square2 sq2(
        .system_clock(clk_100),
        .clock_256(clk_256_output),
        .reset((reset || reset_c2)),
        .NR20, .NR21, .NR22, .NR23,
        .NR24, .output_wave(channel_2));
    
    square1 sq1(
        .system_clock(clk_100),
        .clock_256(clk_256_output),
        .reset(reset || reset_c1),
        .NR10, .NR11, .NR12, .NR13,
        .NR14, .output_wave(channel_1));
    
    ch4_mixer m(.system_clock(clk_100),
        .reset,
        .channel1(channel_1),
        .channel2(channel_2),
        .channel3(channel_3),
        .channel4(channel_4),
        .pause_channel_1(pause_c1),
        .pause_channel_2(pause_c2),
        .pause_channel_3(pause_c3),
        .pause_channel_4(pause_c4),
        .NR50, .NR51, .NR52,
        .output_wave_left(ch4_mixed_l),
        .output_wave_right(ch4_mixed_r)); //used to reset the system

    /* variables for direct sound*/


    direct_sound dsA(
        .clock(clk_100),
        .reset(reset),
        .FIFO_L(FIFO_A_L),
        .FIFO_H(FIFO_A_H),
        .TM0_CNT_L,
        .TM1_CNT_L,
        .timer_num(timer_numA),
        .sequencer_reset (reset_directA), 
        .waveout(direct_A));

    direct_sound dsB(
        .clock(clk_100),
        .reset(reset),
        .FIFO_L(FIFO_B_L),
        .FIFO_H(FIFO_B_H),
        .TM0_CNT_L,
        .TM1_CNT_L,
        .timer_num(timer_numB),
        .sequencer_reset(reset_directB), 
        .waveout(direct_B));

    ds_mixer (
        .clock(clk_100),
        .reset,
        .direct_A,
        .direct_B,
        .channel4_l(ch4_mixed_l),
        .channel4_r(ch4_mixed_r),
        .sound_cnt_h(SOUND_CNT_H),
        .timer_numA,
        .timer_numB,
        .reset_directA,
        .reset_directB,
        .output_wave_r,
        .output_wave_l);

    power p(
        .clock(clk_100),
        .NR52,
        .pause_channel1(pause_c1),
        .pause_channel2(pause_c2),
        .pause_channel3(pause_c3),
        .pause_channel4(pause_c4),
        .reset_channel1(reset_c1),
        .reset_channel2(reset_c2),
        .reset_channel3(reset_c3),
        .reset_channel4(reset_c4));
    
    always_ff @(posedge clk_100) begin
        hphone_valid <= 0;
        hphone_l <= 0;
        hphone_r <= 0;

        if (new_sample == 1) begin
            hphone_valid <= 1'b1;
            hphone_r <= {output_wave_r};
            hphone_l <= {output_wave_l};
        end
    end

    BUFG BUFG_inst(
        .O (clk_100_buffered),
        .I (clk_100)
        );

 
endmodule: audio_top

`default_nettype wire

