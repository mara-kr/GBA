
module noise_channel(
    input logic system_clock, //frequency timer
    input logic reset,
    input logic [7:0] NR43,
    output logic wave);
    
    logic [14:0] LFSR;
    logic [14:0] LFSR_right_shift;
    logic step7;
    logic old_step7;
    logic [12:0] frequency_timer_period;
    logic [3:0] shift_freq;
    logic frequency_timer_clock;
    logic [6:0] base_divisor;

    assign wave = ~(LFSR[0]);
    assign step7 = NR43[3];
    assign LFSR_right_shift = LFSR >> 1;
    assign shift_freq = NR43[7:4];
    //TODO: unsure about the shift freq??
    assign frequency_timer_period = (base_divisor << shift_freq);

    frequency_timer ft(system_clock, reset, frequency_timer_period, frequency_timer_clock);
    always_comb begin 
        case (NR43[2:0])
            3'b000: base_divisor = 7'd8;
            3'b001: base_divisor = 7'd16;
            3'b010: base_divisor = 7'd32;
            3'b011: base_divisor = 7'd48;
            3'b100: base_divisor = 7'd64;
            3'b101: base_divisor = 7'd80;
            3'b110: base_divisor = 7'd96;
            3'b111: base_divisor = 7'd112;
        endcase
    end

    always_ff @(posedge frequency_timer_clock, posedge reset) begin
        if (reset || (step7 != old_step7)) begin //if LFSR changed width 
            if (step7) begin
                LFSR <= 7'h40;
            end
            else begin
                LFSR <= 15'h4000;
            end
        end
        else begin
            LFSR <= {(LFSR[1] ^ LFSR[0]), LFSR_right_shift[13:0]};
            if( step7) begin //just ignore the top 8 bits
                LFSR <= {(LFSR[1] ^ LFSR[0]), LFSR_right_shift[6:0]};
            end
        end
        old_step7 <= step7;
    end

endmodule: noise_channel

module noise_channel_test();
    logic clock;
    logic reset;
    logic [7:0] NR43;
    logic wave;

    noise_channel dut(clock, reset, NR43, wave);

    initial begin
        $monitor("freq_clock=%b, reset=%b, NR43=%b, wave=%b LFSR=%b", 
                dut.frequency_timer_clock, reset, NR43, wave, dut.LFSR);
        
        clock <= 1;
        reset <= 1;
        #2
        reset <= 0;
        $display("Set to 15 bit LSFR");
        NR43 <= 8'b0000_0_000; //polynomial counter shift = 0, 15 step, dividing ratio freq = 0
        #1000
        $display("Check that the LSFR is now 7 bit");
        NR43 <= 8'b0000_1_000; //polynomial counter shift = 0, 7 step, dividing ration freq = 0
        #1000
        $finish;

    end

    always
        #1 clock = !clock;

endmodule: noise_channel_test

