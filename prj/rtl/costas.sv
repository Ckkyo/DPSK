`include "head.v"


module costas(
    input   sys_clk
    ,input  rst

    ,input  [7:0]   adc_costas_data
    ,input          adc_costas_valid


    ,output                 costas_bitsync_data
    ,output                 costas_bitsync_valid

);
parameter           LPF_OUT_WIDTH = 34  ;
reg                 costas_bitsync_data_t;
reg                 costas_bitsync_valid_t;


reg lpf_en                                              ;
reg [3:0]lpf_en_delay                                   ;
reg lf_en                                               ;
reg vco_en                                              ;

wire                    signal_valid                    ;
wire signed [7:0]       signal                          ;

wire signed [7:0]       vco_i                           ;
wire signed [15:0]      vco_i_mul_s                     ;
wire signed [LPF_OUT_WIDTH-1:0]      i_lpfed_t                       ;
(* MARK_DEBUG="true" *)wire signed [15:0]       i_lpfed                         ;

wire signed [31:0]      i_lpfed_mul_q_lpfed_t           ;
wire signed [15:0]       i_lpfed_mul_q_lpfed             ;
wire signed [`VCO_N:0]  lfed                            ;

wire signed [7:0]       vco_q                           ;
wire signed [15:0]      vco_q_mul_s                     ;
wire signed [LPF_OUT_WIDTH-1:0]      q_lpfed_t                       ;
wire signed [15:0]       q_lpfed                         ;




assign signal       =   adc_costas_data     ;
assign signal_valid =   adc_costas_valid    ;

assign vco_i_mul_s  =   vco_i * signal      ;
assign vco_q_mul_s  =   vco_q * signal      ;

assign i_lpfed_mul_q_lpfed_t  =   i_lpfed * q_lpfed ;
assign i_lpfed_mul_q_lpfed    =   i_lpfed_mul_q_lpfed_t[31:31-16+1]    ;

assign i_lpfed      =   i_lpfed_t[LPF_OUT_WIDTH-1:LPF_OUT_WIDTH-1-16+1];
assign q_lpfed      =   q_lpfed_t[LPF_OUT_WIDTH-1:LPF_OUT_WIDTH-1-16+1];

always @(*)begin
    if(rst)begin 
        lpf_en = 1'b0;
    end
    else begin 
        lpf_en = signal_valid;
    end
end

always @(posedge sys_clk)begin
    if(rst)begin 
        lf_en <= 1'b0;
        lpf_en_delay<=0;
        
    end
    else begin 
        lpf_en_delay[0]<=lpf_en;
        lpf_en_delay[1]<=lpf_en_delay[0];
        lpf_en_delay[2]<=lpf_en_delay[1];
        lpf_en_delay[3]<=lpf_en_delay[2];
        lf_en <= lpf_en_delay[3];
    end
end

always @(posedge sys_clk)begin
    if(rst)begin 
        vco_en <= 1'b0;
    end
    else begin 
        vco_en <= lf_en ;
    end
end


always @(posedge sys_clk)begin 
    if(rst)begin 
        costas_bitsync_data_t <=1'b0;
    end
    else if(i_lpfed>1280)begin 
        costas_bitsync_data_t <= 1;
    end
    else if(i_lpfed<-1280)begin 
        costas_bitsync_data_t <= 0;
    end
    else begin 
        ;
    end
end

always @(posedge sys_clk)begin 
    if(rst)begin 
        costas_bitsync_valid_t <= 1'b0;
    end
    else begin 
        costas_bitsync_valid_t <= lf_en;
    end
end
assign costas_bitsync_data = costas_bitsync_data_t;
assign costas_bitsync_valid= costas_bitsync_valid_t;
//reg costas_bitsync_data_t;
//reg costas_bitsync_valid_t;

vco #(
    .N_RST(0),
    .FC(`FC)
)i_vco(
    .clk(sys_clk),
    .rst(rst),
    .dlt_step(lfed),
    .rd_en(vco_en),
    .out(vco_i)
);

vco #(
    .FC(`FC)
)q_vco(
    .clk(sys_clk),
    .rst(rst),
    .dlt_step(lfed),
    .rd_en(vco_en),
    .out(vco_q)
);

lpf i_lpf(
    .clk(sys_clk),
    .clk_enable(lpf_en),
    .rst(rst),
    .lpf_in(vco_i_mul_s),
    .lpf_out(i_lpfed_t)
);

lpf q_lpf(
    .clk(sys_clk),
    .clk_enable(lpf_en),
    .rst(rst),
    .lpf_in(vco_q_mul_s),
    .lpf_out(q_lpfed_t)
);

lf u_lf(
    .sys_clk(sys_clk),
    .rst(rst),
    .clk_en(lf_en),
    .lf_in(i_lpfed_mul_q_lpfed),
    .lf_out(lfed)
);


//pll u_pll(
//    .sys_clk(sys_clk),
//    .rst(rst),
//    .dlt_step(0),
//    .pll_out()
//);











endmodule