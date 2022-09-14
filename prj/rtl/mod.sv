`include "head.v"


module mod(
    input sys_clk
    ,input rst

    ,input diff_mod_data
    ,input diff_mod_valid

    ,input dac_mod_ready

    ,output [`VCO_PRECISE-1:0] mod_dac_data
    ,output mod_dac_valid
    ,output mod_busy
);
parameter BASE = 2**`VCO_N  ;
parameter FC   = `FC+`DLT_FC   ;
parameter FS   = `FS        ;
parameter FB   = `FB +`DLT_FB    ;
parameter STEP = BASE*FC/FS ;
parameter CNT_CLK_S_MAX = `SYS_CLK_FREQ/FS;
parameter CNT_CLK_B_MAX = `SYS_CLK_FREQ/FB;
parameter CNT_B_MAX = `FRAME_TOTAL_LEN;

//输出
reg signed [`VCO_PRECISE-1:0] mod_dac_data_t    ;
reg mod_dac_valid_t                             ;






reg [23:0]cnt_clk_b;                  //clk_freq/fb   到上限从fifo中读出一个数值
//reg cnt_c,                    //clk_freq/fc   这个应该用不上，能用上的是STEP=2**N(fc/fs)
reg [19:0]cnt_clk_s;                  //clk_freq/fs   到上限从vco以step读出一个数值，并且产生valid到dac
reg [15:0]cnt_b                       ;//记录读取了几个码元，达到上限清空fifo以及计数器
wire flag_cnt_clk_b_clear       ;
wire flag_cnt_clk_b_add         ;//add为启动条件加上累加条件
wire flag_cnt_clk_b             ;//指示是否处于累加状态
wire flag_cnt_clk_s_clear       ;
wire flag_cnt_clk_s_add         ;
wire flag_cnt_clk_s             ;//指示是否处于累加状态
wire flag_cnt_b_clear           ;
wire flag_cnt_b_add             ;
wire flag_cnt_b                 ;
reg  flag_cnt_b_t               ;

//vco
wire                            vco_rd_en;
wire signed [`VCO_PRECISE-1:0]  vco_out  ;

//fifo
wire fifo_rst   ;
wire fifo_wr_en ;            //fifo中数据数量小于某个数值且不属于计数器累加状态的时候使能
wire fifo_rd_en ;            //非空且属于计数器累加状态且累加到特定值使用
wire fifo_dout  ;            
wire fifo_full  ;
wire fifo_empty ;
wire [11:0] cnt_fifo_data;

//fifo
assign fifo_wr_en = (cnt_fifo_data<`FRAME_TOTAL_LEN)&(~flag_cnt_b)&diff_mod_valid;
assign fifo_rd_en = flag_cnt_b & flag_cnt_b_add;
assign fifo_rst   = rst ;

//vco
assign vco_rd_en = cnt_clk_s==CNT_CLK_S_MAX-1;

//计数器
assign flag_cnt_clk_b_clear  = (~flag_cnt_b)|(cnt_clk_b==CNT_CLK_B_MAX-1);
assign flag_cnt_clk_b_add    = (cnt_clk_b ==0 &cnt_fifo_data >= `FRAME_TOTAL_LEN)|(flag_cnt_b);
//assign flag_cnt_clk_b        = ;
assign flag_cnt_clk_s_clear  = (~flag_cnt_b)|(cnt_clk_s==CNT_CLK_S_MAX-1);
assign flag_cnt_clk_s_add    = (cnt_clk_s==0 & cnt_fifo_data >= `FRAME_TOTAL_LEN)|(flag_cnt_b);
//assign flag_cnt_clk_s        = ;
assign flag_cnt_b_clear      = (cnt_clk_b==CNT_CLK_B_MAX-1&cnt_b==CNT_B_MAX-1)&(flag_cnt_b);
assign flag_cnt_b_add        = (cnt_clk_b==CNT_CLK_B_MAX-1)&(flag_cnt_b);
assign flag_cnt_b            = (cnt_clk_b==0&cnt_clk_s==0&cnt_b==0&cnt_fifo_data >= `FRAME_TOTAL_LEN)
                                |flag_cnt_b_t;

always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_clk_s <= 0;
    end
    else if(flag_cnt_clk_s_clear)begin 
        cnt_clk_s <= 0;
    end
    else if(flag_cnt_clk_s_add)begin 
        cnt_clk_s <= cnt_clk_s + 1'b1;
    end
    else begin 
        ;
    end
end
always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_clk_b <= 0;
    end
    else if(flag_cnt_clk_b_clear)begin 
        cnt_clk_b <= 0;
    end
    else if(flag_cnt_clk_b_add)begin 
        cnt_clk_b <= cnt_clk_b + 1'b1;
    end
    else begin 
        ;
    end
end

always @(posedge sys_clk)begin 
    if(rst)begin 
        cnt_b <= 0;
    end
    else if(flag_cnt_b_clear)begin 
        cnt_b <= 0;
    end
    else if(flag_cnt_b_add)begin 
        cnt_b <= cnt_b + 1'b1;
    end
    else begin 
        ;
    end
end

always @(posedge sys_clk)begin 
    if(rst)begin 
        flag_cnt_b_t <= 0;
    end
    else if(cnt_clk_b==0&cnt_clk_s==0&cnt_b==0&cnt_fifo_data >= `FRAME_TOTAL_LEN)begin 
        flag_cnt_b_t <= 1;
    end
    else if(cnt_clk_b==CNT_CLK_B_MAX-1&cnt_b==CNT_B_MAX-1)begin 
        flag_cnt_b_t <= 0;
    end
    else begin 
        ;
    end
end



always @(posedge sys_clk)begin 
    mod_dac_valid_t <= vco_rd_en;
end

always @(*)begin//这里取反的时候一定要注意，不能直接取，而需要判断是否等于-128，因为整数上限是127，会出现溢出的问题
                //不过对vco数据限制在-127到127之后则可不加以下判断
    if(fifo_dout)begin 
        mod_dac_data_t <= vco_out       ;
    end
    else begin 
        //if(vco_out == -8'd128)begin 
        //    mod_dac_data_t =127;
        //end
        //else begin 
        //    mod_dac_data_t = -vco_out;
        //end
        mod_dac_data_t <= -vco_out;
    end
end

assign mod_dac_data = mod_dac_data_t ;
assign mod_dac_valid= mod_dac_valid_t;
assign mod_busy     = flag_cnt_b ;












fifo_generator_0 u_diff_mod_fifo(
    .clk    (sys_clk),
    .srst   (fifo_rst),
    .din    (diff_mod_data),
    .wr_en  (fifo_wr_en),
    .rd_en  (fifo_rd_en),
    .dout   (fifo_dout),
    .full   (fifo_full),
    .empty  (fifo_empty),
    .data_count(cnt_fifo_data)
);

vco #(
    .FC(FC)
    )u_vco(
    .clk(sys_clk),
    .rst(rst),
    .dlt_step(0),
    .rd_en(vco_rd_en),
    .out(vco_out)
);


















endmodule