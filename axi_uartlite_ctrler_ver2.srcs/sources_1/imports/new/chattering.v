`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/15 01:07:18
// Design Name: 
// Module Name: chattering
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


module chattering(
    input [0:0] clk_in,
    input [0:0] switch_in,
    output reg [0:0] switch_out
    );

    parameter COUNT_MAX = 10; // set parameter (default 4000, sim 10)
    parameter COUNT_WIDTH = 12; // set parameter
    
    reg [COUNT_WIDTH-1:0] count = 0;
    reg [0:0] switch = 0;
    
    always@(posedge clk_in)
        if (switch_in == switch) begin
            if (count == COUNT_MAX) begin
                switch_out <= switch_in;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            count <= 0;
            switch <= switch_in;
        end
    
endmodule
