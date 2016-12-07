
module priority_eval (
    input logic[19:0] BG,
    input logic [19:0] OBJ,
    input logic [31:0] data,
    input logic clk,
    input logic clear,

    input logic [15:0] winin,
    input logic [15:0] winout,
    input logic [15:0] dispcnt,
    input logic [7:0] vcount,
    input logic [15:0] win0H,
    input logic [15:0] win1H,
    input logic [15:0] win0V,
    input logic [15:0] win1V,

    //control signals from FSM
    input logic [7:0] col,
    input logic send_address_1,
    input logic send_address_2,
    input logic read_data_1,
    input logic read_data_2,

    output logic [31:0] address,
    output logic addr_is_obj,
    output logic [14:0] color0,
    output logic [14:0] color1,
    output logic [19:0] layer0,
    output logic [19:0] layer1,
    output logic [4:0] effects);

    (* mark_debug = "true" *) logic [19:0] top_in;
    (* mark_debug = "true" *) logic [19:0] top_saved;
    (* mark_debug = "true" *) logic [19:0] bot_in;
    (* mark_debug = "true" *) logic [19:0] bot_saved;

    (* mark_debug = "true" *) logic replace_top;
    (* mark_debug = "true" *) logic replace_bot;
    logic [1:0] bgno;

    (* mark_debug = "true" *) logic [4:0] mask;
    (* mark_debug = "true" *) logic replace1;
    (* mark_debug = "true" *) logic replace2;
    (* mark_debug = "true" *) logic replace3;
    (* mark_debug = "true" *) logic replace4;
    (* mark_debug = "true" *) logic replace5;

    logic [19:0] out_mux2;
    logic [19:0] out_mux3;
    logic select_mux3;

    logic out_valid1;
    logic out_valid2;
    logic out_valid3;

    logic window_obj;
    (* mark_debug = "true" *) logic win0;
    (* mark_debug = "true" *) logic win1;

    pe_window_detector wd (.objmode(OBJ[14:13]), .X(col),
                        .Y(vcount), .win0H, .win1H,
                        .win0V, .win1V, .obj(window_obj),
                        .win0, .win1);
    pe_window_masker wm (.obj(window_obj), .win0, .win1, .winin,
                      .winout, .mask, .effects, .dispcnt);

    assign replace_top = replace2 | replace3;
    assign replace_bot = replace4 | replace5;
    pe_register #(20) TOP(.q(top_saved), .d(top_in), .clk, .clear, 
                .enable(replace_top), .rst_b(1'b1));
    pe_register #(20) BOT(.q(bot_saved), .d(bot_in), .clk, .clear, 
                .enable(replace_bot), .rst_b(1'b1));
    priority_comparator priority_comparator1(.inputA(BG), .inputB(OBJ), 
                .mask(mask), .bgno, .replace(replace1));
    
    //HACK
    logic [19:0] bg_masked;
    assign bg_masked = mask[bgno] ? BG : {BG[19:16], 1'b0, BG[14:0]};
    logic [19:0] obj_masked;
    assign obj_masked = mask[4] ? OBJ : {OBJ[19:16], 1'b0, OBJ[14:0]};
    //ENDHACK
    
    pe_mux_2_to_1 #(20) mux1(.out(top_in), .in0(obj_masked), .in1(bg_masked), .select(replace1));
    pe_mux_2_to_1 #(20) mux2(.out(out_mux2), .in0(bg_masked), .in1(obj_masked), .select(replace1));
    //pe_mux_2_to_1 #(20) mux1(.out(top_in), .in0(OBJ), .in1(BG), .select(replace1));
    //pe_mux_2_to_1 #(20) mux2(.out(out_mux2), .in0(BG), .in1(OBJ), .select(replace1));
    pe_mux_2_to_1 #(20) mux3(.out(out_mux3), .in0(top_saved), .in1(out_mux2), 
                .select(~out_valid1 & out_valid2 & out_valid3));
    pe_mux_2_to_1 #(20) mux4(.out(bot_in), .in0(top_in), .in1(out_mux3), 
                .select(replace_top));


    priority_comparator priority_comparator2(.inputA(BG), .inputB(top_saved), 
                .mask, .bgno, .replace(replace2));
    priority_comparator priority_comparator3(.inputA(OBJ), .inputB(top_saved), 
                .mask, .bgno, .replace(replace3));
    priority_comparator priority_comparator4(.inputA(BG), .inputB(bot_saved), 
                .mask, .bgno, .replace(replace4));
    priority_comparator priority_comparator5(.inputA(OBJ), .inputB(bot_saved), 
                .mask, .bgno, .replace(replace5));

    pe_counter #(2) bgno_cntr (.q(bgno), .en(1'b1), .clear, .clk, .rst_b(1'b1));
    pe_valid valid1(.A(top_saved), .mask, .bgno, .valid(out_valid1));
    pe_valid valid2(.A(OBJ), .mask, .bgno, .valid(out_valid2));
    pe_valid valid3(.A(BG), .mask, .bgno, .valid(out_valid3));

    pe_mux_2_to_1 #(20) mux5(.out(layer0), .in0(top_saved), .in1(top_in), 
                .select(replace_top));
    pe_mux_2_to_1 #(20) mux6(.out(layer1), .in0(bot_saved), .in1(bot_in), 
                .select(replace_bot));

    //code send one address a to the PRAM controller at a time
    logic [7:0] address_saved;
    logic data_1_is_top;
    logic [15:0] data_from_PRAM;

    assign data_from_PRAM = (address_saved[1]) ? data[31:16] : data[15:0];
    always_comb begin
        addr_is_obj = layer0[17];
        if (send_address_1 == 1) begin
            address = {layer0[7:0], 1'b0};
            data_1_is_top=1'b0;
        end
        else if (send_address_2 == 1)  begin
            if (layer0[7:0] == address_saved) begin
                address = {23'b0, layer1[7:0], 1'b0};
                data_1_is_top=1'b1;
            end
            else begin 
                address = {23'b0, layer0[7:0], 1'b0};
                data_1_is_top=1'b0;
            end
        end
        else begin
            address = 32'b0;
            data_1_is_top = 1'b0;
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

