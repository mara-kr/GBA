//`default_nettype none
module audio_testbench_sv (
    input  logic clk_100,
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
    input  logic SW7,
    input  logic BTNC);

    //audio codec
    logic        clk_100_buffered;
    logic [5:0]  counter;
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
    logic [3:0] channel_3;
    
    //square2 channel
    logic [7:0] NR21;
    logic [7:0] NR23;
    logic [7:0] NR24;
    logic [3:0] channel_2;
    
    //noise channel
    logic [7:0] NR43;
    logic [3:0] channel_4;
    
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
        .clock_512(clk_100),
        .reset(BTNC),
        .NR40(NRx0),
        .NR41(NRx1),
        .NR42(NRx2),
        .NR43(NR43),
        .NR44(NRx4),
        .output_wave(channel_4));

    wave w(
        .system_clock(clk_100),
        .clock_512(clk_100),
        .reset(BTNC),
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
    
    square2 sq(
            .system_clock(),
            .clock_512(),
            .reset(BTNC),
            .NR20(NRx0),
            .NR21(NR21),
            .NR22(NRx2),
            .NR23(NR23),
            .NR24(NR24),
            .output_wave(channel_2));
    
    
    //inputs for wave channel
    //assign NR32 = volume control
    assign NR33 = 8'b11111111;
    assign NR34 = 3'b111;
    assign addr_0x90 = {4'd2,4'd3,4'd0, 4'd1};
    assign addr_0x92 = {4'd6, 4'd7, 4'd4, 4'd5};
    assign addr_0x94 = {4'd10, 4'd11, 4'd8, 4'd9};
    assign addr_0x96 = {4'd14, 4'd15, 4'd12, 4'd13};
    assign addr_0x98 = {4'd2,4'd3,4'd0, 4'd1};
    assign addr_0x9A = {4'd6, 4'd7, 4'd4, 4'd5};
    assign addr_0x9C = {4'd10, 4'd11, 4'd8, 4'd9};
    assign addr_0x9E = {4'd14, 4'd15, 4'd12, 4'd13};
    
    //inputs for square2 channel -- this is for 50% duty cycle
    assign NR21[7:6] = 2'b10;
    assign NR24 = 3'b111;
    assign NR23 = 8'b11111111;
    
    //inputs for noise channel
    assign NR43 = 8'b0000_0_000; //polynomial counter shift = 0, 15 step, dividing ratio freq = 0
    
    //set generic registers such as volume envelope and length to 0
    assign NRx0 = 0;
    assign NRx1 = 8'd10; //wave should be set to the input wave until time is up
    assign NRx2 = 8'b01111001; // start at volume -0111 attenuate for 1 step
    assign NRx3 = 0;
    assign NRx4 = 8'b0100000;
    
    always_ff @(posedge clk_100) begin
        //maybe need to do some clock checking?
        hphone_valid <= 0;
        hphone_l <= 0;
        hphone_r <= 0;

        if (new_sample == 1) begin
            case ({SW2, SW1, SW0})
                3'b001: begin
                    hphone_valid <= 1'b1;
                    hphone_r <= {channel_2, 18'd0};
                    hphone_l <= {channel_2, 18'd0};
                end 
                3'b010: begin
                    hphone_valid <= 1'b1;
                    hphone_r <= {channel_3, 18'd0};
                    hphone_l <= {channel_3, 18'd0};
                end 
                3'b100: begin
                    hphone_valid <= 1'b1;
                    hphone_r <= {channel_4, 18'd0};
                    hphone_l <= {channel_4, 18'd0};
                end 
                default begin 
                    counter <= counter + 1;
                    hphone_valid <= 1'b1;
                    hphone_r <= {counter, 18'd0};
                    hphone_l <= {counter, 18'd0};
                end
            endcase
        end
    end

    BUFG BUFG_inst(
        .O (clk_100_buffered),
        .I (clk_100)
        );
   
endmodule: audio_testbench_sv
