
module priority_eval (
    input logic[19:0] BG,
    input logic [19:0] OBJ,
    input logic [31:0] data,
    input logic clk,
    input logic clear,

    input logic [15:0] winin,
    input logic [15:0] winout,
    input logic [15:0] disp,
    input logic [7:0] vcount,
    input logic [7:0] win0H,
    input logic [7:0] win1H,
    input logic [7:0] win0V,
    input logic [7:0] win1V,

    //control signals from FSM
    input logic [7:0] col,
    input logic send_address_1,
    input logic send_address_2,
    input logic read_data_1,
    input logic read_data_2,

    output logic [31:0] address,
    output logic [14:0] color0,
    output logic [14:0] color1,
    output logic [19:0] layer0,
    output logic [19:0] layer1,
    output logic [4:0] effects);

    logic [7:0] top_in;
    logic [19:0] top_saved;
    logic [7:0] bot_in;
    logic [19:0] bot_saved;

    logic replace_top;
    logic replace_bot;


    logic [4:0] mask;
    logic replace1;
    logic replace2;
    logic replace3;
    logic out_mux2;
    logic out_mux3;
    logic select_mux3;

    logic out_valid1;
    logic out_valid2;
    logic out_valid3;

    logic window_obj;
    logic [7:0] win0;
    logic [7:0] win1;

    window_detector wd (.objmode(OBJ[14:3]), .X(col),
                        .Y(vcount), .win0H, .win1H,
                        .win0V, .win1V, .obj(window_obj),
                        .win0, .win1);
    window_masker wm (.obj(window_obj), .win0, .win1, .winin,
                      .winout, .disp, .mask, .effects);

    pe_register #(20) TOP(.q(top_saved), .d(top_in), .clk(), .clear(), 
                .enable(replace2 | replace3));
    pe_register #(20) BOT(.q(bot_saved), .d(bot_in), .clk(), .clear(), 
                .enable(replace4 | replcae5));
    priority_comparator priority_comparator1(.inputA(BG), .inputB(OBJ), 
                .mask(mask), .replace(replace1));
    
    pe_mux_2_to_1 #(20) mux1(.out(top_in), .in0(OBJ), .in1(BG), .select(replace1));
    pe_mux_2_to_1 #(20) mux2(.out(out_mux2), .in0(BG), .in1(OBJ), .select(replace1));
    pe_mux_2_to_1 #(20) mux3(.out(out_mux3), .in0(top_saved), .in1(out_mux2), 
                .select(~out_valid1 & out_valid2 & out_valid3));
    pe_mux_2_to_1 #(20) mux4(.out(bot_in), .in0(top_in), .in1(out_mux3), 
                .select(replace_top));


    priority_comparator priority_comparator2(.inputA(BG), .inputB(top_saved), 
                .mask(), .replace(replace2));
    priority_comparator priority_comparator3(.inputA(OBJ), .inputB(top_saved), 
                .mask(), .replace(replace3));
    priority_comparator priority_comparator4(.inputA(BG), .inputB(bot_saved), 
                .mask(), .replace(replace4));
    priority_comparator priority_comparator5(.inputA(OBJ), .inputB(bot_saved), 
                .mask(), .replace(replace5));

    pe_valid valid1(.A(top_saved), .mask(), .valid(out_valid1));
    pe_valid valid2(.A(OBJ), .mask(), .valid(out_valid2));
    pe_valid valid3(.A(BG), .mask(), .valid(out_valid3));

    pe_mux_2_to_1 #(20) mux5(.out(layer0), .in0(top_saved), .in1(top_in), 
                .select(replace_top));
    pe_mux_2_to_1 #(20) mux6(.out(layer1), .in0(bot_saved), .in1(bot_in), 
                .select(replace_bot));

    //code send one address a to the PRAM controller at a time
    logic [7:0] address_saved;
    logic data_1_is_top;
    logic [15:0] data_from_PRAM;

    assign data_from_PRAM = (address_saved[0]) ? data[31:16] : data[15:0];
    always_comb begin
        if (send_address_1 == 1) begin
            address = layer0[7:0];
        end
        else if (send_address_2 == 1)  begin
            if (layer0[7:0] == address_saved) begin
                address = {24'h500000, layer1[7:0]};
                data_1_is_top=1;
            end
            else begin 
                address = {24'h500000, layer0[7:0]};
                data_1_is_top=0;
            end
        end
    end


    always_ff @(posedge clk) begin
        address_saved <= address;
        if (read_data_1) begin
            color0 <= data_from_PRAM[14:0];
        end
        else if (read_data_2) begin
            if(data_1_is_top) begin
                color1 <= data_from_PRAM[14:0];
            end
            else begin
                color1 <= color0;
                color0 <= data_from_PRAM[14:0];
            end
        end
        else begin
            color0 <= color0;
            color1 <= color1;
        end
    end



endmodule: priority_eval

