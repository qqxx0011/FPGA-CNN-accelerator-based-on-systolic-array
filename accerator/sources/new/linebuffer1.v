`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 20:11:44
// Design Name: 
// Module Name: linebuffer1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module linebuffer1 #(
    parameter WIDTH = 8,
    parameter IMG_WIDTH = 482
    )
    (
    input  clk,
    input  rst_n,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout,
    input  valid_in,
    output valid_out
);
wire   rd_en;//读使能
reg    [8:0] cnt;//由于fifo是每个时钟周期移位一次的，所以找一个计数器记录写使能有效的时钟数量就可以记录此时fifo中进了几个数据

//计数器从0变1的时钟沿，写入第一个数据，因此从IMG_WIDTH-1变IMG_WIDTH的时钟沿写入最后一个数据，这时要考虑读是放在里面读还是被挤出来后读
//从而考虑要不要再fifo里面留一个位置,应该是要留一个位置的，有点乱，最好找个相关源码看一看RTFSC
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt <= {9{1'b0}};
    else if(valid_in)begin
        if(cnt == IMG_WIDTH-1)
            cnt <= IMG_WIDTH-1;
        else
            cnt <= cnt +1'b1;
    end
    else
        cnt <= cnt;
end
//buffer中存满了并且还要移位的时候才会有读出的数据
assign rd_en = ((cnt == IMG_WIDTH-1) && (valid_in)) ? 1'b1:1'b0;
assign valid_out = rd_en;

fifo_generator_0 u_line_fifo(
.clk (clk),
.rst (!rst_n),
.din (din),
.dout(dout),
.wr_en (valid_in),
.rd_en (rd_en), 
.wr_rst_busy(), 
.rd_rst_busy()
);


endmodule


//虽然逻辑上好像不用自动切换输入法，但是自动切换很有安全感
//试试输入法自动切换成功没有？？linux用不了？？可以了！！
//爽了！！

