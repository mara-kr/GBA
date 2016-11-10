module ch4_mixer ( input logic system_clock,
               input logic reset,
               input logic [23:0] channel1,
               input logic [23:0] channel2,
               input logic [23:0] channel3,
               input logic [23:0] channel4,
               input logic pause_channel_1,
               input logic pause_channel_2,
               input logic pause_channel_3,
               input logic pause_channel_4,
               input logic [7:0] NR50,
               input logic [7:0] NR51,
               input logic [7:0] NR52,
               output logic [23:0] output_wave_left,
               output logic [23:0] output_wave_right); //used to reset the system

               logic [23:0] channel1_output_l;
               logic [23:0] channel2_output_l;
               logic [23:0] channel3_output_l;
               logic [23:0] channel4_output_l;
               logic [23:0] channel1_output_r;
               logic [23:0] channel2_output_r;
               logic [23:0] channel3_output_r;
               logic [23:0] channel4_output_r;
               
               logic [3:0] volume_control_l;
               logic [3:0] volume_control_r;
               
    
               assign channel1_output_l = (NR51[4] && ~pause_channel_1) ? channel1 : 24'b0;
               assign channel2_output_l = (NR51[5] && ~pause_channel_2) ? channel2 : 24'b0;
               assign channel3_output_l = (NR51[6] && ~pause_channel_3) ? channel3 : 24'b0;
               assign channel4_output_l = (NR51[7] && ~pause_channel_4) ? channel4 : 24'b0;
               assign channel1_output_r = (NR51[0] && ~pause_channel_1) ? channel1 : 24'b0;
               assign channel2_output_r = (NR51[1] && ~pause_channel_2) ? channel2 : 24'b0;
               assign channel3_output_r = (NR51[2] && ~pause_channel_3) ? channel3 : 24'b0;
               assign channel4_output_r = (NR51[3] && ~pause_channel_4) ? channel4 : 24'b0;
                               //channel >> (master_volume << 1)
        
               assign output_wave_left = (channel1_output_l + channel2_output_l 
                                            + channel3_output_l + channel4_output_l) + volume_control_l; 
               assign output_wave_right = (channel1_output_r + channel2_output_r 
                                            + channel3_output_r + channel4_output_r) + volume_control_r; 
               
               
               
               //again arbirtrary (16) weight for volume but keep it consistent
                     // master volume is weight 2x that of channel volume 
                always_comb begin
                    if (output_wave_left[23] == 'bX) begin // for reset because there is circular logic
                        volume_control_l = 0;
                    end
                    else if (output_wave_left[23]) begin
                        volume_control_l = -((NR50[6:4] << 1) << 16);
                    end
                    else begin
                        volume_control_l = ((NR50[6:4] << 1) << 16);
                    end
                end
                
                always_comb begin
                    if (output_wave_right[23] == 'bX) begin
                        volume_control_r = 0;
                    end
                    else if (output_wave_right[23]) begin
                        volume_control_r = -(NR50[2:0] << 1) << 16;
                    end
                    else begin
                        volume_control_r = (NR50[2:0] << 1) << 16;
                    end
                end

endmodule: ch4_mixer

