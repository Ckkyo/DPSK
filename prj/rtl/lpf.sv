/*
这个模块暂时需要手动复制滤波器参数，不方便设置参数，不过可以考虑后续使用python自动生成滤波器代码
首次编写日期：2022 9月11日



*/



`include "head.v"
// -------------------------------------------------------------
//
// Module: filter
// Generated by MATLAB(R) 9.12 and Filter Design HDL Coder 3.1.11.
// Generated on: 2022-09-14 19:05:09
// -------------------------------------------------------------

// -------------------------------------------------------------
// HDL Code Generation Options:
//
// TargetDirectory: /home/ck/do_sth_here/communication/DPSK/prj/rtl
// TargetLanguage: Verilog
// TestBenchStimulus: impulse step ramp chirp noise 
// GenerateHDLTestBench: off

// -------------------------------------------------------------
// HDL Implementation    : Fully parallel
// Folding Factor        : 1
// -------------------------------------------------------------




`timescale 1 ns / 1 ns

module lpf
               (
                clk,
                clk_enable,
                rst,
                lpf_in,
                lpf_out
                );

  input   clk; 
  input   clk_enable; 
  input   rst; 
  input   signed [15:0] lpf_in; //sfix16_En15
  output  signed [33:0] lpf_out; //sfix34_En33

////////////////////////////////////////////////////////////////
//Module Architecture: filter
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  parameter signed [15:0] coeff1 = 16'b0000001011111001; //sfix16_En18
  parameter signed [15:0] coeff2 = 16'b0000011011000010; //sfix16_En18
  parameter signed [15:0] coeff3 = 16'b0000110101000111; //sfix16_En18
  parameter signed [15:0] coeff4 = 16'b0001011010000100; //sfix16_En18
  parameter signed [15:0] coeff5 = 16'b0010001001001001; //sfix16_En18
  parameter signed [15:0] coeff6 = 16'b0010111111101001; //sfix16_En18
  parameter signed [15:0] coeff7 = 16'b0011111000111010; //sfix16_En18
  parameter signed [15:0] coeff8 = 16'b0100101111000001; //sfix16_En18
  parameter signed [15:0] coeff9 = 16'b0101011011100101; //sfix16_En18
  parameter signed [15:0] coeff10 = 16'b0101111000111100; //sfix16_En18
  parameter signed [15:0] coeff11 = 16'b0110000011001100; //sfix16_En18
  parameter signed [15:0] coeff12 = 16'b0101111000111100; //sfix16_En18
  parameter signed [15:0] coeff13 = 16'b0101011011100101; //sfix16_En18
  parameter signed [15:0] coeff14 = 16'b0100101111000001; //sfix16_En18
  parameter signed [15:0] coeff15 = 16'b0011111000111010; //sfix16_En18
  parameter signed [15:0] coeff16 = 16'b0010111111101001; //sfix16_En18
  parameter signed [15:0] coeff17 = 16'b0010001001001001; //sfix16_En18
  parameter signed [15:0] coeff18 = 16'b0001011010000100; //sfix16_En18
  parameter signed [15:0] coeff19 = 16'b0000110101000111; //sfix16_En18
  parameter signed [15:0] coeff20 = 16'b0000011011000010; //sfix16_En18
  parameter signed [15:0] coeff21 = 16'b0000001011111001; //sfix16_En18

  // Signals
  reg  signed [15:0] delay_pipeline [0:20] ; // sfix16_En15
  wire signed [30:0] product21; // sfix31_En33
  wire signed [31:0] mul_temp; // sfix32_En33
  wire signed [30:0] product20; // sfix31_En33
  wire signed [31:0] mul_temp_1; // sfix32_En33
  wire signed [30:0] product19; // sfix31_En33
  wire signed [31:0] mul_temp_2; // sfix32_En33
  wire signed [30:0] product18; // sfix31_En33
  wire signed [31:0] mul_temp_3; // sfix32_En33
  wire signed [30:0] product17; // sfix31_En33
  wire signed [31:0] mul_temp_4; // sfix32_En33
  wire signed [30:0] product16; // sfix31_En33
  wire signed [31:0] mul_temp_5; // sfix32_En33
  wire signed [30:0] product15; // sfix31_En33
  wire signed [31:0] mul_temp_6; // sfix32_En33
  wire signed [30:0] product14; // sfix31_En33
  wire signed [31:0] mul_temp_7; // sfix32_En33
  wire signed [30:0] product13; // sfix31_En33
  wire signed [31:0] mul_temp_8; // sfix32_En33
  wire signed [30:0] product12; // sfix31_En33
  wire signed [31:0] mul_temp_9; // sfix32_En33
  wire signed [30:0] product11; // sfix31_En33
  wire signed [31:0] mul_temp_10; // sfix32_En33
  wire signed [30:0] product10; // sfix31_En33
  wire signed [31:0] mul_temp_11; // sfix32_En33
  wire signed [30:0] product9; // sfix31_En33
  wire signed [31:0] mul_temp_12; // sfix32_En33
  wire signed [30:0] product8; // sfix31_En33
  wire signed [31:0] mul_temp_13; // sfix32_En33
  wire signed [30:0] product7; // sfix31_En33
  wire signed [31:0] mul_temp_14; // sfix32_En33
  wire signed [30:0] product6; // sfix31_En33
  wire signed [31:0] mul_temp_15; // sfix32_En33
  wire signed [30:0] product5; // sfix31_En33
  wire signed [31:0] mul_temp_16; // sfix32_En33
  wire signed [30:0] product4; // sfix31_En33
  wire signed [31:0] mul_temp_17; // sfix32_En33
  wire signed [30:0] product3; // sfix31_En33
  wire signed [31:0] mul_temp_18; // sfix32_En33
  wire signed [30:0] product2; // sfix31_En33
  wire signed [31:0] mul_temp_19; // sfix32_En33
  wire signed [33:0] product1_cast; // sfix34_En33
  wire signed [30:0] product1; // sfix31_En33
  wire signed [31:0] mul_temp_20; // sfix32_En33
  wire signed [33:0] sum1; // sfix34_En33
  wire signed [33:0] add_signext; // sfix34_En33
  wire signed [33:0] add_signext_1; // sfix34_En33
  wire signed [34:0] add_temp; // sfix35_En33
  wire signed [33:0] sum2; // sfix34_En33
  wire signed [33:0] add_signext_2; // sfix34_En33
  wire signed [33:0] add_signext_3; // sfix34_En33
  wire signed [34:0] add_temp_1; // sfix35_En33
  wire signed [33:0] sum3; // sfix34_En33
  wire signed [33:0] add_signext_4; // sfix34_En33
  wire signed [33:0] add_signext_5; // sfix34_En33
  wire signed [34:0] add_temp_2; // sfix35_En33
  wire signed [33:0] sum4; // sfix34_En33
  wire signed [33:0] add_signext_6; // sfix34_En33
  wire signed [33:0] add_signext_7; // sfix34_En33
  wire signed [34:0] add_temp_3; // sfix35_En33
  wire signed [33:0] sum5; // sfix34_En33
  wire signed [33:0] add_signext_8; // sfix34_En33
  wire signed [33:0] add_signext_9; // sfix34_En33
  wire signed [34:0] add_temp_4; // sfix35_En33
  wire signed [33:0] sum6; // sfix34_En33
  wire signed [33:0] add_signext_10; // sfix34_En33
  wire signed [33:0] add_signext_11; // sfix34_En33
  wire signed [34:0] add_temp_5; // sfix35_En33
  wire signed [33:0] sum7; // sfix34_En33
  wire signed [33:0] add_signext_12; // sfix34_En33
  wire signed [33:0] add_signext_13; // sfix34_En33
  wire signed [34:0] add_temp_6; // sfix35_En33
  wire signed [33:0] sum8; // sfix34_En33
  wire signed [33:0] add_signext_14; // sfix34_En33
  wire signed [33:0] add_signext_15; // sfix34_En33
  wire signed [34:0] add_temp_7; // sfix35_En33
  wire signed [33:0] sum9; // sfix34_En33
  wire signed [33:0] add_signext_16; // sfix34_En33
  wire signed [33:0] add_signext_17; // sfix34_En33
  wire signed [34:0] add_temp_8; // sfix35_En33
  wire signed [33:0] sum10; // sfix34_En33
  wire signed [33:0] add_signext_18; // sfix34_En33
  wire signed [33:0] add_signext_19; // sfix34_En33
  wire signed [34:0] add_temp_9; // sfix35_En33
  wire signed [33:0] sum11; // sfix34_En33
  wire signed [33:0] add_signext_20; // sfix34_En33
  wire signed [33:0] add_signext_21; // sfix34_En33
  wire signed [34:0] add_temp_10; // sfix35_En33
  wire signed [33:0] sum12; // sfix34_En33
  wire signed [33:0] add_signext_22; // sfix34_En33
  wire signed [33:0] add_signext_23; // sfix34_En33
  wire signed [34:0] add_temp_11; // sfix35_En33
  wire signed [33:0] sum13; // sfix34_En33
  wire signed [33:0] add_signext_24; // sfix34_En33
  wire signed [33:0] add_signext_25; // sfix34_En33
  wire signed [34:0] add_temp_12; // sfix35_En33
  wire signed [33:0] sum14; // sfix34_En33
  wire signed [33:0] add_signext_26; // sfix34_En33
  wire signed [33:0] add_signext_27; // sfix34_En33
  wire signed [34:0] add_temp_13; // sfix35_En33
  wire signed [33:0] sum15; // sfix34_En33
  wire signed [33:0] add_signext_28; // sfix34_En33
  wire signed [33:0] add_signext_29; // sfix34_En33
  wire signed [34:0] add_temp_14; // sfix35_En33
  wire signed [33:0] sum16; // sfix34_En33
  wire signed [33:0] add_signext_30; // sfix34_En33
  wire signed [33:0] add_signext_31; // sfix34_En33
  wire signed [34:0] add_temp_15; // sfix35_En33
  wire signed [33:0] sum17; // sfix34_En33
  wire signed [33:0] add_signext_32; // sfix34_En33
  wire signed [33:0] add_signext_33; // sfix34_En33
  wire signed [34:0] add_temp_16; // sfix35_En33
  wire signed [33:0] sum18; // sfix34_En33
  wire signed [33:0] add_signext_34; // sfix34_En33
  wire signed [33:0] add_signext_35; // sfix34_En33
  wire signed [34:0] add_temp_17; // sfix35_En33
  wire signed [33:0] sum19; // sfix34_En33
  wire signed [33:0] add_signext_36; // sfix34_En33
  wire signed [33:0] add_signext_37; // sfix34_En33
  wire signed [34:0] add_temp_18; // sfix35_En33
  wire signed [33:0] sum20; // sfix34_En33
  wire signed [33:0] add_signext_38; // sfix34_En33
  wire signed [33:0] add_signext_39; // sfix34_En33
  wire signed [34:0] add_temp_19; // sfix35_En33
  reg  signed [33:0] output_register; // sfix34_En33

  // Block Statements
  always @( posedge clk or posedge rst)
    begin: Delay_Pipeline_process
      if (rst == 1'b1) begin
        delay_pipeline[0] <= 0;
        delay_pipeline[1] <= 0;
        delay_pipeline[2] <= 0;
        delay_pipeline[3] <= 0;
        delay_pipeline[4] <= 0;
        delay_pipeline[5] <= 0;
        delay_pipeline[6] <= 0;
        delay_pipeline[7] <= 0;
        delay_pipeline[8] <= 0;
        delay_pipeline[9] <= 0;
        delay_pipeline[10] <= 0;
        delay_pipeline[11] <= 0;
        delay_pipeline[12] <= 0;
        delay_pipeline[13] <= 0;
        delay_pipeline[14] <= 0;
        delay_pipeline[15] <= 0;
        delay_pipeline[16] <= 0;
        delay_pipeline[17] <= 0;
        delay_pipeline[18] <= 0;
        delay_pipeline[19] <= 0;
        delay_pipeline[20] <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          delay_pipeline[0] <= lpf_in;
          delay_pipeline[1] <= delay_pipeline[0];
          delay_pipeline[2] <= delay_pipeline[1];
          delay_pipeline[3] <= delay_pipeline[2];
          delay_pipeline[4] <= delay_pipeline[3];
          delay_pipeline[5] <= delay_pipeline[4];
          delay_pipeline[6] <= delay_pipeline[5];
          delay_pipeline[7] <= delay_pipeline[6];
          delay_pipeline[8] <= delay_pipeline[7];
          delay_pipeline[9] <= delay_pipeline[8];
          delay_pipeline[10] <= delay_pipeline[9];
          delay_pipeline[11] <= delay_pipeline[10];
          delay_pipeline[12] <= delay_pipeline[11];
          delay_pipeline[13] <= delay_pipeline[12];
          delay_pipeline[14] <= delay_pipeline[13];
          delay_pipeline[15] <= delay_pipeline[14];
          delay_pipeline[16] <= delay_pipeline[15];
          delay_pipeline[17] <= delay_pipeline[16];
          delay_pipeline[18] <= delay_pipeline[17];
          delay_pipeline[19] <= delay_pipeline[18];
          delay_pipeline[20] <= delay_pipeline[19];
        end
      end
    end // Delay_Pipeline_process


  assign mul_temp = delay_pipeline[20] * coeff21;
  assign product21 = mul_temp[30:0];

  assign mul_temp_1 = delay_pipeline[19] * coeff20;
  assign product20 = mul_temp_1[30:0];

  assign mul_temp_2 = delay_pipeline[18] * coeff19;
  assign product19 = mul_temp_2[30:0];

  assign mul_temp_3 = delay_pipeline[17] * coeff18;
  assign product18 = mul_temp_3[30:0];

  assign mul_temp_4 = delay_pipeline[16] * coeff17;
  assign product17 = mul_temp_4[30:0];

  assign mul_temp_5 = delay_pipeline[15] * coeff16;
  assign product16 = mul_temp_5[30:0];

  assign mul_temp_6 = delay_pipeline[14] * coeff15;
  assign product15 = mul_temp_6[30:0];

  assign mul_temp_7 = delay_pipeline[13] * coeff14;
  assign product14 = mul_temp_7[30:0];

  assign mul_temp_8 = delay_pipeline[12] * coeff13;
  assign product13 = mul_temp_8[30:0];

  assign mul_temp_9 = delay_pipeline[11] * coeff12;
  assign product12 = mul_temp_9[30:0];

  assign mul_temp_10 = delay_pipeline[10] * coeff11;
  assign product11 = mul_temp_10[30:0];

  assign mul_temp_11 = delay_pipeline[9] * coeff10;
  assign product10 = mul_temp_11[30:0];

  assign mul_temp_12 = delay_pipeline[8] * coeff9;
  assign product9 = mul_temp_12[30:0];

  assign mul_temp_13 = delay_pipeline[7] * coeff8;
  assign product8 = mul_temp_13[30:0];

  assign mul_temp_14 = delay_pipeline[6] * coeff7;
  assign product7 = mul_temp_14[30:0];

  assign mul_temp_15 = delay_pipeline[5] * coeff6;
  assign product6 = mul_temp_15[30:0];

  assign mul_temp_16 = delay_pipeline[4] * coeff5;
  assign product5 = mul_temp_16[30:0];

  assign mul_temp_17 = delay_pipeline[3] * coeff4;
  assign product4 = mul_temp_17[30:0];

  assign mul_temp_18 = delay_pipeline[2] * coeff3;
  assign product3 = mul_temp_18[30:0];

  assign mul_temp_19 = delay_pipeline[1] * coeff2;
  assign product2 = mul_temp_19[30:0];

  assign product1_cast = $signed({{3{product1[30]}}, product1});

  assign mul_temp_20 = delay_pipeline[0] * coeff1;
  assign product1 = mul_temp_20[30:0];

  assign add_signext = product1_cast;
  assign add_signext_1 = $signed({{3{product2[30]}}, product2});
  assign add_temp = add_signext + add_signext_1;
  assign sum1 = add_temp[33:0];

  assign add_signext_2 = sum1;
  assign add_signext_3 = $signed({{3{product3[30]}}, product3});
  assign add_temp_1 = add_signext_2 + add_signext_3;
  assign sum2 = add_temp_1[33:0];

  assign add_signext_4 = sum2;
  assign add_signext_5 = $signed({{3{product4[30]}}, product4});
  assign add_temp_2 = add_signext_4 + add_signext_5;
  assign sum3 = add_temp_2[33:0];

  assign add_signext_6 = sum3;
  assign add_signext_7 = $signed({{3{product5[30]}}, product5});
  assign add_temp_3 = add_signext_6 + add_signext_7;
  assign sum4 = add_temp_3[33:0];

  assign add_signext_8 = sum4;
  assign add_signext_9 = $signed({{3{product6[30]}}, product6});
  assign add_temp_4 = add_signext_8 + add_signext_9;
  assign sum5 = add_temp_4[33:0];

  assign add_signext_10 = sum5;
  assign add_signext_11 = $signed({{3{product7[30]}}, product7});
  assign add_temp_5 = add_signext_10 + add_signext_11;
  assign sum6 = add_temp_5[33:0];

  assign add_signext_12 = sum6;
  assign add_signext_13 = $signed({{3{product8[30]}}, product8});
  assign add_temp_6 = add_signext_12 + add_signext_13;
  assign sum7 = add_temp_6[33:0];

  assign add_signext_14 = sum7;
  assign add_signext_15 = $signed({{3{product9[30]}}, product9});
  assign add_temp_7 = add_signext_14 + add_signext_15;
  assign sum8 = add_temp_7[33:0];

  assign add_signext_16 = sum8;
  assign add_signext_17 = $signed({{3{product10[30]}}, product10});
  assign add_temp_8 = add_signext_16 + add_signext_17;
  assign sum9 = add_temp_8[33:0];

  assign add_signext_18 = sum9;
  assign add_signext_19 = $signed({{3{product11[30]}}, product11});
  assign add_temp_9 = add_signext_18 + add_signext_19;
  assign sum10 = add_temp_9[33:0];

  assign add_signext_20 = sum10;
  assign add_signext_21 = $signed({{3{product12[30]}}, product12});
  assign add_temp_10 = add_signext_20 + add_signext_21;
  assign sum11 = add_temp_10[33:0];

  assign add_signext_22 = sum11;
  assign add_signext_23 = $signed({{3{product13[30]}}, product13});
  assign add_temp_11 = add_signext_22 + add_signext_23;
  assign sum12 = add_temp_11[33:0];

  assign add_signext_24 = sum12;
  assign add_signext_25 = $signed({{3{product14[30]}}, product14});
  assign add_temp_12 = add_signext_24 + add_signext_25;
  assign sum13 = add_temp_12[33:0];

  assign add_signext_26 = sum13;
  assign add_signext_27 = $signed({{3{product15[30]}}, product15});
  assign add_temp_13 = add_signext_26 + add_signext_27;
  assign sum14 = add_temp_13[33:0];

  assign add_signext_28 = sum14;
  assign add_signext_29 = $signed({{3{product16[30]}}, product16});
  assign add_temp_14 = add_signext_28 + add_signext_29;
  assign sum15 = add_temp_14[33:0];

  assign add_signext_30 = sum15;
  assign add_signext_31 = $signed({{3{product17[30]}}, product17});
  assign add_temp_15 = add_signext_30 + add_signext_31;
  assign sum16 = add_temp_15[33:0];

  assign add_signext_32 = sum16;
  assign add_signext_33 = $signed({{3{product18[30]}}, product18});
  assign add_temp_16 = add_signext_32 + add_signext_33;
  assign sum17 = add_temp_16[33:0];

  assign add_signext_34 = sum17;
  assign add_signext_35 = $signed({{3{product19[30]}}, product19});
  assign add_temp_17 = add_signext_34 + add_signext_35;
  assign sum18 = add_temp_17[33:0];

  assign add_signext_36 = sum18;
  assign add_signext_37 = $signed({{3{product20[30]}}, product20});
  assign add_temp_18 = add_signext_36 + add_signext_37;
  assign sum19 = add_temp_18[33:0];

  assign add_signext_38 = sum19;
  assign add_signext_39 = $signed({{3{product21[30]}}, product21});
  assign add_temp_19 = add_signext_38 + add_signext_39;
  assign sum20 = add_temp_19[33:0];

  always @ (*)
    begin: Output_Register_process
      if (rst == 1'b1) begin
        output_register = 0;
      end
      else begin
        output_register = sum20;
      end
    end // Output_Register_process

  // Assignment Statements
  assign lpf_out = output_register;
endmodule  // filter






// -------------------------------------------------------------
//
// Module: lpf
// Generated by MATLAB(R) 9.12 and Filter Design HDL Coder 3.1.11.
// Generated on: 2022-09-14 16:15:07
// -------------------------------------------------------------

// -------------------------------------------------------------
// HDL Code Generation Options:
//
// TargetDirectory: /home/ck/do_sth_here/communication/DPSK/prj/rtl
// TargetLanguage: Verilog
// TestBenchStimulus: impulse step ramp chirp noise 

// -------------------------------------------------------------
// HDL Implementation    : Fully parallel
// Folding Factor        : 1
// -------------------------------------------------------------












/*


`timescale 1 ns / 1 ns

module lpf
               (
                clk,
                clk_enable,
                rst,
                lpf_in,
                lpf_out
                );

  input   clk; 
  input   clk_enable; 
  input   rst; 
  input   signed [15:0] lpf_in; //sfix16_En17
  output  signed [32:0] lpf_out; //sfix33_En34

////////////////////////////////////////////////////////////////
//Module Architecture: lpf
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  parameter signed [15:0] coeff1 = 16'b0000001111011110; //sfix16_En17
  parameter signed [15:0] coeff2 = 16'b0000110100100011; //sfix16_En17
  parameter signed [15:0] coeff3 = 16'b0001110101011101; //sfix16_En17
  parameter signed [15:0] coeff4 = 16'b0011001001001101; //sfix16_En17
  parameter signed [15:0] coeff5 = 16'b0100011001011110; //sfix16_En17
  parameter signed [15:0] coeff6 = 16'b0101001010111101; //sfix16_En17
  parameter signed [15:0] coeff7 = 16'b0101001010111101; //sfix16_En17
  parameter signed [15:0] coeff8 = 16'b0100011001011110; //sfix16_En17
  parameter signed [15:0] coeff9 = 16'b0011001001001101; //sfix16_En17
  parameter signed [15:0] coeff10 = 16'b0001110101011101; //sfix16_En17
  parameter signed [15:0] coeff11 = 16'b0000110100100011; //sfix16_En17
  parameter signed [15:0] coeff12 = 16'b0000001111011110; //sfix16_En17

  // Signals
  reg  signed [15:0] delay_pipeline [0:11] ; // sfix16_En17
  wire signed [30:0] product12; // sfix31_En34
  wire signed [31:0] mul_temp; // sfix32_En34
  wire signed [30:0] product11; // sfix31_En34
  wire signed [31:0] mul_temp_1; // sfix32_En34
  wire signed [30:0] product10; // sfix31_En34
  wire signed [31:0] mul_temp_2; // sfix32_En34
  wire signed [30:0] product9; // sfix31_En34
  wire signed [31:0] mul_temp_3; // sfix32_En34
  wire signed [30:0] product8; // sfix31_En34
  wire signed [31:0] mul_temp_4; // sfix32_En34
  wire signed [30:0] product7; // sfix31_En34
  wire signed [31:0] mul_temp_5; // sfix32_En34
  wire signed [30:0] product6; // sfix31_En34
  wire signed [31:0] mul_temp_6; // sfix32_En34
  wire signed [30:0] product5; // sfix31_En34
  wire signed [31:0] mul_temp_7; // sfix32_En34
  wire signed [30:0] product4; // sfix31_En34
  wire signed [31:0] mul_temp_8; // sfix32_En34
  wire signed [30:0] product3; // sfix31_En34
  wire signed [31:0] mul_temp_9; // sfix32_En34
  wire signed [30:0] product2; // sfix31_En34
  wire signed [31:0] mul_temp_10; // sfix32_En34
  wire signed [32:0] product1_cast; // sfix33_En34
  wire signed [30:0] product1; // sfix31_En34
  wire signed [31:0] mul_temp_11; // sfix32_En34
  wire signed [32:0] sum1; // sfix33_En34
  wire signed [32:0] add_signext; // sfix33_En34
  wire signed [32:0] add_signext_1; // sfix33_En34
  wire signed [33:0] add_temp; // sfix34_En34
  wire signed [32:0] sum2; // sfix33_En34
  wire signed [32:0] add_signext_2; // sfix33_En34
  wire signed [32:0] add_signext_3; // sfix33_En34
  wire signed [33:0] add_temp_1; // sfix34_En34
  wire signed [32:0] sum3; // sfix33_En34
  wire signed [32:0] add_signext_4; // sfix33_En34
  wire signed [32:0] add_signext_5; // sfix33_En34
  wire signed [33:0] add_temp_2; // sfix34_En34
  wire signed [32:0] sum4; // sfix33_En34
  wire signed [32:0] add_signext_6; // sfix33_En34
  wire signed [32:0] add_signext_7; // sfix33_En34
  wire signed [33:0] add_temp_3; // sfix34_En34
  wire signed [32:0] sum5; // sfix33_En34
  wire signed [32:0] add_signext_8; // sfix33_En34
  wire signed [32:0] add_signext_9; // sfix33_En34
  wire signed [33:0] add_temp_4; // sfix34_En34
  wire signed [32:0] sum6; // sfix33_En34
  wire signed [32:0] add_signext_10; // sfix33_En34
  wire signed [32:0] add_signext_11; // sfix33_En34
  wire signed [33:0] add_temp_5; // sfix34_En34
  wire signed [32:0] sum7; // sfix33_En34
  wire signed [32:0] add_signext_12; // sfix33_En34
  wire signed [32:0] add_signext_13; // sfix33_En34
  wire signed [33:0] add_temp_6; // sfix34_En34
  wire signed [32:0] sum8; // sfix33_En34
  wire signed [32:0] add_signext_14; // sfix33_En34
  wire signed [32:0] add_signext_15; // sfix33_En34
  wire signed [33:0] add_temp_7; // sfix34_En34
  wire signed [32:0] sum9; // sfix33_En34
  wire signed [32:0] add_signext_16; // sfix33_En34
  wire signed [32:0] add_signext_17; // sfix33_En34
  wire signed [33:0] add_temp_8; // sfix34_En34
  wire signed [32:0] sum10; // sfix33_En34
  wire signed [32:0] add_signext_18; // sfix33_En34
  wire signed [32:0] add_signext_19; // sfix33_En34
  wire signed [33:0] add_temp_9; // sfix34_En34
  wire signed [32:0] sum11; // sfix33_En34
  wire signed [32:0] add_signext_20; // sfix33_En34
  wire signed [32:0] add_signext_21; // sfix33_En34
  wire signed [33:0] add_temp_10; // sfix34_En34
  reg  signed [32:0] output_register; // sfix33_En34

  // Block Statements
  always @( posedge clk)
    begin: Delay_Pipeline_process
      if (rst == 1'b1) begin
        delay_pipeline[0] <= 0;
        delay_pipeline[1] <= 0;
        delay_pipeline[2] <= 0;
        delay_pipeline[3] <= 0;
        delay_pipeline[4] <= 0;
        delay_pipeline[5] <= 0;
        delay_pipeline[6] <= 0;
        delay_pipeline[7] <= 0;
        delay_pipeline[8] <= 0;
        delay_pipeline[9] <= 0;
        delay_pipeline[10] <= 0;
        delay_pipeline[11] <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          delay_pipeline[0] <= lpf_in;
          delay_pipeline[1] <= delay_pipeline[0];
          delay_pipeline[2] <= delay_pipeline[1];
          delay_pipeline[3] <= delay_pipeline[2];
          delay_pipeline[4] <= delay_pipeline[3];
          delay_pipeline[5] <= delay_pipeline[4];
          delay_pipeline[6] <= delay_pipeline[5];
          delay_pipeline[7] <= delay_pipeline[6];
          delay_pipeline[8] <= delay_pipeline[7];
          delay_pipeline[9] <= delay_pipeline[8];
          delay_pipeline[10] <= delay_pipeline[9];
          delay_pipeline[11] <= delay_pipeline[10];
        end
      end
    end // Delay_Pipeline_process


  assign mul_temp = delay_pipeline[11] * coeff12;
  assign product12 = mul_temp[30:0];

  assign mul_temp_1 = delay_pipeline[10] * coeff11;
  assign product11 = mul_temp_1[30:0];

  assign mul_temp_2 = delay_pipeline[9] * coeff10;
  assign product10 = mul_temp_2[30:0];

  assign mul_temp_3 = delay_pipeline[8] * coeff9;
  assign product9 = mul_temp_3[30:0];

  assign mul_temp_4 = delay_pipeline[7] * coeff8;
  assign product8 = mul_temp_4[30:0];

  assign mul_temp_5 = delay_pipeline[6] * coeff7;
  assign product7 = mul_temp_5[30:0];

  assign mul_temp_6 = delay_pipeline[5] * coeff6;
  assign product6 = mul_temp_6[30:0];

  assign mul_temp_7 = delay_pipeline[4] * coeff5;
  assign product5 = mul_temp_7[30:0];

  assign mul_temp_8 = delay_pipeline[3] * coeff4;
  assign product4 = mul_temp_8[30:0];

  assign mul_temp_9 = delay_pipeline[2] * coeff3;
  assign product3 = mul_temp_9[30:0];

  assign mul_temp_10 = delay_pipeline[1] * coeff2;
  assign product2 = mul_temp_10[30:0];

  assign product1_cast = $signed({{2{product1[30]}}, product1});

  assign mul_temp_11 = delay_pipeline[0] * coeff1;
  assign product1 = mul_temp_11[30:0];

  assign add_signext = product1_cast;
  assign add_signext_1 = $signed({{2{product2[30]}}, product2});
  assign add_temp = add_signext + add_signext_1;
  assign sum1 = add_temp[32:0];

  assign add_signext_2 = sum1;
  assign add_signext_3 = $signed({{2{product3[30]}}, product3});
  assign add_temp_1 = add_signext_2 + add_signext_3;
  assign sum2 = add_temp_1[32:0];

  assign add_signext_4 = sum2;
  assign add_signext_5 = $signed({{2{product4[30]}}, product4});
  assign add_temp_2 = add_signext_4 + add_signext_5;
  assign sum3 = add_temp_2[32:0];

  assign add_signext_6 = sum3;
  assign add_signext_7 = $signed({{2{product5[30]}}, product5});
  assign add_temp_3 = add_signext_6 + add_signext_7;
  assign sum4 = add_temp_3[32:0];

  assign add_signext_8 = sum4;
  assign add_signext_9 = $signed({{2{product6[30]}}, product6});
  assign add_temp_4 = add_signext_8 + add_signext_9;
  assign sum5 = add_temp_4[32:0];

  assign add_signext_10 = sum5;
  assign add_signext_11 = $signed({{2{product7[30]}}, product7});
  assign add_temp_5 = add_signext_10 + add_signext_11;
  assign sum6 = add_temp_5[32:0];

  assign add_signext_12 = sum6;
  assign add_signext_13 = $signed({{2{product8[30]}}, product8});
  assign add_temp_6 = add_signext_12 + add_signext_13;
  assign sum7 = add_temp_6[32:0];

  assign add_signext_14 = sum7;
  assign add_signext_15 = $signed({{2{product9[30]}}, product9});
  assign add_temp_7 = add_signext_14 + add_signext_15;
  assign sum8 = add_temp_7[32:0];

  assign add_signext_16 = sum8;
  assign add_signext_17 = $signed({{2{product10[30]}}, product10});
  assign add_temp_8 = add_signext_16 + add_signext_17;
  assign sum9 = add_temp_8[32:0];

  assign add_signext_18 = sum9;
  assign add_signext_19 = $signed({{2{product11[30]}}, product11});
  assign add_temp_9 = add_signext_18 + add_signext_19;
  assign sum10 = add_temp_9[32:0];

  assign add_signext_20 = sum10;
  assign add_signext_21 = $signed({{2{product12[30]}}, product12});
  assign add_temp_10 = add_signext_20 + add_signext_21;
  assign sum11 = add_temp_10[32:0];

  always @ (*)
    begin: Output_Register_process
      if (rst == 1'b1) begin
        output_register = 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          output_register = sum11;
        end
      end
    end // Output_Register_process

  // Assignment Statements
  assign lpf_out = sum11;
endmodule  // lpf
*/