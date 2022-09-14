`timescale 1ns/1ns
module bit_sybc_tb();

    reg sys_clk;
    reg rst;

    initial begin:gen_clk
        sys_clk <= 0;
        forever #10 sys_clk <=~sys_clk ;
    end
    initial begin:gen_rst
        rst <= 1;
        #300 rst <=0 ;
    end
    reg costas_bitsync_data;
    reg sync;
    integer rand_a;
    integer send_data;
    integer sync_data;
    always begin 
        rand_a = $random()%10;
        @(posedge sys_clk);
            sync   <= 0;
        repeat (50000000/(200+30)) @(posedge sys_clk);
        begin 
            costas_bitsync_data <= $random();
            sync                <= 1;
        end 
    end
    always begin 
        @(posedge sync)begin 
            send_data <= costas_bitsync_data;
        end
        @(posedge bitsync_data_valid)begin 
            sync_data <= bitsync_data;
        end
        $display("%d",send_data - sync_data);
    end

wire bitsync_data;
wire bitsync_data_valid;
bit_sync u_bit_sync(
    .sys_clk(sys_clk),
    .rst(rst),
    .costas_bitsync_data(costas_bitsync_data),
    .bitsync_data(bitsync_data),
    .bitsync_data_valid(bitsync_data_valid)
);









endmodule