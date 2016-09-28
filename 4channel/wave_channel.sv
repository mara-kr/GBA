module wave_channel (
    input logic system_clock,
    input logic reset,
    input logic [7:0] NR32,
    input logic [7:0] NR33,
    input logic [7:0] NR34,
    input logic [15:0] addr_0x90,
    input logic [15:0] addr_0x92,
    input logic [15:0] addr_0x94,
    input logic [15:0] addr_0x96,
    input logic [15:0] addr_0x98,
    input logic [15:0] addr_0x9A,
    input logic [15:0] addr_0x9C,
    input logic [15:0] addr_0x9E,
    output logic [3:0] wave);

    logic [12:0] frequency_timer_period;
    logic [10:0]frequency;
    logic frequency_timer_clock;
    logic [6:0] position_counter;
    logic [127:0]waveform_pattern;
    logic [3:0] volume_control;

    logic top_byte;
    
    assign frequency = {NR34[2:0], NR33[7:0]};
    assign frequency_timer_period = (2048-frequency)*4;
    assign waveform_pattern = {addr_0x9E, addr_0x9C, addr_0x9A, addr_0x98, 
                                addr_0x96, addr_0x94, addr_0x92, addr_0x90};
    assign wave = (waveform_pattern[(position_counter+3)-:4]) >> volume_control;

    frequency_timer ft(system_clock, reset, frequency_timer_period, frequency_timer_clock);

    always_comb begin
        case (NR32[7:5])
            3'b000: volume_control = 3'd4;
            3'b001: volume_control = 3'd0;
            3'b010: volume_control = 3'd1;
            3'b011: volume_control = 3'd2;
            default: volume_control = 3'd3; //forced 3/4 output
        endcase
    end

    always_ff @(posedge frequency_timer_clock, posedge reset) begin
        if(reset) begin
            top_byte <= 1;
            position_counter <= 4;
        end
        else if(top_byte) begin
            position_counter <= position_counter - 4'd4;
        end
        else begin
            position_counter <= position_counter + 4'd12;
        end
        top_byte = !top_byte;
    end


endmodule: wave_channel



/** test only checks that position counter gets incremented correctly **/
/**module wave_channel_test ();
    logic clock;
    logic reset;
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
    logic [3:0] wave;


    wave_channel dut(clock, reset, NR32, NR33, NR34, addr_0x90, addr_0x92,
         addr_0x94, addr_0x96, addr_0x98, addr_0x9A, addr_0x9C, addr_0x9E, wave);

    initial begin
        $monitor ("clock = %b, position_counter=%d, wave=%d",
        dut.frequency_timer_clock, dut.position_counter, wave);

        clock <= 0;
        reset <= 1;
        NR34 = 3'b111;
        NR33 = 8'b11111111;
        addr_0x90 = {4'd2,4'd3,4'd0, 4'd1};
        addr_0x92 = {4'd6, 4'd7, 4'd4, 4'd5};
        addr_0x94 = {4'd10, 4'd11, 4'd8, 4'd9};
        addr_0x96 = {4'd14, 4'd15, 4'd12, 4'd13};
        addr_0x98 = {4'd2,4'd3,4'd0, 4'd1};
        addr_0x9A = {4'd6, 4'd7, 4'd4, 4'd5};
        addr_0x9C = {4'd10, 4'd11, 4'd8, 4'd9};
        addr_0x9E = {4'd14, 4'd15, 4'd12, 4'd13};
        #2 reset <= 0;

        #640 $finish;
    end

    always 
        #1 clock = !clock;

endmodule: wave_channel_test*/
