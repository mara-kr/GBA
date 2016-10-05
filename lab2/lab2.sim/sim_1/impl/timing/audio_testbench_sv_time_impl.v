// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Wed Oct  5 17:00:07 2016
// Host        : hypnos.andrew.local.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file
//               /afs/ece.cmu.edu/usr/ryanovsk/Private/18545/GBA/lab2/lab2.sim/sim_1/impl/timing/audio_testbench_sv_time_impl.v
// Design      : audio_testbench_sv
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

module ADAU1761_interface
   (AC_MCLK,
    CLK_48);
  output AC_MCLK;
  input CLK_48;

  wire AC_MCLK;
  wire CLK_48;
  wire master_clk_i_1_n_0;

  LUT1 #(
    .INIT(2'h1)) 
    master_clk_i_1
       (.I0(AC_MCLK),
        .O(master_clk_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    master_clk_reg
       (.C(CLK_48),
        .CE(1'b1),
        .D(master_clk_i_1_n_0),
        .Q(AC_MCLK),
        .R(1'b0));
endmodule

module IOBUF_UNIQ_BASE_
   (IO,
    O,
    I,
    T);
  inout IO;
  output O;
  input I;
  input T;

  wire I;
  wire IO;
  wire O;
  wire T;

  IBUF #(
    .IOSTANDARD("DEFAULT")) 
    IBUF
       (.I(IO),
        .O(O));
  OBUFT #(
    .IOSTANDARD("DEFAULT")) 
    OBUFT
       (.I(I),
        .O(IO),
        .T(T));
endmodule

module adau1761_configuraiton_data
   (DOADO,
    \bitcount_reg[0] ,
    \state_reg[2] ,
    \pcnext_reg_rep[3] ,
    skip_reg,
    skip_reg_0,
    \delay_reg[0] ,
    skip_reg_1,
    \pcnext_reg_rep[3]_0 ,
    \i2c_data_reg[2] ,
    \i2c_data_reg[0] ,
    D,
    \i2c_data_reg[4] ,
    skip_reg_2,
    CLK_48,
    ADDRARDADDR,
    \state_reg[2]_0 ,
    skip_reg_3,
    skip_reg_4,
    ack_flag,
    \state_reg[3] ,
    skip_reg_5,
    \state_reg[2]_1 ,
    O,
    Q,
    \delay_reg[12] ,
    \delay_reg[14] ,
    \i2c_data_reg[3] ,
    \delay_reg[0]_0 ,
    \delay_reg[0]_1 ,
    pwropt,
    pwropt_1);
  output [8:0]DOADO;
  output \bitcount_reg[0] ;
  output \state_reg[2] ;
  output \pcnext_reg_rep[3] ;
  output skip_reg;
  output skip_reg_0;
  output \delay_reg[0] ;
  output skip_reg_1;
  output \pcnext_reg_rep[3]_0 ;
  output \i2c_data_reg[2] ;
  output \i2c_data_reg[0] ;
  output [15:0]D;
  output [1:0]\i2c_data_reg[4] ;
  output skip_reg_2;
  input CLK_48;
  input [9:0]ADDRARDADDR;
  input \state_reg[2]_0 ;
  input skip_reg_3;
  input skip_reg_4;
  input ack_flag;
  input \state_reg[3] ;
  input skip_reg_5;
  input \state_reg[2]_1 ;
  input [3:0]O;
  input [0:0]Q;
  input [3:0]\delay_reg[12] ;
  input [2:0]\delay_reg[14] ;
  input [1:0]\i2c_data_reg[3] ;
  input [3:0]\delay_reg[0]_0 ;
  input [0:0]\delay_reg[0]_1 ;
  input pwropt;
  input pwropt_1;

  wire [9:0]ADDRARDADDR;
  wire CLK_48;
  wire [15:0]D;
  wire [8:0]DOADO;
  wire [3:0]O;
  wire [0:0]Q;
  wire ack_flag;
  wire \bitcount_reg[0] ;
  wire data_reg_ENARDEN_cooolgate_en_sig_3;
  wire \delay_reg[0] ;
  wire [3:0]\delay_reg[0]_0 ;
  wire [0:0]\delay_reg[0]_1 ;
  wire [3:0]\delay_reg[12] ;
  wire [2:0]\delay_reg[14] ;
  wire \i2c_data[7]_i_3_n_0 ;
  wire \i2c_data_reg[0] ;
  wire \i2c_data_reg[2] ;
  wire [1:0]\i2c_data_reg[3] ;
  wire [1:0]\i2c_data_reg[4] ;
  wire \pcnext_reg_rep[3] ;
  wire \pcnext_reg_rep[3]_0 ;
  wire pwropt;
  wire pwropt_1;
  wire skip_i_10_n_0;
  wire skip_i_2_n_0;
  wire skip_i_3_n_0;
  wire skip_i_4_n_0;
  wire skip_i_6_n_0;
  wire skip_i_7_n_0;
  wire skip_i_9_n_0;
  wire skip_reg;
  wire skip_reg_0;
  wire skip_reg_1;
  wire skip_reg_2;
  wire skip_reg_3;
  wire skip_reg_4;
  wire skip_reg_5;
  wire \state[2]_i_5_n_0 ;
  wire \state[3]_i_10_n_0 ;
  wire \state[3]_i_11_n_0 ;
  wire \state[3]_i_12_n_0 ;
  wire \state[3]_i_13_n_0 ;
  wire \state[3]_i_7_n_0 ;
  wire \state[3]_i_9_n_0 ;
  wire \state_reg[2] ;
  wire \state_reg[2]_0 ;
  wire \state_reg[2]_1 ;
  wire \state_reg[3] ;
  wire \top/Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data_reg_cooolgate_en_sig_1 ;
  wire \top/Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data_reg_cooolgate_en_sig_2 ;
  wire NLW_data_reg_REGCEAREGCE_UNCONNECTED;
  wire NLW_data_reg_REGCEB_UNCONNECTED;
  wire [15:9]NLW_data_reg_DOADO_UNCONNECTED;
  wire [15:0]NLW_data_reg_DOBDO_UNCONNECTED;
  wire [1:0]NLW_data_reg_DOPADOP_UNCONNECTED;
  wire [1:0]NLW_data_reg_DOPBDOP_UNCONNECTED;

  (* IS_CLOCK_GATED *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-6 {cell *THIS*}}" *) 
  (* POWER_OPTED_CE = "ENARDEN=NEW" *) 
  (* RTL_RAM_BITS = "9216" *) 
  (* RTL_RAM_NAME = "Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data" *) 
  (* bram_addr_begin = "0" *) 
  (* bram_addr_end = "1023" *) 
  (* bram_slice_begin = "0" *) 
  (* bram_slice_end = "35" *) 
  RAMB18E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h00FF01010123010C0100017D010001020140017600FF010E01000140017600EF),
    .INIT_01(256'h0101010A0140017600FF010101150140017600EF00FF010F01000140017600EF),
    .INIT_02(256'h00FF0105010D0140017600FF0101010C0140017600FF0105010B0140017600FF),
    .INIT_03(256'h017600FF01E701230140017600FF0141011E0140017600FF0121011C01400176),
    .INIT_04(256'h0140017600FF01E701260140017600FF01E701250140017600FF01E701240140),
    .INIT_05(256'h01F20140017600FF0103012A0140017600FF010301290140017600FF01030119),
    .INIT_06(256'h010301FA0140017600FF017F01F90140017600FF010101F30140017600FF0101),
    .INIT_07(256'h011E0140017600FF0120011C0140017600FE00FE00FE00FE00FE00FE001300FF),
    .INIT_08(256'h017600FF0121011C0140017600EF00EF00A100A000EF00EF00EF00EF00FF0140),
    .INIT_09(256'h00FE00FE00FE0013001900810014008000FE00FE00FE00FE00FF0141011E0140),
    .INIT_0A(256'h00A100B000EF00EF00EF00EF00FF0140011E0140017600FF0120011C01400176),
    .INIT_0B(256'h00FE00FE00FE00FE00FF0141011E0140017600FF0121011C0140017600EF00EF),
    .INIT_0C(256'h011E0140017600FF0120011C0140017600FE00FE00FE0018001E0081000F0090),
    .INIT_0D(256'h017600FF0121011C0140017600EF00EF00B100A000EF00EF00EF00EF00FF0140),
    .INIT_0E(256'h00FE00FE00FE001D000F00910000008000FE00FE00FE00FE00FF0141011E0140),
    .INIT_0F(256'h00B100B000EF00EF00EF00EF00FF0140011E0140017600FF0120011C01400176),
    .INIT_10(256'h00FE00FE00FE00FE00FF0141011E0140017600FF0121011C0140017600EF00EF),
    .INIT_11(256'h0000000000000000000000000000000000000000000000220014009100190090),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .INIT_FILE("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(18),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(18),
    .WRITE_WIDTH_B(0)) 
    data_reg
       (.ADDRARDADDR({ADDRARDADDR,1'b0,1'b0,1'b0,1'b0}),
        .ADDRBWRADDR({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CLKARDCLK(CLK_48),
        .CLKBWRCLK(1'b0),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .DIBDI({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0}),
        .DIPBDIP({1'b1,1'b1}),
        .DOADO({NLW_data_reg_DOADO_UNCONNECTED[15:9],DOADO}),
        .DOBDO(NLW_data_reg_DOBDO_UNCONNECTED[15:0]),
        .DOPADOP(NLW_data_reg_DOPADOP_UNCONNECTED[1:0]),
        .DOPBDOP(NLW_data_reg_DOPBDOP_UNCONNECTED[1:0]),
        .ENARDEN(data_reg_ENARDEN_cooolgate_en_sig_3),
        .ENBWREN(1'b0),
        .REGCEAREGCE(NLW_data_reg_REGCEAREGCE_UNCONNECTED),
        .REGCEB(NLW_data_reg_REGCEB_UNCONNECTED),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0}));
  LUT2 #(
    .INIT(4'he)) 
    data_reg_ENARDEN_cooolgate_en_gate_3
       (.I0(\top/Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data_reg_cooolgate_en_sig_2 ),
        .I1(\top/Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data_reg_cooolgate_en_sig_1 ),
        .O(data_reg_ENARDEN_cooolgate_en_sig_3));
  LUT6 #(
    .INIT(64'h4444444444444447)) 
    \delay[0]_i_1 
       (.I0(\delay_reg[0]_1 ),
        .I1(Q),
        .I2(DOADO[0]),
        .I3(DOADO[1]),
        .I4(DOADO[2]),
        .I5(DOADO[3]),
        .O(D[0]));
  LUT6 #(
    .INIT(64'hAAAA0000AAAA0C00)) 
    \delay[10]_i_1 
       (.I0(\delay_reg[12] [1]),
        .I1(DOADO[1]),
        .I2(DOADO[2]),
        .I3(DOADO[3]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[10]));
  LUT6 #(
    .INIT(64'hAAAA0C00AAAA0000)) 
    \delay[11]_i_1 
       (.I0(\delay_reg[12] [2]),
        .I1(DOADO[1]),
        .I2(DOADO[2]),
        .I3(DOADO[3]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[11]));
  LUT6 #(
    .INIT(64'h888888888888B888)) 
    \delay[12]_i_1 
       (.I0(\delay_reg[12] [3]),
        .I1(Q),
        .I2(DOADO[3]),
        .I3(DOADO[2]),
        .I4(DOADO[1]),
        .I5(DOADO[0]),
        .O(D[12]));
  LUT6 #(
    .INIT(64'h8888B88888888888)) 
    \delay[13]_i_1 
       (.I0(\delay_reg[14] [0]),
        .I1(Q),
        .I2(DOADO[3]),
        .I3(DOADO[2]),
        .I4(DOADO[1]),
        .I5(DOADO[0]),
        .O(D[13]));
  LUT6 #(
    .INIT(64'hAAAA0000AAAAC000)) 
    \delay[14]_i_1 
       (.I0(\delay_reg[14] [1]),
        .I1(DOADO[2]),
        .I2(DOADO[3]),
        .I3(DOADO[1]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[14]));
  LUT6 #(
    .INIT(64'hB888888888888888)) 
    \delay[15]_i_2 
       (.I0(\delay_reg[14] [2]),
        .I1(Q),
        .I2(DOADO[0]),
        .I3(DOADO[2]),
        .I4(DOADO[3]),
        .I5(DOADO[1]),
        .O(D[15]));
  LUT6 #(
    .INIT(64'h0000000004000000)) 
    \delay[15]_i_3 
       (.I0(skip_reg_4),
        .I1(DOADO[7]),
        .I2(DOADO[8]),
        .I3(DOADO[6]),
        .I4(DOADO[5]),
        .I5(DOADO[4]),
        .O(\delay_reg[0] ));
  LUT6 #(
    .INIT(64'hAAAA0003AAAA0000)) 
    \delay[1]_i_1 
       (.I0(\delay_reg[0]_0 [0]),
        .I1(DOADO[2]),
        .I2(DOADO[3]),
        .I3(DOADO[1]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[1]));
  LUT6 #(
    .INIT(64'hAAAA0000AAAA0300)) 
    \delay[2]_i_1 
       (.I0(\delay_reg[0]_0 [1]),
        .I1(DOADO[2]),
        .I2(DOADO[3]),
        .I3(DOADO[1]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[2]));
  LUT6 #(
    .INIT(64'hAAAA0300AAAA0000)) 
    \delay[3]_i_1 
       (.I0(\delay_reg[0]_0 [2]),
        .I1(DOADO[2]),
        .I2(DOADO[3]),
        .I3(DOADO[1]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[3]));
  LUT6 #(
    .INIT(64'hAAAA0000AAAA000C)) 
    \delay[4]_i_1 
       (.I0(\delay_reg[0]_0 [3]),
        .I1(DOADO[2]),
        .I2(DOADO[3]),
        .I3(DOADO[1]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[4]));
  LUT6 #(
    .INIT(64'hAAAA000CAAAA0000)) 
    \delay[5]_i_1 
       (.I0(O[0]),
        .I1(DOADO[2]),
        .I2(DOADO[3]),
        .I3(DOADO[1]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[5]));
  LUT6 #(
    .INIT(64'hAAAA0000AAAA0C00)) 
    \delay[6]_i_1 
       (.I0(O[1]),
        .I1(DOADO[2]),
        .I2(DOADO[3]),
        .I3(DOADO[1]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[6]));
  LUT6 #(
    .INIT(64'hAAAA0C00AAAA0000)) 
    \delay[7]_i_1 
       (.I0(O[2]),
        .I1(DOADO[2]),
        .I2(DOADO[3]),
        .I3(DOADO[1]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[7]));
  LUT6 #(
    .INIT(64'hAAAA0000AAAA0300)) 
    \delay[8]_i_1 
       (.I0(O[3]),
        .I1(DOADO[2]),
        .I2(DOADO[1]),
        .I3(DOADO[3]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[8]));
  LUT6 #(
    .INIT(64'hAAAA0300AAAA0000)) 
    \delay[9]_i_1 
       (.I0(\delay_reg[12] [0]),
        .I1(DOADO[2]),
        .I2(DOADO[1]),
        .I3(DOADO[3]),
        .I4(Q),
        .I5(DOADO[0]),
        .O(D[9]));
  LUT6 #(
    .INIT(64'h0008000800088000)) 
    \i2c_bits_left[3]_i_3 
       (.I0(\state_reg[2] ),
        .I1(\state_reg[2]_1 ),
        .I2(\pcnext_reg_rep[3] ),
        .I3(skip_reg),
        .I4(DOADO[8]),
        .I5(\state[3]_i_9_n_0 ),
        .O(\i2c_data_reg[0] ));
  LUT4 #(
    .INIT(16'hF3D1)) 
    \i2c_data[2]_i_1 
       (.I0(\i2c_data_reg[2] ),
        .I1(Q),
        .I2(\i2c_data_reg[3] [0]),
        .I3(DOADO[1]),
        .O(\i2c_data_reg[4] [0]));
  LUT4 #(
    .INIT(16'hF3D1)) 
    \i2c_data[4]_i_1 
       (.I0(\i2c_data_reg[2] ),
        .I1(Q),
        .I2(\i2c_data_reg[3] [1]),
        .I3(DOADO[3]),
        .O(\i2c_data_reg[4] [1]));
  LUT6 #(
    .INIT(64'hAAEBAAAAEEEBAAAA)) 
    \i2c_data[7]_i_2 
       (.I0(DOADO[8]),
        .I1(DOADO[5]),
        .I2(DOADO[4]),
        .I3(DOADO[6]),
        .I4(DOADO[7]),
        .I5(\i2c_data[7]_i_3_n_0 ),
        .O(\i2c_data_reg[2] ));
  LUT5 #(
    .INIT(32'h10109000)) 
    \i2c_data[7]_i_3 
       (.I0(DOADO[3]),
        .I1(DOADO[2]),
        .I2(DOADO[4]),
        .I3(DOADO[1]),
        .I4(DOADO[0]),
        .O(\i2c_data[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFCDCFCDCFCDCDDFD)) 
    \pcnext[2]_i_4 
       (.I0(\pcnext_reg_rep[3] ),
        .I1(skip_reg_5),
        .I2(skip_reg),
        .I3(\state_reg[2] ),
        .I4(\state[3]_i_9_n_0 ),
        .I5(DOADO[8]),
        .O(\pcnext_reg_rep[3]_0 ));
  LUT6 #(
    .INIT(64'h00FFFFFFABFF0000)) 
    skip_i_1
       (.I0(skip_i_2_n_0),
        .I1(ack_flag),
        .I2(skip_reg),
        .I3(\state_reg[3] ),
        .I4(skip_i_3_n_0),
        .I5(skip_reg_4),
        .O(skip_reg_1));
  LUT4 #(
    .INIT(16'hA802)) 
    skip_i_10
       (.I0(DOADO[7]),
        .I1(DOADO[6]),
        .I2(DOADO[4]),
        .I3(DOADO[5]),
        .O(skip_i_10_n_0));
  LUT5 #(
    .INIT(32'h00008000)) 
    skip_i_11
       (.I0(DOADO[5]),
        .I1(DOADO[6]),
        .I2(DOADO[7]),
        .I3(DOADO[4]),
        .I4(DOADO[8]),
        .O(skip_reg_2));
  LUT6 #(
    .INIT(64'hAB00AB000000AB00)) 
    skip_i_2
       (.I0(skip_i_4_n_0),
        .I1(\state_reg[2] ),
        .I2(\i2c_data_reg[2] ),
        .I3(skip_reg),
        .I4(\pcnext_reg_rep[3] ),
        .I5(ack_flag),
        .O(skip_i_2_n_0));
  LUT6 #(
    .INIT(64'hFEFFFEFE02000202)) 
    skip_i_3
       (.I0(\state_reg[2]_0 ),
        .I1(skip_i_6_n_0),
        .I2(\pcnext_reg_rep[3] ),
        .I3(skip_i_7_n_0),
        .I4(\state_reg[2] ),
        .I5(skip_reg_3),
        .O(skip_i_3_n_0));
  LUT6 #(
    .INIT(64'h33BF333333333333)) 
    skip_i_4
       (.I0(\state[3]_i_12_n_0 ),
        .I1(DOADO[4]),
        .I2(DOADO[5]),
        .I3(DOADO[8]),
        .I4(DOADO[7]),
        .I5(DOADO[6]),
        .O(skip_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFF0000B800)) 
    skip_i_6
       (.I0(skip_i_9_n_0),
        .I1(\i2c_data[7]_i_3_n_0 ),
        .I2(skip_i_10_n_0),
        .I3(\state[3]_i_11_n_0 ),
        .I4(skip_reg_0),
        .I5(DOADO[8]),
        .O(skip_i_6_n_0));
  LUT6 #(
    .INIT(64'h0000004545450045)) 
    skip_i_7
       (.I0(DOADO[8]),
        .I1(skip_reg_0),
        .I2(\state[3]_i_11_n_0 ),
        .I3(skip_i_10_n_0),
        .I4(\i2c_data[7]_i_3_n_0 ),
        .I5(skip_i_9_n_0),
        .O(skip_i_7_n_0));
  LUT4 #(
    .INIT(16'h2002)) 
    skip_i_9
       (.I0(DOADO[7]),
        .I1(DOADO[6]),
        .I2(DOADO[4]),
        .I3(DOADO[5]),
        .O(skip_i_9_n_0));
  LUT6 #(
    .INIT(64'hDFCFFFCCCCCCCCCC)) 
    \state[2]_i_2 
       (.I0(\state[2]_i_5_n_0 ),
        .I1(DOADO[8]),
        .I2(DOADO[5]),
        .I3(DOADO[4]),
        .I4(DOADO[6]),
        .I5(DOADO[7]),
        .O(\state_reg[2] ));
  LUT6 #(
    .INIT(64'h4555555555555555)) 
    \state[2]_i_3 
       (.I0(DOADO[8]),
        .I1(skip_reg_0),
        .I2(DOADO[4]),
        .I3(DOADO[7]),
        .I4(DOADO[6]),
        .I5(DOADO[5]),
        .O(skip_reg));
  LUT4 #(
    .INIT(16'hBFF6)) 
    \state[2]_i_5 
       (.I0(DOADO[0]),
        .I1(DOADO[1]),
        .I2(DOADO[2]),
        .I3(DOADO[3]),
        .O(\state[2]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \state[2]_i_6 
       (.I0(DOADO[0]),
        .I1(DOADO[1]),
        .I2(DOADO[2]),
        .I3(DOADO[3]),
        .O(skip_reg_0));
  LUT5 #(
    .INIT(32'h00001000)) 
    \state[3]_i_10 
       (.I0(DOADO[6]),
        .I1(DOADO[8]),
        .I2(DOADO[7]),
        .I3(DOADO[5]),
        .I4(DOADO[4]),
        .O(\state[3]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \state[3]_i_11 
       (.I0(DOADO[4]),
        .I1(DOADO[7]),
        .I2(DOADO[6]),
        .I3(DOADO[5]),
        .O(\state[3]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h77EF)) 
    \state[3]_i_12 
       (.I0(DOADO[2]),
        .I1(DOADO[1]),
        .I2(DOADO[0]),
        .I3(DOADO[3]),
        .O(\state[3]_i_12_n_0 ));
  LUT5 #(
    .INIT(32'h0000F400)) 
    \state[3]_i_13 
       (.I0(DOADO[4]),
        .I1(DOADO[5]),
        .I2(DOADO[6]),
        .I3(DOADO[7]),
        .I4(DOADO[8]),
        .O(\state[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBB77B0B0B077)) 
    \state[3]_i_5 
       (.I0(\state_reg[2] ),
        .I1(\state[3]_i_7_n_0 ),
        .I2(\pcnext_reg_rep[3] ),
        .I3(\state[3]_i_9_n_0 ),
        .I4(DOADO[8]),
        .I5(skip_reg),
        .O(\bitcount_reg[0] ));
  LUT6 #(
    .INIT(64'h3323002003030000)) 
    \state[3]_i_7 
       (.I0(\state[3]_i_10_n_0 ),
        .I1(DOADO[8]),
        .I2(\state[3]_i_11_n_0 ),
        .I3(\state[3]_i_12_n_0 ),
        .I4(\state[3]_i_13_n_0 ),
        .I5(skip_reg_0),
        .O(\state[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h008000F000C000C0)) 
    \state[3]_i_8 
       (.I0(\state[3]_i_12_n_0 ),
        .I1(DOADO[6]),
        .I2(DOADO[7]),
        .I3(DOADO[8]),
        .I4(DOADO[4]),
        .I5(DOADO[5]),
        .O(\pcnext_reg_rep[3] ));
  LUT5 #(
    .INIT(32'h4C40000C)) 
    \state[3]_i_9 
       (.I0(\i2c_data[7]_i_3_n_0 ),
        .I1(DOADO[7]),
        .I2(DOADO[6]),
        .I3(DOADO[4]),
        .I4(DOADO[5]),
        .O(\state[3]_i_9_n_0 ));
  FDCE #(
    .INIT(1'b1)) 
    \top/Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data_reg_cooolgate_en_gate_1_cooolDelFlop 
       (.C(CLK_48),
        .CE(1'b1),
        .CLR(1'b0),
        .D(pwropt),
        .Q(\top/Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data_reg_cooolgate_en_sig_1 ));
  FDCE #(
    .INIT(1'b1)) 
    \top/Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data_reg_cooolgate_en_gate_2_cooolDelFlop 
       (.C(CLK_48),
        .CE(1'b1),
        .CLR(1'b0),
        .D(pwropt_1),
        .Q(\top/Inst_adau1761_izedboard/Inst_i2c/Inst_adau1761_configuraiton_data/data_reg_cooolgate_en_sig_2 ));
endmodule

module adau1761_izedboard
   (\sr_out_reg[57] ,
    AC_GPIO0,
    Q,
    AC_MCLK,
    AC_SCK_OBUF,
    AC_SDA,
    CLK_48,
    AC_GPIO2_IBUF,
    AC_GPIO3_IBUF,
    D);
  output \sr_out_reg[57] ;
  output AC_GPIO0;
  output [10:0]Q;
  output AC_MCLK;
  output AC_SCK_OBUF;
  inout AC_SDA;
  input CLK_48;
  input AC_GPIO2_IBUF;
  input AC_GPIO3_IBUF;
  input [11:0]D;

  wire AC_GPIO0;
  wire AC_GPIO2_IBUF;
  wire AC_GPIO3_IBUF;
  wire AC_MCLK;
  wire AC_SCK_OBUF;
  wire AC_SDA;
  wire CLK_48;
  wire [11:0]D;
  wire [10:0]Q;
  wire i2c_sda_i;
  wire i2c_sda_t;
  wire \sr_out_reg[57] ;

  i2c Inst_i2c
       (.AC_SCK_OBUF(AC_SCK_OBUF),
        .CLK_48(CLK_48),
        .i2c_sda_i(i2c_sda_i),
        .i2c_sda_t(i2c_sda_t));
  i2s_data_interface Inst_i2s_data_interface
       (.AC_GPIO0(AC_GPIO0),
        .AC_GPIO2_IBUF(AC_GPIO2_IBUF),
        .AC_GPIO3_IBUF(AC_GPIO3_IBUF),
        .CLK_48(CLK_48),
        .D(D),
        .Q(Q),
        .\sr_out_reg[57]_0 (\sr_out_reg[57] ));
  ADAU1761_interface i_ADAU1761_interface
       (.AC_MCLK(AC_MCLK),
        .CLK_48(CLK_48));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* IOSTANDARD = "DEFAULT" *) 
  (* XILINX_REPORT_XFORM = "IOBUF" *) 
  IOBUF_UNIQ_BASE_ i_i2s_sda_obuf
       (.I(1'b0),
        .IO(AC_SDA),
        .O(i2c_sda_i),
        .T(i2c_sda_t));
endmodule

(* ECO_CHECKSUM = "3c4daa35" *) (* POWER_OPT_BRAM_CDC = "0" *) (* POWER_OPT_BRAM_SR_ADDR = "0" *) 
(* POWER_OPT_LOOPED_NET_PERCENTAGE = "0" *) 
(* NotValidForBitStream *)
module audio_testbench_sv
   (clk_100,
    BTNC,
    AC_ADR0,
    AC_ADR1,
    AC_GPIO0,
    AC_GPIO1,
    AC_GPIO2,
    AC_GPIO3,
    AC_MCLK,
    AC_SCK,
    AC_SDA,
    SW0,
    SW1,
    SW2,
    SW3,
    SW4,
    SW5,
    SW6,
    SW7);
  input clk_100;
  input BTNC;
  output AC_ADR0;
  output AC_ADR1;
  output AC_GPIO0;
  input AC_GPIO1;
  input AC_GPIO2;
  input AC_GPIO3;
  output AC_MCLK;
  output AC_SCK;
  inout AC_SDA;
  input SW0;
  input SW1;
  input SW2;
  input SW3;
  input SW4;
  input SW5;
  input SW6;
  input SW7;

  wire AC_ADR0;
  wire AC_ADR1;
  wire AC_GPIO0;
  wire AC_GPIO0_OBUF;
  wire AC_GPIO1;
  wire AC_GPIO1_IBUF;
  wire AC_GPIO2;
  wire AC_GPIO2_IBUF;
  wire AC_GPIO3;
  wire AC_GPIO3_IBUF;
  wire AC_MCLK;
  wire AC_MCLK_OBUF;
  wire AC_SCK;
  wire AC_SCK_OBUF;
  (* DRIVE = "12" *) (* IBUF_LOW_PWR *) (* SLEW = "SLOW" *) wire AC_SDA;
  wire BTNC;
  wire BTNC_IBUF;
  wire SW0;
  wire SW0_IBUF;
  wire SW1;
  wire SW1_IBUF;
  wire SW2;
  wire SW2_IBUF;
  wire SW3;
  wire SW3_IBUF;
  wire SW4;
  wire SW4_IBUF;
  wire SW5;
  wire SW5_IBUF;
  wire SW6;
  wire SW6_IBUF;
  wire SW7;
  wire SW7_IBUF;
  (* IBUF_LOW_PWR *) wire clk_100;
  wire clk_4;
  wire clk_512;
  wire clk_8;
  wire \counter_saw_tooth[5]_i_1_n_0 ;
  wire \counter_saw_tooth[5]_i_4_n_0 ;
  wire [23:18]data4;
  wire [23:18]hphone_r;
  wire \hphone_r[23]_i_4_n_0 ;
  wire \hphone_r_reg_n_0_[18] ;
  wire \hphone_r_reg_n_0_[19] ;
  wire \hphone_r_reg_n_0_[20] ;
  wire \hphone_r_reg_n_0_[21] ;
  wire \hphone_r_reg_n_0_[22] ;
  wire \hphone_r_reg_n_0_[23] ;
  wire hphone_valid;
  wire new_sample;
  wire output_clk_100;
  wire sq1_n_0;
  wire sq2_n_0;
  wire top_n_0;
  wire top_n_2;
  wire top_n_3;
  wire top_n_4;
  wire top_n_5;
  wire top_n_6;
  wire top_n_7;
  wire top_n_8;

initial begin
 $sdf_annotate("audio_testbench_sv_time_impl.sdf",,,,"tool_control");
end
  OBUF AC_ADR0_OBUF_inst
       (.I(1'b1),
        .O(AC_ADR0));
  OBUF AC_ADR1_OBUF_inst
       (.I(1'b1),
        .O(AC_ADR1));
  OBUF AC_GPIO0_OBUF_inst
       (.I(AC_GPIO0_OBUF),
        .O(AC_GPIO0));
  (* OPT_INSERTED *) 
  IBUF AC_GPIO1_IBUF_inst
       (.I(AC_GPIO1),
        .O(AC_GPIO1_IBUF));
  IBUF AC_GPIO2_IBUF_inst
       (.I(AC_GPIO2),
        .O(AC_GPIO2_IBUF));
  IBUF AC_GPIO3_IBUF_inst
       (.I(AC_GPIO3),
        .O(AC_GPIO3_IBUF));
  OBUF AC_MCLK_OBUF_inst
       (.I(AC_MCLK_OBUF),
        .O(AC_MCLK));
  OBUF AC_SCK_OBUF_inst
       (.I(AC_SCK_OBUF),
        .O(AC_SCK));
  IBUF BTNC_IBUF_inst
       (.I(BTNC),
        .O(BTNC_IBUF));
  IBUF SW0_IBUF_inst
       (.I(SW0),
        .O(SW0_IBUF));
  IBUF SW1_IBUF_inst
       (.I(SW1),
        .O(SW1_IBUF));
  IBUF SW2_IBUF_inst
       (.I(SW2),
        .O(SW2_IBUF));
  IBUF SW3_IBUF_inst
       (.I(SW3),
        .O(SW3_IBUF));
  (* OPT_INSERTED *) 
  IBUF SW4_IBUF_inst
       (.I(SW4),
        .O(SW4_IBUF));
  (* OPT_INSERTED *) 
  IBUF SW5_IBUF_inst
       (.I(SW5),
        .O(SW5_IBUF));
  (* OPT_INSERTED *) 
  IBUF SW6_IBUF_inst
       (.I(SW6),
        .O(SW6_IBUF));
  (* OPT_INSERTED *) 
  IBUF SW7_IBUF_inst
       (.I(SW7),
        .O(SW7_IBUF));
  clock_divider clock_generate
       (.CLK(clk_4),
        .clk_100(clk_8));
  (* CORE_GENERATION_INFO = "clock_generator,IP_Integrator,{x_ipProduct=Vivado 2015.2,x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=clock_generator,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}" *) 
  (* HW_HANDOFF = "clock_generator.hwdef" *) 
  clock_generator clock_generator_i
       (.clk_100_input(clk_100),
        .clk_100_output(output_clk_100),
        .clk_512(clk_512),
        .clk_8(clk_8),
        .reset(1'b0));
  LUT5 #(
    .INIT(32'h00020228)) 
    \counter_saw_tooth[5]_i_1 
       (.I0(BTNC_IBUF),
        .I1(SW1_IBUF),
        .I2(SW3_IBUF),
        .I3(SW2_IBUF),
        .I4(SW0_IBUF),
        .O(\counter_saw_tooth[5]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \counter_saw_tooth[5]_i_4 
       (.I0(data4[21]),
        .I1(data4[19]),
        .I2(data4[18]),
        .I3(data4[20]),
        .O(\counter_saw_tooth[5]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_saw_tooth_reg[0] 
       (.C(output_clk_100),
        .CE(top_n_2),
        .D(top_n_3),
        .Q(data4[18]),
        .R(\counter_saw_tooth[5]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_saw_tooth_reg[1] 
       (.C(output_clk_100),
        .CE(top_n_2),
        .D(top_n_8),
        .Q(data4[19]),
        .R(\counter_saw_tooth[5]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_saw_tooth_reg[2] 
       (.C(output_clk_100),
        .CE(top_n_2),
        .D(top_n_4),
        .Q(data4[20]),
        .R(\counter_saw_tooth[5]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_saw_tooth_reg[3] 
       (.C(output_clk_100),
        .CE(top_n_2),
        .D(top_n_5),
        .Q(data4[21]),
        .R(\counter_saw_tooth[5]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_saw_tooth_reg[4] 
       (.C(output_clk_100),
        .CE(top_n_2),
        .D(top_n_6),
        .Q(data4[22]),
        .R(\counter_saw_tooth[5]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_saw_tooth_reg[5] 
       (.C(output_clk_100),
        .CE(top_n_2),
        .D(top_n_7),
        .Q(data4[23]),
        .R(\counter_saw_tooth[5]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFCAA)) 
    \hphone_r[22]_i_1 
       (.I0(data4[22]),
        .I1(SW0_IBUF),
        .I2(SW1_IBUF),
        .I3(\hphone_r[23]_i_4_n_0 ),
        .O(hphone_r[22]));
  LUT4 #(
    .INIT(16'h0116)) 
    \hphone_r[23]_i_4 
       (.I0(SW0_IBUF),
        .I1(SW1_IBUF),
        .I2(SW2_IBUF),
        .I3(SW3_IBUF),
        .O(\hphone_r[23]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_r_reg[18] 
       (.C(output_clk_100),
        .CE(1'b1),
        .D(hphone_r[18]),
        .Q(\hphone_r_reg_n_0_[18] ),
        .R(top_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_r_reg[19] 
       (.C(output_clk_100),
        .CE(1'b1),
        .D(hphone_r[19]),
        .Q(\hphone_r_reg_n_0_[19] ),
        .R(top_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_r_reg[20] 
       (.C(output_clk_100),
        .CE(1'b1),
        .D(hphone_r[20]),
        .Q(\hphone_r_reg_n_0_[20] ),
        .R(top_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_r_reg[21] 
       (.C(output_clk_100),
        .CE(1'b1),
        .D(hphone_r[21]),
        .Q(\hphone_r_reg_n_0_[21] ),
        .R(top_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_r_reg[22] 
       (.C(output_clk_100),
        .CE(1'b1),
        .D(hphone_r[22]),
        .Q(\hphone_r_reg_n_0_[22] ),
        .R(top_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_r_reg[23] 
       (.C(output_clk_100),
        .CE(1'b1),
        .D(hphone_r[23]),
        .Q(\hphone_r_reg_n_0_[23] ),
        .R(top_n_0));
  FDRE #(
    .INIT(1'b0)) 
    hphone_valid_reg
       (.C(output_clk_100),
        .CE(1'b1),
        .D(new_sample),
        .Q(hphone_valid),
        .R(1'b0));
  noise n
       (.AR(BTNC_IBUF),
        .CLK(clk_8),
        .D(hphone_r[23]),
        .SW3(\hphone_r[23]_i_4_n_0 ),
        .SW3_IBUF(SW3_IBUF),
        .data4(data4[23]),
        .\wave_reg[23] (sq1_n_0));
  square1 sq1
       (.AR(BTNC_IBUF),
        .CLK(clk_4),
        .SW0_IBUF(SW0_IBUF),
        .SW1_IBUF(SW1_IBUF),
        .clk_512(clk_512),
        .\hphone_r_reg[21] (sq1_n_0),
        .\wave_reg[23] (sq2_n_0));
  square2 sq2
       (.AR(BTNC_IBUF),
        .clk_8(clk_8),
        .\wave_reg[23] (sq2_n_0));
  audio_top top
       (.AC_GPIO0(AC_GPIO0_OBUF),
        .AC_GPIO2_IBUF(AC_GPIO2_IBUF),
        .AC_GPIO3_IBUF(AC_GPIO3_IBUF),
        .AC_MCLK(AC_MCLK_OBUF),
        .AC_SCK_OBUF(AC_SCK_OBUF),
        .AC_SDA(AC_SDA),
        .AR(BTNC_IBUF),
        .Q({\hphone_r_reg_n_0_[23] ,\hphone_r_reg_n_0_[22] ,\hphone_r_reg_n_0_[21] ,\hphone_r_reg_n_0_[20] ,\hphone_r_reg_n_0_[19] ,\hphone_r_reg_n_0_[18] }),
        .SR(top_n_0),
        .SW0_IBUF(SW0_IBUF),
        .SW1_IBUF(SW1_IBUF),
        .SW2_IBUF(SW2_IBUF),
        .SW3_IBUF(SW3_IBUF),
        .clk_100_buffered(output_clk_100),
        .\counter_saw_tooth_reg[0] (top_n_2),
        .\counter_saw_tooth_reg[0]_0 (top_n_3),
        .\counter_saw_tooth_reg[1] (top_n_8),
        .\counter_saw_tooth_reg[2] (top_n_4),
        .\counter_saw_tooth_reg[3] (top_n_5),
        .\counter_saw_tooth_reg[3]_0 (\counter_saw_tooth[5]_i_4_n_0 ),
        .\counter_saw_tooth_reg[4] (top_n_6),
        .\counter_saw_tooth_reg[5] (top_n_7),
        .data4(data4),
        .hphone_valid(hphone_valid),
        .new_sample(new_sample));
  wave w
       (.AR(BTNC_IBUF),
        .D(hphone_r[21:18]),
        .SW2_IBUF(SW2_IBUF),
        .SW3(\hphone_r[23]_i_4_n_0 ),
        .clk_8(clk_8),
        .data4(data4[21:18]),
        .\wave_reg[23] (sq1_n_0));
endmodule

module audio_top
   (SR,
    new_sample,
    \counter_saw_tooth_reg[0] ,
    \counter_saw_tooth_reg[0]_0 ,
    \counter_saw_tooth_reg[2] ,
    \counter_saw_tooth_reg[3] ,
    \counter_saw_tooth_reg[4] ,
    \counter_saw_tooth_reg[5] ,
    \counter_saw_tooth_reg[1] ,
    AC_GPIO0,
    AC_MCLK,
    AC_SCK_OBUF,
    AC_SDA,
    AC_GPIO2_IBUF,
    AC_GPIO3_IBUF,
    SW0_IBUF,
    SW2_IBUF,
    SW3_IBUF,
    SW1_IBUF,
    AR,
    data4,
    \counter_saw_tooth_reg[3]_0 ,
    clk_100_buffered,
    hphone_valid,
    Q);
  output [0:0]SR;
  output new_sample;
  output \counter_saw_tooth_reg[0] ;
  output \counter_saw_tooth_reg[0]_0 ;
  output \counter_saw_tooth_reg[2] ;
  output \counter_saw_tooth_reg[3] ;
  output \counter_saw_tooth_reg[4] ;
  output \counter_saw_tooth_reg[5] ;
  output \counter_saw_tooth_reg[1] ;
  output AC_GPIO0;
  output AC_MCLK;
  output AC_SCK_OBUF;
  inout AC_SDA;
  input AC_GPIO2_IBUF;
  input AC_GPIO3_IBUF;
  input SW0_IBUF;
  input SW2_IBUF;
  input SW3_IBUF;
  input SW1_IBUF;
  input [0:0]AR;
  input [5:0]data4;
  input \counter_saw_tooth_reg[3]_0 ;
  input clk_100_buffered;
  input hphone_valid;
  input [5:0]Q;

  wire AC_GPIO0;
  wire AC_GPIO2_IBUF;
  wire AC_GPIO3_IBUF;
  wire AC_MCLK;
  wire AC_SCK_OBUF;
  wire AC_SDA;
  wire [0:0]AR;
  wire Inst_adau1761_izedboard_n_0;
  wire [5:0]Q;
  wire [0:0]SR;
  wire SW0_IBUF;
  wire SW1_IBUF;
  wire SW2_IBUF;
  wire SW3_IBUF;
  wire clk_100_buffered;
  wire clk_48;
  wire \counter_saw_tooth_reg[0] ;
  wire \counter_saw_tooth_reg[0]_0 ;
  wire \counter_saw_tooth_reg[1] ;
  wire \counter_saw_tooth_reg[2] ;
  wire \counter_saw_tooth_reg[3] ;
  wire \counter_saw_tooth_reg[3]_0 ;
  wire \counter_saw_tooth_reg[4] ;
  wire \counter_saw_tooth_reg[5] ;
  wire [5:0]data4;
  wire \hphone_l_freeze_100_reg_n_0_[18] ;
  wire \hphone_l_freeze_100_reg_n_0_[19] ;
  wire \hphone_l_freeze_100_reg_n_0_[20] ;
  wire \hphone_l_freeze_100_reg_n_0_[21] ;
  wire \hphone_l_freeze_100_reg_n_0_[22] ;
  wire \hphone_l_freeze_100_reg_n_0_[23] ;
  wire hphone_valid;
  wire new_sample;
  wire new_sample_100;
  wire new_sample_100_i_1_n_0;
  wire sample_clk_48k_d2_48_reg_srl2_n_0;
  wire sample_clk_48k_d3_48;
  wire sample_clk_48k_d4_100;
  wire sample_clk_48k_d5_100;
  wire sample_clk_48k_d6_100;
  wire [62:26]sr_out;
  wire \sr_out[26]_i_1_n_0 ;
  wire \sr_out[27]_i_1_n_0 ;
  wire \sr_out[28]_i_1_n_0 ;
  wire \sr_out[29]_i_1_n_0 ;
  wire \sr_out[30]_i_1_n_0 ;
  wire \sr_out[31]_i_1_n_0 ;
  wire \sr_out[58]_i_1_n_0 ;
  wire \sr_out[59]_i_1_n_0 ;
  wire \sr_out[60]_i_1_n_0 ;
  wire \sr_out[61]_i_1_n_0 ;
  wire \sr_out[62]_i_1_n_0 ;
  wire \sr_out[63]_i_1_n_0 ;

  adau1761_izedboard Inst_adau1761_izedboard
       (.AC_GPIO0(AC_GPIO0),
        .AC_GPIO2_IBUF(AC_GPIO2_IBUF),
        .AC_GPIO3_IBUF(AC_GPIO3_IBUF),
        .AC_MCLK(AC_MCLK),
        .AC_SCK_OBUF(AC_SCK_OBUF),
        .AC_SDA(AC_SDA),
        .CLK_48(clk_48),
        .D({\sr_out[63]_i_1_n_0 ,\sr_out[62]_i_1_n_0 ,\sr_out[61]_i_1_n_0 ,\sr_out[60]_i_1_n_0 ,\sr_out[59]_i_1_n_0 ,\sr_out[58]_i_1_n_0 ,\sr_out[31]_i_1_n_0 ,\sr_out[30]_i_1_n_0 ,\sr_out[29]_i_1_n_0 ,\sr_out[28]_i_1_n_0 ,\sr_out[27]_i_1_n_0 ,\sr_out[26]_i_1_n_0 }),
        .Q({sr_out[62:57],sr_out[30:26]}),
        .\sr_out_reg[57] (Inst_adau1761_izedboard_n_0));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \counter_saw_tooth[0]_i_1 
       (.I0(new_sample),
        .I1(data4[0]),
        .O(\counter_saw_tooth_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \counter_saw_tooth[1]_i_1 
       (.I0(new_sample),
        .I1(data4[1]),
        .I2(data4[0]),
        .O(\counter_saw_tooth_reg[1] ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT4 #(
    .INIT(16'h2888)) 
    \counter_saw_tooth[2]_i_1 
       (.I0(new_sample),
        .I1(data4[2]),
        .I2(data4[1]),
        .I3(data4[0]),
        .O(\counter_saw_tooth_reg[2] ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT5 #(
    .INIT(32'h28888888)) 
    \counter_saw_tooth[3]_i_1 
       (.I0(new_sample),
        .I1(data4[3]),
        .I2(data4[2]),
        .I3(data4[0]),
        .I4(data4[1]),
        .O(\counter_saw_tooth_reg[3] ));
  LUT6 #(
    .INIT(64'h2888888888888888)) 
    \counter_saw_tooth[4]_i_1 
       (.I0(new_sample),
        .I1(data4[4]),
        .I2(data4[3]),
        .I3(data4[1]),
        .I4(data4[0]),
        .I5(data4[2]),
        .O(\counter_saw_tooth_reg[4] ));
  LUT6 #(
    .INIT(64'hFFFFFFFFAAA8A882)) 
    \counter_saw_tooth[5]_i_2 
       (.I0(new_sample),
        .I1(SW0_IBUF),
        .I2(SW2_IBUF),
        .I3(SW3_IBUF),
        .I4(SW1_IBUF),
        .I5(AR),
        .O(\counter_saw_tooth_reg[0] ));
  LUT4 #(
    .INIT(16'h2888)) 
    \counter_saw_tooth[5]_i_3 
       (.I0(new_sample),
        .I1(data4[5]),
        .I2(data4[4]),
        .I3(\counter_saw_tooth_reg[3]_0 ),
        .O(\counter_saw_tooth_reg[5] ));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_l_freeze_100_reg[18] 
       (.C(clk_100_buffered),
        .CE(hphone_valid),
        .D(Q[0]),
        .Q(\hphone_l_freeze_100_reg_n_0_[18] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_l_freeze_100_reg[19] 
       (.C(clk_100_buffered),
        .CE(hphone_valid),
        .D(Q[1]),
        .Q(\hphone_l_freeze_100_reg_n_0_[19] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_l_freeze_100_reg[20] 
       (.C(clk_100_buffered),
        .CE(hphone_valid),
        .D(Q[2]),
        .Q(\hphone_l_freeze_100_reg_n_0_[20] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_l_freeze_100_reg[21] 
       (.C(clk_100_buffered),
        .CE(hphone_valid),
        .D(Q[3]),
        .Q(\hphone_l_freeze_100_reg_n_0_[21] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_l_freeze_100_reg[22] 
       (.C(clk_100_buffered),
        .CE(hphone_valid),
        .D(Q[4]),
        .Q(\hphone_l_freeze_100_reg_n_0_[22] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \hphone_l_freeze_100_reg[23] 
       (.C(clk_100_buffered),
        .CE(hphone_valid),
        .D(Q[5]),
        .Q(\hphone_l_freeze_100_reg_n_0_[23] ),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    \hphone_r[23]_i_1 
       (.I0(new_sample),
        .O(SR));
  clocking i_clocking
       (.CLK_48(clk_48),
        .clk_100_buffered(clk_100_buffered));
  LUT2 #(
    .INIT(4'h2)) 
    new_sample_100_i_1
       (.I0(sample_clk_48k_d5_100),
        .I1(sample_clk_48k_d6_100),
        .O(new_sample_100_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    new_sample_100_reg
       (.C(clk_100_buffered),
        .CE(1'b1),
        .D(new_sample_100_i_1_n_0),
        .Q(new_sample_100),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    new_sample_reg
       (.C(clk_100_buffered),
        .CE(1'b1),
        .D(new_sample_100),
        .Q(new_sample),
        .R(1'b0));
  (* srl_name = "\top/sample_clk_48k_d2_48_reg_srl2 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    sample_clk_48k_d2_48_reg_srl2
       (.A0(1'b1),
        .A1(1'b0),
        .A2(1'b0),
        .A3(1'b0),
        .CE(1'b1),
        .CLK(clk_48),
        .D(AC_GPIO3_IBUF),
        .Q(sample_clk_48k_d2_48_reg_srl2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    sample_clk_48k_d3_48_reg__0
       (.C(clk_48),
        .CE(1'b1),
        .D(sample_clk_48k_d2_48_reg_srl2_n_0),
        .Q(sample_clk_48k_d3_48),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    sample_clk_48k_d4_100_reg
       (.C(clk_100_buffered),
        .CE(1'b1),
        .D(sample_clk_48k_d3_48),
        .Q(sample_clk_48k_d4_100),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    sample_clk_48k_d5_100_reg
       (.C(clk_100_buffered),
        .CE(1'b1),
        .D(sample_clk_48k_d4_100),
        .Q(sample_clk_48k_d5_100),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    sample_clk_48k_d6_100_reg
       (.C(clk_100_buffered),
        .CE(1'b1),
        .D(sample_clk_48k_d5_100),
        .Q(sample_clk_48k_d6_100),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'h20)) 
    \sr_out[26]_i_1 
       (.I0(AC_GPIO3_IBUF),
        .I1(Inst_adau1761_izedboard_n_0),
        .I2(\hphone_l_freeze_100_reg_n_0_[18] ),
        .O(\sr_out[26]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[27]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[19] ),
        .I1(sr_out[26]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[27]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[28]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[20] ),
        .I1(sr_out[27]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[28]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[29]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[21] ),
        .I1(sr_out[28]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[30]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[22] ),
        .I1(sr_out[29]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[30]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[31]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[23] ),
        .I1(sr_out[30]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[58]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[18] ),
        .I1(sr_out[57]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[58]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[59]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[19] ),
        .I1(sr_out[58]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[59]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[60]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[20] ),
        .I1(sr_out[59]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[60]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[61]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[21] ),
        .I1(sr_out[60]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[61]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[62]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[22] ),
        .I1(sr_out[61]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[62]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT4 #(
    .INIT(16'hCCAC)) 
    \sr_out[63]_i_1 
       (.I0(\hphone_l_freeze_100_reg_n_0_[23] ),
        .I1(sr_out[62]),
        .I2(AC_GPIO3_IBUF),
        .I3(Inst_adau1761_izedboard_n_0),
        .O(\sr_out[63]_i_1_n_0 ));
endmodule

module clock_divider
   (CLK,
    clk_100);
  output CLK;
  input clk_100;

  wire CLK;
  wire clk_100;
  wire [0:0]p_0_in;

  LUT1 #(
    .INIT(2'h1)) 
    \counter[0]_i_1 
       (.I0(CLK),
        .O(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(clk_100),
        .CE(1'b1),
        .D(p_0_in),
        .Q(CLK),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "clock_divider" *) 
module clock_divider_1
   (Q,
    clk_512,
    AR);
  output [0:0]Q;
  input clk_512;
  input [0:0]AR;

  wire [0:0]AR;
  wire [0:0]Q;
  wire clk_512;
  wire \counter[0]_i_1_n_0 ;
  wire \counter[1]_i_1_n_0 ;
  wire \counter_reg_n_0_[0] ;

  LUT1 #(
    .INIT(2'h1)) 
    \counter[0]_i_1 
       (.I0(\counter_reg_n_0_[0] ),
        .O(\counter[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \counter[1]_i_1 
       (.I0(\counter_reg_n_0_[0] ),
        .I1(Q),
        .O(\counter[1]_i_1_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(clk_512),
        .CE(1'b1),
        .CLR(AR),
        .D(\counter[0]_i_1_n_0 ),
        .Q(\counter_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(clk_512),
        .CE(1'b1),
        .CLR(AR),
        .D(\counter[1]_i_1_n_0 ),
        .Q(Q));
endmodule

(* CORE_GENERATION_INFO = "clock_generator,IP_Integrator,{x_ipProduct=Vivado 2015.2,x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=clock_generator,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}" *) (* HW_HANDOFF = "clock_generator.hwdef" *) 
module clock_generator
   (clk_100_input,
    clk_100_output,
    clk_512,
    clk_8,
    reset);
  input clk_100_input;
  output clk_100_output;
  output clk_512;
  output clk_8;
  input reset;

  wire clk_100_input;
  wire clk_100_output;
  wire clk_512;
  wire clk_8;
  wire reset;

  (* CORE_GENERATION_INFO = "clock_generator_clk_wiz_0_0,clk_wiz_v5_1,{component_name=clock_generator_clk_wiz_0_0,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,enable_axi=0,feedback_source=FDBK_AUTO,PRIMITIVE=MMCM,num_out_clk=3,clkin1_period=10.0,clkin2_period=10.0,use_power_down=false,use_reset=true,use_locked=false,use_inclk_stopped=false,feedback_type=SINGLE,CLOCK_MGR_TYPE=NA,manual_override=false}" *) 
  clock_generator_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_100_input),
        .clk_out1(clk_512),
        .clk_out2(clk_8),
        .clk_out3(clk_100_output),
        .reset(reset));
endmodule

(* CORE_GENERATION_INFO = "clock_generator_clk_wiz_0_0,clk_wiz_v5_1,{component_name=clock_generator_clk_wiz_0_0,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,enable_axi=0,feedback_source=FDBK_AUTO,PRIMITIVE=MMCM,num_out_clk=3,clkin1_period=10.0,clkin2_period=10.0,use_power_down=false,use_reset=true,use_locked=false,use_inclk_stopped=false,feedback_type=SINGLE,CLOCK_MGR_TYPE=NA,manual_override=false}" *) 
module clock_generator_clk_wiz_0_0
   (clk_in1,
    clk_out1,
    clk_out2,
    clk_out3,
    reset);
  input clk_in1;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  input reset;

  wire clk_in1;
  wire clk_out1;
  wire clk_out2;
  wire clk_out3;
  wire reset;

  clock_generator_clk_wiz_0_0_clk_wiz inst
       (.clk_in1(clk_in1),
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .clk_out3(clk_out3),
        .reset(reset));
endmodule

module clock_generator_clk_wiz_0_0_clk_wiz
   (clk_in1,
    clk_out1,
    clk_out2,
    clk_out3,
    reset);
  input clk_in1;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  input reset;

  wire clk_in1;
  wire clk_in1_clock_generator_clk_wiz_0_0;
  wire clk_out1;
  wire clk_out1_clock_generator_clk_wiz_0_0;
  wire clk_out2;
  wire clk_out2_clock_generator_clk_wiz_0_0;
  wire clk_out3;
  wire clk_out3_clock_generator_clk_wiz_0_0;
  wire clkfbout_buf_clock_generator_clk_wiz_0_0;
  wire clkfbout_clock_generator_clk_wiz_0_0;
  wire reset;
  wire NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED;
  wire NLW_mmcm_adv_inst_DRDY_UNCONNECTED;
  wire NLW_mmcm_adv_inst_LOCKED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_PSDONE_UNCONNECTED;
  wire [15:0]NLW_mmcm_adv_inst_DO_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkf_buf
       (.I(clkfbout_clock_generator_clk_wiz_0_0),
        .O(clkfbout_buf_clock_generator_clk_wiz_0_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* IBUF_DELAY_VALUE = "0" *) 
  (* IFD_DELAY_VALUE = "AUTO" *) 
  IBUF #(
    .IOSTANDARD("DEFAULT")) 
    clkin1_ibufg
       (.I(clk_in1),
        .O(clk_in1_clock_generator_clk_wiz_0_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout1_buf
       (.I(clk_out1_clock_generator_clk_wiz_0_0),
        .O(clk_out1));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout2_buf
       (.I(clk_out2_clock_generator_clk_wiz_0_0),
        .O(clk_out2));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout3_buf
       (.I(clk_out3_clock_generator_clk_wiz_0_0),
        .O(clk_out3));
  (* BOX_TYPE = "PRIMITIVE" *) 
  MMCME2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(10.250000),
    .CLKFBOUT_PHASE(0.000000),
    .CLKFBOUT_USE_FINE_PS("FALSE"),
    .CLKIN1_PERIOD(10.000000),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE_F(2.000000),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT0_USE_FINE_PS("FALSE"),
    .CLKOUT1_DIVIDE(122),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUT1_USE_FINE_PS("FALSE"),
    .CLKOUT2_DIVIDE(10),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(0.000000),
    .CLKOUT2_USE_FINE_PS("FALSE"),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(0.000000),
    .CLKOUT3_USE_FINE_PS("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(0.000000),
    .CLKOUT4_USE_FINE_PS("FALSE"),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .CLKOUT5_USE_FINE_PS("FALSE"),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.500000),
    .CLKOUT6_PHASE(0.000000),
    .CLKOUT6_USE_FINE_PS("FALSE"),
    .COMPENSATION("ZHOLD"),
    .DIVCLK_DIVIDE(1),
    .IS_CLKINSEL_INVERTED(1'b0),
    .IS_PSEN_INVERTED(1'b0),
    .IS_PSINCDEC_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.010000),
    .SS_EN("FALSE"),
    .SS_MODE("CENTER_HIGH"),
    .SS_MOD_PERIOD(10000),
    .STARTUP_WAIT("FALSE")) 
    mmcm_adv_inst
       (.CLKFBIN(clkfbout_buf_clock_generator_clk_wiz_0_0),
        .CLKFBOUT(clkfbout_clock_generator_clk_wiz_0_0),
        .CLKFBOUTB(NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED),
        .CLKFBSTOPPED(NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED),
        .CLKIN1(clk_in1_clock_generator_clk_wiz_0_0),
        .CLKIN2(1'b0),
        .CLKINSEL(1'b1),
        .CLKINSTOPPED(NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED),
        .CLKOUT0(clk_out1_clock_generator_clk_wiz_0_0),
        .CLKOUT0B(NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(clk_out2_clock_generator_clk_wiz_0_0),
        .CLKOUT1B(NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED),
        .CLKOUT2(clk_out3_clock_generator_clk_wiz_0_0),
        .CLKOUT2B(NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED),
        .CLKOUT3(NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED),
        .CLKOUT3B(NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED),
        .CLKOUT4(NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED),
        .CLKOUT5(NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED),
        .CLKOUT6(NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_mmcm_adv_inst_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_mmcm_adv_inst_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(NLW_mmcm_adv_inst_LOCKED_UNCONNECTED),
        .PSCLK(1'b0),
        .PSDONE(NLW_mmcm_adv_inst_PSDONE_UNCONNECTED),
        .PSEN(1'b0),
        .PSINCDEC(1'b0),
        .PWRDWN(1'b0),
        .RST(reset));
endmodule

module clocking
   (CLK_48,
    clk_100_buffered);
  output CLK_48;
  input clk_100_buffered;

  wire CLK_48;
  wire clk_100_buffered;
  wire clk_feedback;
  wire zed_audio_clk_48M;
  wire NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT1_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED;
  wire NLW_mmcm_adv_inst_DRDY_UNCONNECTED;
  wire NLW_mmcm_adv_inst_LOCKED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_PSDONE_UNCONNECTED;
  wire [15:0]NLW_mmcm_adv_inst_DO_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout1_buf
       (.I(zed_audio_clk_48M),
        .O(CLK_48));
  (* BOX_TYPE = "PRIMITIVE" *) 
  MMCME2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(49.500000),
    .CLKFBOUT_PHASE(0.000000),
    .CLKFBOUT_USE_FINE_PS("FALSE"),
    .CLKIN1_PERIOD(9.756097),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE_F(20.625000),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT0_USE_FINE_PS("FALSE"),
    .CLKOUT1_DIVIDE(1),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUT1_USE_FINE_PS("FALSE"),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(0.000000),
    .CLKOUT2_USE_FINE_PS("FALSE"),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(0.000000),
    .CLKOUT3_USE_FINE_PS("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(0.000000),
    .CLKOUT4_USE_FINE_PS("FALSE"),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .CLKOUT5_USE_FINE_PS("FALSE"),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.500000),
    .CLKOUT6_PHASE(0.000000),
    .CLKOUT6_USE_FINE_PS("FALSE"),
    .COMPENSATION("INTERNAL"),
    .DIVCLK_DIVIDE(5),
    .IS_CLKINSEL_INVERTED(1'b0),
    .IS_PSEN_INVERTED(1'b0),
    .IS_PSINCDEC_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.000000),
    .SS_EN("FALSE"),
    .SS_MODE("CENTER_HIGH"),
    .SS_MOD_PERIOD(10000),
    .STARTUP_WAIT("FALSE")) 
    mmcm_adv_inst
       (.CLKFBIN(clk_feedback),
        .CLKFBOUT(clk_feedback),
        .CLKFBOUTB(NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED),
        .CLKFBSTOPPED(NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED),
        .CLKIN1(clk_100_buffered),
        .CLKIN2(1'b0),
        .CLKINSEL(1'b1),
        .CLKINSTOPPED(NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED),
        .CLKOUT0(zed_audio_clk_48M),
        .CLKOUT0B(NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(NLW_mmcm_adv_inst_CLKOUT1_UNCONNECTED),
        .CLKOUT1B(NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED),
        .CLKOUT2(NLW_mmcm_adv_inst_CLKOUT2_UNCONNECTED),
        .CLKOUT2B(NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED),
        .CLKOUT3(NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED),
        .CLKOUT3B(NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED),
        .CLKOUT4(NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED),
        .CLKOUT5(NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED),
        .CLKOUT6(NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_mmcm_adv_inst_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_mmcm_adv_inst_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(NLW_mmcm_adv_inst_LOCKED_UNCONNECTED),
        .PSCLK(1'b0),
        .PSDONE(NLW_mmcm_adv_inst_PSDONE_UNCONNECTED),
        .PSEN(1'b0),
        .PSINCDEC(1'b0),
        .PWRDWN(1'b0),
        .RST(1'b0));
endmodule

module frequency_sweep
   (D,
    CO,
    \counter_reg[12] ,
    Q,
    AR,
    S,
    \frequency_timer_period_old_reg[12] ,
    \frequency_timer_period_old_reg[11] ,
    O,
    \counter_reg[12]_0 ,
    \counter_reg[8] ,
    \counter_reg[0] );
  output [10:0]D;
  output [0:0]CO;
  output [10:0]\counter_reg[12] ;
  input [0:0]Q;
  input [0:0]AR;
  input [0:0]S;
  input [0:0]\frequency_timer_period_old_reg[12] ;
  input [8:0]\frequency_timer_period_old_reg[11] ;
  input [3:0]O;
  input \counter_reg[12]_0 ;
  input [3:0]\counter_reg[8] ;
  input [2:0]\counter_reg[0] ;

  wire [0:0]AR;
  wire [0:0]CO;
  wire [10:0]D;
  wire [3:0]O;
  wire [0:0]Q;
  wire [0:0]S;
  wire \counter[12]_i_13_n_0 ;
  wire \counter[12]_i_14_n_0 ;
  wire \counter[12]_i_15_n_0 ;
  wire [2:0]\counter_reg[0] ;
  wire [10:0]\counter_reg[12] ;
  wire \counter_reg[12]_0 ;
  wire \counter_reg[12]_i_11_n_0 ;
  wire [3:0]\counter_reg[8] ;
  wire enable_flag;
  wire enable_flag_i_1_n_0;
  wire [10:0]freq_shadow;
  wire \frequency_timer_period_old[12]_i_2_n_0 ;
  wire [8:0]\frequency_timer_period_old_reg[11] ;
  wire [0:0]\frequency_timer_period_old_reg[12] ;
  wire [7:1]internal_NR13_reg;
  wire internal_NR13_reg1;
  wire \internal_NR13_reg[3]_i_2_n_0 ;
  wire \internal_NR13_reg[3]_i_3_n_0 ;
  wire \internal_NR13_reg[3]_i_4_n_0 ;
  wire \internal_NR13_reg[3]_i_5_n_0 ;
  wire \internal_NR13_reg[3]_i_6_n_0 ;
  wire \internal_NR13_reg[7]_i_1_n_0 ;
  wire \internal_NR13_reg[7]_i_3_n_0 ;
  wire \internal_NR13_reg[7]_i_4_n_0 ;
  wire \internal_NR13_reg[7]_i_5_n_0 ;
  wire \internal_NR13_reg[7]_i_6_n_0 ;
  wire \internal_NR13_reg_reg[3]_i_1_n_0 ;
  wire \internal_NR13_reg_reg[3]_i_1_n_4 ;
  wire \internal_NR13_reg_reg[3]_i_1_n_5 ;
  wire \internal_NR13_reg_reg[3]_i_1_n_6 ;
  wire \internal_NR13_reg_reg[3]_i_1_n_7 ;
  wire \internal_NR13_reg_reg[7]_i_2_n_0 ;
  wire \internal_NR13_reg_reg[7]_i_2_n_4 ;
  wire \internal_NR13_reg_reg[7]_i_2_n_5 ;
  wire \internal_NR13_reg_reg[7]_i_2_n_6 ;
  wire \internal_NR13_reg_reg[7]_i_2_n_7 ;
  wire \internal_NR14_reg[2]_i_3_n_0 ;
  wire \internal_NR14_reg[2]_i_4_n_0 ;
  wire \internal_NR14_reg[2]_i_5_n_0 ;
  wire \internal_NR14_reg_reg_n_0_[0] ;
  wire \internal_NR14_reg_reg_n_0_[1] ;
  wire \internal_NR14_reg_reg_n_0_[2] ;
  wire [0:0]overflow;
  wire [2:0]p_2_in;
  wire [2:0]sweep_timer;
  wire \sweep_timer[0]_i_1_n_0 ;
  wire \sweep_timer[1]_i_1_n_0 ;
  wire \sweep_timer[2]_i_1_n_0 ;
  wire [2:0]\NLW_counter_reg[12]_i_11_CO_UNCONNECTED ;
  wire [3:0]\NLW_counter_reg[12]_i_11_O_UNCONNECTED ;
  wire [3:1]\NLW_counter_reg[12]_i_8_CO_UNCONNECTED ;
  wire [3:0]\NLW_counter_reg[12]_i_8_O_UNCONNECTED ;
  wire [2:0]\NLW_internal_NR13_reg_reg[3]_i_1_CO_UNCONNECTED ;
  wire [2:0]\NLW_internal_NR13_reg_reg[7]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_internal_NR14_reg_reg[2]_i_2_CO_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \counter[10]_i_1 
       (.I0(D[8]),
        .I1(O[1]),
        .I2(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [8]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \counter[11]_i_1 
       (.I0(D[9]),
        .I1(O[2]),
        .I2(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [9]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \counter[12]_i_1 
       (.I0(D[10]),
        .I1(O[3]),
        .I2(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [10]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \counter[12]_i_13 
       (.I0(D[7]),
        .I1(\frequency_timer_period_old_reg[11] [6]),
        .I2(\frequency_timer_period_old_reg[11] [8]),
        .I3(D[9]),
        .I4(\frequency_timer_period_old_reg[11] [7]),
        .I5(D[8]),
        .O(\counter[12]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \counter[12]_i_14 
       (.I0(D[4]),
        .I1(\frequency_timer_period_old_reg[11] [3]),
        .I2(\frequency_timer_period_old_reg[11] [5]),
        .I3(D[6]),
        .I4(\frequency_timer_period_old_reg[11] [4]),
        .I5(D[5]),
        .O(\counter[12]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \counter[12]_i_15 
       (.I0(D[1]),
        .I1(\frequency_timer_period_old_reg[11] [0]),
        .I2(\frequency_timer_period_old_reg[11] [2]),
        .I3(D[3]),
        .I4(\frequency_timer_period_old_reg[11] [1]),
        .I5(D[2]),
        .O(\counter[12]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \counter[2]_i_1 
       (.I0(D[0]),
        .I1(\counter_reg[0] [0]),
        .I2(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [0]));
  LUT4 #(
    .INIT(16'h66F0)) 
    \counter[3]_i_1 
       (.I0(D[0]),
        .I1(internal_NR13_reg[1]),
        .I2(\counter_reg[0] [1]),
        .I3(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [1]));
  LUT5 #(
    .INIT(32'h1E1EFF00)) 
    \counter[4]_i_1 
       (.I0(D[0]),
        .I1(internal_NR13_reg[1]),
        .I2(internal_NR13_reg[2]),
        .I3(\counter_reg[0] [2]),
        .I4(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [2]));
  LUT6 #(
    .INIT(64'h01FE01FEFFFF0000)) 
    \counter[5]_i_1 
       (.I0(internal_NR13_reg[2]),
        .I1(internal_NR13_reg[1]),
        .I2(D[0]),
        .I3(internal_NR13_reg[3]),
        .I4(\counter_reg[8] [0]),
        .I5(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [3]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \counter[6]_i_1 
       (.I0(D[4]),
        .I1(\counter_reg[8] [1]),
        .I2(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [4]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \counter[7]_i_1 
       (.I0(D[5]),
        .I1(\counter_reg[8] [2]),
        .I2(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [5]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \counter[8]_i_1 
       (.I0(D[6]),
        .I1(\counter_reg[8] [3]),
        .I2(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [6]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \counter[9]_i_1 
       (.I0(D[7]),
        .I1(O[0]),
        .I2(\counter_reg[12]_0 ),
        .O(\counter_reg[12] [7]));
  CARRY4 \counter_reg[12]_i_11 
       (.CI(1'b0),
        .CO({\counter_reg[12]_i_11_n_0 ,\NLW_counter_reg[12]_i_11_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(\NLW_counter_reg[12]_i_11_O_UNCONNECTED [3:0]),
        .S({\counter[12]_i_13_n_0 ,\counter[12]_i_14_n_0 ,\counter[12]_i_15_n_0 ,S}));
  CARRY4 \counter_reg[12]_i_8 
       (.CI(\counter_reg[12]_i_11_n_0 ),
        .CO({\NLW_counter_reg[12]_i_8_CO_UNCONNECTED [3:1],CO}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O(\NLW_counter_reg[12]_i_8_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\frequency_timer_period_old_reg[12] }));
  LUT3 #(
    .INIT(8'h01)) 
    enable_flag_i_1
       (.I0(sweep_timer[0]),
        .I1(sweep_timer[2]),
        .I2(sweep_timer[1]),
        .O(enable_flag_i_1_n_0));
  FDCE #(
    .INIT(1'b0)) 
    enable_flag_reg
       (.C(Q),
        .CE(1'b1),
        .CLR(AR),
        .D(enable_flag_i_1_n_0),
        .Q(enable_flag));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[0] 
       (.C(Q),
        .CE(1'b1),
        .D(D[0]),
        .Q(freq_shadow[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[10] 
       (.C(Q),
        .CE(1'b1),
        .D(\internal_NR14_reg_reg_n_0_[2] ),
        .Q(freq_shadow[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[1] 
       (.C(Q),
        .CE(1'b1),
        .D(internal_NR13_reg[1]),
        .Q(freq_shadow[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[2] 
       (.C(Q),
        .CE(1'b1),
        .D(internal_NR13_reg[2]),
        .Q(freq_shadow[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[3] 
       (.C(Q),
        .CE(1'b1),
        .D(internal_NR13_reg[3]),
        .Q(freq_shadow[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[4] 
       (.C(Q),
        .CE(1'b1),
        .D(internal_NR13_reg[4]),
        .Q(freq_shadow[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[5] 
       (.C(Q),
        .CE(1'b1),
        .D(internal_NR13_reg[5]),
        .Q(freq_shadow[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[6] 
       (.C(Q),
        .CE(1'b1),
        .D(internal_NR13_reg[6]),
        .Q(freq_shadow[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[7] 
       (.C(Q),
        .CE(1'b1),
        .D(internal_NR13_reg[7]),
        .Q(freq_shadow[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[8] 
       (.C(Q),
        .CE(1'b1),
        .D(\internal_NR14_reg_reg_n_0_[0] ),
        .Q(freq_shadow[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \freq_shadow_reg[9] 
       (.C(Q),
        .CE(1'b1),
        .D(\internal_NR14_reg_reg_n_0_[1] ),
        .Q(freq_shadow[9]),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h04FB)) 
    \frequency_timer_period_old[10]_i_1 
       (.I0(internal_NR13_reg[7]),
        .I1(\frequency_timer_period_old[12]_i_2_n_0 ),
        .I2(internal_NR13_reg[6]),
        .I3(\internal_NR14_reg_reg_n_0_[0] ),
        .O(D[8]));
  LUT5 #(
    .INIT(32'h0010FFEF)) 
    \frequency_timer_period_old[11]_i_1 
       (.I0(\internal_NR14_reg_reg_n_0_[0] ),
        .I1(internal_NR13_reg[6]),
        .I2(\frequency_timer_period_old[12]_i_2_n_0 ),
        .I3(internal_NR13_reg[7]),
        .I4(\internal_NR14_reg_reg_n_0_[1] ),
        .O(D[9]));
  LUT6 #(
    .INIT(64'h00000010FFFFFFEF)) 
    \frequency_timer_period_old[12]_i_1 
       (.I0(\internal_NR14_reg_reg_n_0_[1] ),
        .I1(internal_NR13_reg[7]),
        .I2(\frequency_timer_period_old[12]_i_2_n_0 ),
        .I3(internal_NR13_reg[6]),
        .I4(\internal_NR14_reg_reg_n_0_[0] ),
        .I5(\internal_NR14_reg_reg_n_0_[2] ),
        .O(D[10]));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \frequency_timer_period_old[12]_i_2 
       (.I0(internal_NR13_reg[4]),
        .I1(internal_NR13_reg[2]),
        .I2(internal_NR13_reg[1]),
        .I3(D[0]),
        .I4(internal_NR13_reg[3]),
        .I5(internal_NR13_reg[5]),
        .O(\frequency_timer_period_old[12]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \frequency_timer_period_old[3]_i_1 
       (.I0(D[0]),
        .I1(internal_NR13_reg[1]),
        .O(D[1]));
  LUT3 #(
    .INIT(8'h1E)) 
    \frequency_timer_period_old[4]_i_1 
       (.I0(D[0]),
        .I1(internal_NR13_reg[1]),
        .I2(internal_NR13_reg[2]),
        .O(D[2]));
  LUT4 #(
    .INIT(16'h01FE)) 
    \frequency_timer_period_old[5]_i_1 
       (.I0(internal_NR13_reg[2]),
        .I1(internal_NR13_reg[1]),
        .I2(D[0]),
        .I3(internal_NR13_reg[3]),
        .O(D[3]));
  LUT5 #(
    .INIT(32'h0001FFFE)) 
    \frequency_timer_period_old[6]_i_1 
       (.I0(internal_NR13_reg[3]),
        .I1(D[0]),
        .I2(internal_NR13_reg[1]),
        .I3(internal_NR13_reg[2]),
        .I4(internal_NR13_reg[4]),
        .O(D[4]));
  LUT6 #(
    .INIT(64'h00000001FFFFFFFE)) 
    \frequency_timer_period_old[7]_i_1 
       (.I0(internal_NR13_reg[4]),
        .I1(internal_NR13_reg[2]),
        .I2(internal_NR13_reg[1]),
        .I3(D[0]),
        .I4(internal_NR13_reg[3]),
        .I5(internal_NR13_reg[5]),
        .O(D[5]));
  LUT2 #(
    .INIT(4'h9)) 
    \frequency_timer_period_old[8]_i_1 
       (.I0(\frequency_timer_period_old[12]_i_2_n_0 ),
        .I1(internal_NR13_reg[6]),
        .O(D[6]));
  LUT3 #(
    .INIT(8'h4B)) 
    \frequency_timer_period_old[9]_i_1 
       (.I0(internal_NR13_reg[6]),
        .I1(\frequency_timer_period_old[12]_i_2_n_0 ),
        .I2(internal_NR13_reg[7]),
        .O(D[7]));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR13_reg[3]_i_2 
       (.I0(freq_shadow[7]),
        .O(\internal_NR13_reg[3]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \internal_NR13_reg[3]_i_3 
       (.I0(freq_shadow[3]),
        .I1(freq_shadow[10]),
        .O(\internal_NR13_reg[3]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \internal_NR13_reg[3]_i_4 
       (.I0(freq_shadow[2]),
        .I1(freq_shadow[9]),
        .O(\internal_NR13_reg[3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \internal_NR13_reg[3]_i_5 
       (.I0(freq_shadow[1]),
        .I1(freq_shadow[8]),
        .O(\internal_NR13_reg[3]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR13_reg[3]_i_6 
       (.I0(freq_shadow[0]),
        .O(\internal_NR13_reg[3]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \internal_NR13_reg[7]_i_1 
       (.I0(overflow),
        .I1(enable_flag),
        .I2(AR),
        .O(\internal_NR13_reg[7]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR13_reg[7]_i_3 
       (.I0(freq_shadow[7]),
        .O(\internal_NR13_reg[7]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR13_reg[7]_i_4 
       (.I0(freq_shadow[6]),
        .O(\internal_NR13_reg[7]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR13_reg[7]_i_5 
       (.I0(freq_shadow[5]),
        .O(\internal_NR13_reg[7]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR13_reg[7]_i_6 
       (.I0(freq_shadow[4]),
        .O(\internal_NR13_reg[7]_i_6_n_0 ));
  FDSE #(
    .INIT(1'b1)) 
    \internal_NR13_reg_reg[0] 
       (.C(Q),
        .CE(\internal_NR13_reg[7]_i_1_n_0 ),
        .D(\internal_NR13_reg_reg[3]_i_1_n_7 ),
        .Q(D[0]),
        .S(AR));
  FDSE #(
    .INIT(1'b1)) 
    \internal_NR13_reg_reg[1] 
       (.C(Q),
        .CE(\internal_NR13_reg[7]_i_1_n_0 ),
        .D(\internal_NR13_reg_reg[3]_i_1_n_6 ),
        .Q(internal_NR13_reg[1]),
        .S(AR));
  FDSE #(
    .INIT(1'b1)) 
    \internal_NR13_reg_reg[2] 
       (.C(Q),
        .CE(\internal_NR13_reg[7]_i_1_n_0 ),
        .D(\internal_NR13_reg_reg[3]_i_1_n_5 ),
        .Q(internal_NR13_reg[2]),
        .S(AR));
  FDSE #(
    .INIT(1'b1)) 
    \internal_NR13_reg_reg[3] 
       (.C(Q),
        .CE(\internal_NR13_reg[7]_i_1_n_0 ),
        .D(\internal_NR13_reg_reg[3]_i_1_n_4 ),
        .Q(internal_NR13_reg[3]),
        .S(AR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \internal_NR13_reg_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\internal_NR13_reg_reg[3]_i_1_n_0 ,\NLW_internal_NR13_reg_reg[3]_i_1_CO_UNCONNECTED [2:0]}),
        .CYINIT(\internal_NR13_reg[3]_i_2_n_0 ),
        .DI({freq_shadow[3:1],1'b1}),
        .O({\internal_NR13_reg_reg[3]_i_1_n_4 ,\internal_NR13_reg_reg[3]_i_1_n_5 ,\internal_NR13_reg_reg[3]_i_1_n_6 ,\internal_NR13_reg_reg[3]_i_1_n_7 }),
        .S({\internal_NR13_reg[3]_i_3_n_0 ,\internal_NR13_reg[3]_i_4_n_0 ,\internal_NR13_reg[3]_i_5_n_0 ,\internal_NR13_reg[3]_i_6_n_0 }));
  FDSE #(
    .INIT(1'b1)) 
    \internal_NR13_reg_reg[4] 
       (.C(Q),
        .CE(\internal_NR13_reg[7]_i_1_n_0 ),
        .D(\internal_NR13_reg_reg[7]_i_2_n_7 ),
        .Q(internal_NR13_reg[4]),
        .S(AR));
  FDSE #(
    .INIT(1'b1)) 
    \internal_NR13_reg_reg[5] 
       (.C(Q),
        .CE(\internal_NR13_reg[7]_i_1_n_0 ),
        .D(\internal_NR13_reg_reg[7]_i_2_n_6 ),
        .Q(internal_NR13_reg[5]),
        .S(AR));
  FDSE #(
    .INIT(1'b1)) 
    \internal_NR13_reg_reg[6] 
       (.C(Q),
        .CE(\internal_NR13_reg[7]_i_1_n_0 ),
        .D(\internal_NR13_reg_reg[7]_i_2_n_5 ),
        .Q(internal_NR13_reg[6]),
        .S(AR));
  FDSE #(
    .INIT(1'b1)) 
    \internal_NR13_reg_reg[7] 
       (.C(Q),
        .CE(\internal_NR13_reg[7]_i_1_n_0 ),
        .D(\internal_NR13_reg_reg[7]_i_2_n_4 ),
        .Q(internal_NR13_reg[7]),
        .S(AR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \internal_NR13_reg_reg[7]_i_2 
       (.CI(\internal_NR13_reg_reg[3]_i_1_n_0 ),
        .CO({\internal_NR13_reg_reg[7]_i_2_n_0 ,\NLW_internal_NR13_reg_reg[7]_i_2_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI(freq_shadow[7:4]),
        .O({\internal_NR13_reg_reg[7]_i_2_n_4 ,\internal_NR13_reg_reg[7]_i_2_n_5 ,\internal_NR13_reg_reg[7]_i_2_n_6 ,\internal_NR13_reg_reg[7]_i_2_n_7 }),
        .S({\internal_NR13_reg[7]_i_3_n_0 ,\internal_NR13_reg[7]_i_4_n_0 ,\internal_NR13_reg[7]_i_5_n_0 ,\internal_NR13_reg[7]_i_6_n_0 }));
  LUT2 #(
    .INIT(4'h2)) 
    \internal_NR14_reg[2]_i_1 
       (.I0(enable_flag),
        .I1(overflow),
        .O(internal_NR13_reg1));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR14_reg[2]_i_3 
       (.I0(freq_shadow[10]),
        .O(\internal_NR14_reg[2]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR14_reg[2]_i_4 
       (.I0(freq_shadow[9]),
        .O(\internal_NR14_reg[2]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \internal_NR14_reg[2]_i_5 
       (.I0(freq_shadow[8]),
        .O(\internal_NR14_reg[2]_i_5_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \internal_NR14_reg_reg[0] 
       (.C(Q),
        .CE(internal_NR13_reg1),
        .D(p_2_in[0]),
        .Q(\internal_NR14_reg_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \internal_NR14_reg_reg[1] 
       (.C(Q),
        .CE(internal_NR13_reg1),
        .D(p_2_in[1]),
        .Q(\internal_NR14_reg_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \internal_NR14_reg_reg[2] 
       (.C(Q),
        .CE(internal_NR13_reg1),
        .D(p_2_in[2]),
        .Q(\internal_NR14_reg_reg_n_0_[2] ),
        .R(1'b0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \internal_NR14_reg_reg[2]_i_2 
       (.CI(\internal_NR13_reg_reg[7]_i_2_n_0 ),
        .CO(\NLW_internal_NR14_reg_reg[2]_i_2_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,freq_shadow[10:8]}),
        .O({overflow,p_2_in}),
        .S({1'b1,\internal_NR14_reg[2]_i_3_n_0 ,\internal_NR14_reg[2]_i_4_n_0 ,\internal_NR14_reg[2]_i_5_n_0 }));
  LUT1 #(
    .INIT(2'h1)) 
    \sweep_timer[0]_i_1 
       (.I0(sweep_timer[0]),
        .O(\sweep_timer[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \sweep_timer[1]_i_1 
       (.I0(sweep_timer[1]),
        .I1(sweep_timer[0]),
        .O(\sweep_timer[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hA9)) 
    \sweep_timer[2]_i_1 
       (.I0(sweep_timer[2]),
        .I1(sweep_timer[0]),
        .I2(sweep_timer[1]),
        .O(\sweep_timer[2]_i_1_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \sweep_timer_reg[0] 
       (.C(Q),
        .CE(1'b1),
        .D(\sweep_timer[0]_i_1_n_0 ),
        .PRE(AR),
        .Q(sweep_timer[0]));
  FDPE #(
    .INIT(1'b1)) 
    \sweep_timer_reg[1] 
       (.C(Q),
        .CE(1'b1),
        .D(\sweep_timer[1]_i_1_n_0 ),
        .PRE(AR),
        .Q(sweep_timer[1]));
  FDPE #(
    .INIT(1'b1)) 
    \sweep_timer_reg[2] 
       (.C(Q),
        .CE(1'b1),
        .D(\sweep_timer[2]_i_1_n_0 ),
        .PRE(AR),
        .Q(sweep_timer[2]));
endmodule

module frequency_timer
   (frequency_timer_clock,
    clk_8,
    AR);
  output frequency_timer_clock;
  input clk_8;
  input [0:0]AR;

  wire [0:0]AR;
  wire clk_8;
  wire [12:0]counter;
  wire \counter[12]_i_2__0_n_0 ;
  wire \counter[12]_i_3__1_n_0 ;
  wire \counter[12]_i_5__0_n_0 ;
  wire \counter[12]_i_6__0_n_0 ;
  wire \counter[12]_i_7__0_n_0 ;
  wire \counter[12]_i_8__0_n_0 ;
  wire \counter[4]_i_3__0_n_0 ;
  wire \counter[4]_i_4__0_n_0 ;
  wire \counter[4]_i_5__0_n_0 ;
  wire \counter[4]_i_6__0_n_0 ;
  wire \counter[8]_i_3__0_n_0 ;
  wire \counter[8]_i_4__0_n_0 ;
  wire \counter[8]_i_5__0_n_0 ;
  wire \counter[8]_i_6__0_n_0 ;
  wire \counter_reg[12]_i_4__0_n_4 ;
  wire \counter_reg[12]_i_4__0_n_5 ;
  wire \counter_reg[12]_i_4__0_n_6 ;
  wire \counter_reg[12]_i_4__0_n_7 ;
  wire \counter_reg[4]_i_2__0_n_0 ;
  wire \counter_reg[4]_i_2__0_n_4 ;
  wire \counter_reg[4]_i_2__0_n_5 ;
  wire \counter_reg[4]_i_2__0_n_6 ;
  wire \counter_reg[4]_i_2__0_n_7 ;
  wire \counter_reg[8]_i_2__0_n_0 ;
  wire \counter_reg[8]_i_2__0_n_4 ;
  wire \counter_reg[8]_i_2__0_n_5 ;
  wire \counter_reg[8]_i_2__0_n_6 ;
  wire \counter_reg[8]_i_2__0_n_7 ;
  wire frequency_timer_clock;
  wire frequency_timer_clock_i_1__1_n_0;
  wire [12:0]p_2_in;
  wire [3:0]\NLW_counter_reg[12]_i_4__0_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[4]_i_2__0_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[8]_i_2__0_CO_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \counter[0]_i_1__2 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(counter[0]),
        .O(p_2_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[10]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[12]_i_4__0_n_6 ),
        .O(p_2_in[10]));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[11]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[12]_i_4__0_n_5 ),
        .O(p_2_in[11]));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[12]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[12]_i_4__0_n_4 ),
        .O(p_2_in[12]));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \counter[12]_i_2__0 
       (.I0(counter[10]),
        .I1(counter[9]),
        .I2(counter[11]),
        .I3(counter[12]),
        .I4(counter[7]),
        .I5(counter[8]),
        .O(\counter[12]_i_2__0_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \counter[12]_i_3__1 
       (.I0(counter[0]),
        .I1(counter[2]),
        .I2(counter[3]),
        .I3(counter[4]),
        .I4(counter[5]),
        .I5(counter[6]),
        .O(\counter[12]_i_3__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_5__0 
       (.I0(counter[12]),
        .O(\counter[12]_i_5__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_6__0 
       (.I0(counter[11]),
        .O(\counter[12]_i_6__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_7__0 
       (.I0(counter[10]),
        .O(\counter[12]_i_7__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_8__0 
       (.I0(counter[9]),
        .O(\counter[12]_i_8__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[1]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[4]_i_2__0_n_7 ),
        .O(p_2_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT4 #(
    .INIT(16'hFF20)) 
    \counter[2]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[4]_i_2__0_n_6 ),
        .O(p_2_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[3]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[4]_i_2__0_n_5 ),
        .O(p_2_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[4]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[4]_i_2__0_n_4 ),
        .O(p_2_in[4]));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_3__0 
       (.I0(counter[4]),
        .O(\counter[4]_i_3__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_4__0 
       (.I0(counter[3]),
        .O(\counter[4]_i_4__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_5__0 
       (.I0(counter[2]),
        .O(\counter[4]_i_5__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_6__0 
       (.I0(counter[1]),
        .O(\counter[4]_i_6__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[5]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[8]_i_2__0_n_7 ),
        .O(p_2_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[6]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[8]_i_2__0_n_6 ),
        .O(p_2_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[7]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[8]_i_2__0_n_5 ),
        .O(p_2_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[8]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[8]_i_2__0_n_4 ),
        .O(p_2_in[8]));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_3__0 
       (.I0(counter[8]),
        .O(\counter[8]_i_3__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_4__0 
       (.I0(counter[7]),
        .O(\counter[8]_i_4__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_5__0 
       (.I0(counter[6]),
        .O(\counter[8]_i_5__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_6__0 
       (.I0(counter[5]),
        .O(\counter[8]_i_6__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[9]_i_1__1 
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(\counter_reg[12]_i_4__0_n_7 ),
        .O(p_2_in[9]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[0]),
        .Q(counter[0]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[10]),
        .Q(counter[10]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[11]),
        .Q(counter[11]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[12]),
        .Q(counter[12]));
  CARRY4 \counter_reg[12]_i_4__0 
       (.CI(\counter_reg[8]_i_2__0_n_0 ),
        .CO(\NLW_counter_reg[12]_i_4__0_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,counter[11:9]}),
        .O({\counter_reg[12]_i_4__0_n_4 ,\counter_reg[12]_i_4__0_n_5 ,\counter_reg[12]_i_4__0_n_6 ,\counter_reg[12]_i_4__0_n_7 }),
        .S({\counter[12]_i_5__0_n_0 ,\counter[12]_i_6__0_n_0 ,\counter[12]_i_7__0_n_0 ,\counter[12]_i_8__0_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[1]),
        .Q(counter[1]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[2]),
        .Q(counter[2]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[3]),
        .Q(counter[3]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[4] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[4]),
        .Q(counter[4]));
  CARRY4 \counter_reg[4]_i_2__0 
       (.CI(1'b0),
        .CO({\counter_reg[4]_i_2__0_n_0 ,\NLW_counter_reg[4]_i_2__0_CO_UNCONNECTED [2:0]}),
        .CYINIT(counter[0]),
        .DI(counter[4:1]),
        .O({\counter_reg[4]_i_2__0_n_4 ,\counter_reg[4]_i_2__0_n_5 ,\counter_reg[4]_i_2__0_n_6 ,\counter_reg[4]_i_2__0_n_7 }),
        .S({\counter[4]_i_3__0_n_0 ,\counter[4]_i_4__0_n_0 ,\counter[4]_i_5__0_n_0 ,\counter[4]_i_6__0_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[5] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[5]),
        .Q(counter[5]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[6] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[6]),
        .Q(counter[6]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[7] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[7]),
        .Q(counter[7]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[8] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[8]),
        .Q(counter[8]));
  CARRY4 \counter_reg[8]_i_2__0 
       (.CI(\counter_reg[4]_i_2__0_n_0 ),
        .CO({\counter_reg[8]_i_2__0_n_0 ,\NLW_counter_reg[8]_i_2__0_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI(counter[8:5]),
        .O({\counter_reg[8]_i_2__0_n_4 ,\counter_reg[8]_i_2__0_n_5 ,\counter_reg[8]_i_2__0_n_6 ,\counter_reg[8]_i_2__0_n_7 }),
        .S({\counter[8]_i_3__0_n_0 ,\counter[8]_i_4__0_n_0 ,\counter[8]_i_5__0_n_0 ,\counter[8]_i_6__0_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[9]),
        .Q(counter[9]));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT4 #(
    .INIT(16'hDF20)) 
    frequency_timer_clock_i_1__1
       (.I0(\counter[12]_i_2__0_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__1_n_0 ),
        .I3(frequency_timer_clock),
        .O(frequency_timer_clock_i_1__1_n_0));
  FDCE #(
    .INIT(1'b0)) 
    frequency_timer_clock_reg
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(frequency_timer_clock_i_1__1_n_0),
        .Q(frequency_timer_clock));
endmodule

(* ORIG_REF_NAME = "frequency_timer" *) 
module frequency_timer_0
   (CLK,
    clk_8,
    AR);
  output CLK;
  input clk_8;
  input [0:0]AR;

  wire [0:0]AR;
  wire CLK;
  wire clk_8;
  wire [12:0]counter;
  wire \counter[12]_i_2__1_n_0 ;
  wire \counter[12]_i_3__2_n_0 ;
  wire \counter[12]_i_5__1_n_0 ;
  wire \counter[12]_i_6__1_n_0 ;
  wire \counter[12]_i_7__1_n_0 ;
  wire \counter[12]_i_8__1_n_0 ;
  wire \counter[4]_i_3__1_n_0 ;
  wire \counter[4]_i_4__1_n_0 ;
  wire \counter[4]_i_5__1_n_0 ;
  wire \counter[4]_i_6__1_n_0 ;
  wire \counter[8]_i_3__1_n_0 ;
  wire \counter[8]_i_4__1_n_0 ;
  wire \counter[8]_i_5__1_n_0 ;
  wire \counter[8]_i_6__1_n_0 ;
  wire \counter_reg[12]_i_4__1_n_4 ;
  wire \counter_reg[12]_i_4__1_n_5 ;
  wire \counter_reg[12]_i_4__1_n_6 ;
  wire \counter_reg[12]_i_4__1_n_7 ;
  wire \counter_reg[4]_i_2__1_n_0 ;
  wire \counter_reg[4]_i_2__1_n_4 ;
  wire \counter_reg[4]_i_2__1_n_5 ;
  wire \counter_reg[4]_i_2__1_n_6 ;
  wire \counter_reg[4]_i_2__1_n_7 ;
  wire \counter_reg[8]_i_2__1_n_0 ;
  wire \counter_reg[8]_i_2__1_n_4 ;
  wire \counter_reg[8]_i_2__1_n_5 ;
  wire \counter_reg[8]_i_2__1_n_6 ;
  wire \counter_reg[8]_i_2__1_n_7 ;
  wire frequency_timer_clock_i_1__2_n_0;
  wire [12:0]p_2_in;
  wire [3:0]\NLW_counter_reg[12]_i_4__1_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[4]_i_2__1_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[8]_i_2__1_CO_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \counter[0]_i_1__3 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(counter[0]),
        .O(p_2_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[10]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[12]_i_4__1_n_6 ),
        .O(p_2_in[10]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[11]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[12]_i_4__1_n_5 ),
        .O(p_2_in[11]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[12]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[12]_i_4__1_n_4 ),
        .O(p_2_in[12]));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \counter[12]_i_2__1 
       (.I0(counter[10]),
        .I1(counter[9]),
        .I2(counter[11]),
        .I3(counter[12]),
        .I4(counter[7]),
        .I5(counter[8]),
        .O(\counter[12]_i_2__1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \counter[12]_i_3__2 
       (.I0(counter[0]),
        .I1(counter[2]),
        .I2(counter[3]),
        .I3(counter[4]),
        .I4(counter[5]),
        .I5(counter[6]),
        .O(\counter[12]_i_3__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_5__1 
       (.I0(counter[12]),
        .O(\counter[12]_i_5__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_6__1 
       (.I0(counter[11]),
        .O(\counter[12]_i_6__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_7__1 
       (.I0(counter[10]),
        .O(\counter[12]_i_7__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_8__1 
       (.I0(counter[9]),
        .O(\counter[12]_i_8__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[1]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[4]_i_2__1_n_7 ),
        .O(p_2_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'hFF20)) 
    \counter[2]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[4]_i_2__1_n_6 ),
        .O(p_2_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[3]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[4]_i_2__1_n_5 ),
        .O(p_2_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[4]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[4]_i_2__1_n_4 ),
        .O(p_2_in[4]));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_3__1 
       (.I0(counter[4]),
        .O(\counter[4]_i_3__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_4__1 
       (.I0(counter[3]),
        .O(\counter[4]_i_4__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_5__1 
       (.I0(counter[2]),
        .O(\counter[4]_i_5__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_6__1 
       (.I0(counter[1]),
        .O(\counter[4]_i_6__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[5]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[8]_i_2__1_n_7 ),
        .O(p_2_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[6]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[8]_i_2__1_n_6 ),
        .O(p_2_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[7]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[8]_i_2__1_n_5 ),
        .O(p_2_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[8]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[8]_i_2__1_n_4 ),
        .O(p_2_in[8]));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_3__1 
       (.I0(counter[8]),
        .O(\counter[8]_i_3__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_4__1 
       (.I0(counter[7]),
        .O(\counter[8]_i_4__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_5__1 
       (.I0(counter[6]),
        .O(\counter[8]_i_5__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_6__1 
       (.I0(counter[5]),
        .O(\counter[8]_i_6__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[9]_i_1__2 
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(\counter_reg[12]_i_4__1_n_7 ),
        .O(p_2_in[9]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[0]),
        .Q(counter[0]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[10]),
        .Q(counter[10]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[11]),
        .Q(counter[11]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[12]),
        .Q(counter[12]));
  CARRY4 \counter_reg[12]_i_4__1 
       (.CI(\counter_reg[8]_i_2__1_n_0 ),
        .CO(\NLW_counter_reg[12]_i_4__1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,counter[11:9]}),
        .O({\counter_reg[12]_i_4__1_n_4 ,\counter_reg[12]_i_4__1_n_5 ,\counter_reg[12]_i_4__1_n_6 ,\counter_reg[12]_i_4__1_n_7 }),
        .S({\counter[12]_i_5__1_n_0 ,\counter[12]_i_6__1_n_0 ,\counter[12]_i_7__1_n_0 ,\counter[12]_i_8__1_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[1]),
        .Q(counter[1]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[2]),
        .Q(counter[2]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[3]),
        .Q(counter[3]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[4] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[4]),
        .Q(counter[4]));
  CARRY4 \counter_reg[4]_i_2__1 
       (.CI(1'b0),
        .CO({\counter_reg[4]_i_2__1_n_0 ,\NLW_counter_reg[4]_i_2__1_CO_UNCONNECTED [2:0]}),
        .CYINIT(counter[0]),
        .DI(counter[4:1]),
        .O({\counter_reg[4]_i_2__1_n_4 ,\counter_reg[4]_i_2__1_n_5 ,\counter_reg[4]_i_2__1_n_6 ,\counter_reg[4]_i_2__1_n_7 }),
        .S({\counter[4]_i_3__1_n_0 ,\counter[4]_i_4__1_n_0 ,\counter[4]_i_5__1_n_0 ,\counter[4]_i_6__1_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[5] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[5]),
        .Q(counter[5]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[6] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[6]),
        .Q(counter[6]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[7] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[7]),
        .Q(counter[7]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[8] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[8]),
        .Q(counter[8]));
  CARRY4 \counter_reg[8]_i_2__1 
       (.CI(\counter_reg[4]_i_2__1_n_0 ),
        .CO({\counter_reg[8]_i_2__1_n_0 ,\NLW_counter_reg[8]_i_2__1_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI(counter[8:5]),
        .O({\counter_reg[8]_i_2__1_n_4 ,\counter_reg[8]_i_2__1_n_5 ,\counter_reg[8]_i_2__1_n_6 ,\counter_reg[8]_i_2__1_n_7 }),
        .S({\counter[8]_i_3__1_n_0 ,\counter[8]_i_4__1_n_0 ,\counter[8]_i_5__1_n_0 ,\counter[8]_i_6__1_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[9]),
        .Q(counter[9]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'hDF20)) 
    frequency_timer_clock_i_1__2
       (.I0(\counter[12]_i_2__1_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__2_n_0 ),
        .I3(CLK),
        .O(frequency_timer_clock_i_1__2_n_0));
  FDCE #(
    .INIT(1'b0)) 
    frequency_timer_clock_reg
       (.C(clk_8),
        .CE(1'b1),
        .CLR(AR),
        .D(frequency_timer_clock_i_1__2_n_0),
        .Q(CLK));
endmodule

(* ORIG_REF_NAME = "frequency_timer" *) 
module frequency_timer_3
   (CLK,
    frequency_timer_clock_reg_0,
    S,
    frequency_timer_clock_reg_1,
    \counter_reg[4]_0 ,
    \counter_reg[8]_0 ,
    O,
    Q,
    \counter_reg[0]_0 ,
    AR,
    D,
    CO,
    \internal_NR14_reg_reg[1] );
  output CLK;
  output frequency_timer_clock_reg_0;
  output [0:0]S;
  output [0:0]frequency_timer_clock_reg_1;
  output [2:0]\counter_reg[4]_0 ;
  output [3:0]\counter_reg[8]_0 ;
  output [3:0]O;
  output [8:0]Q;
  input \counter_reg[0]_0 ;
  input [0:0]AR;
  input [10:0]D;
  input [0:0]CO;
  input [10:0]\internal_NR14_reg_reg[1] ;

  wire [0:0]AR;
  wire CLK;
  wire [0:0]CO;
  wire [10:0]D;
  wire [3:0]O;
  wire [8:0]Q;
  wire [0:0]S;
  wire [12:0]counter;
  wire \counter[0]_i_1__0_n_0 ;
  wire \counter[12]_i_10_n_0 ;
  wire \counter[12]_i_4_n_0 ;
  wire \counter[12]_i_5__2_n_0 ;
  wire \counter[12]_i_6__2_n_0 ;
  wire \counter[12]_i_7__2_n_0 ;
  wire \counter[12]_i_9_n_0 ;
  wire \counter[1]_i_1_n_0 ;
  wire \counter[4]_i_3__2_n_0 ;
  wire \counter[4]_i_4__2_n_0 ;
  wire \counter[4]_i_5__2_n_0 ;
  wire \counter[4]_i_6__2_n_0 ;
  wire \counter[8]_i_3__2_n_0 ;
  wire \counter[8]_i_4__2_n_0 ;
  wire \counter[8]_i_5__2_n_0 ;
  wire \counter[8]_i_6__2_n_0 ;
  wire \counter_reg[0]_0 ;
  wire [2:0]\counter_reg[4]_0 ;
  wire \counter_reg[4]_i_2__2_n_0 ;
  wire \counter_reg[4]_i_2__2_n_7 ;
  wire [3:0]\counter_reg[8]_0 ;
  wire \counter_reg[8]_i_2__2_n_0 ;
  wire frequency_timer_clock_i_1_n_0;
  wire frequency_timer_clock_reg_0;
  wire [0:0]frequency_timer_clock_reg_1;
  wire [12:2]frequency_timer_period_old;
  wire [10:0]\internal_NR14_reg_reg[1] ;
  wire [3:0]\NLW_counter_reg[12]_i_2_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[4]_i_2__2_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[8]_i_2__2_CO_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \counter[0]_i_1__0 
       (.I0(counter[0]),
        .I1(frequency_timer_clock_reg_0),
        .O(\counter[0]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \counter[12]_i_10 
       (.I0(counter[1]),
        .I1(counter[8]),
        .I2(counter[4]),
        .I3(counter[0]),
        .I4(counter[2]),
        .I5(counter[3]),
        .O(\counter[12]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \counter[12]_i_12 
       (.I0(frequency_timer_period_old[12]),
        .I1(D[10]),
        .O(frequency_timer_clock_reg_1));
  LUT2 #(
    .INIT(4'h9)) 
    \counter[12]_i_16 
       (.I0(frequency_timer_period_old[2]),
        .I1(D[0]),
        .O(S));
  LUT4 #(
    .INIT(16'hAEAA)) 
    \counter[12]_i_3 
       (.I0(CO),
        .I1(\counter[12]_i_9_n_0 ),
        .I2(counter[12]),
        .I3(\counter[12]_i_10_n_0 ),
        .O(frequency_timer_clock_reg_0));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_4 
       (.I0(counter[12]),
        .O(\counter[12]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_5__2 
       (.I0(counter[11]),
        .O(\counter[12]_i_5__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_6__2 
       (.I0(counter[10]),
        .O(\counter[12]_i_6__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_7__2 
       (.I0(counter[9]),
        .O(\counter[12]_i_7__2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \counter[12]_i_9 
       (.I0(counter[10]),
        .I1(counter[9]),
        .I2(counter[6]),
        .I3(counter[7]),
        .I4(counter[11]),
        .I5(counter[5]),
        .O(\counter[12]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \counter[1]_i_1 
       (.I0(\counter_reg[4]_i_2__2_n_7 ),
        .I1(frequency_timer_clock_reg_0),
        .O(\counter[1]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_3__2 
       (.I0(counter[4]),
        .O(\counter[4]_i_3__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_4__2 
       (.I0(counter[3]),
        .O(\counter[4]_i_4__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_5__2 
       (.I0(counter[2]),
        .O(\counter[4]_i_5__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_6__2 
       (.I0(counter[1]),
        .O(\counter[4]_i_6__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_3__2 
       (.I0(counter[8]),
        .O(\counter[8]_i_3__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_4__2 
       (.I0(counter[7]),
        .O(\counter[8]_i_4__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_5__2 
       (.I0(counter[6]),
        .O(\counter[8]_i_5__2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_6__2 
       (.I0(counter[5]),
        .O(\counter[8]_i_6__2_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\counter[0]_i_1__0_n_0 ),
        .Q(counter[0]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [8]),
        .Q(counter[10]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [9]),
        .Q(counter[11]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [10]),
        .Q(counter[12]));
  CARRY4 \counter_reg[12]_i_2 
       (.CI(\counter_reg[8]_i_2__2_n_0 ),
        .CO(\NLW_counter_reg[12]_i_2_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,counter[11:9]}),
        .O(O),
        .S({\counter[12]_i_4_n_0 ,\counter[12]_i_5__2_n_0 ,\counter[12]_i_6__2_n_0 ,\counter[12]_i_7__2_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\counter[1]_i_1_n_0 ),
        .Q(counter[1]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [0]),
        .Q(counter[2]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [1]),
        .Q(counter[3]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[4] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [2]),
        .Q(counter[4]));
  CARRY4 \counter_reg[4]_i_2__2 
       (.CI(1'b0),
        .CO({\counter_reg[4]_i_2__2_n_0 ,\NLW_counter_reg[4]_i_2__2_CO_UNCONNECTED [2:0]}),
        .CYINIT(counter[0]),
        .DI(counter[4:1]),
        .O({\counter_reg[4]_0 ,\counter_reg[4]_i_2__2_n_7 }),
        .S({\counter[4]_i_3__2_n_0 ,\counter[4]_i_4__2_n_0 ,\counter[4]_i_5__2_n_0 ,\counter[4]_i_6__2_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[5] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [3]),
        .Q(counter[5]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[6] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [4]),
        .Q(counter[6]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[7] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [5]),
        .Q(counter[7]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[8] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [6]),
        .Q(counter[8]));
  CARRY4 \counter_reg[8]_i_2__2 
       (.CI(\counter_reg[4]_i_2__2_n_0 ),
        .CO({\counter_reg[8]_i_2__2_n_0 ,\NLW_counter_reg[8]_i_2__2_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI(counter[8:5]),
        .O(\counter_reg[8]_0 ),
        .S({\counter[8]_i_3__2_n_0 ,\counter[8]_i_4__2_n_0 ,\counter[8]_i_5__2_n_0 ,\counter[8]_i_6__2_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(\internal_NR14_reg_reg[1] [7]),
        .Q(counter[9]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h6)) 
    frequency_timer_clock_i_1
       (.I0(frequency_timer_clock_reg_0),
        .I1(CLK),
        .O(frequency_timer_clock_i_1_n_0));
  FDCE #(
    .INIT(1'b0)) 
    frequency_timer_clock_reg
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .CLR(AR),
        .D(frequency_timer_clock_i_1_n_0),
        .Q(CLK));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[10] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[8]),
        .Q(Q[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[11] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[9]),
        .Q(Q[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[12] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[10]),
        .Q(frequency_timer_period_old[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[2] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[0]),
        .Q(frequency_timer_period_old[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[3] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[1]),
        .Q(Q[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[4] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[2]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[5] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[3]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[6] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[4]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[7] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[5]),
        .Q(Q[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[8] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[6]),
        .Q(Q[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \frequency_timer_period_old_reg[9] 
       (.C(\counter_reg[0]_0 ),
        .CE(1'b1),
        .D(D[7]),
        .Q(Q[6]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "frequency_timer" *) 
module frequency_timer_4
   (frequency_timer_clock,
    CLK,
    AR);
  output frequency_timer_clock;
  input CLK;
  input [0:0]AR;

  wire [0:0]AR;
  wire CLK;
  wire [12:0]counter;
  wire \counter[12]_i_2_n_0 ;
  wire \counter[12]_i_3__0_n_0 ;
  wire \counter[12]_i_5_n_0 ;
  wire \counter[12]_i_6_n_0 ;
  wire \counter[12]_i_7_n_0 ;
  wire \counter[12]_i_8_n_0 ;
  wire \counter[4]_i_3_n_0 ;
  wire \counter[4]_i_4_n_0 ;
  wire \counter[4]_i_5_n_0 ;
  wire \counter[4]_i_6_n_0 ;
  wire \counter[8]_i_3_n_0 ;
  wire \counter[8]_i_4_n_0 ;
  wire \counter[8]_i_5_n_0 ;
  wire \counter[8]_i_6_n_0 ;
  wire \counter_reg[12]_i_4_n_4 ;
  wire \counter_reg[12]_i_4_n_5 ;
  wire \counter_reg[12]_i_4_n_6 ;
  wire \counter_reg[12]_i_4_n_7 ;
  wire \counter_reg[4]_i_2_n_0 ;
  wire \counter_reg[4]_i_2_n_4 ;
  wire \counter_reg[4]_i_2_n_5 ;
  wire \counter_reg[4]_i_2_n_6 ;
  wire \counter_reg[4]_i_2_n_7 ;
  wire \counter_reg[8]_i_2_n_0 ;
  wire \counter_reg[8]_i_2_n_4 ;
  wire \counter_reg[8]_i_2_n_5 ;
  wire \counter_reg[8]_i_2_n_6 ;
  wire \counter_reg[8]_i_2_n_7 ;
  wire frequency_timer_clock;
  wire frequency_timer_clock_i_1__0_n_0;
  wire [12:0]p_2_in;
  wire [3:0]\NLW_counter_reg[12]_i_4_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[4]_i_2_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[8]_i_2_CO_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \counter[0]_i_1__1 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(counter[0]),
        .O(p_2_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[10]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[12]_i_4_n_6 ),
        .O(p_2_in[10]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[11]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[12]_i_4_n_5 ),
        .O(p_2_in[11]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[12]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[12]_i_4_n_4 ),
        .O(p_2_in[12]));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \counter[12]_i_2 
       (.I0(counter[10]),
        .I1(counter[9]),
        .I2(counter[11]),
        .I3(counter[12]),
        .I4(counter[7]),
        .I5(counter[8]),
        .O(\counter[12]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \counter[12]_i_3__0 
       (.I0(counter[0]),
        .I1(counter[2]),
        .I2(counter[3]),
        .I3(counter[4]),
        .I4(counter[5]),
        .I5(counter[6]),
        .O(\counter[12]_i_3__0_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_5 
       (.I0(counter[12]),
        .O(\counter[12]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_6 
       (.I0(counter[11]),
        .O(\counter[12]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_7 
       (.I0(counter[10]),
        .O(\counter[12]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[12]_i_8 
       (.I0(counter[9]),
        .O(\counter[12]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[1]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[4]_i_2_n_7 ),
        .O(p_2_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[2]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[4]_i_2_n_6 ),
        .O(p_2_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hFF20)) 
    \counter[3]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[4]_i_2_n_5 ),
        .O(p_2_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[4]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[4]_i_2_n_4 ),
        .O(p_2_in[4]));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_3 
       (.I0(counter[4]),
        .O(\counter[4]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_4 
       (.I0(counter[3]),
        .O(\counter[4]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_5 
       (.I0(counter[2]),
        .O(\counter[4]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[4]_i_6 
       (.I0(counter[1]),
        .O(\counter[4]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[5]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[8]_i_2_n_7 ),
        .O(p_2_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[6]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[8]_i_2_n_6 ),
        .O(p_2_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[7]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[8]_i_2_n_5 ),
        .O(p_2_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[8]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[8]_i_2_n_4 ),
        .O(p_2_in[8]));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_3 
       (.I0(counter[8]),
        .O(\counter[8]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_4 
       (.I0(counter[7]),
        .O(\counter[8]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_5 
       (.I0(counter[6]),
        .O(\counter[8]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[8]_i_6 
       (.I0(counter[5]),
        .O(\counter[8]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hDF00)) 
    \counter[9]_i_1__0 
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(\counter_reg[12]_i_4_n_7 ),
        .O(p_2_in[9]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[0]),
        .Q(counter[0]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[10]),
        .Q(counter[10]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[11]),
        .Q(counter[11]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[12]),
        .Q(counter[12]));
  CARRY4 \counter_reg[12]_i_4 
       (.CI(\counter_reg[8]_i_2_n_0 ),
        .CO(\NLW_counter_reg[12]_i_4_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,counter[11:9]}),
        .O({\counter_reg[12]_i_4_n_4 ,\counter_reg[12]_i_4_n_5 ,\counter_reg[12]_i_4_n_6 ,\counter_reg[12]_i_4_n_7 }),
        .S({\counter[12]_i_5_n_0 ,\counter[12]_i_6_n_0 ,\counter[12]_i_7_n_0 ,\counter[12]_i_8_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[1]),
        .Q(counter[1]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[2]),
        .Q(counter[2]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[3]),
        .Q(counter[3]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[4]),
        .Q(counter[4]));
  CARRY4 \counter_reg[4]_i_2 
       (.CI(1'b0),
        .CO({\counter_reg[4]_i_2_n_0 ,\NLW_counter_reg[4]_i_2_CO_UNCONNECTED [2:0]}),
        .CYINIT(counter[0]),
        .DI(counter[4:1]),
        .O({\counter_reg[4]_i_2_n_4 ,\counter_reg[4]_i_2_n_5 ,\counter_reg[4]_i_2_n_6 ,\counter_reg[4]_i_2_n_7 }),
        .S({\counter[4]_i_3_n_0 ,\counter[4]_i_4_n_0 ,\counter[4]_i_5_n_0 ,\counter[4]_i_6_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[5]),
        .Q(counter[5]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[6]),
        .Q(counter[6]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[7]),
        .Q(counter[7]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[8]),
        .Q(counter[8]));
  CARRY4 \counter_reg[8]_i_2 
       (.CI(\counter_reg[4]_i_2_n_0 ),
        .CO({\counter_reg[8]_i_2_n_0 ,\NLW_counter_reg[8]_i_2_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI(counter[8:5]),
        .O({\counter_reg[8]_i_2_n_4 ,\counter_reg[8]_i_2_n_5 ,\counter_reg[8]_i_2_n_6 ,\counter_reg[8]_i_2_n_7 }),
        .S({\counter[8]_i_3_n_0 ,\counter[8]_i_4_n_0 ,\counter[8]_i_5_n_0 ,\counter[8]_i_6_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(p_2_in[9]),
        .Q(counter[9]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hDF20)) 
    frequency_timer_clock_i_1__0
       (.I0(\counter[12]_i_2_n_0 ),
        .I1(counter[1]),
        .I2(\counter[12]_i_3__0_n_0 ),
        .I3(frequency_timer_clock),
        .O(frequency_timer_clock_i_1__0_n_0));
  FDCE #(
    .INIT(1'b0)) 
    frequency_timer_clock_reg
       (.C(CLK),
        .CE(1'b1),
        .CLR(AR),
        .D(frequency_timer_clock_i_1__0_n_0),
        .Q(frequency_timer_clock));
endmodule

module i2c
   (AC_SCK_OBUF,
    i2c_sda_t,
    CLK_48,
    i2c_sda_i);
  output AC_SCK_OBUF;
  output i2c_sda_t;
  input CLK_48;
  input i2c_sda_i;

  wire AC_SCK_OBUF;
  wire CLK_48;
  wire Inst_adau1761_configuraiton_data_n_10;
  wire Inst_adau1761_configuraiton_data_n_11;
  wire Inst_adau1761_configuraiton_data_n_12;
  wire Inst_adau1761_configuraiton_data_n_13;
  wire Inst_adau1761_configuraiton_data_n_14;
  wire Inst_adau1761_configuraiton_data_n_15;
  wire Inst_adau1761_configuraiton_data_n_16;
  wire Inst_adau1761_configuraiton_data_n_17;
  wire Inst_adau1761_configuraiton_data_n_18;
  wire Inst_adau1761_configuraiton_data_n_19;
  wire Inst_adau1761_configuraiton_data_n_20;
  wire Inst_adau1761_configuraiton_data_n_21;
  wire Inst_adau1761_configuraiton_data_n_22;
  wire Inst_adau1761_configuraiton_data_n_23;
  wire Inst_adau1761_configuraiton_data_n_24;
  wire Inst_adau1761_configuraiton_data_n_25;
  wire Inst_adau1761_configuraiton_data_n_26;
  wire Inst_adau1761_configuraiton_data_n_27;
  wire Inst_adau1761_configuraiton_data_n_28;
  wire Inst_adau1761_configuraiton_data_n_29;
  wire Inst_adau1761_configuraiton_data_n_30;
  wire Inst_adau1761_configuraiton_data_n_31;
  wire Inst_adau1761_configuraiton_data_n_32;
  wire Inst_adau1761_configuraiton_data_n_33;
  wire Inst_adau1761_configuraiton_data_n_34;
  wire Inst_adau1761_configuraiton_data_n_37;
  wire Inst_adau1761_configuraiton_data_n_9;
  wire Inst_i3c2_n_0;
  wire Inst_i3c2_n_10;
  wire Inst_i3c2_n_11;
  wire Inst_i3c2_n_12;
  wire Inst_i3c2_n_13;
  wire Inst_i3c2_n_14;
  wire Inst_i3c2_n_15;
  wire Inst_i3c2_n_16;
  wire Inst_i3c2_n_17;
  wire Inst_i3c2_n_18;
  wire Inst_i3c2_n_19;
  wire Inst_i3c2_n_20;
  wire Inst_i3c2_n_21;
  wire Inst_i3c2_n_22;
  wire Inst_i3c2_n_23;
  wire Inst_i3c2_n_24;
  wire Inst_i3c2_n_25;
  wire Inst_i3c2_n_26;
  wire Inst_i3c2_n_27;
  wire Inst_i3c2_n_28;
  wire Inst_i3c2_n_29;
  wire Inst_i3c2_n_30;
  wire Inst_i3c2_n_31;
  wire Inst_i3c2_n_32;
  wire Inst_i3c2_n_33;
  wire Inst_i3c2_n_34;
  wire Inst_i3c2_n_35;
  wire Inst_i3c2_n_36;
  wire Inst_i3c2_n_37;
  wire Inst_i3c2_n_4;
  wire Inst_i3c2_n_5;
  wire Inst_i3c2_n_6;
  wire Inst_i3c2_n_8;
  wire Inst_i3c2_n_9;
  wire ack_flag;
  wire [0:0]delay;
  wire i2c_sda_i;
  wire i2c_sda_t;
  wire [8:0]inst_data;
  wire [4:2]p_1_in;
  wire pwropt;
  wire pwropt_1;

  adau1761_configuraiton_data Inst_adau1761_configuraiton_data
       (.ADDRARDADDR({Inst_i3c2_n_26,Inst_i3c2_n_27,Inst_i3c2_n_28,Inst_i3c2_n_29,Inst_i3c2_n_30,Inst_i3c2_n_31,Inst_i3c2_n_32,Inst_i3c2_n_33,Inst_i3c2_n_34,Inst_i3c2_n_35}),
        .CLK_48(CLK_48),
        .D({Inst_adau1761_configuraiton_data_n_19,Inst_adau1761_configuraiton_data_n_20,Inst_adau1761_configuraiton_data_n_21,Inst_adau1761_configuraiton_data_n_22,Inst_adau1761_configuraiton_data_n_23,Inst_adau1761_configuraiton_data_n_24,Inst_adau1761_configuraiton_data_n_25,Inst_adau1761_configuraiton_data_n_26,Inst_adau1761_configuraiton_data_n_27,Inst_adau1761_configuraiton_data_n_28,Inst_adau1761_configuraiton_data_n_29,Inst_adau1761_configuraiton_data_n_30,Inst_adau1761_configuraiton_data_n_31,Inst_adau1761_configuraiton_data_n_32,Inst_adau1761_configuraiton_data_n_33,Inst_adau1761_configuraiton_data_n_34}),
        .DOADO(inst_data),
        .O({Inst_i3c2_n_12,Inst_i3c2_n_13,Inst_i3c2_n_14,Inst_i3c2_n_15}),
        .Q(Inst_i3c2_n_4),
        .ack_flag(ack_flag),
        .\bitcount_reg[0] (Inst_adau1761_configuraiton_data_n_9),
        .\delay_reg[0] (Inst_adau1761_configuraiton_data_n_14),
        .\delay_reg[0]_0 ({Inst_i3c2_n_8,Inst_i3c2_n_9,Inst_i3c2_n_10,Inst_i3c2_n_11}),
        .\delay_reg[0]_1 (delay),
        .\delay_reg[12] ({Inst_i3c2_n_16,Inst_i3c2_n_17,Inst_i3c2_n_18,Inst_i3c2_n_19}),
        .\delay_reg[14] ({Inst_i3c2_n_20,Inst_i3c2_n_21,Inst_i3c2_n_22}),
        .\i2c_data_reg[0] (Inst_adau1761_configuraiton_data_n_18),
        .\i2c_data_reg[2] (Inst_adau1761_configuraiton_data_n_17),
        .\i2c_data_reg[3] ({Inst_i3c2_n_36,Inst_i3c2_n_37}),
        .\i2c_data_reg[4] ({p_1_in[4],p_1_in[2]}),
        .\pcnext_reg_rep[3] (Inst_adau1761_configuraiton_data_n_11),
        .\pcnext_reg_rep[3]_0 (Inst_adau1761_configuraiton_data_n_16),
        .pwropt(pwropt),
        .pwropt_1(pwropt_1),
        .skip_reg(Inst_adau1761_configuraiton_data_n_12),
        .skip_reg_0(Inst_adau1761_configuraiton_data_n_13),
        .skip_reg_1(Inst_adau1761_configuraiton_data_n_15),
        .skip_reg_2(Inst_adau1761_configuraiton_data_n_37),
        .skip_reg_3(Inst_i3c2_n_5),
        .skip_reg_4(Inst_i3c2_n_0),
        .skip_reg_5(Inst_i3c2_n_23),
        .\state_reg[2] (Inst_adau1761_configuraiton_data_n_10),
        .\state_reg[2]_0 (Inst_i3c2_n_6),
        .\state_reg[2]_1 (Inst_i3c2_n_25),
        .\state_reg[3] (Inst_i3c2_n_24));
  i3c2 Inst_i3c2
       (.AC_SCK_OBUF(AC_SCK_OBUF),
        .ADDRARDADDR({Inst_i3c2_n_26,Inst_i3c2_n_27,Inst_i3c2_n_28,Inst_i3c2_n_29,Inst_i3c2_n_30,Inst_i3c2_n_31,Inst_i3c2_n_32,Inst_i3c2_n_33,Inst_i3c2_n_34,Inst_i3c2_n_35}),
        .CLK_48(CLK_48),
        .D({p_1_in[4],p_1_in[2]}),
        .DOADO(inst_data),
        .O({Inst_i3c2_n_12,Inst_i3c2_n_13,Inst_i3c2_n_14,Inst_i3c2_n_15}),
        .Q(Inst_i3c2_n_4),
        .ack_flag(ack_flag),
        .ack_flag_reg_0(Inst_adau1761_configuraiton_data_n_15),
        .\bitcount_reg[0]_0 (Inst_i3c2_n_23),
        .\bitcount_reg[0]_1 (Inst_i3c2_n_24),
        .data_reg(Inst_adau1761_configuraiton_data_n_16),
        .data_reg_0(Inst_adau1761_configuraiton_data_n_13),
        .data_reg_1(Inst_adau1761_configuraiton_data_n_37),
        .data_reg_2(Inst_adau1761_configuraiton_data_n_10),
        .data_reg_3(Inst_adau1761_configuraiton_data_n_12),
        .data_reg_4(Inst_adau1761_configuraiton_data_n_18),
        .data_reg_5(Inst_adau1761_configuraiton_data_n_9),
        .data_reg_6(Inst_adau1761_configuraiton_data_n_11),
        .data_reg_7(Inst_adau1761_configuraiton_data_n_17),
        .\delay_reg[0]_0 (delay),
        .\delay_reg[12]_0 ({Inst_i3c2_n_16,Inst_i3c2_n_17,Inst_i3c2_n_18,Inst_i3c2_n_19}),
        .\delay_reg[15]_0 ({Inst_i3c2_n_20,Inst_i3c2_n_21,Inst_i3c2_n_22}),
        .\delay_reg[4]_0 ({Inst_i3c2_n_8,Inst_i3c2_n_9,Inst_i3c2_n_10,Inst_i3c2_n_11}),
        .\i2c_data_reg[0]_0 (Inst_i3c2_n_25),
        .\i2c_data_reg[4]_0 ({Inst_i3c2_n_36,Inst_i3c2_n_37}),
        .i2c_sda_i(i2c_sda_i),
        .i2c_sda_t(i2c_sda_t),
        .pwropt(pwropt),
        .pwropt_1(pwropt_1),
        .skip_reg_0(Inst_i3c2_n_0),
        .skip_reg_1(Inst_i3c2_n_5),
        .skip_reg_2(Inst_i3c2_n_6),
        .skip_reg_3(Inst_adau1761_configuraiton_data_n_14),
        .\state_reg[0]_0 ({Inst_adau1761_configuraiton_data_n_19,Inst_adau1761_configuraiton_data_n_20,Inst_adau1761_configuraiton_data_n_21,Inst_adau1761_configuraiton_data_n_22,Inst_adau1761_configuraiton_data_n_23,Inst_adau1761_configuraiton_data_n_24,Inst_adau1761_configuraiton_data_n_25,Inst_adau1761_configuraiton_data_n_26,Inst_adau1761_configuraiton_data_n_27,Inst_adau1761_configuraiton_data_n_28,Inst_adau1761_configuraiton_data_n_29,Inst_adau1761_configuraiton_data_n_30,Inst_adau1761_configuraiton_data_n_31,Inst_adau1761_configuraiton_data_n_32,Inst_adau1761_configuraiton_data_n_33,Inst_adau1761_configuraiton_data_n_34}));
endmodule

module i2s_data_interface
   (\sr_out_reg[57]_0 ,
    AC_GPIO0,
    Q,
    CLK_48,
    AC_GPIO2_IBUF,
    AC_GPIO3_IBUF,
    D);
  output \sr_out_reg[57]_0 ;
  output AC_GPIO0;
  output [10:0]Q;
  input CLK_48;
  input AC_GPIO2_IBUF;
  input AC_GPIO3_IBUF;
  input [11:0]D;

  wire AC_GPIO0;
  wire AC_GPIO2_IBUF;
  wire AC_GPIO3_IBUF;
  wire CLK_48;
  wire [11:0]D;
  wire [10:0]Q;
  wire \bclk_delay_reg[1]__0_n_0 ;
  wire \bclk_delay_reg[2]_srl7_n_0 ;
  wire \bclk_delay_reg[9]__0_n_0 ;
  wire \bclk_delay_reg_n_0_[0] ;
  wire i2s_lr_last_i_1_n_0;
  wire [63:31]sr_out;
  wire \sr_out[39]_i_1_n_0 ;
  wire \sr_out[40]_i_1_n_0 ;
  wire \sr_out[41]_i_1_n_0 ;
  wire \sr_out[42]_i_1_n_0 ;
  wire \sr_out[43]_i_1_n_0 ;
  wire \sr_out[44]_i_1_n_0 ;
  wire \sr_out[45]_i_1_n_0 ;
  wire \sr_out[46]_i_1_n_0 ;
  wire \sr_out[47]_i_1_n_0 ;
  wire \sr_out[48]_i_1_n_0 ;
  wire \sr_out[49]_i_1_n_0 ;
  wire \sr_out[50]_i_1_n_0 ;
  wire \sr_out[51]_i_1_n_0 ;
  wire \sr_out[52]_i_1_n_0 ;
  wire \sr_out[53]_i_1_n_0 ;
  wire \sr_out[54]_i_1_n_0 ;
  wire \sr_out[55]_i_1_n_0 ;
  wire \sr_out[56]_i_1_n_0 ;
  wire \sr_out[57]_i_1_n_0 ;
  wire \sr_out_reg[57]_0 ;

  FDRE #(
    .INIT(1'b0)) 
    \bclk_delay_reg[0] 
       (.C(CLK_48),
        .CE(1'b1),
        .D(\bclk_delay_reg[1]__0_n_0 ),
        .Q(\bclk_delay_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \bclk_delay_reg[1]__0 
       (.C(CLK_48),
        .CE(1'b1),
        .D(\bclk_delay_reg[2]_srl7_n_0 ),
        .Q(\bclk_delay_reg[1]__0_n_0 ),
        .R(1'b0));
  (* srl_bus_name = "\top/Inst_adau1761_izedboard/Inst_i2s_data_interface/bclk_delay_reg " *) 
  (* srl_name = "\top/Inst_adau1761_izedboard/Inst_i2s_data_interface/bclk_delay_reg[2]_srl7 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \bclk_delay_reg[2]_srl7 
       (.A0(1'b0),
        .A1(1'b1),
        .A2(1'b1),
        .A3(1'b0),
        .CE(1'b1),
        .CLK(CLK_48),
        .D(\bclk_delay_reg[9]__0_n_0 ),
        .Q(\bclk_delay_reg[2]_srl7_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \bclk_delay_reg[9]__0 
       (.C(CLK_48),
        .CE(1'b1),
        .D(AC_GPIO2_IBUF),
        .Q(\bclk_delay_reg[9]__0_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    i2s_d_out_reg
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[63]),
        .Q(AC_GPIO0),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    i2s_lr_last_i_1
       (.I0(\bclk_delay_reg[1]__0_n_0 ),
        .I1(\bclk_delay_reg_n_0_[0] ),
        .O(i2s_lr_last_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    i2s_lr_last_reg
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(AC_GPIO3_IBUF),
        .Q(\sr_out_reg[57]_0 ),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h0400)) 
    \sr_out[39]_i_1 
       (.I0(\sr_out_reg[57]_0 ),
        .I1(AC_GPIO3_IBUF),
        .I2(\bclk_delay_reg_n_0_[0] ),
        .I3(\bclk_delay_reg[1]__0_n_0 ),
        .O(\sr_out[39]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[40]_i_1 
       (.I0(sr_out[39]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[40]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[41]_i_1 
       (.I0(sr_out[40]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[41]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[42]_i_1 
       (.I0(sr_out[41]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[42]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[43]_i_1 
       (.I0(sr_out[42]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[43]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[44]_i_1 
       (.I0(sr_out[43]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[44]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[45]_i_1 
       (.I0(sr_out[44]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[45]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[46]_i_1 
       (.I0(sr_out[45]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[46]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[47]_i_1 
       (.I0(sr_out[46]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[47]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[48]_i_1 
       (.I0(sr_out[47]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[48]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[49]_i_1 
       (.I0(sr_out[48]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[49]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[50]_i_1 
       (.I0(sr_out[49]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[50]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[51]_i_1 
       (.I0(sr_out[50]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[51]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[52]_i_1 
       (.I0(sr_out[51]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[52]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[53]_i_1 
       (.I0(sr_out[52]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[53]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[54]_i_1 
       (.I0(sr_out[53]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[54]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[55]_i_1 
       (.I0(sr_out[54]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[55]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[56]_i_1 
       (.I0(sr_out[55]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[56]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \sr_out[57]_i_1 
       (.I0(sr_out[56]),
        .I1(\sr_out_reg[57]_0 ),
        .I2(AC_GPIO3_IBUF),
        .O(\sr_out[57]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[26] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[0]),
        .Q(Q[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[27] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[1]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[28] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[2]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[29] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[3]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[30] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[4]),
        .Q(Q[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[31] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[5]),
        .Q(sr_out[31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[32] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[31]),
        .Q(sr_out[32]),
        .R(\sr_out[39]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[33] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[32]),
        .Q(sr_out[33]),
        .R(\sr_out[39]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[34] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[33]),
        .Q(sr_out[34]),
        .R(\sr_out[39]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[35] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[34]),
        .Q(sr_out[35]),
        .R(\sr_out[39]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[36] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[35]),
        .Q(sr_out[36]),
        .R(\sr_out[39]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[37] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[36]),
        .Q(sr_out[37]),
        .R(\sr_out[39]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[38] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[37]),
        .Q(sr_out[38]),
        .R(\sr_out[39]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[39] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(sr_out[38]),
        .Q(sr_out[39]),
        .R(\sr_out[39]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[40] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[40]_i_1_n_0 ),
        .Q(sr_out[40]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[41] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[41]_i_1_n_0 ),
        .Q(sr_out[41]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[42] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[42]_i_1_n_0 ),
        .Q(sr_out[42]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[43] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[43]_i_1_n_0 ),
        .Q(sr_out[43]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[44] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[44]_i_1_n_0 ),
        .Q(sr_out[44]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[45] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[45]_i_1_n_0 ),
        .Q(sr_out[45]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[46] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[46]_i_1_n_0 ),
        .Q(sr_out[46]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[47] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[47]_i_1_n_0 ),
        .Q(sr_out[47]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[48] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[48]_i_1_n_0 ),
        .Q(sr_out[48]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[49] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[49]_i_1_n_0 ),
        .Q(sr_out[49]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[50] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[50]_i_1_n_0 ),
        .Q(sr_out[50]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[51] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[51]_i_1_n_0 ),
        .Q(sr_out[51]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[52] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[52]_i_1_n_0 ),
        .Q(sr_out[52]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[53] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[53]_i_1_n_0 ),
        .Q(sr_out[53]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[54] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[54]_i_1_n_0 ),
        .Q(sr_out[54]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[55] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[55]_i_1_n_0 ),
        .Q(sr_out[55]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[56] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[56]_i_1_n_0 ),
        .Q(sr_out[56]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[57] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(\sr_out[57]_i_1_n_0 ),
        .Q(Q[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[58] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[6]),
        .Q(Q[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[59] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[7]),
        .Q(Q[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[60] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[8]),
        .Q(Q[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[61] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[9]),
        .Q(Q[9]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[62] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[10]),
        .Q(Q[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \sr_out_reg[63] 
       (.C(CLK_48),
        .CE(i2s_lr_last_i_1_n_0),
        .D(D[11]),
        .Q(sr_out[63]),
        .R(1'b0));
endmodule

module i3c2
   (skip_reg_0,
    ack_flag,
    AC_SCK_OBUF,
    i2c_sda_t,
    Q,
    skip_reg_1,
    skip_reg_2,
    \delay_reg[0]_0 ,
    \delay_reg[4]_0 ,
    O,
    \delay_reg[12]_0 ,
    \delay_reg[15]_0 ,
    \bitcount_reg[0]_0 ,
    \bitcount_reg[0]_1 ,
    \i2c_data_reg[0]_0 ,
    ADDRARDADDR,
    \i2c_data_reg[4]_0 ,
    ack_flag_reg_0,
    CLK_48,
    data_reg,
    DOADO,
    data_reg_0,
    data_reg_1,
    data_reg_2,
    data_reg_3,
    data_reg_4,
    data_reg_5,
    skip_reg_3,
    data_reg_6,
    D,
    data_reg_7,
    i2c_sda_i,
    \state_reg[0]_0 ,
    pwropt,
    pwropt_1);
  output skip_reg_0;
  output ack_flag;
  output AC_SCK_OBUF;
  output i2c_sda_t;
  output [0:0]Q;
  output skip_reg_1;
  output skip_reg_2;
  output [0:0]\delay_reg[0]_0 ;
  output [3:0]\delay_reg[4]_0 ;
  output [3:0]O;
  output [3:0]\delay_reg[12]_0 ;
  output [2:0]\delay_reg[15]_0 ;
  output \bitcount_reg[0]_0 ;
  output \bitcount_reg[0]_1 ;
  output \i2c_data_reg[0]_0 ;
  output [9:0]ADDRARDADDR;
  output [1:0]\i2c_data_reg[4]_0 ;
  input ack_flag_reg_0;
  input CLK_48;
  input data_reg;
  input [8:0]DOADO;
  input data_reg_0;
  input data_reg_1;
  input data_reg_2;
  input data_reg_3;
  input data_reg_4;
  input data_reg_5;
  input skip_reg_3;
  input data_reg_6;
  input [1:0]D;
  input data_reg_7;
  input i2c_sda_i;
  input [15:0]\state_reg[0]_0 ;
  output pwropt;
  output pwropt_1;

  wire AC_SCK_OBUF;
  wire [9:0]ADDRARDADDR;
  wire CLK_48;
  wire [1:0]D;
  wire [8:0]DOADO;
  wire [3:0]O;
  wire [0:0]Q;
  wire ack_flag;
  wire ack_flag_i_1_n_0;
  wire ack_flag_i_2_n_0;
  wire ack_flag_reg_0;
  wire [7:0]bitcount;
  wire \bitcount[0]_i_1_n_0 ;
  wire \bitcount[1]_i_1_n_0 ;
  wire \bitcount[2]_i_1_n_0 ;
  wire \bitcount[2]_i_2_n_0 ;
  wire \bitcount[2]_i_3_n_0 ;
  wire \bitcount[3]_i_1_n_0 ;
  wire \bitcount[3]_i_2_n_0 ;
  wire \bitcount[4]_i_1_n_0 ;
  wire \bitcount[4]_i_2_n_0 ;
  wire \bitcount[5]_i_1_n_0 ;
  wire \bitcount[5]_i_2_n_0 ;
  wire \bitcount[6]_i_1_n_0 ;
  wire \bitcount[6]_i_2_n_0 ;
  wire \bitcount[6]_i_3_n_0 ;
  wire \bitcount[7]_i_1_n_0 ;
  wire \bitcount[7]_i_2_n_0 ;
  wire \bitcount[7]_i_3_n_0 ;
  wire \bitcount[7]_i_5_n_0 ;
  wire \bitcount[7]_i_6_n_0 ;
  wire \bitcount_reg[0]_0 ;
  wire \bitcount_reg[0]_1 ;
  wire data0;
  wire data_reg;
  wire data_reg_0;
  wire data_reg_1;
  wire data_reg_2;
  wire data_reg_3;
  wire data_reg_4;
  wire data_reg_5;
  wire data_reg_6;
  wire data_reg_7;
  wire [15:1]delay;
  wire \delay[12]_i_3_n_0 ;
  wire \delay[12]_i_4_n_0 ;
  wire \delay[12]_i_5_n_0 ;
  wire \delay[12]_i_6_n_0 ;
  wire \delay[15]_i_10_n_0 ;
  wire \delay[15]_i_1_n_0 ;
  wire \delay[15]_i_4_n_0 ;
  wire \delay[15]_i_6_n_0 ;
  wire \delay[15]_i_7_n_0 ;
  wire \delay[15]_i_8_n_0 ;
  wire \delay[15]_i_9_n_0 ;
  wire \delay[4]_i_3_n_0 ;
  wire \delay[4]_i_4_n_0 ;
  wire \delay[4]_i_5_n_0 ;
  wire \delay[4]_i_6_n_0 ;
  wire \delay[8]_i_3_n_0 ;
  wire \delay[8]_i_4_n_0 ;
  wire \delay[8]_i_5_n_0 ;
  wire \delay[8]_i_6_n_0 ;
  wire [0:0]\delay_reg[0]_0 ;
  wire [3:0]\delay_reg[12]_0 ;
  wire \delay_reg[12]_i_2_n_0 ;
  wire [2:0]\delay_reg[15]_0 ;
  wire [3:0]\delay_reg[4]_0 ;
  wire \delay_reg[4]_i_2_n_0 ;
  wire \delay_reg[8]_i_2_n_0 ;
  wire \i2c_bits_left[0]_i_1_n_0 ;
  wire \i2c_bits_left[1]_i_1_n_0 ;
  wire \i2c_bits_left[2]_i_1_n_0 ;
  wire \i2c_bits_left[3]_i_1_n_0 ;
  wire \i2c_bits_left[3]_i_2_n_0 ;
  wire \i2c_bits_left[3]_i_4_n_0 ;
  wire \i2c_bits_left[3]_i_5_n_0 ;
  wire \i2c_bits_left_reg_n_0_[0] ;
  wire \i2c_bits_left_reg_n_0_[1] ;
  wire \i2c_bits_left_reg_n_0_[2] ;
  wire \i2c_bits_left_reg_n_0_[3] ;
  wire \i2c_data[0]_i_1_n_0 ;
  wire \i2c_data[0]_i_2_n_0 ;
  wire \i2c_data[8]_i_1_n_0 ;
  wire \i2c_data[8]_i_3_n_0 ;
  wire \i2c_data[8]_i_4_n_0 ;
  wire \i2c_data[8]_i_5_n_0 ;
  wire \i2c_data_reg[0]_0 ;
  wire [1:0]\i2c_data_reg[4]_0 ;
  wire \i2c_data_reg_n_0_[0] ;
  wire \i2c_data_reg_n_0_[2] ;
  wire \i2c_data_reg_n_0_[4] ;
  wire \i2c_data_reg_n_0_[5] ;
  wire \i2c_data_reg_n_0_[6] ;
  wire \i2c_data_reg_n_0_[7] ;
  wire i2c_scl_i_1_n_0;
  wire i2c_scl_i_2_n_0;
  wire i2c_sda_i;
  wire i2c_sda_t;
  wire i2c_sda_t_i_10_n_0;
  wire i2c_sda_t_i_1_n_0;
  wire i2c_sda_t_i_2_n_0;
  wire i2c_sda_t_i_3_n_0;
  wire i2c_sda_t_i_4_n_0;
  wire i2c_sda_t_i_5_n_0;
  wire i2c_sda_t_i_6_n_0;
  wire i2c_sda_t_i_7_n_0;
  wire i2c_sda_t_i_8_n_0;
  wire i2c_sda_t_i_9_n_0;
  wire i2c_started;
  wire i2c_started_i_1_n_0;
  wire [8:1]p_1_in;
  wire [9:0]pcnext;
  wire \pcnext[0]_i_1_n_0 ;
  wire \pcnext[1]_i_1_n_0 ;
  wire \pcnext[2]_i_1_n_0 ;
  wire \pcnext[2]_i_2_n_0 ;
  wire \pcnext[2]_i_3_n_0 ;
  wire \pcnext[2]_i_5_n_0 ;
  wire \pcnext[2]_i_6_n_0 ;
  wire \pcnext[2]_i_7_n_0 ;
  wire \pcnext[3]_i_1_n_0 ;
  wire \pcnext[3]_i_2_n_0 ;
  wire \pcnext[4]_i_1_n_0 ;
  wire \pcnext[4]_i_2_n_0 ;
  wire \pcnext[5]_i_1_n_0 ;
  wire \pcnext[5]_i_2_n_0 ;
  wire \pcnext[6]_i_1_n_0 ;
  wire \pcnext[7]_i_1_n_0 ;
  wire \pcnext[7]_i_2_n_0 ;
  wire \pcnext[8]_i_1_n_0 ;
  wire \pcnext[9]_i_1_n_0 ;
  wire \pcnext[9]_i_2_n_0 ;
  wire \pcnext[9]_i_3_n_0 ;
  wire \pcnext[9]_i_4_n_0 ;
  wire \pcnext[9]_i_5_n_0 ;
  wire \pcnext[9]_i_6_n_0 ;
  wire skip_i_12_n_0;
  wire skip_reg_0;
  wire skip_reg_1;
  wire skip_reg_2;
  wire skip_reg_3;
  wire \state[0]_i_1_n_0 ;
  wire \state[0]_i_2_n_0 ;
  wire \state[1]_i_1_n_0 ;
  wire \state[2]_i_1_n_0 ;
  wire \state[2]_i_4_n_0 ;
  wire \state[3]_i_1_n_0 ;
  wire \state[3]_i_2_n_0 ;
  wire \state[3]_i_4_n_0 ;
  wire \state[3]_i_6_n_0 ;
  wire [15:0]\state_reg[0]_0 ;
  wire \state_reg_n_0_[1] ;
  wire \state_reg_n_0_[2] ;
  wire \state_reg_n_0_[3] ;
  wire [2:0]\NLW_delay_reg[12]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_delay_reg[15]_i_5_CO_UNCONNECTED ;
  wire [3:3]\NLW_delay_reg[15]_i_5_O_UNCONNECTED ;
  wire [2:0]\NLW_delay_reg[4]_i_2_CO_UNCONNECTED ;
  wire [2:0]\NLW_delay_reg[8]_i_2_CO_UNCONNECTED ;

  assign pwropt = \pcnext[2]_i_1_n_0 ;
  assign pwropt_1 = \pcnext[9]_i_1_n_0 ;
  LUT5 #(
    .INIT(32'hFFF70004)) 
    ack_flag_i_1
       (.I0(\i2c_data_reg_n_0_[0] ),
        .I1(ack_flag_i_2_n_0),
        .I2(\state_reg_n_0_[2] ),
        .I3(\state_reg_n_0_[3] ),
        .I4(ack_flag),
        .O(ack_flag_i_1_n_0));
  LUT4 #(
    .INIT(16'h8000)) 
    ack_flag_i_2
       (.I0(\bitcount[7]_i_6_n_0 ),
        .I1(\i2c_bits_left[3]_i_5_n_0 ),
        .I2(Q),
        .I3(\state_reg_n_0_[1] ),
        .O(ack_flag_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    ack_flag_reg
       (.C(CLK_48),
        .CE(1'b1),
        .D(ack_flag_i_1_n_0),
        .Q(ack_flag),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h000000FE)) 
    \bitcount[0]_i_1 
       (.I0(Q),
        .I1(\state_reg_n_0_[1] ),
        .I2(\state_reg_n_0_[2] ),
        .I3(\bitcount[2]_i_2_n_0 ),
        .I4(bitcount[0]),
        .O(\bitcount[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFEFE0000000000FE)) 
    \bitcount[1]_i_1 
       (.I0(Q),
        .I1(\state_reg_n_0_[1] ),
        .I2(\state_reg_n_0_[2] ),
        .I3(\bitcount[2]_i_2_n_0 ),
        .I4(bitcount[0]),
        .I5(bitcount[1]),
        .O(\bitcount[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h10101001)) 
    \bitcount[2]_i_1 
       (.I0(\bitcount[6]_i_3_n_0 ),
        .I1(\bitcount[2]_i_2_n_0 ),
        .I2(bitcount[2]),
        .I3(bitcount[0]),
        .I4(bitcount[1]),
        .O(\bitcount[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \bitcount[2]_i_2 
       (.I0(bitcount[3]),
        .I1(\bitcount[2]_i_3_n_0 ),
        .I2(bitcount[7]),
        .I3(bitcount[6]),
        .I4(bitcount[4]),
        .I5(bitcount[5]),
        .O(\bitcount[2]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hEF)) 
    \bitcount[2]_i_3 
       (.I0(bitcount[2]),
        .I1(bitcount[1]),
        .I2(\state_reg_n_0_[1] ),
        .O(\bitcount[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h9999009F9999999F)) 
    \bitcount[3]_i_1 
       (.I0(bitcount[3]),
        .I1(\bitcount[3]_i_2_n_0 ),
        .I2(\state_reg_n_0_[2] ),
        .I3(Q),
        .I4(\state_reg_n_0_[1] ),
        .I5(\bitcount[7]_i_6_n_0 ),
        .O(\bitcount[3]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \bitcount[3]_i_2 
       (.I0(bitcount[2]),
        .I1(bitcount[0]),
        .I2(bitcount[1]),
        .O(\bitcount[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFEAAAAAAAB)) 
    \bitcount[4]_i_1 
       (.I0(\bitcount[4]_i_2_n_0 ),
        .I1(bitcount[3]),
        .I2(bitcount[1]),
        .I3(bitcount[0]),
        .I4(bitcount[2]),
        .I5(bitcount[4]),
        .O(\bitcount[4]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h1011)) 
    \bitcount[4]_i_2 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg_n_0_[1] ),
        .I2(\bitcount[7]_i_6_n_0 ),
        .I3(Q),
        .O(\bitcount[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFD0D0D0D0FF)) 
    \bitcount[5]_i_1 
       (.I0(Q),
        .I1(\bitcount[7]_i_6_n_0 ),
        .I2(\bitcount[5]_i_2_n_0 ),
        .I3(bitcount[4]),
        .I4(\bitcount[6]_i_2_n_0 ),
        .I5(bitcount[5]),
        .O(\bitcount[5]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \bitcount[5]_i_2 
       (.I0(\state_reg_n_0_[1] ),
        .I1(\state_reg_n_0_[2] ),
        .O(\bitcount[5]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFAAA9)) 
    \bitcount[6]_i_1 
       (.I0(bitcount[6]),
        .I1(bitcount[5]),
        .I2(bitcount[4]),
        .I3(\bitcount[6]_i_2_n_0 ),
        .I4(\bitcount[6]_i_3_n_0 ),
        .O(\bitcount[6]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \bitcount[6]_i_2 
       (.I0(bitcount[3]),
        .I1(bitcount[1]),
        .I2(bitcount[0]),
        .I3(bitcount[2]),
        .O(\bitcount[6]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h01)) 
    \bitcount[6]_i_3 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg_n_0_[1] ),
        .I2(Q),
        .O(\bitcount[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFF888888FF8F8888)) 
    \bitcount[7]_i_1 
       (.I0(\pcnext[9]_i_3_n_0 ),
        .I1(\bitcount[7]_i_3_n_0 ),
        .I2(\bitcount_reg[0]_0 ),
        .I3(\pcnext[2]_i_5_n_0 ),
        .I4(\bitcount_reg[0]_1 ),
        .I5(data_reg_5),
        .O(\bitcount[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8888FF8888880080)) 
    \bitcount[7]_i_2 
       (.I0(bitcount[7]),
        .I1(\bitcount[7]_i_5_n_0 ),
        .I2(Q),
        .I3(\bitcount[7]_i_6_n_0 ),
        .I4(\state_reg_n_0_[1] ),
        .I5(\state_reg_n_0_[2] ),
        .O(\bitcount[7]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h01)) 
    \bitcount[7]_i_3 
       (.I0(\bitcount[7]_i_6_n_0 ),
        .I1(Q),
        .I2(\state_reg_n_0_[3] ),
        .O(\bitcount[7]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \bitcount[7]_i_4 
       (.I0(\state_reg_n_0_[3] ),
        .I1(\state_reg_n_0_[2] ),
        .O(\bitcount_reg[0]_1 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \bitcount[7]_i_5 
       (.I0(bitcount[6]),
        .I1(bitcount[5]),
        .I2(bitcount[4]),
        .I3(\bitcount[6]_i_2_n_0 ),
        .O(\bitcount[7]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \bitcount[7]_i_6 
       (.I0(\bitcount[6]_i_2_n_0 ),
        .I1(bitcount[5]),
        .I2(bitcount[4]),
        .I3(bitcount[6]),
        .I4(bitcount[7]),
        .O(\bitcount[7]_i_6_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \bitcount_reg[0] 
       (.C(CLK_48),
        .CE(\bitcount[7]_i_1_n_0 ),
        .D(\bitcount[0]_i_1_n_0 ),
        .Q(bitcount[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \bitcount_reg[1] 
       (.C(CLK_48),
        .CE(\bitcount[7]_i_1_n_0 ),
        .D(\bitcount[1]_i_1_n_0 ),
        .Q(bitcount[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \bitcount_reg[2] 
       (.C(CLK_48),
        .CE(\bitcount[7]_i_1_n_0 ),
        .D(\bitcount[2]_i_1_n_0 ),
        .Q(bitcount[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \bitcount_reg[3] 
       (.C(CLK_48),
        .CE(\bitcount[7]_i_1_n_0 ),
        .D(\bitcount[3]_i_1_n_0 ),
        .Q(bitcount[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \bitcount_reg[4] 
       (.C(CLK_48),
        .CE(\bitcount[7]_i_1_n_0 ),
        .D(\bitcount[4]_i_1_n_0 ),
        .Q(bitcount[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \bitcount_reg[5] 
       (.C(CLK_48),
        .CE(\bitcount[7]_i_1_n_0 ),
        .D(\bitcount[5]_i_1_n_0 ),
        .Q(bitcount[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \bitcount_reg[6] 
       (.C(CLK_48),
        .CE(\bitcount[7]_i_1_n_0 ),
        .D(\bitcount[6]_i_1_n_0 ),
        .Q(bitcount[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \bitcount_reg[7] 
       (.C(CLK_48),
        .CE(\bitcount[7]_i_1_n_0 ),
        .D(\bitcount[7]_i_2_n_0 ),
        .Q(bitcount[7]),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[12]_i_3 
       (.I0(delay[12]),
        .O(\delay[12]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[12]_i_4 
       (.I0(delay[11]),
        .O(\delay[12]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[12]_i_5 
       (.I0(delay[10]),
        .O(\delay[12]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[12]_i_6 
       (.I0(delay[9]),
        .O(\delay[12]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00000000E2220000)) 
    \delay[15]_i_1 
       (.I0(skip_reg_3),
        .I1(Q),
        .I2(\bitcount[7]_i_6_n_0 ),
        .I3(\delay[15]_i_4_n_0 ),
        .I4(\bitcount_reg[0]_1 ),
        .I5(\state_reg_n_0_[1] ),
        .O(\delay[15]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[15]_i_10 
       (.I0(delay[13]),
        .O(\delay[15]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \delay[15]_i_4 
       (.I0(delay[7]),
        .I1(delay[15]),
        .I2(delay[10]),
        .I3(delay[13]),
        .I4(\delay[15]_i_6_n_0 ),
        .I5(\delay[15]_i_7_n_0 ),
        .O(\delay[15]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \delay[15]_i_6 
       (.I0(delay[1]),
        .I1(\delay_reg[0]_0 ),
        .I2(delay[8]),
        .I3(delay[5]),
        .I4(delay[11]),
        .I5(delay[2]),
        .O(\delay[15]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \delay[15]_i_7 
       (.I0(delay[9]),
        .I1(delay[14]),
        .I2(delay[3]),
        .I3(delay[4]),
        .I4(delay[12]),
        .I5(delay[6]),
        .O(\delay[15]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[15]_i_8 
       (.I0(delay[15]),
        .O(\delay[15]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[15]_i_9 
       (.I0(delay[14]),
        .O(\delay[15]_i_9_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[4]_i_3 
       (.I0(delay[4]),
        .O(\delay[4]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[4]_i_4 
       (.I0(delay[3]),
        .O(\delay[4]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[4]_i_5 
       (.I0(delay[2]),
        .O(\delay[4]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[4]_i_6 
       (.I0(delay[1]),
        .O(\delay[4]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[8]_i_3 
       (.I0(delay[8]),
        .O(\delay[8]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[8]_i_4 
       (.I0(delay[7]),
        .O(\delay[8]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[8]_i_5 
       (.I0(delay[6]),
        .O(\delay[8]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \delay[8]_i_6 
       (.I0(delay[5]),
        .O(\delay[8]_i_6_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[0] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [0]),
        .Q(\delay_reg[0]_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[10] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [10]),
        .Q(delay[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[11] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [11]),
        .Q(delay[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[12] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [12]),
        .Q(delay[12]),
        .R(1'b0));
  CARRY4 \delay_reg[12]_i_2 
       (.CI(\delay_reg[8]_i_2_n_0 ),
        .CO({\delay_reg[12]_i_2_n_0 ,\NLW_delay_reg[12]_i_2_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI(delay[12:9]),
        .O(\delay_reg[12]_0 ),
        .S({\delay[12]_i_3_n_0 ,\delay[12]_i_4_n_0 ,\delay[12]_i_5_n_0 ,\delay[12]_i_6_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[13] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [13]),
        .Q(delay[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[14] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [14]),
        .Q(delay[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[15] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [15]),
        .Q(delay[15]),
        .R(1'b0));
  CARRY4 \delay_reg[15]_i_5 
       (.CI(\delay_reg[12]_i_2_n_0 ),
        .CO(\NLW_delay_reg[15]_i_5_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,delay[14:13]}),
        .O({\NLW_delay_reg[15]_i_5_O_UNCONNECTED [3],\delay_reg[15]_0 }),
        .S({1'b0,\delay[15]_i_8_n_0 ,\delay[15]_i_9_n_0 ,\delay[15]_i_10_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[1] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [1]),
        .Q(delay[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[2] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [2]),
        .Q(delay[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[3] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [3]),
        .Q(delay[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[4] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [4]),
        .Q(delay[4]),
        .R(1'b0));
  CARRY4 \delay_reg[4]_i_2 
       (.CI(1'b0),
        .CO({\delay_reg[4]_i_2_n_0 ,\NLW_delay_reg[4]_i_2_CO_UNCONNECTED [2:0]}),
        .CYINIT(\delay_reg[0]_0 ),
        .DI(delay[4:1]),
        .O(\delay_reg[4]_0 ),
        .S({\delay[4]_i_3_n_0 ,\delay[4]_i_4_n_0 ,\delay[4]_i_5_n_0 ,\delay[4]_i_6_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[5] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [5]),
        .Q(delay[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[6] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [6]),
        .Q(delay[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[7] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [7]),
        .Q(delay[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[8] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [8]),
        .Q(delay[8]),
        .R(1'b0));
  CARRY4 \delay_reg[8]_i_2 
       (.CI(\delay_reg[4]_i_2_n_0 ),
        .CO({\delay_reg[8]_i_2_n_0 ,\NLW_delay_reg[8]_i_2_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI(delay[8:5]),
        .O(O),
        .S({\delay[8]_i_3_n_0 ,\delay[8]_i_4_n_0 ,\delay[8]_i_5_n_0 ,\delay[8]_i_6_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \delay_reg[9] 
       (.C(CLK_48),
        .CE(\delay[15]_i_1_n_0 ),
        .D(\state_reg[0]_0 [9]),
        .Q(delay[9]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \i2c_bits_left[0]_i_1 
       (.I0(\state_reg_n_0_[1] ),
        .I1(\i2c_bits_left_reg_n_0_[0] ),
        .O(\i2c_bits_left[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h82)) 
    \i2c_bits_left[1]_i_1 
       (.I0(\state_reg_n_0_[1] ),
        .I1(\i2c_bits_left_reg_n_0_[1] ),
        .I2(\i2c_bits_left_reg_n_0_[0] ),
        .O(\i2c_bits_left[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT4 #(
    .INIT(16'hE100)) 
    \i2c_bits_left[2]_i_1 
       (.I0(\i2c_bits_left_reg_n_0_[0] ),
        .I1(\i2c_bits_left_reg_n_0_[1] ),
        .I2(\i2c_bits_left_reg_n_0_[2] ),
        .I3(\state_reg_n_0_[1] ),
        .O(\i2c_bits_left[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000C000C0008AAAA)) 
    \i2c_bits_left[3]_i_1 
       (.I0(data_reg_4),
        .I1(\bitcount[7]_i_6_n_0 ),
        .I2(\i2c_bits_left[3]_i_4_n_0 ),
        .I3(\i2c_bits_left[3]_i_5_n_0 ),
        .I4(\state_reg_n_0_[3] ),
        .I5(Q),
        .O(\i2c_bits_left[3]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFE01FFFF)) 
    \i2c_bits_left[3]_i_2 
       (.I0(\i2c_bits_left_reg_n_0_[1] ),
        .I1(\i2c_bits_left_reg_n_0_[0] ),
        .I2(\i2c_bits_left_reg_n_0_[2] ),
        .I3(\i2c_bits_left_reg_n_0_[3] ),
        .I4(Q),
        .O(\i2c_bits_left[3]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hFD)) 
    \i2c_bits_left[3]_i_4 
       (.I0(\state_reg_n_0_[1] ),
        .I1(\state_reg_n_0_[2] ),
        .I2(\state_reg_n_0_[3] ),
        .O(\i2c_bits_left[3]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \i2c_bits_left[3]_i_5 
       (.I0(\i2c_bits_left_reg_n_0_[2] ),
        .I1(\i2c_bits_left_reg_n_0_[0] ),
        .I2(\i2c_bits_left_reg_n_0_[1] ),
        .I3(\i2c_bits_left_reg_n_0_[3] ),
        .O(\i2c_bits_left[3]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h01)) 
    \i2c_bits_left[3]_i_6 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg_n_0_[1] ),
        .I2(skip_reg_0),
        .O(\i2c_data_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_bits_left_reg[0] 
       (.C(CLK_48),
        .CE(\i2c_bits_left[3]_i_1_n_0 ),
        .D(\i2c_bits_left[0]_i_1_n_0 ),
        .Q(\i2c_bits_left_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_bits_left_reg[1] 
       (.C(CLK_48),
        .CE(\i2c_bits_left[3]_i_1_n_0 ),
        .D(\i2c_bits_left[1]_i_1_n_0 ),
        .Q(\i2c_bits_left_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_bits_left_reg[2] 
       (.C(CLK_48),
        .CE(\i2c_bits_left[3]_i_1_n_0 ),
        .D(\i2c_bits_left[2]_i_1_n_0 ),
        .Q(\i2c_bits_left_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_bits_left_reg[3] 
       (.C(CLK_48),
        .CE(\i2c_bits_left[3]_i_1_n_0 ),
        .D(\i2c_bits_left[3]_i_2_n_0 ),
        .Q(\i2c_bits_left_reg_n_0_[3] ),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hAACFAACA)) 
    \i2c_data[0]_i_1 
       (.I0(\i2c_data_reg_n_0_[0] ),
        .I1(i2c_sda_i),
        .I2(Q),
        .I3(\i2c_data[0]_i_2_n_0 ),
        .I4(data_reg_4),
        .O(\i2c_data[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFAAFF2A)) 
    \i2c_data[0]_i_2 
       (.I0(Q),
        .I1(\state_reg_n_0_[1] ),
        .I2(\i2c_data[8]_i_3_n_0 ),
        .I3(\state_reg_n_0_[3] ),
        .I4(\state_reg_n_0_[2] ),
        .O(\i2c_data[0]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hB8BB)) 
    \i2c_data[1]_i_1 
       (.I0(\i2c_data_reg_n_0_[0] ),
        .I1(Q),
        .I2(DOADO[0]),
        .I3(data_reg_7),
        .O(p_1_in[1]));
  LUT4 #(
    .INIT(16'hB8BB)) 
    \i2c_data[3]_i_1 
       (.I0(\i2c_data_reg_n_0_[2] ),
        .I1(Q),
        .I2(DOADO[2]),
        .I3(data_reg_7),
        .O(p_1_in[3]));
  LUT4 #(
    .INIT(16'hB8BB)) 
    \i2c_data[5]_i_1 
       (.I0(\i2c_data_reg_n_0_[4] ),
        .I1(Q),
        .I2(DOADO[4]),
        .I3(data_reg_7),
        .O(p_1_in[5]));
  LUT4 #(
    .INIT(16'hB8BB)) 
    \i2c_data[6]_i_1 
       (.I0(\i2c_data_reg_n_0_[5] ),
        .I1(Q),
        .I2(DOADO[5]),
        .I3(data_reg_7),
        .O(p_1_in[6]));
  LUT4 #(
    .INIT(16'hB8BB)) 
    \i2c_data[7]_i_1 
       (.I0(\i2c_data_reg_n_0_[6] ),
        .I1(Q),
        .I2(DOADO[6]),
        .I3(data_reg_7),
        .O(p_1_in[7]));
  LUT6 #(
    .INIT(64'h030000000A0A0A0A)) 
    \i2c_data[8]_i_1 
       (.I0(data_reg_4),
        .I1(\state_reg_n_0_[2] ),
        .I2(\state_reg_n_0_[3] ),
        .I3(\i2c_data[8]_i_3_n_0 ),
        .I4(\state_reg_n_0_[1] ),
        .I5(Q),
        .O(\i2c_data[8]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hB8BB)) 
    \i2c_data[8]_i_2 
       (.I0(\i2c_data_reg_n_0_[7] ),
        .I1(Q),
        .I2(DOADO[7]),
        .I3(DOADO[8]),
        .O(p_1_in[8]));
  LUT6 #(
    .INIT(64'h0000000000008000)) 
    \i2c_data[8]_i_3 
       (.I0(bitcount[2]),
        .I1(bitcount[4]),
        .I2(bitcount[5]),
        .I3(bitcount[3]),
        .I4(\i2c_data[8]_i_4_n_0 ),
        .I5(\i2c_data[8]_i_5_n_0 ),
        .O(\i2c_data[8]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \i2c_data[8]_i_4 
       (.I0(bitcount[6]),
        .I1(bitcount[7]),
        .O(\i2c_data[8]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \i2c_data[8]_i_5 
       (.I0(bitcount[1]),
        .I1(bitcount[0]),
        .O(\i2c_data[8]_i_5_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[0] 
       (.C(CLK_48),
        .CE(1'b1),
        .D(\i2c_data[0]_i_1_n_0 ),
        .Q(\i2c_data_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[1] 
       (.C(CLK_48),
        .CE(\i2c_data[8]_i_1_n_0 ),
        .D(p_1_in[1]),
        .Q(\i2c_data_reg[4]_0 [0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[2] 
       (.C(CLK_48),
        .CE(\i2c_data[8]_i_1_n_0 ),
        .D(D[0]),
        .Q(\i2c_data_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[3] 
       (.C(CLK_48),
        .CE(\i2c_data[8]_i_1_n_0 ),
        .D(p_1_in[3]),
        .Q(\i2c_data_reg[4]_0 [1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[4] 
       (.C(CLK_48),
        .CE(\i2c_data[8]_i_1_n_0 ),
        .D(D[1]),
        .Q(\i2c_data_reg_n_0_[4] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[5] 
       (.C(CLK_48),
        .CE(\i2c_data[8]_i_1_n_0 ),
        .D(p_1_in[5]),
        .Q(\i2c_data_reg_n_0_[5] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[6] 
       (.C(CLK_48),
        .CE(\i2c_data[8]_i_1_n_0 ),
        .D(p_1_in[6]),
        .Q(\i2c_data_reg_n_0_[6] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[7] 
       (.C(CLK_48),
        .CE(\i2c_data[8]_i_1_n_0 ),
        .D(p_1_in[7]),
        .Q(\i2c_data_reg_n_0_[7] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i2c_data_reg[8] 
       (.C(CLK_48),
        .CE(\i2c_data[8]_i_1_n_0 ),
        .D(p_1_in[8]),
        .Q(data0),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hEEFFFFFF00301030)) 
    i2c_scl_i_1
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg_n_0_[3] ),
        .I2(i2c_scl_i_2_n_0),
        .I3(\state_reg_n_0_[1] ),
        .I4(\bitcount[7]_i_6_n_0 ),
        .I5(AC_SCK_OBUF),
        .O(i2c_scl_i_1_n_0));
  LUT4 #(
    .INIT(16'hBA22)) 
    i2c_scl_i_2
       (.I0(\state_reg_n_0_[1] ),
        .I1(Q),
        .I2(\state_reg_n_0_[2] ),
        .I3(\i2c_data[8]_i_3_n_0 ),
        .O(i2c_scl_i_2_n_0));
  FDRE #(
    .INIT(1'b1)) 
    i2c_scl_reg
       (.C(CLK_48),
        .CE(1'b1),
        .D(i2c_scl_i_1_n_0),
        .Q(AC_SCK_OBUF),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hAAEFAA20)) 
    i2c_sda_t_i_1
       (.I0(i2c_sda_t_i_2_n_0),
        .I1(i2c_sda_t_i_3_n_0),
        .I2(i2c_sda_t_i_4_n_0),
        .I3(i2c_sda_t_i_5_n_0),
        .I4(i2c_sda_t),
        .O(i2c_sda_t_i_1_n_0));
  LUT4 #(
    .INIT(16'hFBFF)) 
    i2c_sda_t_i_10
       (.I0(bitcount[5]),
        .I1(bitcount[4]),
        .I2(bitcount[0]),
        .I3(bitcount[1]),
        .O(i2c_sda_t_i_10_n_0));
  LUT5 #(
    .INIT(32'h8F888888)) 
    i2c_sda_t_i_2
       (.I0(data0),
        .I1(Q),
        .I2(\state_reg_n_0_[1] ),
        .I3(bitcount[3]),
        .I4(i2c_sda_t_i_6_n_0),
        .O(i2c_sda_t_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFDF)) 
    i2c_sda_t_i_3
       (.I0(bitcount[1]),
        .I1(bitcount[0]),
        .I2(bitcount[4]),
        .I3(bitcount[5]),
        .I4(i2c_sda_t_i_7_n_0),
        .O(i2c_sda_t_i_3_n_0));
  LUT4 #(
    .INIT(16'h0008)) 
    i2c_sda_t_i_4
       (.I0(\state_reg_n_0_[1] ),
        .I1(Q),
        .I2(\state_reg_n_0_[2] ),
        .I3(\state_reg_n_0_[3] ),
        .O(i2c_sda_t_i_4_n_0));
  LUT6 #(
    .INIT(64'h0101050001000500)) 
    i2c_sda_t_i_5
       (.I0(\state_reg_n_0_[3] ),
        .I1(\state_reg_n_0_[2] ),
        .I2(Q),
        .I3(i2c_sda_t_i_8_n_0),
        .I4(\state_reg_n_0_[1] ),
        .I5(\i2c_data[8]_i_3_n_0 ),
        .O(i2c_sda_t_i_5_n_0));
  LUT6 #(
    .INIT(64'h0000000000200000)) 
    i2c_sda_t_i_6
       (.I0(bitcount[1]),
        .I1(bitcount[0]),
        .I2(bitcount[4]),
        .I3(bitcount[5]),
        .I4(bitcount[2]),
        .I5(\i2c_data[8]_i_4_n_0 ),
        .O(i2c_sda_t_i_6_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFF15FFFF)) 
    i2c_sda_t_i_7
       (.I0(bitcount[5]),
        .I1(bitcount[3]),
        .I2(bitcount[4]),
        .I3(bitcount[7]),
        .I4(bitcount[6]),
        .I5(bitcount[2]),
        .O(i2c_sda_t_i_7_n_0));
  LUT6 #(
    .INIT(64'h0000000000080800)) 
    i2c_sda_t_i_8
       (.I0(\state_reg_n_0_[2] ),
        .I1(i2c_sda_t_i_9_n_0),
        .I2(bitcount[7]),
        .I3(bitcount[6]),
        .I4(bitcount[2]),
        .I5(i2c_sda_t_i_10_n_0),
        .O(i2c_sda_t_i_8_n_0));
  LUT3 #(
    .INIT(8'hF8)) 
    i2c_sda_t_i_9
       (.I0(bitcount[4]),
        .I1(bitcount[3]),
        .I2(bitcount[5]),
        .O(i2c_sda_t_i_9_n_0));
  FDRE #(
    .INIT(1'b1)) 
    i2c_sda_t_reg
       (.C(CLK_48),
        .CE(1'b1),
        .D(i2c_sda_t_i_1_n_0),
        .Q(i2c_sda_t),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hFFEF0100)) 
    i2c_started_i_1
       (.I0(\state_reg_n_0_[3] ),
        .I1(Q),
        .I2(\state_reg_n_0_[2] ),
        .I3(\state_reg_n_0_[1] ),
        .I4(i2c_started),
        .O(i2c_started_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    i2c_started_reg
       (.C(CLK_48),
        .CE(1'b1),
        .D(i2c_started_i_1_n_0),
        .Q(i2c_started),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h00010101)) 
    \pcnext[0]_i_1 
       (.I0(pcnext[0]),
        .I1(\pcnext[2]_i_7_n_0 ),
        .I2(\state_reg_n_0_[3] ),
        .I3(\state_reg_n_0_[2] ),
        .I4(\state_reg_n_0_[1] ),
        .O(\pcnext[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000600060006)) 
    \pcnext[1]_i_1 
       (.I0(pcnext[1]),
        .I1(pcnext[0]),
        .I2(\pcnext[2]_i_7_n_0 ),
        .I3(\state_reg_n_0_[3] ),
        .I4(\state_reg_n_0_[2] ),
        .I5(\state_reg_n_0_[1] ),
        .O(\pcnext[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBABBBABFFAFBBAB)) 
    \pcnext[2]_i_1 
       (.I0(\state[3]_i_6_n_0 ),
        .I1(\pcnext[2]_i_3_n_0 ),
        .I2(\state_reg_n_0_[2] ),
        .I3(\state_reg_n_0_[1] ),
        .I4(data_reg),
        .I5(\pcnext[2]_i_5_n_0 ),
        .O(\pcnext[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h0000006A)) 
    \pcnext[2]_i_2 
       (.I0(pcnext[2]),
        .I1(pcnext[1]),
        .I2(pcnext[0]),
        .I3(\pcnext[2]_i_6_n_0 ),
        .I4(\pcnext[2]_i_7_n_0 ),
        .O(\pcnext[2]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00F07FFF)) 
    \pcnext[2]_i_3 
       (.I0(\i2c_bits_left[3]_i_5_n_0 ),
        .I1(\bitcount[7]_i_6_n_0 ),
        .I2(Q),
        .I3(\state_reg_n_0_[1] ),
        .I4(\state_reg_n_0_[2] ),
        .O(\pcnext[2]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFDF0)) 
    \pcnext[2]_i_5 
       (.I0(\bitcount[7]_i_6_n_0 ),
        .I1(\delay[15]_i_4_n_0 ),
        .I2(\state_reg_n_0_[1] ),
        .I3(Q),
        .O(\pcnext[2]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'hEA)) 
    \pcnext[2]_i_6 
       (.I0(\state_reg_n_0_[3] ),
        .I1(\state_reg_n_0_[2] ),
        .I2(\state_reg_n_0_[1] ),
        .O(\pcnext[2]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hAAAA0001)) 
    \pcnext[2]_i_7 
       (.I0(Q),
        .I1(skip_reg_0),
        .I2(DOADO[8]),
        .I3(DOADO[7]),
        .I4(\state_reg_n_0_[2] ),
        .O(\pcnext[2]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h9090FF90)) 
    \pcnext[3]_i_1 
       (.I0(pcnext[3]),
        .I1(\pcnext[3]_i_2_n_0 ),
        .I2(\pcnext[9]_i_4_n_0 ),
        .I3(DOADO[0]),
        .I4(\pcnext[9]_i_6_n_0 ),
        .O(\pcnext[3]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \pcnext[3]_i_2 
       (.I0(pcnext[1]),
        .I1(pcnext[0]),
        .I2(pcnext[2]),
        .O(\pcnext[3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h9090FF90)) 
    \pcnext[4]_i_1 
       (.I0(pcnext[4]),
        .I1(\pcnext[4]_i_2_n_0 ),
        .I2(\pcnext[9]_i_4_n_0 ),
        .I3(DOADO[1]),
        .I4(\pcnext[9]_i_6_n_0 ),
        .O(\pcnext[4]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \pcnext[4]_i_2 
       (.I0(pcnext[2]),
        .I1(pcnext[0]),
        .I2(pcnext[1]),
        .I3(pcnext[3]),
        .O(\pcnext[4]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h9090FF90)) 
    \pcnext[5]_i_1 
       (.I0(pcnext[5]),
        .I1(\pcnext[5]_i_2_n_0 ),
        .I2(\pcnext[9]_i_4_n_0 ),
        .I3(DOADO[2]),
        .I4(\pcnext[9]_i_6_n_0 ),
        .O(\pcnext[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    \pcnext[5]_i_2 
       (.I0(pcnext[3]),
        .I1(pcnext[1]),
        .I2(pcnext[0]),
        .I3(pcnext[2]),
        .I4(pcnext[4]),
        .O(\pcnext[5]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h9090FF90)) 
    \pcnext[6]_i_1 
       (.I0(pcnext[6]),
        .I1(\pcnext[7]_i_2_n_0 ),
        .I2(\pcnext[9]_i_4_n_0 ),
        .I3(DOADO[3]),
        .I4(\pcnext[9]_i_6_n_0 ),
        .O(\pcnext[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA600A600FFFFA600)) 
    \pcnext[7]_i_1 
       (.I0(pcnext[7]),
        .I1(pcnext[6]),
        .I2(\pcnext[7]_i_2_n_0 ),
        .I3(\pcnext[9]_i_4_n_0 ),
        .I4(DOADO[4]),
        .I5(\pcnext[9]_i_6_n_0 ),
        .O(\pcnext[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \pcnext[7]_i_2 
       (.I0(pcnext[4]),
        .I1(pcnext[2]),
        .I2(pcnext[0]),
        .I3(pcnext[1]),
        .I4(pcnext[3]),
        .I5(pcnext[5]),
        .O(\pcnext[7]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h9090FF90)) 
    \pcnext[8]_i_1 
       (.I0(pcnext[8]),
        .I1(\pcnext[9]_i_5_n_0 ),
        .I2(\pcnext[9]_i_4_n_0 ),
        .I3(DOADO[5]),
        .I4(\pcnext[9]_i_6_n_0 ),
        .O(\pcnext[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000040F0000)) 
    \pcnext[9]_i_1 
       (.I0(\pcnext[2]_i_5_n_0 ),
        .I1(data_reg),
        .I2(\pcnext[9]_i_3_n_0 ),
        .I3(\pcnext[2]_i_3_n_0 ),
        .I4(\state_reg_n_0_[3] ),
        .I5(\state[3]_i_6_n_0 ),
        .O(\pcnext[9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h82888288FFFF8288)) 
    \pcnext[9]_i_2 
       (.I0(\pcnext[9]_i_4_n_0 ),
        .I1(pcnext[9]),
        .I2(\pcnext[9]_i_5_n_0 ),
        .I3(pcnext[8]),
        .I4(DOADO[6]),
        .I5(\pcnext[9]_i_6_n_0 ),
        .O(\pcnext[9]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \pcnext[9]_i_3 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg_n_0_[1] ),
        .O(\pcnext[9]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h3333333377777774)) 
    \pcnext[9]_i_4 
       (.I0(\state_reg_n_0_[1] ),
        .I1(\state_reg_n_0_[2] ),
        .I2(DOADO[7]),
        .I3(DOADO[8]),
        .I4(skip_reg_0),
        .I5(Q),
        .O(\pcnext[9]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \pcnext[9]_i_5 
       (.I0(pcnext[6]),
        .I1(\pcnext[7]_i_2_n_0 ),
        .I2(pcnext[7]),
        .O(\pcnext[9]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \pcnext[9]_i_6 
       (.I0(DOADO[8]),
        .I1(DOADO[7]),
        .I2(skip_reg_0),
        .I3(Q),
        .I4(\state_reg_n_0_[2] ),
        .O(\pcnext[9]_i_6_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[0] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[0]_i_1_n_0 ),
        .Q(pcnext[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[1] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[1]_i_1_n_0 ),
        .Q(pcnext[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[2] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[2]_i_2_n_0 ),
        .Q(pcnext[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[3] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[3]_i_1_n_0 ),
        .Q(pcnext[3]),
        .R(\pcnext[9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[4] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[4]_i_1_n_0 ),
        .Q(pcnext[4]),
        .R(\pcnext[9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[5] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[5]_i_1_n_0 ),
        .Q(pcnext[5]),
        .R(\pcnext[9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[6] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[6]_i_1_n_0 ),
        .Q(pcnext[6]),
        .R(\pcnext[9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[7] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[7]_i_1_n_0 ),
        .Q(pcnext[7]),
        .R(\pcnext[9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[8] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[8]_i_1_n_0 ),
        .Q(pcnext[8]),
        .R(\pcnext[9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg[9] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[9]_i_2_n_0 ),
        .Q(pcnext[9]),
        .R(\pcnext[9]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[0] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[0]_i_1_n_0 ),
        .Q(ADDRARDADDR[0]),
        .R(1'b0));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[1] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[1]_i_1_n_0 ),
        .Q(ADDRARDADDR[1]),
        .R(1'b0));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[2] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[2]_i_2_n_0 ),
        .Q(ADDRARDADDR[2]),
        .R(1'b0));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[3] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[3]_i_1_n_0 ),
        .Q(ADDRARDADDR[3]),
        .R(\pcnext[9]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[4] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[4]_i_1_n_0 ),
        .Q(ADDRARDADDR[4]),
        .R(\pcnext[9]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[5] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[5]_i_1_n_0 ),
        .Q(ADDRARDADDR[5]),
        .R(\pcnext[9]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[6] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[6]_i_1_n_0 ),
        .Q(ADDRARDADDR[6]),
        .R(\pcnext[9]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[7] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[7]_i_1_n_0 ),
        .Q(ADDRARDADDR[7]),
        .R(\pcnext[9]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[8] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[8]_i_1_n_0 ),
        .Q(ADDRARDADDR[8]),
        .R(\pcnext[9]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \pcnext_reg_rep[9] 
       (.C(CLK_48),
        .CE(\pcnext[2]_i_1_n_0 ),
        .D(\pcnext[9]_i_2_n_0 ),
        .Q(ADDRARDADDR[9]),
        .R(\pcnext[9]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFEAA)) 
    skip_i_12
       (.I0(\state_reg_n_0_[3] ),
        .I1(Q),
        .I2(\state_reg_n_0_[1] ),
        .I3(\state_reg_n_0_[2] ),
        .O(skip_i_12_n_0));
  LUT4 #(
    .INIT(16'hFFA9)) 
    skip_i_5
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg_n_0_[1] ),
        .I2(Q),
        .I3(\state_reg_n_0_[3] ),
        .O(skip_reg_2));
  LUT5 #(
    .INIT(32'hFFFFAA80)) 
    skip_i_8
       (.I0(\bitcount[6]_i_3_n_0 ),
        .I1(data_reg_0),
        .I2(data_reg_1),
        .I3(skip_reg_0),
        .I4(skip_i_12_n_0),
        .O(skip_reg_1));
  FDRE #(
    .INIT(1'b1)) 
    skip_reg
       (.C(CLK_48),
        .CE(1'b1),
        .D(ack_flag_reg_0),
        .Q(skip_reg_0),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h02)) 
    \state[0]_i_1 
       (.I0(\state[0]_i_2_n_0 ),
        .I1(\state_reg_n_0_[2] ),
        .I2(\state_reg_n_0_[3] ),
        .O(\state[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8F8C8F8F8F8C8C8C)) 
    \state[0]_i_2 
       (.I0(\i2c_bits_left_reg_n_0_[0] ),
        .I1(\state_reg_n_0_[1] ),
        .I2(Q),
        .I3(i2c_started),
        .I4(data_reg_2),
        .I5(data_reg_6),
        .O(\state[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h1000111110001010)) 
    \state[1]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg_n_0_[3] ),
        .I2(\state_reg_n_0_[1] ),
        .I3(\i2c_bits_left_reg_n_0_[1] ),
        .I4(Q),
        .I5(data_reg_2),
        .O(\state[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000CCCCCCCD)) 
    \state[2]_i_1 
       (.I0(data_reg_2),
        .I1(Q),
        .I2(data_reg_3),
        .I3(\state_reg_n_0_[1] ),
        .I4(\state_reg_n_0_[2] ),
        .I5(\state[2]_i_4_n_0 ),
        .O(\state[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFA2FFAA)) 
    \state[2]_i_4 
       (.I0(Q),
        .I1(\state_reg_n_0_[1] ),
        .I2(\state_reg_n_0_[2] ),
        .I3(\state_reg_n_0_[3] ),
        .I4(\i2c_bits_left_reg_n_0_[2] ),
        .O(\state[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFA0F0A0F1)) 
    \state[3]_i_1 
       (.I0(\state_reg_n_0_[1] ),
        .I1(\bitcount_reg[0]_0 ),
        .I2(\state[3]_i_4_n_0 ),
        .I3(\state_reg_n_0_[2] ),
        .I4(data_reg_5),
        .I5(\state[3]_i_6_n_0 ),
        .O(\state[3]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h02000000)) 
    \state[3]_i_2 
       (.I0(\i2c_bits_left_reg_n_0_[3] ),
        .I1(\state_reg_n_0_[3] ),
        .I2(\state_reg_n_0_[2] ),
        .I3(Q),
        .I4(\state_reg_n_0_[1] ),
        .O(\state[3]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \state[3]_i_3 
       (.I0(skip_reg_0),
        .I1(Q),
        .O(\bitcount_reg[0]_0 ));
  LUT6 #(
    .INIT(64'hFF73FF73F0403040)) 
    \state[3]_i_4 
       (.I0(\delay[15]_i_4_n_0 ),
        .I1(Q),
        .I2(\bitcount[7]_i_6_n_0 ),
        .I3(\state_reg_n_0_[1] ),
        .I4(\i2c_bits_left[3]_i_5_n_0 ),
        .I5(\state_reg_n_0_[2] ),
        .O(\state[3]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hF2F2F2F0)) 
    \state[3]_i_6 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg_n_0_[1] ),
        .I2(\state_reg_n_0_[3] ),
        .I3(Q),
        .I4(\bitcount[7]_i_6_n_0 ),
        .O(\state[3]_i_6_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[0] 
       (.C(CLK_48),
        .CE(\state[3]_i_1_n_0 ),
        .D(\state[0]_i_1_n_0 ),
        .Q(Q),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[1] 
       (.C(CLK_48),
        .CE(\state[3]_i_1_n_0 ),
        .D(\state[1]_i_1_n_0 ),
        .Q(\state_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[2] 
       (.C(CLK_48),
        .CE(\state[3]_i_1_n_0 ),
        .D(\state[2]_i_1_n_0 ),
        .Q(\state_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[3] 
       (.C(CLK_48),
        .CE(\state[3]_i_1_n_0 ),
        .D(\state[3]_i_2_n_0 ),
        .Q(\state_reg_n_0_[3] ),
        .R(1'b0));
endmodule

module noise
   (D,
    CLK,
    AR,
    SW3_IBUF,
    \wave_reg[23] ,
    SW3,
    data4);
  output [0:0]D;
  input CLK;
  input [0:0]AR;
  input SW3_IBUF;
  input \wave_reg[23] ;
  input SW3;
  input [0:0]data4;

  wire [0:0]AR;
  wire CLK;
  wire [0:0]D;
  wire SW3;
  wire SW3_IBUF;
  wire [0:0]data4;
  wire \wave_reg[23] ;

  noise_channel nc3
       (.AR(AR),
        .CLK(CLK),
        .D(D),
        .SW3(SW3),
        .SW3_IBUF(SW3_IBUF),
        .data4(data4),
        .\wave_reg[23] (\wave_reg[23] ));
endmodule

module noise_channel
   (D,
    CLK,
    AR,
    SW3_IBUF,
    \wave_reg[23] ,
    SW3,
    data4);
  output [0:0]D;
  input CLK;
  input [0:0]AR;
  input SW3_IBUF;
  input \wave_reg[23] ;
  input SW3;
  input [0:0]data4;

  wire [0:0]AR;
  wire CLK;
  wire [0:0]D;
  wire LFSR0;
  wire \LFSR_reg[2]_n_nc3_LFSR_reg_c_10_n_0 ;
  wire \LFSR_reg[3]_srl11_n_nc3_LFSR_reg_c_9_n_0 ;
  wire LFSR_reg_c_0_n_0;
  wire LFSR_reg_c_10_n_0;
  wire LFSR_reg_c_1_n_0;
  wire LFSR_reg_c_2_n_0;
  wire LFSR_reg_c_3_n_0;
  wire LFSR_reg_c_4_n_0;
  wire LFSR_reg_c_5_n_0;
  wire LFSR_reg_c_6_n_0;
  wire LFSR_reg_c_7_n_0;
  wire LFSR_reg_c_8_n_0;
  wire LFSR_reg_c_9_n_0;
  wire LFSR_reg_c_n_0;
  wire LFSR_reg_gate_n_0;
  wire \LFSR_reg_n_0_[0] ;
  wire [13:0]LFSR_right_shift;
  wire SW3;
  wire SW3_IBUF;
  wire [0:0]data4;
  wire frequency_timer_clock;
  wire \wave_reg[23] ;

  LUT2 #(
    .INIT(4'h6)) 
    \LFSR[14]_i_1 
       (.I0(LFSR_right_shift[0]),
        .I1(\LFSR_reg_n_0_[0] ),
        .O(LFSR0));
  FDCE #(
    .INIT(1'b0)) 
    \LFSR_reg[0] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_right_shift[0]),
        .Q(\LFSR_reg_n_0_[0] ));
  FDPE #(
    .INIT(1'b1)) 
    \LFSR_reg[14] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .D(LFSR0),
        .PRE(AR),
        .Q(LFSR_right_shift[13]));
  FDCE #(
    .INIT(1'b0)) 
    \LFSR_reg[1] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_gate_n_0),
        .Q(LFSR_right_shift[0]));
  FDRE #(
    .INIT(1'b0)) 
    \LFSR_reg[2]_n_nc3_LFSR_reg_c_10 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .D(\LFSR_reg[3]_srl11_n_nc3_LFSR_reg_c_9_n_0 ),
        .Q(\LFSR_reg[2]_n_nc3_LFSR_reg_c_10_n_0 ),
        .R(1'b0));
  (* srl_bus_name = "\n/nc3/LFSR_reg " *) 
  (* srl_name = "\n/nc3/LFSR_reg[3]_srl11_n_nc3_LFSR_reg_c_9 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \LFSR_reg[3]_srl11_n_nc3_LFSR_reg_c_9 
       (.A0(1'b0),
        .A1(1'b1),
        .A2(1'b0),
        .A3(1'b1),
        .CE(1'b1),
        .CLK(frequency_timer_clock),
        .D(LFSR_right_shift[13]),
        .Q(\LFSR_reg[3]_srl11_n_nc3_LFSR_reg_c_9_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(1'b1),
        .Q(LFSR_reg_c_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_0
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_n_0),
        .Q(LFSR_reg_c_0_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_1
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_0_n_0),
        .Q(LFSR_reg_c_1_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_10
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_9_n_0),
        .Q(LFSR_reg_c_10_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_2
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_1_n_0),
        .Q(LFSR_reg_c_2_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_3
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_2_n_0),
        .Q(LFSR_reg_c_3_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_4
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_3_n_0),
        .Q(LFSR_reg_c_4_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_5
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_4_n_0),
        .Q(LFSR_reg_c_5_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_6
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_5_n_0),
        .Q(LFSR_reg_c_6_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_7
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_6_n_0),
        .Q(LFSR_reg_c_7_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_8
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_7_n_0),
        .Q(LFSR_reg_c_8_n_0));
  FDCE #(
    .INIT(1'b0)) 
    LFSR_reg_c_9
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(LFSR_reg_c_8_n_0),
        .Q(LFSR_reg_c_9_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    LFSR_reg_gate
       (.I0(\LFSR_reg[2]_n_nc3_LFSR_reg_c_10_n_0 ),
        .I1(LFSR_reg_c_10_n_0),
        .O(LFSR_reg_gate_n_0));
  frequency_timer_4 ft
       (.AR(AR),
        .CLK(CLK),
        .frequency_timer_clock(frequency_timer_clock));
  LUT5 #(
    .INIT(32'hF4FFF400)) 
    \hphone_r[23]_i_2 
       (.I0(\LFSR_reg_n_0_[0] ),
        .I1(SW3_IBUF),
        .I2(\wave_reg[23] ),
        .I3(SW3),
        .I4(data4),
        .O(D));
endmodule

module square1
   (\hphone_r_reg[21] ,
    AR,
    CLK,
    SW0_IBUF,
    SW1_IBUF,
    \wave_reg[23] ,
    clk_512);
  output \hphone_r_reg[21] ;
  input [0:0]AR;
  input CLK;
  input SW0_IBUF;
  input SW1_IBUF;
  input \wave_reg[23] ;
  input clk_512;

  wire [0:0]AR;
  wire CLK;
  wire SW0_IBUF;
  wire SW1_IBUF;
  wire clk_512;
  wire clock_128;
  wire [11:3]frequency_timer_period_old;
  wire fs_n_0;
  wire fs_n_1;
  wire fs_n_12;
  wire fs_n_13;
  wire fs_n_14;
  wire fs_n_15;
  wire fs_n_16;
  wire fs_n_17;
  wire fs_n_18;
  wire fs_n_19;
  wire fs_n_2;
  wire fs_n_20;
  wire fs_n_21;
  wire fs_n_22;
  wire fs_n_3;
  wire fs_n_4;
  wire fs_n_5;
  wire fs_n_6;
  wire fs_n_7;
  wire fs_n_8;
  wire fs_n_9;
  wire [0:0]\ft/update_regs ;
  wire \hphone_r_reg[21] ;
  wire [0:0]internal_NR13_reg;
  wire sw_n_1;
  wire sw_n_12;
  wire sw_n_13;
  wire sw_n_14;
  wire sw_n_15;
  wire sw_n_16;
  wire sw_n_17;
  wire sw_n_18;
  wire sw_n_19;
  wire sw_n_2;
  wire sw_n_20;
  wire sw_n_21;
  wire sw_n_22;
  wire sw_n_23;
  wire \wave_reg[23] ;

  clock_divider_1 cd
       (.AR(AR),
        .Q(clock_128),
        .clk_512(clk_512));
  frequency_sweep fs
       (.AR(AR),
        .CO(\ft/update_regs ),
        .D({fs_n_0,fs_n_1,fs_n_2,fs_n_3,fs_n_4,fs_n_5,fs_n_6,fs_n_7,fs_n_8,fs_n_9,internal_NR13_reg}),
        .O({sw_n_20,sw_n_21,sw_n_22,sw_n_23}),
        .Q(clock_128),
        .S(sw_n_2),
        .\counter_reg[0] ({sw_n_13,sw_n_14,sw_n_15}),
        .\counter_reg[12] ({fs_n_12,fs_n_13,fs_n_14,fs_n_15,fs_n_16,fs_n_17,fs_n_18,fs_n_19,fs_n_20,fs_n_21,fs_n_22}),
        .\counter_reg[12]_0 (sw_n_1),
        .\counter_reg[8] ({sw_n_16,sw_n_17,sw_n_18,sw_n_19}),
        .\frequency_timer_period_old_reg[11] (frequency_timer_period_old),
        .\frequency_timer_period_old_reg[12] (sw_n_12));
  square_wave_2 sw
       (.AR(AR),
        .CLK(CLK),
        .CO(\ft/update_regs ),
        .D({fs_n_0,fs_n_1,fs_n_2,fs_n_3,fs_n_4,fs_n_5,fs_n_6,fs_n_7,fs_n_8,fs_n_9,internal_NR13_reg}),
        .O({sw_n_20,sw_n_21,sw_n_22,sw_n_23}),
        .Q(frequency_timer_period_old),
        .S(sw_n_2),
        .SW0_IBUF(SW0_IBUF),
        .SW1_IBUF(SW1_IBUF),
        .\counter_reg[4] ({sw_n_13,sw_n_14,sw_n_15}),
        .\counter_reg[8] ({sw_n_16,sw_n_17,sw_n_18,sw_n_19}),
        .frequency_timer_clock_reg(sw_n_1),
        .frequency_timer_clock_reg_0(sw_n_12),
        .\hphone_r_reg[21] (\hphone_r_reg[21] ),
        .\internal_NR14_reg_reg[1] ({fs_n_12,fs_n_13,fs_n_14,fs_n_15,fs_n_16,fs_n_17,fs_n_18,fs_n_19,fs_n_20,fs_n_21,fs_n_22}),
        .\wave_reg[23]_0 (\wave_reg[23] ));
endmodule

module square2
   (\wave_reg[23] ,
    clk_8,
    AR);
  output \wave_reg[23] ;
  input clk_8;
  input [0:0]AR;

  wire [0:0]AR;
  wire clk_8;
  wire \wave_reg[23] ;

  square_wave sw1
       (.AR(AR),
        .clk_8(clk_8),
        .\wave_reg[23]_0 (\wave_reg[23] ));
endmodule

module square_wave
   (\wave_reg[23]_0 ,
    clk_8,
    AR);
  output \wave_reg[23]_0 ;
  input clk_8;
  input [0:0]AR;

  wire [0:0]AR;
  wire clk_8;
  wire frequency_timer_clock;
  wire [2:0]num_cycles;
  wire \num_cycles[0]_i_1_n_0 ;
  wire \num_cycles[1]_i_1_n_0 ;
  wire \num_cycles[2]_i_1_n_0 ;
  wire \wave[23]_i_1__0_n_0 ;
  wire \wave_reg[23]_0 ;

  frequency_timer_0 ft
       (.AR(AR),
        .CLK(frequency_timer_clock),
        .clk_8(clk_8));
  LUT1 #(
    .INIT(2'h1)) 
    \num_cycles[0]_i_1 
       (.I0(num_cycles[0]),
        .O(\num_cycles[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \num_cycles[1]_i_1 
       (.I0(num_cycles[0]),
        .I1(num_cycles[1]),
        .O(\num_cycles[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \num_cycles[2]_i_1 
       (.I0(num_cycles[0]),
        .I1(num_cycles[1]),
        .I2(num_cycles[2]),
        .O(\num_cycles[2]_i_1_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \num_cycles_reg[0] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(\num_cycles[0]_i_1_n_0 ),
        .Q(num_cycles[0]));
  FDCE #(
    .INIT(1'b0)) 
    \num_cycles_reg[1] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(\num_cycles[1]_i_1_n_0 ),
        .Q(num_cycles[1]));
  FDCE #(
    .INIT(1'b0)) 
    \num_cycles_reg[2] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(\num_cycles[2]_i_1_n_0 ),
        .Q(num_cycles[2]));
  LUT3 #(
    .INIT(8'hE2)) 
    \wave[23]_i_1__0 
       (.I0(num_cycles[2]),
        .I1(AR),
        .I2(\wave_reg[23]_0 ),
        .O(\wave[23]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wave_reg[23] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .D(\wave[23]_i_1__0_n_0 ),
        .Q(\wave_reg[23]_0 ),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "square_wave" *) 
module square_wave_2
   (\hphone_r_reg[21] ,
    frequency_timer_clock_reg,
    S,
    Q,
    frequency_timer_clock_reg_0,
    \counter_reg[4] ,
    \counter_reg[8] ,
    O,
    CLK,
    AR,
    SW0_IBUF,
    SW1_IBUF,
    \wave_reg[23]_0 ,
    D,
    CO,
    \internal_NR14_reg_reg[1] );
  output \hphone_r_reg[21] ;
  output frequency_timer_clock_reg;
  output [0:0]S;
  output [8:0]Q;
  output [0:0]frequency_timer_clock_reg_0;
  output [2:0]\counter_reg[4] ;
  output [3:0]\counter_reg[8] ;
  output [3:0]O;
  input CLK;
  input [0:0]AR;
  input SW0_IBUF;
  input SW1_IBUF;
  input \wave_reg[23]_0 ;
  input [10:0]D;
  input [0:0]CO;
  input [10:0]\internal_NR14_reg_reg[1] ;

  wire [0:0]AR;
  wire CLK;
  wire [0:0]CO;
  wire [10:0]D;
  wire [3:0]O;
  wire [8:0]Q;
  wire [0:0]S;
  wire SW0_IBUF;
  wire SW1_IBUF;
  wire [2:0]\counter_reg[4] ;
  wire [3:0]\counter_reg[8] ;
  wire frequency_timer_clock;
  wire frequency_timer_clock_reg;
  wire [0:0]frequency_timer_clock_reg_0;
  wire \hphone_r_reg[21] ;
  wire [10:0]\internal_NR14_reg_reg[1] ;
  wire [2:0]num_cycles;
  wire \num_cycles[0]_i_1_n_0 ;
  wire \num_cycles[1]_i_1_n_0 ;
  wire \num_cycles[2]_i_1_n_0 ;
  wire \wave[23]_i_1_n_0 ;
  wire \wave_reg[23]_0 ;
  wire \wave_reg_n_0_[23] ;

  frequency_timer_3 ft
       (.AR(AR),
        .CLK(frequency_timer_clock),
        .CO(CO),
        .D(D),
        .O(O),
        .Q(Q),
        .S(S),
        .\counter_reg[0]_0 (CLK),
        .\counter_reg[4]_0 (\counter_reg[4] ),
        .\counter_reg[8]_0 (\counter_reg[8] ),
        .frequency_timer_clock_reg_0(frequency_timer_clock_reg),
        .frequency_timer_clock_reg_1(frequency_timer_clock_reg_0),
        .\internal_NR14_reg_reg[1] (\internal_NR14_reg_reg[1] ));
  LUT4 #(
    .INIT(16'hF888)) 
    \hphone_r[23]_i_3 
       (.I0(SW0_IBUF),
        .I1(\wave_reg_n_0_[23] ),
        .I2(SW1_IBUF),
        .I3(\wave_reg[23]_0 ),
        .O(\hphone_r_reg[21] ));
  LUT1 #(
    .INIT(2'h1)) 
    \num_cycles[0]_i_1 
       (.I0(num_cycles[0]),
        .O(\num_cycles[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \num_cycles[1]_i_1 
       (.I0(num_cycles[0]),
        .I1(num_cycles[1]),
        .O(\num_cycles[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \num_cycles[2]_i_1 
       (.I0(num_cycles[0]),
        .I1(num_cycles[1]),
        .I2(num_cycles[2]),
        .O(\num_cycles[2]_i_1_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \num_cycles_reg[0] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(\num_cycles[0]_i_1_n_0 ),
        .Q(num_cycles[0]));
  FDCE #(
    .INIT(1'b0)) 
    \num_cycles_reg[1] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(\num_cycles[1]_i_1_n_0 ),
        .Q(num_cycles[1]));
  FDCE #(
    .INIT(1'b0)) 
    \num_cycles_reg[2] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(\num_cycles[2]_i_1_n_0 ),
        .Q(num_cycles[2]));
  LUT3 #(
    .INIT(8'hE2)) 
    \wave[23]_i_1 
       (.I0(num_cycles[2]),
        .I1(AR),
        .I2(\wave_reg_n_0_[23] ),
        .O(\wave[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wave_reg[23] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .D(\wave[23]_i_1_n_0 ),
        .Q(\wave_reg_n_0_[23] ),
        .R(1'b0));
endmodule

module wave
   (D,
    AR,
    clk_8,
    SW2_IBUF,
    \wave_reg[23] ,
    SW3,
    data4);
  output [3:0]D;
  input [0:0]AR;
  input clk_8;
  input SW2_IBUF;
  input \wave_reg[23] ;
  input SW3;
  input [3:0]data4;

  wire [0:0]AR;
  wire [3:0]D;
  wire SW2_IBUF;
  wire SW3;
  wire clk_8;
  wire [3:0]data4;
  wire \wave_reg[23] ;

  wave_channel vw2
       (.AR(AR),
        .D(D),
        .SW2_IBUF(SW2_IBUF),
        .SW3(SW3),
        .clk_8(clk_8),
        .data4(data4),
        .\wave_reg[23] (\wave_reg[23] ));
endmodule

module wave_channel
   (D,
    AR,
    clk_8,
    SW2_IBUF,
    \wave_reg[23] ,
    SW3,
    data4);
  output [3:0]D;
  input [0:0]AR;
  input clk_8;
  input SW2_IBUF;
  input \wave_reg[23] ;
  input SW3;
  input [3:0]data4;

  wire [0:0]AR;
  wire [3:0]D;
  wire SW2_IBUF;
  wire SW3;
  wire clk_8;
  wire [3:0]data4;
  wire frequency_timer_clock;
  wire [5:2]position_counter;
  wire [5:2]position_counter_reg__0;
  wire top_byte;
  wire top_byte_i_1_n_0;
  wire \wave_reg[23] ;

  frequency_timer ft
       (.AR(AR),
        .clk_8(clk_8),
        .frequency_timer_clock(frequency_timer_clock));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT4 #(
    .INIT(16'h2F20)) 
    \hphone_r[18]_i_1 
       (.I0(SW2_IBUF),
        .I1(position_counter_reg__0[2]),
        .I2(SW3),
        .I3(data4[0]),
        .O(D[0]));
  LUT4 #(
    .INIT(16'h8F80)) 
    \hphone_r[19]_i_1 
       (.I0(SW2_IBUF),
        .I1(position_counter_reg__0[3]),
        .I2(SW3),
        .I3(data4[1]),
        .O(D[1]));
  LUT5 #(
    .INIT(32'hF8FFF800)) 
    \hphone_r[20]_i_1 
       (.I0(position_counter_reg__0[4]),
        .I1(SW2_IBUF),
        .I2(\wave_reg[23] ),
        .I3(SW3),
        .I4(data4[2]),
        .O(D[2]));
  LUT5 #(
    .INIT(32'hF8FFF800)) 
    \hphone_r[21]_i_1 
       (.I0(position_counter_reg__0[5]),
        .I1(SW2_IBUF),
        .I2(\wave_reg[23] ),
        .I3(SW3),
        .I4(data4[3]),
        .O(D[3]));
  LUT1 #(
    .INIT(2'h1)) 
    \position_counter[2]_i_1 
       (.I0(position_counter_reg__0[2]),
        .O(position_counter[2]));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \position_counter[3]_i_1 
       (.I0(position_counter_reg__0[2]),
        .I1(position_counter_reg__0[3]),
        .O(position_counter[3]));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT4 #(
    .INIT(16'hE11E)) 
    \position_counter[4]_i_1 
       (.I0(position_counter_reg__0[3]),
        .I1(position_counter_reg__0[2]),
        .I2(position_counter_reg__0[4]),
        .I3(top_byte),
        .O(position_counter[4]));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT5 #(
    .INIT(32'hFE5701A8)) 
    \position_counter[5]_i_1 
       (.I0(position_counter_reg__0[4]),
        .I1(position_counter_reg__0[2]),
        .I2(position_counter_reg__0[3]),
        .I3(top_byte),
        .I4(position_counter_reg__0[5]),
        .O(position_counter[5]));
  FDPE #(
    .INIT(1'b1)) 
    \position_counter_reg[2] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .D(position_counter[2]),
        .PRE(AR),
        .Q(position_counter_reg__0[2]));
  FDCE #(
    .INIT(1'b0)) 
    \position_counter_reg[3] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(position_counter[3]),
        .Q(position_counter_reg__0[3]));
  FDCE #(
    .INIT(1'b0)) 
    \position_counter_reg[4] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(position_counter[4]),
        .Q(position_counter_reg__0[4]));
  FDCE #(
    .INIT(1'b0)) 
    \position_counter_reg[5] 
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .CLR(AR),
        .D(position_counter[5]),
        .Q(position_counter_reg__0[5]));
  LUT1 #(
    .INIT(2'h1)) 
    top_byte_i_1
       (.I0(top_byte),
        .O(top_byte_i_1_n_0));
  FDPE #(
    .INIT(1'b1)) 
    top_byte_reg
       (.C(frequency_timer_clock),
        .CE(1'b1),
        .D(top_byte_i_1_n_0),
        .PRE(AR),
        .Q(top_byte));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
