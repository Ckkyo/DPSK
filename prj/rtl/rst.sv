//此模块对输入的复位信号同步处理，以在后续可以使用
//同步复位同步释放或者异步复位同步释放策略
//xilinx建议使用高电平进行复位，而且释放使用同步
module rst(
    input sys_clk   ,
    input rst_n   ,//此开发板上的按键默认为高，按下为低，因此下面使用下降沿
    output rst    

);
reg [3:0]   rst_t ;
always @(posedge sys_clk or negedge rst_n)
    if(!rst_n)begin 
        rst_t   <= 4'b1111;
    end
    else begin 
        rst_t[0]    <= 1'b0;
        rst_t[1]    <= rst_t[0];
        rst_t[2]    <= rst_t[1];
        rst_t[3]    <= rst_t[2];
    end
assign rst  = rst_t[4];




endmodule