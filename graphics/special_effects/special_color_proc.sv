module special_color_proc (
    input logic [19:0] layer0,
    input logic [13:0] BLDCNT,
    input logic [4:0] effects,
    input logic [19:0] layer1,
    input logic [15:0] color0,
    input logic [15:0] color1,
    input logic [15:0] BLDALPHA,
    input logic [15:0] BLDY,
    output logic color);

    logic [2:0] effects_bit_layer_0;
    logic [2:0] effects_bit_layer_1;
    logic match1;
    logic match2;
    logic select_color;
    logic [1:0] control;
    logic [4:0] col1;
    logic [4:0] col2;
    logic [4:0] col3;
    
    //which bit of effects to look at
    assign effects_bit_lay_0 = (layer0[17]) ? 3'd4 : {1'b0, layer0[9:8]};
    assign effects_bit_lay_1 = (layer1[17]) ? 3'd4 : {1'b0, layer1[9:8]};

    match_target mt1(.layer(layer0), .targets(BLDCNT[5:0]), .match(match1));
    match_target mt2(.layer(layer1), .targets(BLDCNT[13:8]), .match(match2));

    assign select_color = ((match1 & match2) & effects[effects_bit_lay_0]) | 
                          (layer0[13] & match2);

    assign control = (layer0[13]) ? 2'b10 : BLDCNT[7:6];

    process_color pc1(.first(color0[4:0]), .second(color1[4:0]), 
                        .alpha(BLDALPHA), .Y(BLDY), .control, .color(col1));
    process_color pc2(.first(color0[9:5]), .second(color1[9:5]), 
                        .alpha(BLDALPHA), .Y(BLDY), .control, .color(col2));

    process_color pc3(.first(color0[14:10]), .second(color1[14:10]), 
                        .alpha(BLDALPHA), .Y(BLDY), .control, .color(col3));
    assign color = (select_color) ? {col3, col2, col1} : color0;
endmodule: special_color_proc
