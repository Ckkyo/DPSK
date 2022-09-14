`include "head.v"
module top(
    input sys_clk,
    input rst_n,
    input rx,
    (* MARK_DEBUG="true" *)input [7:0] adc_data,
    (* MARK_DEBUG="true" *)input adc_otr,
    output tx,

    output led,

    (* MARK_DEBUG="true" *)output [7:0] dac_data,
    (* MARK_DEBUG="true" *)output adc_clk,
    output dac_clk

);
assign led = ~adc_otr ;
    reg rst ;
    always @(posedge sys_clk)begin 
        rst <= ~rst_n;
    end

    wire        frame_uart_ready     ;
    wire        uart_frame_valid     ;
    wire [7:0]  uart_frame_data      ;
    wire        diff_mod_valid       ;
    wire        diff_mod_data        ;

    wire        mod_dac_valid       ;
    wire  [7:0] mod_dac_data        ;

    wire        adc_costas_data_valid;
    wire signed [7:0] adc_costas_data;

    (* MARK_DEBUG="true" *)wire costas_bitsync_data;
    (* MARK_DEBUG="true" *)wire costas_bitsync_valid;
    (* MARK_DEBUG="true" *)wire bitsync_data;
    (* MARK_DEBUG="true" *)wire bitsync_data_valid;    
    wire [7:0] deframe_uart_data;
    wire deframe_uart_data_vld;
    wire uart_deframe_ready;

//rst u_rst(
//    .sys_clk(sys_clk)   ,
//    .rst_n(rst_n)   ,//此开发板上的按键默认为高，按下为低，因此下面使用下降沿
//    .rst(rst)    //

//);

    uart_rec u_uart_rec(
        .sys_clk(sys_clk),
        .rst(rst),
        .uart_rx(rx),
        .uart_rx_ready(1),
        .uart_rx_valid(uart_frame_valid),
        .uart_rx_data(uart_frame_data)
    );

    mod_top u_mod_top(
        .sys_clk(sys_clk),
        .rst(rst),
        .uart_mod_valid(uart_frame_valid),
        .uart_mod_data(uart_frame_data),
        .mod_uart_ready(frame_uart_ready),
        .mod_dac_data(mod_dac_data),
        .mod_dac_valid(mod_dac_valid)
    );

    dac u_dac(
        .sys_clk(sys_clk),
        .rst(rst),
        .mod_dac_data(mod_dac_data+8'd128),
        .mod_dac_valid(mod_dac_valid),
        .dac_clk(dac_clk),
        .dac_data(dac_data)
    );













//----------------------------------------------------------------


    adc u_adc(
        .sys_clk(sys_clk),
        .rst(rst),
        .adc_data(adc_data),
        .adc_otr(adc_otr),
        .adc_costas_data(adc_costas_data),
        .adc_costas_data_valid(adc_costas_valid),
        .adc_clk(adc_clk)
    );









    costas u_costas(
        .sys_clk(sys_clk),
        .rst(rst),
        .adc_costas_data(adc_costas_data+8'b1000_0000),
        .adc_costas_valid(adc_costas_valid),
        .costas_bitsync_data(costas_bitsync_data),
        .costas_bitsync_valid(costas_bitsync_valid)
    );

    bit_sync u_bit_sync(
    .sys_clk(sys_clk),
    .rst(rst),
    .costas_bitsync_data(costas_bitsync_data),
    .bitsync_data(bitsync_data),
    .bitsync_data_valid(bitsync_data_valid)
    );

    deframe u_deframe(
        .sys_clk(sys_clk),
        .rst(rst),
        .bitsync_deframe_data(bitsync_data),
        .bitsync_deframe_data_vld(bitsync_data_valid),
        .deframe_uart_data(deframe_uart_data),
        .deframe_uart_data_vld(deframe_uart_data_vld),
        .uart_deframe_ready(uart_deframe_ready)
    );

    uart_send u_uart_send(
        .sys_clk(sys_clk), 
        .rst(rst),

        .deframe_uart_data(deframe_uart_data),
        .deframe_uart_data_vld(deframe_uart_data_vld),
        .uart_deframe_ready(uart_deframe_ready),
        .uart_tx(tx)
    );










endmodule