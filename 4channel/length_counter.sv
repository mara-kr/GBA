//asumptions 
//      1. if counter is reset to 10 -> it should already start decrementing on next clock cycle
//      2. if initializiion flag is set (NRx4 bit 7) the counter is reset, and will continue to reset
//      until initialization flag is turned off
//      3. there is no reset, maybe need to set all registers to zero?

//change wave to enable output
module length_counter (
    input logic clock_256,
    input logic reset,
    input logic [27:0] input_wave,
    input logic [7:0] NRx1, 
    input logic [7:0] NRx4,
    output logic [27:0] wave);

    logic internal_enable;
    logic initialization_flag;
    logic sound_length_counter;
    logic old_sound_length_counter;
    logic update_regs;
    logic [7:0]old_NRx1;
    logic update_sound_length_counter;

    logic [5:0] counter;

    assign initialization_flag = NRx4[7];
    //0: continuous
    //1: counter
    assign sound_length_counter = NRx4[6];
    assign internal_enable = (counter) ? 1'b1 : 1'b0;
    assign wave = (internal_enable) ? input_wave : 27'b0;

    assign update_regs = (old_NRx1 != NRx1) ? 1'b1 : 1'b0;
    assign update_sound_length_counter = (old_sound_length_counter != sound_length_counter) ? 
                                            1'b1 : 1'b0;
    always_ff @(posedge clock_256) begin
        old_NRx1 <= NRx1;
        old_sound_length_counter <= sound_length_counter;
    end

    always_ff @(posedge clock_256, posedge reset) begin
        if (update_regs || initialization_flag || update_sound_length_counter || reset)  begin
            counter <= (NRx1[5:0] -1); //start at -1 because it includes 0
        end
        else if (sound_length_counter == 1 & counter != 0) begin
            counter <= counter - 1;
        end
    end
endmodule: length_counter


/*module length_counter_test ();

    logic clock;
    logic [3:0] input_wave;
    logic [7:0] NRx1;
    logic [7:0] NRx4;
    logic [3:0] wave;

    length_counter dut(clock, input_wave, NRx1, NRx4, wave);

    initial begin 
        $monitor("clock= %b, NRx1=%b, NRx4=%b, wave=%h, int_enable=%b, counter=%d sound_l_cnter = %d, update_regs=%d" ,
                clock, NRx1, NRx4, wave, dut.internal_enable, dut.counter, 
                dut.sound_length_counter, dut.update_regs);

         clock = 0;
         NRx4 = 0;
         NRx1 = 0;
         #2
         input_wave = 24'hDEADBE;
        
         NRx1 = 8'd10; //wave should be set to the input wave until time is up
         NRx4[6] = 1; //set to count mode
         NRx4[7] = 0; //turn off initialization
        #18 assert (wave == input_wave);
        #2 assert (wave == 0);
        
        #6 NRx1 = 8'd5;
        #4 NRx1 = 5'd6; //reset the counter
        #2 assert(dut.counter == (NRx1 - 1));
        
        #4 NRx1 = 5'd2; //reset the counter
        #2 assert(dut.counter == (NRx1 - 1));
       
        NRx1 = 5'd2; //reset the counter
        #2 NRx4[6] = 0; // counter shouldn't decrement
        #2 NRx4[6] = 1; // reset counter as expected
        #2 assert(dut.counter == (NRx1 - 1));

        NRx1 = 5'd7; //reset the counter
        #2 assert(dut.counter == (NRx1 - 1));
        #2 NRx4[7] = 1; //counter should reset
        #2 assert(dut.counter == (NRx1 - 1));
        #2 assert(dut.counter == (NRx1 - 1));
        #2 NRx4[7] = 0; //counter should reset
        #14 assert(dut.counter == 0);
            assert (wave == 0);



        #4 $finish;
    end

    always    
         #1 clock = !clock;

endmodule: length_counter_test*/
