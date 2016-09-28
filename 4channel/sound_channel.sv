//TODO: check system clock should be 24 MHZ
//TODO: double check with specs, check every register
module square1 (
    input logic system_clock,
    input logic clock_512,
    input logic reset,
    input logic [7:0] NR10,
    input logic [7:0] NR11,
    input logic [7:0] NR12,
    inout logic [7:0] NR13,
    inout logic [7:0] NR14,
    output logic [3: 0]wave); //TODO: maybe change this to 8 bits everywhere?

    logic clock_256;
    logic clock_128;
    logic clock_64;
    logic enable_square_wave;
    logic [3:0] square_wave;
    logic [3:0] volume_level;

    assign wave = wave >> volume_level;
    clock_divider cd(clock_512, reset, clock_256,  clock_128, clock_64);
    frequency_sweep fs(clock_128, reset, NR10, NR13, NR14, enable_square_wave);
    square_wave sw(system_clock, reset, NR11, NR13, NR14, square_wave);
    length_counter lc(clock_256, square_wave, NR11, NR14, wave);
    volume_envelope ve(clock_64, NR12, volume_level);
 
endmodule: square1


module square2 (
    input logic system_clock,
    input logic clock_512,
    input logic reset,
    input logic [7:0] NR20,
    input logic [7:0] NR21,
    input logic [7:0] NR22,
    input logic [7:0] NR23,
    input logic [7:0] NR24,
    output logic [3:0] wave);

    logic clock_256;
    logic clock_128;
    logic clock_64;
    logic enable_square_wave;
    logic [3:0] square_wave;
    logic [3:0] volume_level;

    assign wave = wave >> volume_level;
    clock_divider cd1(clock_512, reset, clock_256,  clock_128, clock_64);
    square_wave sw1(system_clock, reset, NR21, NR23, NR24, square_wave);
    length_counter lc1(clock_256, square_wave, NR21, NR24, wave);
    volume_envelope ve1(clock_64, NR22, volume_level);

endmodule: square2

module wave (
    input logic system_clock,
    input logic clock_512,
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
    output logic [3:0] wave);

    logic clock_256;
    logic clock_128;
    logic clock_64;
    logic [3:0] predefined_wave;
    logic [3:0] volume_level;

    clock_divider cd2(clock_512, reset, clock_256,  clock_128, clock_64);
    wave_channel vw2(system_clock, reset, NR32, NR33, NR34,
                addr_0x90, addr_0x92, addr_0x94,
                addr_0x96, addr_0x98, addr_0x9A, addr_0x9C, addr_0x9E, predefined_wave);
    length_counter lc2(clock_256, predefined_wave, NR31, NR34, wave);

endmodule: wave

module noise (
    input logic system_clock,
    input logic clock_512,
    input logic reset,
    input logic [7:0] NR40,
    input logic [7:0] NR41,
    input logic [7:0] NR42,
    input logic [7:0] NR43,
    input logic [7:0] NR44,
    output logic [3:0] wave);

    logic clock_256;
    logic clock_128;
    logic clock_64;
    logic enable_square_wave;
    logic [3:0] square_wave;
    logic [3:0] volume_level;

    assign wave = wave >> volume_level;
    clock_divider cd3(clock_512, reset, clock_256,  clock_128, clock_64);
    noise_channel nc3(system_clock, reset, NR43, wave);
    length_counter lc3(clock_256, square_wave, NR41, NR44, wave);
    volume_envelope ve3(clock_64, NR42, volume_level);

endmodule: noise


//TODO: need to add the mixer to add all 4 channels

