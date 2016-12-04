module power(
    input logic clock,
    input logic [7:0] NR52,
    output logic reset_channel1,
    output logic reset_channel2,
    output logic reset_channel3,
    output logic reset_channel4);


    logic old_operate_1;
    logic old_operate_2;
    logic old_operate_3;
    logic old_operate_4;
    logic old_operate;

    assign reset_channel1 = (~old_operate && NR52[7]) ? 1 : 0;
    assign reset_channel2 = (~old_operate && NR52[7]) ? 1 : 0;
    assign reset_channel3 = (~old_operate && NR52[7]) ? 1 : 0;
    assign reset_channel4 = (~old_operate && NR52[7]) ? 1 : 0;

   always_ff  @(posedge clock) begin
        old_operate_1 <= NR52[0];
        old_operate_2 <= NR52[1];
        old_operate_3 <= NR52[2];
        old_operate_4 <= NR52[3];
        old_operate <= NR52[7];
    end


endmodule: power
