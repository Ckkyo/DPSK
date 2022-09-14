`include "head.v"

module uart_send(
    input                           sys_clk 
    ,input                          rst
    
    ,input [`UART_DATA_WIDTH-1:0]   deframe_uart_data
    ,input                          deframe_uart_data_vld

    ,output                         uart_deframe_ready
    ,output                         uart_tx
);
parameter   SYS_CLK_FREQ= `SYS_CLK_FREQ     ;
parameter   BPS         = `UART_BPS         ;
parameter   DATA_WIDTH  = `UART_DATA_WIDTH  ;
parameter   CNT_CLK_MAX = SYS_CLK_FREQ/BPS-1;
parameter   CNT_TX_MAX  = DATA_WIDTH + 2-1  ;

parameter   FSM_IDLE    = 2'b0                 ;
parameter   FSM_SENDING = 2'b1                 ;
//对输出做寄存处理
reg                         tx_ready_t   ;
reg                         uart_tx_t    ; 

//
reg [CNT_TX_MAX:0]  tx_data              ;//对输入缓存

//计数器
reg [15:0]                  cnt_clk      ;
reg [3:0]                   cnt_tx       ;

//指示正在发送
reg                         flag_sending ;


//状态机
reg [0:0]                   fsm_cs       ;
reg [0:0]                   fsm_ns       ;

always @(posedge sys_clk)begin 
    if(rst)begin 
        fsm_cs <= FSM_IDLE;
        //fsm_ns <= 1;
    end
    else begin 
        fsm_cs <= fsm_ns;
    end
end

integer t_tx   ;
always @(posedge sys_clk)begin:fsm
    if(rst)begin 
        fsm_ns      <= FSM_IDLE     ;
        tx_ready_t  <= 1'b0            ;
        //tx_data   <= 0            ;
        cnt_clk     <= 16'd0            ;
        cnt_tx      <= 4'd0            ;
        uart_tx_t   <= 1'b1            ;
    end
    else begin 
        case (fsm_cs)
            FSM_IDLE    :begin 
                tx_ready_t  <= 1'b1           ;
                cnt_clk     <= 1'b0            ;
                cnt_tx      <= 0            ;               
                if(tx_ready_t&deframe_uart_data_vld)begin 
                    //tx_ready_t  <=  0                           ;
                    tx_data     <=  {1'b1,deframe_uart_data,1'b0}    ;
                    fsm_ns      <=  FSM_SENDING                 ;
                end
            end
            FSM_SENDING :begin 
                tx_ready_t  <=  0           ;
                if(cnt_clk < CNT_CLK_MAX)begin 
                    cnt_clk <=  cnt_clk + 1 ;
                end
                else begin 
                    cnt_clk <=  0           ;
                end
                if(cnt_clk == CNT_CLK_MAX)begin 
                    cnt_tx  <=  cnt_tx + 1  ;
                end
                else begin 
                    ;
                end


                uart_tx_t   <=  tx_data [cnt_tx];
                if(cnt_clk == CNT_CLK_MAX/2 & cnt_tx == CNT_TX_MAX )begin //提前结束状态
                    fsm_ns  <=  FSM_IDLE    ;
                    tx_ready_t  <=  1   ;
                    //cnt_clk     <= 0            ;
                    //cnt_tx      <= 0            ;
                end
            end 
            default:begin 
                fsm_ns      <= FSM_IDLE ;
                tx_ready_t  <= 0        ;
            end 
        endcase
    end
end


//当数据valid且send模块处于ready状态的时候启动两个计数器
//如果数据valid但是正处于sending状态的时候，应当继续计数而不被清空

assign uart_deframe_ready    =   tx_ready_t  ;
assign uart_tx          =   uart_tx_t   ;




endmodule