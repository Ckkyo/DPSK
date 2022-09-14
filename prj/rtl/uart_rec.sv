`include "head.v"
module uart_rec(
    input                           sys_clk
    ,input                          rst
    ,input                          uart_rx
    ,input                          uart_rx_ready
    ,output                         uart_rx_valid
    //,(* MARK_DEBUG="true" *) output [`UART_DATA_WIDTH-1:0]  uart_rx_data
    ,output [`UART_DATA_WIDTH-1:0]  uart_rx_data
    
    
);
parameter   SYS_CLK_FREQ= `SYS_CLK_FREQ     ;
parameter   BPS         = `UART_BPS         ;
parameter   DATA_WIDTH  = `UART_DATA_WIDTH  ;
parameter   CNT_CLK_MAX = SYS_CLK_FREQ/BPS-1;
parameter   CNT_RX_MAX  = DATA_WIDTH + 1    ;


//output 的临时reg变量
reg [DATA_WIDTH-1:0]    rx_data         ;
reg                     rx_valid        ;


reg [1:0]               uart_rx_delay   ;
reg [15:0]              cnt_clk         ;
reg [3:0]               cnt_rx          ;

reg                     flag_rx         ;//数据接收开始标志

assign uart_rx_valid    =rx_valid       ;
assign uart_rx_data     =rx_data        ;
wire                    flag_negedge_rx ;
wire [DATA_WIDTH + 1:1] rx_data_write_en;
//wire flag_cnt_clk_start                 ;
//wire flag_cnt_clk_suspend               ;
wire flag_cnt_clk_continue              ;
wire flag_cnt_clk_clear                 ;

//wire flag_cnt_rx_start                ;
//wire flag_cnt_rx_suspend              ;
wire flag_cnt_rx_continue             ;
wire flag_cnt_rx_clear                ;

//checking rx's negedge used for start counter 
always @(posedge sys_clk)begin 
    if(rst)begin 
        uart_rx_delay   <= 2'b0;
    end
    else begin 
        uart_rx_delay[0] <= uart_rx             ;
        uart_rx_delay[1] <= uart_rx_delay[0]    ; 
    end
end
assign flag_negedge_rx  = (~uart_rx_delay[0])&uart_rx_delay[1]  ;

//控制flag_rx
always @(posedge sys_clk)begin 
    if(rst)begin 
        flag_rx     <= 1'b0     ;
    end
    else begin 
        if(flag_negedge_rx)begin 
            flag_rx     <= 1'b1     ;
        end
        else if((cnt_clk == CNT_CLK_MAX/2 )&(cnt_rx == CNT_RX_MAX))begin 
            flag_rx     <= 1'b0     ;
        end
        else begin 
            flag_rx     <= flag_rx  ;
        end
    end
end



//cnt_clk
always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_clk     <= 16'd0            ;
    end
    else if(flag_cnt_clk_clear)begin 
        cnt_clk     <= 16'd0            ;
    end
    else if(flag_cnt_clk_continue)begin 
        cnt_clk     <= cnt_clk + 1'b1   ;
    end
    else begin 
        cnt_clk     <= cnt_clk          ;
    end
end
assign flag_cnt_clk_clear   = (cnt_clk == CNT_CLK_MAX)|(~flag_rx)   ;
assign flag_cnt_clk_continue= flag_rx                               ;

//cnt_rx
always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_rx      <= 4'd0             ;
    end
    else if(flag_cnt_rx_clear)begin 
        cnt_rx      <= 4'd0             ;
    end
    else if(flag_cnt_rx_continue)begin 
        cnt_rx      <= cnt_rx + 1'b1    ;
    end
    else begin 
        cnt_rx      <= cnt_rx           ;
    end
end
assign flag_cnt_rx_clear    = (cnt_clk ==CNT_CLK_MAX/2 & cnt_rx == CNT_RX_MAX)
                              |(~flag_rx);
assign flag_cnt_rx_continue = flag_rx & cnt_clk ==CNT_CLK_MAX;

genvar i;
generate 
    for (i=1;i<=DATA_WIDTH;i=i+1) begin 
        always @(posedge sys_clk)begin 
            if(rst)begin 
                rx_data[i-1] <= 1'b0;
            end
            else if(cnt_rx==i & cnt_clk == CNT_CLK_MAX/2)begin 
                rx_data[i-1] <= uart_rx ;
            end
        end
        if(i==DATA_WIDTH)begin 
            always @(posedge sys_clk )begin 
                if(rst)begin 
                    rx_valid <= 0;
                end
                else if(rx_valid & (uart_rx_ready | cnt_clk == CNT_CLK_MAX))begin 
                    rx_valid <= 0;
                end
                else if(cnt_rx==i & cnt_clk == CNT_CLK_MAX/2)begin 
                    rx_valid <= 1;
                end
                else begin 
                    ;
                end

            end
        end
    end
endgenerate



endmodule