`default_nettype none

//Assumptions;
//  1. anytime any register value is changed the volume envelope will reset
//  2. there is no reset, maybe need to set all registers to zero?
//  3. If there is a register change, updates begin on next clock cycle
module volume_envelope (
        input logic clock_64,
        input logic [7:0] NRx2,
        output logic [3:0] volume_level);

        //envelope characteristics
        logic [2:0] num_steps;
        logic increase;
        logic [3:0] initial_value;
        logic [3:0] old_volume_level;
        logic [4:0] calc_volume_level;
        logic [7:0] old_NRx2;
        logic update_regs;

        assign update_regs = (old_NRx2 != NRx2) ? 1 : 0;
        assign volume_level = (calc_volume_level >= 0 & calc_volume_level <= 15) ? 
                                calc_volume_level : old_volume_level;
        assign initial_value = NRx2[7:4];

        always_ff @(posedge clock_64) begin
            old_volume_level <= volume_level;
            old_NRx2 <= NRx2;
        end

        always_ff @(posedge clock_64) begin
            if (update_regs) begin
                num_steps <= NRx2[2:0];
                increase <= NRx2[3];
                calc_volume_level <= NRx2[7:4];
            end
            else if (num_steps > 0) begin
                num_steps <= num_steps -1;
                if (increase) begin
                    calc_volume_level <= volume_level + 1;
                end
                else begin
                    calc_volume_level <= volume_level - 1;
                end
            end
            else begin
                calc_volume_level <= volume_level;
            end
        end
endmodule: volume_envelope

 
module clock_divider_test ();
    logic clock;
    logic [7:0] NRx2;
    logic [3:0] volume;

    logic [3:0]initial_value;
    logic increase;
    logic [2:0] num_steps;
    assign NRx2 = {initial_value, increase, num_steps};

    volume_envelope dut(clock, NRx2, volume);

    initial begin
        $monitor("clock = %b, initial_value = %d, increase = %b, num_steps= %d, volume=%d update_regs = %b NRx2=%b old_NRx2=%b calc_volume=%d old_volume=%d", 
                clock, initial_value, increase, num_steps, volume, dut.update_regs, NRx2, dut.old_NRx2, dut.calc_volume_level, dut.old_volume_level);
                
        clock = 0;
        initial_value = 4'd0;
        increase = 1'b0;
        num_steps = 3'd0;
        #2
        initial_value = 4'd13;
        increase = 1'b0;
        num_steps = 3'd4;
        #2 assert(volume == 4'd13);
        #8 assert (volume == 4'd9);
        #4 assert (volume == 4'd9);
        
        increase = 1'b1;
        num_steps = 3'd2;
        #2 assert(volume == 4'd13);
        #4 assert(volume == 4'd15);
        
        increase = 1'b1;
        num_steps = 3'd7;
        initial_value = 4'd13;
        #2 assert(volume == 4'd13);
        #4 assert(volume == 4'd15);
        #4 assert(volume == 4'd15);

        #4 $finish;
    end

    always    
         #1 clock = !clock;

endmodule: clock_divider_test;
