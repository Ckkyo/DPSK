`include "head.v"
module dac(
    input                 sys_clk,  
    input                 rst    ,  
    
    input        [7:0]    mod_dac_data,  
    input                 mod_dac_valid,

    output                dac_clk ,  
    output       [7:0]    dac_data   
    );
parameter FS        = `FS;
parameter CLK_FREQ  = `SYS_CLK_FREQ;
parameter CNT_DIV_MAX = CLK_FREQ /(FS) ;
reg dac_clk_t ;
reg [7:0] dac_data_t;

reg [19:0] cnt_div ;


always @(posedge sys_clk ) begin
    if(rst)begin 
        cnt_div <= 0;
    end
    else if(cnt_div == CNT_DIV_MAX) begin 
        cnt_div <= 0;
    end
    else begin 
        cnt_div <= cnt_div + 1;
    end
end


always @(posedge sys_clk)begin 
    if(rst)begin 
        dac_clk_t <= 0;
    end
    else if(cnt_div == CNT_DIV_MAX/2)begin 
        dac_clk_t <= 1 ;
    end
    else if(cnt_div == CNT_DIV_MAX)begin 
        dac_clk_t <= 0;
    end
end

always @(posedge sys_clk)begin 
    if(rst)begin 
        dac_data_t <= 0;
    end
    else if(cnt_div == CNT_DIV_MAX) begin 
        dac_data_t <= mod_dac_data ;
    end
end

assign dac_clk = dac_clk_t ;
assign dac_data= dac_data_t;








endmodule