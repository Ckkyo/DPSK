`include "head.v"
module adc(
    input                 sys_clk               , 
    input                 rst                   ,  

    input         [7:0]   adc_data              ,  
    input                 adc_otr               ,
    output                adc_costas_data_valid ,  
    output        [7:0]   adc_costas_data       ,
    output                adc_clk         
    );


parameter FS        = `FS;
parameter CLK_FREQ  = `SYS_CLK_FREQ;
parameter CNT_DIV_MAX = (CLK_FREQ /(FS)) ;

reg                     adc_costas_data_valid_t;
reg        [7:0]        adc_costas_data_t;
reg                     adc_clk_t;

reg [19:0]              cnt_div;

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
        adc_clk_t <= CNT_DIV_MAX/4;
    end
    else if(cnt_div == CNT_DIV_MAX/2)begin 
        adc_clk_t <= 0 ;
    end
    else if(cnt_div == CNT_DIV_MAX)begin 
        adc_clk_t <= 1;
    end
end

always @(posedge sys_clk)begin 
    if(rst)begin 
        adc_costas_data_t <= 0;
    end
    else if(cnt_div == CNT_DIV_MAX) begin 
        adc_costas_data_t <= adc_data ;
    end
end
always @(posedge sys_clk)begin 
    if(rst)begin 
        adc_costas_data_valid_t <= 0;
    end
    else if(cnt_div == CNT_DIV_MAX) begin 
        adc_costas_data_valid_t <= 1 ;
    end
    else begin 
        adc_costas_data_valid_t <= 0 ;
    end
end


assign adc_clk = adc_clk_t ;
assign adc_costas_data= adc_costas_data_t;
assign adc_costas_data_valid=adc_costas_data_valid_t;
endmodule