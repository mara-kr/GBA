
module direct_sound (
    input logic sampling_rate,
    input logic reset,
    input logic [15:0] FIFO_A_L,
    input logic [15:0] FIFO_B_L,
    input logic [15:0] FIFO_A_H,
    input logic [15:0] FIFO_B_H,
    output logic [23:0] waveA,
    output logic [23:0] waveB);

    logic [4:0] position_counter;
    logic [31:0] waveformA_pattern;
    logic [31:0] waveformB_pattern;

    assign waveformA_pattern = {FIFO_A_H, FIFO_A_L};
    assign waveformB_pattern = {FIFO_B_H, FIFO_B_L};

    assign waveA = {waveformA_pattern[(position_counter+7)-:8], 16'b0};
    assign waveB = {waveformB_pattern[(position_counter+7)-:8], 16'b0};

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
    logic sampling_rate;
    logic reset;
    logic [15:0] FIFO_A_L;
    logic [15:0] FIFO_B_L;
    logic [15:0] FIFO_A_H;
    logic [15:0] FIFO_B_H;
    logic [23:0] waveA;
    logic [23:0] waveB;


    direct_sound dut (.sampling_rate, .reset, .FIFO_A_L, .FIFO_B_L, .FIFO_A_H,
                      .FIFO_B_H, .waveA, .waveB);
    initial begin
        $monitor ("clk=%b, rest=%b, position=%d, waveformA=%h, waveformB=%h",
                sampling_rate, reset, dut.position_counter, waveA, waveB);

        sampling_rate <= 0;
        reset <= 1;
        #2
        reset <= 0;
        FIFO_A_L = 16'hAABB;
        FIFO_A_H = 16'h1122;

        FIFO_B_L = 16'hCCDD;
        FIFO_B_H = 16'h3344;
        #16 $finish;
    end
    
    always
        #1 sampling_rate = !sampling_rate;
endmodule: direct_sound_test;

