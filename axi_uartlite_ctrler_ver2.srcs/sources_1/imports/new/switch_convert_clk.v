`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/15 01:13:07
// Design Name: 
// Module Name: switch_convert_clk
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


module switch_convert_clk(
    input [0:0] CLK,
    input [0:0] SWITCH_IN,
    output reg [0:0] SWITCH_OUT
    );
    
    reg switch = 0;
    
    always @(posedge CLK)begin
        switch <= SWITCH_IN;
        SWITCH_OUT <= (~switch & SWITCH_IN);
    end
    
endmodule