`include "head.v"
module bit_sync(
    input   sys_clk
    ,input  rst

    ,input  costas_bitsync_data
    
    ,output bitsync_data 
    ,output bitsync_data_valid
);
parameter   N               = 10                                    ;
parameter   FB              = `FB                                   ;
parameter   BASE            = 2**N                                  ;
parameter   signed CLK_DIV_MAX     = BASE * (`SYS_CLK_FREQ / FB)    ;
parameter   C1              = (1)*(BASE)/(4)                          ;
parameter   C2              = BASE/8                                ;

reg [3:0] bitsync_data_valid_t  ;
reg       bitsync_data_t        ;

reg   signed [31:0]  cnt_div         ;
wire  signed [31:0]  cnt_div_t       ;
reg                 check_inv       ;
reg                 div_clk_en      ;
reg                 div_clk_en_delay;



reg  signed [31:0]  cnt_delay_sum   ;
reg  signed [31:0]  cnt_delay       ;

reg  signed [31:0]  cnt_delay1      ;
wire        flag_cnt_delay1_add     ;
wire        flag_cnt_delay1_clear   ;

reg  signed [31:0]  cnt_delay2      ;
wire        flag_cnt_delay2_add     ;
wire        flag_cnt_delay2_clear   ;

reg         data_delay              ;
reg         data_change             ;

always @(posedge sys_clk)begin 
    data_delay  <= costas_bitsync_data;
end

always @(*)begin 
    data_change = data_delay ^ costas_bitsync_data;
end

reg [31:0] c1_mul_delay;
reg [31:0] c2_mul_delay_sum ;
always @(posedge sys_clk)begin 
    c1_mul_delay <= C1 * cnt_delay;
    c2_mul_delay_sum <= C2*cnt_delay_sum_t>>>8;
    
end
assign cnt_div_t = cnt_div + BASE +c1_mul_delay+((c2_mul_delay_sum));
always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_div <= 32'd0    ;
    end
    else if(cnt_div_t >= CLK_DIV_MAX ) begin 
        cnt_div <= cnt_div_t - CLK_DIV_MAX;
    end
    else if(cnt_div_t<0)begin 
        cnt_div <= cnt_div_t + CLK_DIV_MAX;
    end
    else begin 
        cnt_div <= cnt_div_t ;
    end

end
always @(posedge sys_clk)begin 
    if(rst)begin 
        div_clk_en <= 1'd0;
    end
    else if(cnt_div_t >= CLK_DIV_MAX &(~check_inv)) begin 
        div_clk_en <= 1'd1;
    end
    else begin 
        div_clk_en <= 1'd0;
    end
end

always @(posedge sys_clk)begin 
    if(rst)begin 
        check_inv <= 0;
    end
    else if(cnt_div_t<0)begin 
        check_inv <= 1;
    end
    else if(cnt_div_t >= CLK_DIV_MAX) begin 
        check_inv <= 0;
    end
    else begin 
        ;
    end
end

always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_delay1 <= 32'd0;
    end
    else if(flag_cnt_delay1_clear)begin 
        cnt_delay1 <= 32'd0             ;
    end
    else if(flag_cnt_delay1_add)begin 
        cnt_delay1 <= cnt_delay1 + 1'b1;
    end
    else begin 
        ;
    end
end
assign flag_cnt_delay1_clear = div_clk_en | (div_clk_en & cnt_delay1 != 0) ;
assign flag_cnt_delay1_add   = (cnt_delay1 == 0 & data_change) | (cnt_delay1 != 0) ;

always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_delay2 <= 32'd0;
    end
    else if(flag_cnt_delay2_clear)begin 
        cnt_delay2 <= 32'd0             ;
    end
    else if(flag_cnt_delay2_add)begin 
        cnt_delay2 <= cnt_delay2 + 1'b1;
    end
    else begin 
        ;
    end
end
assign flag_cnt_delay2_clear = div_clk_en  ;
assign flag_cnt_delay2_add   = 1'b1        ;

always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_delay <= 32'd0;
    end
    else if(div_clk_en)begin
        if(cnt_delay1 <= (cnt_delay2>>>1))begin 
            cnt_delay <= cnt_delay1 ;
        end
        else begin
            cnt_delay <= cnt_delay1-cnt_delay2;
        end
    end 
    else begin 
        cnt_delay <= 32'd0;
    end
end



always @(posedge sys_clk)begin 
    if(rst)begin 
        div_clk_en_delay <= 1'b0;
    end
    else begin
        div_clk_en_delay <= div_clk_en;
    end
end

wire signed [31:0]cnt_delay_sum_t;
assign cnt_delay_sum_t = div_clk_en?cnt_delay_sum:32'd0;
always @(posedge sys_clk)begin
    
        if(rst)begin 
            cnt_delay_sum <= 32'd0;
        end
        else if(div_clk_en_delay)begin
            cnt_delay_sum <= cnt_delay_sum + cnt_delay;
        end
        else begin 
            ;
        end
end


always @(posedge sys_clk)begin 
    if(rst)begin 
        bitsync_data_valid_t <= 4'd0;
    end
    else begin
        if(cnt_div_t > CLK_DIV_MAX/2 & cnt_div <= CLK_DIV_MAX /2)begin 
            bitsync_data_valid_t[0] <= 1'b1;
        end
        else begin 
            bitsync_data_valid_t[0] <= 1'b0;
        end
        bitsync_data_valid_t[1] <= bitsync_data_valid_t[0];
        bitsync_data_valid_t[2] <= bitsync_data_valid_t[1];
        bitsync_data_valid_t[3] <= bitsync_data_valid_t[2];
    end
end

always @(posedge sys_clk)begin 
    if(rst)begin 
        bitsync_data_t <= 1'b0;
    end
    else if(bitsync_data_valid_t[2]) begin 
        bitsync_data_t <= costas_bitsync_data;
    end
    else begin 
        ;
    end
end

assign bitsync_data       = bitsync_data_t          ;
assign bitsync_data_valid = bitsync_data_valid_t[3] ;




endmodule