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
wire   rd_en;//��ʹ��
reg    [8:0] cnt;//����fifo��ÿ��ʱ��������λһ�εģ�������һ����������¼дʹ����Ч��ʱ�������Ϳ��Լ�¼��ʱfifo�н��˼�������

//��������0��1��ʱ���أ�д���һ�����ݣ���˴�IMG_WIDTH-1��IMG_WIDTH��ʱ����д�����һ�����ݣ���ʱҪ���Ƕ��Ƿ�����������Ǳ����������
//�Ӷ�����Ҫ��Ҫ��fifo������һ��λ��,Ӧ����Ҫ��һ��λ�õģ��е��ң�����Ҹ����Դ�뿴һ��RTFSC
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
//buffer�д����˲��һ�Ҫ��λ��ʱ��Ż��ж���������
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


//��Ȼ�߼��Ϻ������Զ��л����뷨�������Զ��л����а�ȫ��
//�������뷨�Զ��л��ɹ�û�У���linux�ò��ˣ��������ˣ���
//ˬ�ˣ���

