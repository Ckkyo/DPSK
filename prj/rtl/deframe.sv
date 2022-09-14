`include "head.v"




module deframe(
    input   sys_clk
    ,input  rst

    ,input  bitsync_deframe_data
    ,input  bitsync_deframe_data_vld

    ,output [7:0] deframe_uart_data 
    ,output deframe_uart_data_vld
    ,input  uart_deframe_ready
);
parameter FSM_CHECK_HEAD    = 2'd0           ;
parameter FSM_RECEIVE_FRAME = 2'd1           ;
parameter HEAD_FRAME1   =   32'h5555_ffff;
parameter HEAD_FRAME2   =   32'haaaa_0000;
parameter FRAME_DATA_LEN=   `FRAME_DATA_LEN       ;

wire fsm_ch2rf              ;   
wire fsm_rf2ch              ;
reg [1:0] fsm_cs            ;
reg [1:0] fsm_ns            ;

reg [15:0]cnt_data;
wire flag_cnt_data_clear    ;
wire flag_cnt_data_add      ;

reg [7:0] uart_data_t       ;
reg deframe_uart_data_vld_t ;

assign deframe_uart_data     = uart_data_t              ;
assign deframe_uart_data_vld = deframe_uart_data_vld_t  ;

reg [31:0] check_head;

genvar i_ch;//check head
generate 
    for (i_ch=0;i_ch<32;i_ch=i_ch+1)begin
        if(i_ch==0)begin 
            always @(posedge sys_clk)begin 
                if(bitsync_deframe_data_vld)begin    
                    check_head[i_ch] <= bitsync_deframe_data;
                end
                else begin 
                    ;
                end
            end 
        end
        else begin
            always @(posedge sys_clk)begin 
                if(bitsync_deframe_data_vld)begin      
                    check_head[i_ch] <= check_head[i_ch-1];
                end
                else begin 
                    ;
                end
            end
        end
    end
endgenerate



always @(posedge sys_clk)begin 
    if(rst)begin 
        fsm_cs <= FSM_CHECK_HEAD ;
    end
    else begin 
        fsm_cs <= fsm_ns ;
    end
end


always @(posedge sys_clk)begin 
    if(rst)begin 
        fsm_ns <= FSM_CHECK_HEAD ;
    end
    else begin 
        case (fsm_cs)
            FSM_CHECK_HEAD:begin 
                if(fsm_ch2rf)begin 
                    fsm_ns <= FSM_RECEIVE_FRAME ;
                end
                else begin 
                    ;
                end
            end 
            FSM_RECEIVE_FRAME:begin 
                if(fsm_rf2ch)begin 
                    fsm_ns <= FSM_CHECK_HEAD ;
                end
            end
            default: fsm_ns <= FSM_CHECK_HEAD ;
        endcase
    end
end

assign fsm_ch2rf = (fsm_cs==FSM_CHECK_HEAD)&((check_head==HEAD_FRAME1)|(check_head==HEAD_FRAME2));
assign fsm_rf2ch = (fsm_cs==FSM_RECEIVE_FRAME)&(cnt_data == FRAME_DATA_LEN - 1'b1);

//always @(*)begin 
//    if(rst)begin 
//
//    end
//    else begin 
//        case (fsm_cs)
//            FSM_CHECK_HEAD: begin 
//
//            end
//            FSM_RECEIVE_FRAME:begin 
//
//            end
//            default:; 
//        endcase
//    end
//end

always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_data <= 16'd0;
    end
    else if(flag_cnt_data_clear) begin 
        cnt_data <= 16'd0;
    end
    else if(flag_cnt_data_add) begin 
        cnt_data <= cnt_data + 1'b1;
    end
end
assign flag_cnt_data_clear = (fsm_cs==FSM_CHECK_HEAD)|(cnt_data == FRAME_DATA_LEN - 1'b1);
assign flag_cnt_data_add   = (fsm_cs==FSM_RECEIVE_FRAME)&bitsync_deframe_data_vld;


reg pre_bitsync_deframe_data;
always @(posedge sys_clk)begin 
    if(rst)begin 
        uart_data_t <= 1'b0;
        pre_bitsync_deframe_data <= 1'b0;
    end
    else begin 
        if(fsm_cs == FSM_RECEIVE_FRAME & bitsync_deframe_data_vld)begin 
            pre_bitsync_deframe_data            <= bitsync_deframe_data;
            if(cnt_data == 0)begin 
                uart_data_t[cnt_data[2:0]] <= check_head[0] ^ bitsync_deframe_data;
            end
            else begin 
                uart_data_t[cnt_data[2:0]] <= pre_bitsync_deframe_data ^ bitsync_deframe_data;
            end
        end
    end
end
reg bitsync_deframe_data_vld_delay;

always @(posedge sys_clk)begin 
    bitsync_deframe_data_vld_delay <= bitsync_deframe_data_vld;
end
always @(posedge sys_clk)begin 
    if(rst)begin 
        deframe_uart_data_vld_t <= 0;
    end
    else begin 
        if(fsm_cs == FSM_RECEIVE_FRAME & bitsync_deframe_data_vld_delay &cnt_data[2:0] == 3'd7)begin 
            deframe_uart_data_vld_t <= 1'b1;
        end
        else begin 
            deframe_uart_data_vld_t <= 1'b0;
        end
    end
end


endmodule