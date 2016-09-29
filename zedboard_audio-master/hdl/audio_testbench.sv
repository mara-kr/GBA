`default_nettype none
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
    inout  wire AC_SDA);


    logic        clk_100_buffered;
    logic [5:0]  counter;
    logic [23:0] hphone_l, hphone_r;
    logic        hphone_valid;
    logic        new_sample;
    logic        sample_clk_48k;
    logic [23:0] line_in_r, line_in_l;

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
    
    always_ff @(posedge clk_100) begin
        //maybe need to do some clock checking?
        hphone_valid <= 0;
        hphone_l <= 0;
        hphone_r <= 0;

        if (new_sample == 1) begin
            counter <= counter + 1;
            hphone_valid <= 1'b1;
            hphone_r <= {counter, 18'd0};
            hphone_l <= {counter, 18'd0};
        end
    end

    BUFG BUFG_inst(
        .O (clk_100_buffered),
        .I (clk_100)
        );
   
endmodule: audio_testbench_sv
