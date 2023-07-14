`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/15 17:02:11
// Design Name: 
// Module Name: chattering_convert
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


module chattering_convert(
    input CLK,
    input SWITCH_IN,
    output SWITCH_OUT
    );
    
    wire chat_switch;
    
    chattering chattering(
        .clk_in(CLK),
        .switch_in(SWITCH_IN),
        .switch_out(chat_switch)
    );
    
    switch_convert_clk switch_convert_clk(
        .CLK(CLK),
        .SWITCH_IN(chat_switch),
        .SWITCH_OUT(SWITCH_OUT)
    );
    
endmodule
