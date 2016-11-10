module ds_mixer (
       input logic clock,
       input logic reset,
       input logic [23:0] direct_A,
       input logic [23:0] direct_B,
       input logic [23:0] channel4_l,
       input logic [23:0] channel4_r,
       input logic [15:0] sound_cnt_h,
       output logic timer_numA,
       output logic timer_numB,
       output logic reset_directA,
       output logic reset_directB,
       output logic [23:0] output_wave_r,
       output logic [23:0] output_wave_l);

       //Assumption: timer is turned on by processor

       assign timer_numB = sound_cnt_h[14];
       assign timer_numA = sound_cnt_h[10];

       assign reset_directA = sound_cnt_h[11];
       assign reset_directB = sound_cnt_h[15];

       logic [23:0] directA_l;
       logic [23:0] directA_r;
       logic [23:0] directB_l;
       logic [23:0] directB_r;

       logic out_ratio_A;
       logic out_ratio_B;
       logic [1:0] out_ratio_4ch;

       assign directA_l = (sound_cnt_h[9] && !reset_directA) ? direct_A : 23'b0;
       assign directB_l = (sound_cnt_h[13] && !reset_directB) ? direct_B : 23'b0;
       assign directA_r = (sound_cnt_h[8] && !reset_directA) ? direct_A : 23'b0;
       assign directB_r = (sound_cnt_h[12] && !reset_directB) ? direct_B : 23'b0;

       assign out_ratio_A =  (sound_cnt_h[2]) ? 1'b0 : 1'b1; //right shift by one decreases sound by half
       assign out_ratio_B =  (sound_cnt_h[3]) ? 1'b0 : 1'b1; //right shift by one decreases sound by half
       always_comb begin
           case (sound_cnt_h[1:0])
                2'b00: out_ratio_4ch = 2'd2;
                2'b01: out_ratio_4ch = 2'd1;
                2'b10: out_ratio_4ch = 2'd0;
                default: out_ratio_4ch = 2'd0;
            endcase
       end
      
       assign output_wave_r = (directA_r >> out_ratio_A) + (directB_r >> out_ratio_B) + (channel4_r >> out_ratio_4ch);
       assign output_wave_l = (directA_l >> out_ratio_A) + (directB_l >> out_ratio_B) + (channel4_l >> out_ratio_4ch);

endmodule: ds_mixer
