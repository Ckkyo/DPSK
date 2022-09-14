//SYS
`define SYS_CLK_FREQ        (50_000_000)



//uart
`define UART_BPS            (9600)
`define UART_DATA_WIDTH     (8)


//frame
`define FRAME_HEAD_LEN      (8*8)
`define FRAME_DATA_LEN      (120*8)
`define FRAME_TOTAL_LEN     (128*8)
`define FRAME_HEAD          {{16{1'b0}},{(`FRAME_HEAD_LEN-16){1'b1}}}


`define DIFF_ONE          


//fc,fs,fb
`define FC                  (4000)
`define FS                  (32000)
`define FB                  (200)
`define DLT_FB              (0)
`define DLT_FC              (0)

//vco
`define VCO_N               (10)
`define VCO_PRECISE         (8)
