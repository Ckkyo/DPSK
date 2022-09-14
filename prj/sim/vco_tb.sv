
`timescale 1ns/1ns
module vco_tb();
    reg clk ;
    reg rd_en=0;
    reg signed [10:0] dlt_step=0;
    wire signed [7:0] out;

    initial begin :gen_clk
        clk <= 0;
        forever #20 clk <=~clk ;

    end
    integer fp ;
    initial begin 
        fp =$fopen("/home/ck/do_sth_here/communication/DPSK/prj/sim/vc_test.txt");
        if(fp == 0)begin 
            $display("open fail");
        end
    end

    int i ;
    initial begin
        repeat(10) @(posedge clk);
        for (i=0;i<1000;i=i+1)begin 
            @(posedge clk) begin 
                rd_en <= $random();
                if(rd_en == 1)
                    $fwrite(fp,"%d ",out);
            end
            
        end
        $fclose(fp);
        $display("done");
    end
    

    always @(*) dlt_step = ($random()%1)*rd_en;



    vco u_vco(
        .clk(clk),
        .dlt_step(dlt_step),
        .rd_en(rd_en),
        .out(out)
    );

endmodule


