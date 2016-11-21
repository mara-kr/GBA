`default_nettype none
module audio_testbench_sv (
    input logic clk_100,
    input logic BTNC,
    output logic AC_ADR0,
    output logic AC_ADR1,
    output logic AC_GPIO0,
    input  logic AC_GPIO1,
    input  logic AC_GPIO2,
    input  logic AC_GPIO3,
    output logic AC_MCLK,
    output logic AC_SCK,
    inout  wire AC_SDA,
    input  logic SW0,
    input  logic SW1,
    input  logic SW2,
    input  logic SW3,
    input  logic SW4,
    input  logic SW5,
    input  logic SW6,
    input  logic SW7);
    
    
    //logic clk_100;
    //logic BTNC;

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
    .reset(BTNC));       // input reset
    
    //audio codec
    logic        clk_100_buffered;
    logic [5:0]  counter_saw_tooth;
    logic [23:0] hphone_l, hphone_r;
    logic        hphone_valid;
    logic        new_sample;
    logic        sample_clk_48k;
    logic [23:0] line_in_r, line_in_l;

    //wave channel
    logic [7:0] NR32;
    logic [7:0] NR33;
    logic [7:0] NR34;
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
    logic [7:0] NR21;
    logic [7:0] NR23;
    logic [7:0] NR24;
    logic [23:0] channel_2;
    
    //square1 channel
    logic [7:0] NR10;
    logic [7:0] NR11;
    wire [7:0] NR13;
    wire [7:0] NR14;
    logic [23:0] channel_1;

    //noise channel
    logic [7:0] NR43;
    logic [23:0] channel_4;
    
    //mixed channel
    logic [7:0] NR50;
    logic [7:0] NR51;
    logic [7:0] NR52;
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
    
    //generic registers- for testing keep the same for all channels
    logic [7:0] NRx0;
    logic [7:0] NRx1;
    logic [7:0] NRx2;
    logic [7:0] NRx3;
    logic [7:0] NRx4;
    
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
        .reset((BTNC || reset_c4)),
        .NR41(NRx1),
        .NR42(NRx2),
        .NR43(NR43),
        .NR44(NRx4),
        .output_wave(channel_4));

    wave w(
        .system_clock(clk_100),
        .clock_256(clk_256_output),
        .reset((BTNC || reset_c3)),
        .NR30(NRx0),
        .NR31(NRx1),
        .NR32(NRx2),
        .NR33(NR33),
        .NR34(NR34),
        .addr_0x90(addr_0x90),
        .addr_0x92(addr_0x92),
        .addr_0x94(addr_0x94),
        .addr_0x96(addr_0x96),
        .addr_0x98(addr_0x98),
        .addr_0x9A(addr_0x9A),
        .addr_0x9C(addr_0x9C),
        .addr_0x9E(addr_0x9E),
        .output_wave(channel_3));
    
    square2 sq2(
            .system_clock(clk_100),
            .clock_256(clk_256_output),
            .reset((BTNC || reset_c2)),
            .NR21(NR21),
            .NR22(NRx2),
            .NR23(NR23),
            .NR24(NR24),
            .output_wave(channel_2));
    
    square1 sq1(
        .system_clock(clk_100),
        .clock_256(clk_256_output),
        .reset(BTNC || reset_c1),
        .NR10(NR10),
        .NR11(NR11),
        .NR12(NRx2),
        .NR13(NR13),
        .NR14(NR14),
        .output_wave(channel_1));
    
    //inputs for wave channel
    //assign NR32 = volume control
    assign NR33 = 8'b11111111;
    assign NR34 = 8'b111;
    assign addr_0x90 = {4'd2,4'd3,4'd0, 4'd1};
    assign addr_0x92 = {4'd6, 4'd7, 4'd4, 4'd5};
    assign addr_0x94 = {4'd10, 4'd11, 4'd8, 4'd9};
    assign addr_0x96 = {4'd14, 4'd15, 4'd12, 4'd13};
    assign addr_0x98 = {4'd2,4'd3,4'd0, 4'd1};
    assign addr_0x9A = {4'd6, 4'd7, 4'd4, 4'd5};
    assign addr_0x9C = {4'd10, 4'd11, 4'd8, 4'd9};
    assign addr_0x9E = {4'd14, 4'd15, 4'd12, 4'd13};
    
    //inputs for square1 channel
    assign NR10 = 8'b00010111; //shift(increase) every 7.8 ms, 7 steps 
    assign NR11 = 8'b11111111; //75% duty cycle
    assign NR14 = 8'b00000000;
    assign NR13 = 8'b11111111; //72 Hz

    
    //inputs for square2 channel -- this is for 50% duty cycle
    assign NR21 = 8'b10111111;
    assign NR24 = 8'b00000111;
    assign NR23 = 8'b11101100;
    
    //inputs for noise channel
    assign NR43 = 8'b0000_0_000; //polynomial counter shift = 0, 15 step, dividing ratio freq = 0
    
    //set generic registers such as volume envelope and length to 0
    assign NRx0 = 0;
    assign NRx1 = 8'b0011_1111;
    assign NRx2 = 8'b0111_1001; // start at volume -0111 attenuate for 1 step
    assign NRx3 = 0;
    assign NRx4 = 0;
    
    //set master control for mixer
    assign NR50 = 8'b11111111; //set full volume for left and right
    assign NR51 = 8'b11110000; //set all sounds on left, off right
    assign NR52 = 8'b11111111; //turn on all sounds 
    ch4_mixer m(.system_clock(clk_100),
            .reset(BTNC),
            .channel1(channel_1),
            .channel2(channel_2),
            .channel3(channel_3),
            .channel4(channel_4),
            .pause_channel_1(pause_c1),
            .pause_channel_2(pause_c2),
            .pause_channel_3(pause_c3),
            .pause_channel_4(pause_c4),
            .NR50(NR50),
            .NR51(NR51),
            .NR52(NR52),
            .output_wave_left(mixed_left),
            .output_wave_right(mixed_right)); //used to reset the system
    power p(
        .clock(clk_100),
        .NR52(NR52),
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
        
        if (BTNC) begin
            counter_saw_tooth <= 0;
        end
        if (new_sample == 1) begin
            case ({SW4, SW3, SW2, SW1, SW0})  
                5'b00001: begin
                    hphone_valid <= 1'b1;
                    hphone_r <= {channel_1};
                    hphone_l <= {channel_1};
                end 
                5'b00010: begin
                    hphone_valid <= 1'b1;
                    hphone_r <= {channel_2};
                    hphone_l <= {channel_2};
                end 
                5'b00100: begin
                    hphone_valid <= 1'b1;
                    hphone_r <= {channel_3};
                    hphone_l <= {channel_3};
                end 
                5'b01000: begin
                    hphone_valid <= 1'b1;
                    hphone_r <= {channel_4};
                    hphone_l <= {channel_4};
                end
                5'b10000: begin
                    hphone_valid <= 1'b1;
                    hphone_r <= {mixed_right};
                    hphone_l <= {mixed_left};
                end
                default begin 
                    counter_saw_tooth <= counter_saw_tooth + 1;
                    hphone_valid <= 1'b1;
                    hphone_r <= {counter_saw_tooth, 18'd0};
                    hphone_l <= {counter_saw_tooth, 18'd0};
                end
            endcase
        end
    end

    BUFG BUFG_inst(
        .O (clk_100_buffered),
        .I (clk_100)
        );

  /**initial begin
            clk_100 <= 0;
            #8 BTNC <= 1;
            #2 BTNC <= 0;
        end
        always            #1 clk_100 = !clk_100;
*/
 
endmodule: audio_testbench_sv

`default_nettype wire
