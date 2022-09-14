`include "head.v"
module mod_top(
    input sys_clk
    ,input rst
    ,input uart_mod_valid
    ,input [`UART_DATA_WIDTH-1:0] uart_mod_data

    ,output mod_uart_ready
    ,output [`VCO_PRECISE-1:0]mod_dac_data 
    ,output mod_dac_valid
);

wire [`UART_DATA_WIDTH-1:0]uart_frame_data;
wire frame_uart_ready;
wire diff_mod_valid;
wire diff_mod_data;

wire mod_busy ;


assign uart_frame_valid = uart_mod_valid &(mod_uart_ready);
assign uart_frame_data  = uart_mod_data  ;
assign mod_uart_ready   = frame_uart_ready & (~mod_busy) &(~diff_mod_valid);





    frame_and_diff u_frame_diff(
        .sys_clk(sys_clk),
        .rst(rst),
        .uart_frame_data(uart_frame_data),
        .uart_frame_valid(uart_frame_valid),
        .frame_uart_ready(frame_uart_ready),
        .diff_mod_valid(diff_mod_valid),
        .diff_mod_data(diff_mod_data)

    );

    mod u_mod(
        .sys_clk(sys_clk),
        .rst(rst),
        .diff_mod_data(diff_mod_data),
        .diff_mod_valid(diff_mod_valid),
        .dac_mod_ready(),
        .mod_dac_data(mod_dac_data),
        .mod_dac_valid(mod_dac_valid),
        .mod_busy(mod_busy)
    );











    endmodule