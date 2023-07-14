`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/26 10:45:11
// Design Name: 
// Module Name: cpu_side_io_controller
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
`include "define.vh"
`include "io_simplebus.vh"
`include "cpu_memory_map-uart.vh"

module cpu_side_io_controller(
	input [`ADDR_WIDTH-1:0] ADDR,
	input [0:0] WE,
	
	output [1:0] CMD
	);
	
	assign CMD = cmd_generator(ADDR[`ADDR_WIDTH-1:0], WE);

	function [1:0] cmd_generator;
		input [`ADDR_WIDTH-1:0] addr;
		input [0:0] we;
		begin
			if(`CPU_UART_ADDR_MIN <= addr && addr <= `CPU_UART_ADDR_MAX && we == 0)
				cmd_generator = `READ;
		    else if(`CPU_UART_ADDR_MIN <= addr && addr <= `CPU_UART_ADDR_MAX && we == 1)
		        cmd_generator = `WRITE;
			else
				cmd_generator = `NOP;
		end
	endfunction

	
endmodule
