//TODO: check system clock should be 24 MHZ
//TODO: double check with specs, check every register
module square1 (
    input logic clock_512,
    input logic reset,
    input logic [7:0] NR10,
    input logic [7:0] NR11,
    input logic [7:0] NR12,
    inout logic [7:0] NR13,
    inout logic [7:0] NR14,
    output logic [23: 0]wave) //TODO: maybe change this to 8 bits everywhere?

    logic clock_128;
    logic clock_64;
    logic enable_square_wave;
    logic [23:0] square_wave;

    clock_divider(clock_512, reset, clock_256,  clock_128, clock_64);
    frequency_sweep(clock_128, reset, NR10, NR13, NR14, enable_square_wave);
    square_wave (system_clock, reset, NR11, NR13, NR14, square_wave);
    length_counter (clock_256, square_wave, NR11, NR14, wave); //TODO: check volume level??
    volume_envelope(clock_64, NR12, volume_level);
 
endmodule: square1


module square2 (
    input logic clock_512,
    input logic reset,
    input logic [7:0] NR20,
    input logic [7:0] NR21,
    input logic [7:0] NR22,
    input logic [7:0] NR23,
    input logic [7:0] NR24,
    output logic wave)

    logic clock_128;
    logic clock_64;
    logic enable_square_wave;
    logic [23:0] square_wave;

    clock_divider(clock_512, reset, clock_256,  clock_128, clock_64);
    square_wave (system_clock, reset, NR11, NR13, NR14, square_wave);
    length_counter (clock_256, square_wave, NR11, NR14, wave); //TODO: check volume level??
    volume_envelope(clock_64, NR12, volume_level);

endmodule: square2

//TODO: what do you do with with NR33 and NR34 regs??
module wave (
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
    output logic [3:0] wave)

    clock_divider(clock_512, reset, clock_256,  clock_128, clock_64);
    wave_channel (system_clock, reset, addr_0x90, addr_0x92, addr_0x94,
                addr_0x96, addr_0x98, addr_0x9A, addr_0x9C, addr_0x9E, wave);
    length_counter (clock_256, square_wave, NR31, NR34, wave); //TODO: check volume level??

endmodule: wave

module noise (
    input logic [7:0] NR40,
    input logic [7:0] NR41,
    input logic [7:0] NR42,
    input logic [7:0] NR13,
    input logic [7:0] NR44,
    output logic wave)

    clock_divider(clock_512, reset, clock_256,  clock_128, clock_64);
    noise_channel (system_clock, reset, NR43, wave)
    length_counter (clock_256, square_wave, NR41, NR44, wave);
    volume_envelope(clock_64, NR42, volume_level);

endmodule: noise

