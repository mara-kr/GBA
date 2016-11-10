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
    logic [23:0] mixed_left;
    logic [23:0] mixed_right;
    logic pause_c1;
    logic pause_c2;
    logic pause_c3;
    logic pause_c4;
    logic reset_c1;
    logic reset_c2;
    logic reset_c3;
    logic reset_c4;
    

    assign NR10 = IO_reg_datas[SOUND1_CNT_L_IDX][7:0];
    assign NR11 = IO_reg_datas[SOUND1_CNT_H_IDX][23:16];
    assign NR12 = IO_reg_datas[SOUND1_CNT_H_IDX][31:24];
    assign NR13 = IO_reg_datas[SOUND1_CNT_X_IDX][7:0];
    assign NR14 = IO_reg_datas[SOUND1_CNT_X_IDX][15:8];

    assign NR21 = IO_reg_datas[SOUND2_CNT_L_IDX][7:0];
    assign NR22 = IO_reg_datas[SOUND2_CNT_L_IDX][15:8];
    assign NR23 = IO_reg_datas[SOUND2_CNT_H_IDX][7:0];
    assign NR24 = IO_reg_datas[SOUND2_CNT_H_IDX][15:8];

    assign NR30 = IO_reg_datas[SOUND3_CNT_L_IDX][7:0];
    assign NR31 = IO_reg_datas[SOUND3_CNT_H_IDX][23:16];
    assign NR32 = IO_reg_datas[SOUND3_CNT_H_IDX][31:24];
    assign NR33 = IO_reg_datas[SOUND3_CNT_X_IDX][7:0];
    assign NR34 = IO_reg_datas[SOUND3_CNT_X_IDX][15:8];

    assign addr_0x90 = IO_reg_datas[WAVE_RAM0_L][15:0];
    assign addr_0x92 = IO_reg_datas[WAVE_RAM0_H][31:16];
    assign addr_0x94 = IO_reg_datas[WAVE_RAM1_L][15:0];
    assign addr_0x96 = IO_reg_datas[WAVE_RAM1_H][31:16];
    assign addr_0x98 = IO_reg_datas[WAVE_RAM2_L][15:0];
    assign addr_0x9A = IO_reg_datas[WAVE_RAM2_H][13:16];
    assign addr_0x9C = IO_reg_datas[WAVE_RAM3_L][15:0];
    assign addr_0x9E = IO_reg_datas[WAVE_RAM3_H][31:16];
    
    assign NR41 = IO_reg_datas[SOUND4_CNT_L_IDX][7:0];
    assign NR42 = IO_reg_datas[SOUND4_CNT_L_IDX][15:8];
    assign NR43 = IO_reg_datas[SOUND4_CNT_H_IDX][7:0];
    assign NR44 = IO_reg_datas[SOUND4_CNT_H_IDX][15:8];

    assign NR50 = IO_reg_datas[SOUND_CNT_L_IDX][7:0];
    assign NR51 = IO_reg_datas[SOUND_CNT_L_IDX][15:8];
    assign NR52 = IO_reg_datas[SOUND_CNT_X_IDX][7:0];

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
       .output_wave_left(mixed_left),
       .output_wave_right(mixed_right)); //used to reset the system

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
            hphone_r <= {mixed_right};
            hphone_l <= {mixed_left};
        end

    BUFG BUFG_inst(
        .O (clk_100_buffered),
        .I (clk_100)
        );

 
endmodule: audio_testbench_sv
