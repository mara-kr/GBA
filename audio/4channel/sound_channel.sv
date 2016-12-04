module square1 (
    input logic system_clock,
    input logic clock_256,
    (* mark_debug = "true" *) input logic reset,
    input logic [7:0] NR10,
    input logic [7:0] NR11,
    input logic [7:0] NR12,
    input logic [7:0] NR13,
    input logic [7:0] NR14,
    (* mark_debug = "true" *) output logic [23:0]output_wave); 

    logic clock_128;
    logic clock_64;
    (* mark_debug = "true" *) logic enable_square_wave;
    (* mark_debug = "true" *) logic [23:0] square_wave;
    (* mark_debug = "true" *) logic [23:0] length_wave;
    (* mark_debug = "true" *) logic [3:0] volume_level;
    logic [7:0] internal_NR13;
    logic [7:0] internal_NR14;
    
    //assign internal_NR13 = NR13;
    //assign internal_NR14 = NR14;

    //assign output_wave = length_wave;//(enable_square_wave) ? $signed(length_wave) >>> (16-volume_level) : 0;
    assign output_wave = (length_wave[23]) ? (length_wave - (volume_level << 16)) : (length_wave + (volume_level << 16)); 
    //give volume an aribitrary weight, but keep it consistant

    clock_divider cd(clock_256, reset,  clock_128, clock_64);
    frequency_sweep fs(clock_128, reset, NR10, NR13, NR14, internal_NR13, internal_NR14, enable_square_wave);
    square_wave sw(system_clock, reset, NR11, internal_NR13, internal_NR14, square_wave);
    length_counter lc(clock_256, reset, square_wave, NR11, NR14, length_wave);
    volume_envelope ve(clock_64, reset, NR12, volume_level);
 
endmodule: square1


module square2 (
    input logic system_clock,
    input logic clock_256,
    input logic reset,
    input logic [7:0] NR21,
    input logic [7:0] NR22,
    input logic [7:0] NR23,
    input logic [7:0] NR24,
    output logic [23:0] output_wave);

    logic clock_128;
    logic clock_64;
    logic [23:0] square_wave;
    logic [23:0] length_wave;
    logic [3:0] volume_level;

    assign output_wave = (length_wave[23])  ? (length_wave - (volume_level << 16)) : (volume_level + (4'd1 << 16));
    clock_divider cd1(clock_256, reset, clock_128, clock_64);
    square_wave sw1(system_clock, reset, NR21, NR23, NR24, square_wave);
    length_counter lc1(clock_256, reset, square_wave, NR21, NR24, length_wave);
    volume_envelope ve1(clock_64, reset, NR22, volume_level);

endmodule: square2

module wave (
    input logic system_clock,
    input logic clock_256,
    input logic reset,
    input logic [7:0] NR30,
    input logic [7:0] NR31,
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
    output logic [23:0] output_wave);

    logic clock_128;
    logic clock_64;
    logic [23:0] predefined_wave;
    logic [3:0] volume_level;

    clock_divider cd2(clock_256, reset, clock_128, clock_64);
    wave_channel vw2(system_clock, reset, NR32, NR33, NR34,
                addr_0x90, addr_0x92, addr_0x94,
                addr_0x96, addr_0x98, addr_0x9A, addr_0x9C, addr_0x9E, predefined_wave);
    length_counter lc2(clock_256, reset, predefined_wave, NR31, NR34, output_wave);

endmodule: wave

module noise (
    input logic system_clock,
    input logic clock_256,
    input logic reset,
    input logic [7:0] NR41,
    input logic [7:0] NR42,
    input logic [7:0] NR43,
    input logic [7:0] NR44,
    output logic [23:0] output_wave);

    logic clock_128;
    logic clock_64;
    logic [23:0] noise_wave;
    logic [23:0] length_wave;
    logic [3:0] volume_level;

    assign output_wave = (length_wave[23])  ? (length_wave - (volume_level << 16)) 
                            : (length_wave + (volume_level << 16));

    clock_divider cd3(clock_256, reset, clock_128, clock_64);
    noise_channel nc3(system_clock, reset, NR43, noise_wave);
    length_counter lc3(clock_256, reset, noise_wave, NR41, NR44, length_wave);
    volume_envelope ve3(clock_64, reset, NR42, volume_level);

endmodule: noise
