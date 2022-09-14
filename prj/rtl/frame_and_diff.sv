`include "head.v"
/*
将uart输入的8bit信号当做数据信号，与预设帧头组成完整的帧之后差分化
差分后的数据是以50mhz输出的，后续的模块需要将其存入fifo以便降低速率到fs
每1bit diff_mod_data应当控制fc/fb个载波，每个载波中有fs/fc个采样点，即每bit
占用fs/fb个点，每个点的速率应当是Tb/(fs/fb)=fs



*/
module frame_and_diff(
    input sys_clk
    ,input rst
    ,input [`UART_DATA_WIDTH-1:0] uart_frame_data
    ,input uart_frame_valid
    //,input mod_frame_ready

    ,output frame_uart_ready
    ,output diff_mod_valid
    ,output diff_mod_data

);
`ifdef DIFF_FIRST
    parameter DIFF_FIRST = 1;
`else
    parameter DIFF_FIRST = 0;
`endif
reg diff_mod_valid_t;
//输出
reg frame_uart_ready_t;
wire flag_ready_down;
wire flag_ready_up;

//reg diff_mod_valid_t;
reg diff_mod_data_t ;


//
reg [`FRAME_TOTAL_LEN-1:0]  frame;
wire flag_wr_frame;
reg [15:0]  cnt_data;
wire flag_clear_cnt_data;
wire flag_add_cnt_data;
reg [15:0]  cnt_diff;
wire flag_clear_cnt_diff;
wire flag_add_cnt_diff;




always @(posedge sys_clk) begin
    if(rst | flag_clear_cnt_data)begin 
        cnt_data <= 15'd0;
    end
    else if(flag_add_cnt_data)begin 
        cnt_data <= cnt_data + 1'b1 ;
    end
    else begin 
        ;
    end
end
assign flag_clear_cnt_data = cnt_diff == `FRAME_TOTAL_LEN - 1;
assign flag_add_cnt_data = (cnt_data != (`FRAME_DATA_LEN/8)-1)&uart_frame_valid;


always @(posedge sys_clk) begin
    if(rst | flag_clear_cnt_diff)begin 
        cnt_diff <= 0;
    end
    else if(flag_add_cnt_diff)begin 
        cnt_diff <= cnt_diff + 1'b1 ;
    end
    else begin 
        ;
    end
end
assign flag_clear_cnt_diff = cnt_diff == `FRAME_TOTAL_LEN - 1;
assign flag_add_cnt_diff = ((cnt_data == (`FRAME_DATA_LEN/8)-1)&uart_frame_valid)
                                |cnt_diff != 0
                                ;


always @(posedge sys_clk)begin 
    if(rst)begin 
        frame[`FRAME_HEAD_LEN-1:0] = `FRAME_HEAD;
    end
    else if(flag_wr_frame)begin 
        frame[8*(cnt_data)+`FRAME_HEAD_LEN+:8]=
            uart_frame_data  ;
    end
    else begin 
        ;
    end
end

assign  flag_wr_frame = uart_frame_valid & frame_uart_ready;

always @(posedge sys_clk)begin 
    if(rst)begin 
        frame_uart_ready_t <= 1;
    end
    else if(flag_ready_down)begin 
        frame_uart_ready_t <= 0;
    end
    else if(flag_ready_up)begin 
        frame_uart_ready_t <= 1;
    end
    else begin 
        ;
    end
end
assign flag_ready_down = (cnt_data == `FRAME_DATA_LEN/8 - 1) & uart_frame_valid;
assign flag_ready_up   = cnt_diff == `FRAME_TOTAL_LEN - 1;


always @(posedge sys_clk)begin 
    if(cnt_diff == 0)begin 
        diff_mod_data_t <= 1 ^ frame[cnt_diff];
    end
    else begin 
        diff_mod_data_t <= diff_mod_data_t ^ frame[cnt_diff];
    end
end
always @(posedge sys_clk)begin 
    diff_mod_valid_t <= flag_add_cnt_diff;
end

assign frame_uart_ready = frame_uart_ready_t;
assign diff_mod_data        = diff_mod_data_t;
assign diff_mod_valid   = diff_mod_valid_t;
endmodule