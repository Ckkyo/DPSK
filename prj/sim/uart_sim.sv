`timescale 1ns/1ns
`include "head.v"
module uart_tb();

    logic       sys_clk         ;
    reg         rst             ;

    reg [7:0]   tb_rx_data;
    reg         tb_uart_rec_rx=1;

    wire        frame_uart_ready     ;
    wire        uart_frame_valid     ;
    wire [7:0]  uart_frame_data      ;
    wire        diff_mod_valid       ;
    wire        diff_mod_data        ;

    wire        mod_dac_valid       ;
    wire signed [7:0] mod_dac_data  ;

    wire costas_bitsync_data;
    wire costas_bitsync_valid;
    wire bitsync_data;
    wire bitsync_data_valid;    
    wire [7:0] deframe_uart_data;
    wire deframe_uart_data_vld;
    wire uart_deframe_ready;

    initial begin:gen_clk
        sys_clk <= 0;
        forever #10 sys_clk <=~sys_clk ;
    end
    initial begin:gen_rst
        rst <= 1;
        #300 rst <=0 ;
    end
    

    integer i_gen_data;
    initial begin:gen_data_to_rx
        for(i_gen_data=0;i_gen_data<228;i_gen_data=i_gen_data+1)begin
            //tb_rx_data <= $random();
            if(i_gen_data<`FRAME_DATA_LEN/8)begin    
                tb_rx_data <= $random();
                #($urandom()%100) ;
                send_data(
                    .tb_rx_data(tb_rx_data),
                    .sys_clk(sys_clk),
                    .tb_uart_rec_rx(tb_uart_rec_rx)
                );
            end
            else if(i_gen_data<100+`FRAME_DATA_LEN/8 & i_gen_data >=100)begin 
                tb_rx_data <= 8'b1111_1111;
                #($urandom()%100) ;
                send_data(
                    .tb_rx_data(tb_rx_data),
                    .sys_clk(sys_clk),
                    .tb_uart_rec_rx(tb_uart_rec_rx)
                );
            end
            else if(i_gen_data<200+`FRAME_DATA_LEN/8 & i_gen_data >=200)begin 
                tb_rx_data <= 8'b1111_1111;
                #($urandom()%100) ;
                send_data(
                    .tb_rx_data(tb_rx_data),
                    .sys_clk(sys_clk),
                    .tb_uart_rec_rx(tb_uart_rec_rx)
                );
            end
            else begin 
                repeat (10*`SYS_CLK_FREQ/`UART_BPS) @(posedge sys_clk);
            end
            //$display("send done ");
        end
    end
    integer i_moded;
    integer fp_vco_txt;
    integer fp_moded_txt;
    integer fp_i_lpfed_txt;
    initial fork 
        fp_moded_txt = $fopen("/home/ck/do_sth_here/communication/DPSK/prj/sim/moded.txt");
        fp_vco_txt = $fopen("/home/ck/do_sth_here/communication/DPSK/prj/sim/vco.txt");
        fp_i_lpfed_txt=$fopen("/home/ck/do_sth_here/communication/DPSK/prj/sim/i_lpfed.txt");
        if(fp_moded_txt==0)begin 
            $display("moded txt open fail");
        end
        forever @(negedge mod_dac_valid ) begin 
                $fwrite(fp_moded_txt,"%d\n",u_top.mod_dac_data);
                $fwrite(fp_vco_txt,"%d\n",u_top.u_mod_top.u_mod.vco_out);
            end
        forever @(posedge sys_clk)begin 
            if(u_top.u_costas.lpf_en)begin 
               $fwrite(fp_i_lpfed_txt,"%d\n",u_top.u_costas.i_lpfed); 
            end
        end

    join

    initial begin 
        @(negedge u_top.u_mod_top.u_mod.flag_cnt_b)begin 
            @(negedge u_top.u_mod_top.u_mod.flag_cnt_b) ;
        end
        $display("close fp");
        $fclose(fp_moded_txt);
        $fclose(fp_vco_txt);
        //$finish();
    end
    wire [7:0] adda_data;
    top u_top(
        .sys_clk(sys_clk),
        .rst_n(~rst),
        .rx(tb_uart_rec_rx),
        .adc_data(adda_data),
        .adc_otr(),
        .tx(uart_tx),
        .led(),
        .dac_data(adda_data),
        .adc_clk(),
        .dac_clk()
    );
    //注入adc错误，看看结果
    initial begin 
        //force u_top.u_adc.adc_costas_data = 255;
    end



endmodule

task automatic send_data;
    ref logic [7:0] tb_rx_data;
    ref logic sys_clk;
    ref logic tb_uart_rec_rx;
    integer i = 0;
    begin
        repeat (`SYS_CLK_FREQ/`UART_BPS) @(posedge sys_clk);
            tb_uart_rec_rx =0;
        for(i=0;i<=7;i=i+1)begin 
            repeat (`SYS_CLK_FREQ/`UART_BPS) @(posedge sys_clk);
            tb_uart_rec_rx =tb_rx_data[i];
            //$display(tb_uart_rec_rx);
        end
        repeat (`SYS_CLK_FREQ/`UART_BPS) @(posedge sys_clk);
            tb_uart_rec_rx =1;
        repeat (`SYS_CLK_FREQ/`UART_BPS) @(posedge sys_clk);
            
    end

endtask

interface test_if(
    input bit sys_clk
);
    //logic sys_clk ; 
    
endinterface //test_if
