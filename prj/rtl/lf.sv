`include "head.v"
//module lf(
//    input   sys_clk
//    ,input  rst
//    ,input  clk_en 
//    ,input  signed  [7:0]       lf_in
//    ,output signed  [`VCO_N:0]  lf_out   
//);
//parameter signed  C1     =  8'd20   ;
//parameter signed  C2     =  8'd1    ;
//
//reg signed  [`VCO_N+8:0]    lf_out_t      ;
//
//reg signed  [`VCO_N:0]      acc           ;
//
//wire signed [15:0]          c1_mul_lf_in  ; 
//wire signed [`VCO_N+8:0]    c2_mul_acc    ;
//
//assign c1_mul_lf_in =   C1 * lf_in     ;
//assign c2_mul_acc   =   C2 * acc       ;
//
//always @(posedge sys_clk)begin 
//    if(rst)begin 
//        acc <= 0    ;
//    end
//    else if(clk_en)begin 
//        acc <= acc + lf_in  ;
//    end
//    else begin 
//        ; 
//    end
//end
//
//always @(*)begin 
//    if(clk_en)begin 
//        lf_out_t = (c1_mul_lf_in + c2_mul_acc) ;
//        //if(c1_mul_lf_in>0)begin 
//        //    lf_out_t = -1;
//        //end
//        //else begin 
//        //    lf_out_t = 1;
//        //end
//    end
//    else begin 
//        ;
//    end
//
//end
//
//
//
//assign lf_out = {lf_out_t[`VCO_N+8:8]};
//
//
//
//
//
//endmodule

module lf(
    input   sys_clk
    ,input  rst
    ,input  clk_en 
    ,input  signed  [15:0]       lf_in
    ,output signed  [`VCO_N:0]  lf_out   
);
parameter         M      =  12            ;
parameter signed  C1     =  (2**M)/1   ;
parameter signed  C2     =  (2**M)/1256 ;

reg signed  [31:0]    lf_out_t      ;

reg signed  [31:0]    acc           ;

wire signed [31:0]    c1_mul_lf_in  ;
wire signed [31:0]    c2_mul_acc    ; 
//wire signed [31+M:0]    c2_mul_acc_t  ;

assign c1_mul_lf_in =   C1 * lf_in     ;
assign c2_mul_acc   =   C2 * acc       ;
//assign c2_mul_acc   =   {c2_mul_acc_t[31+M],c2_mul_acc_t[30:0]};

always @(posedge sys_clk)begin 
    if(rst)begin 
        acc <= 0    ;
    end
    else if(clk_en)begin 
        acc <= acc + lf_in  ;
    end
    else begin 
        ; 
    end
end

always @(*)begin 
    if(clk_en)begin 
        lf_out_t = (c1_mul_lf_in + c2_mul_acc) ;
        //if(c1_mul_lf_in>0)begin 
        //    lf_out_t = -1;
        //end
        //else begin 
        //    lf_out_t = 1;
        //end
    end
    else begin 
        ;
    end

end



assign lf_out[`VCO_N-1:0] = lf_out_t>>>18;
assign lf_out[`VCO_N    ] = lf_out_t[31];





endmodule

