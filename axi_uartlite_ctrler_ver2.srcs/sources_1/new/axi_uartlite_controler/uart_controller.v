`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/27 23:36:18
// Design Name: 
// Module Name: uart_controller
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
`include "io_simplebus.vh"
`include "cpu_memory_map-uart.vh"
`include "uart_memory_map.vh"
`include "define.vh"

module uart_controller(
    input CLK,
    input RST,
    
    input [1:0]CMD,
    input[`ADDR_WIDTH - 1:0] CPU_ADDR,
    input [`DATA_WIDTH - 1:0]CPU_WRITE_DATA,
    output [`DATA_WIDTH - 1:0]CPU_READ_DATA,
    
    output UART_WRITE_REQ,
    output [`ADDR_WIDTH - 1:0]UART_WRITE_ADDR,
    output [`DATA_WIDTH - 1:0]UART_WRITE_DATA,
    input UART_WRITE_BUSY,
    input UART_WRITE_RESP_VALID,
    input [1:0]UART_WRITE_RESP,
    
    output UART_READ_REQ, 
    output [`ADDR_WIDTH - 1:0]UART_READ_ADDR,
    input [`DATA_WIDTH - 1:0]UART_READ_DATA,
    input UART_READ_BUSY,
    input UART_READ_RESP_VALID,
    input [1:0]UART_READ_RESP
    );

    reg write_data_valid;
    reg read_data_valid;
    reg [`DATA_WIDTH - 1:0]ctrl_data;
    
    reg [`ADDR_WIDTH - 1:0]write_addr;
    reg [`ADDR_WIDTH - 1:0]read_addr;
    reg [`DATA_WIDTH - 1:0]write_data;
    reg [`DATA_WIDTH - 1:0]read_data;

    assign UART_WRITE_ADDR = write_addr;
    assign UART_WRITE_DATA = write_data;
    assign UART_READ_ADDR = read_addr;
    
    //send uart_write_request
    assign UART_WRITE_REQ = (CMD[0] && !UART_WRITE_BUSY) || (!UART_WRITE_BUSY && UART_WRITE_RESP_VALID && UART_WRITE_RESP[1]);
    
    //write_data_valid
    always @(posedge CLK)begin
        if(RST == 0)
            write_data_valid = 0;
        else if(CMD == `WRITE)
            write_data_valid = 1;
        else if(UART_WRITE_RESP_VALID == 1 && UART_WRITE_RESP[1] == 0)
            write_data_valid = 0;
    end
    
    //write_addr_reg
    always @(posedge CLK)begin
        if(RST == 0)
            write_addr = 0;
        else if(CMD == `WRITE)
            write_addr = CPU_ADDR;
    end
    
    //write_data_reg
    always @(posedge CLK)begin
        if(RST == 0)
            write_data <= 0;
        else if(CMD == `WRITE && CPU_ADDR == `CPU_UART_WRITE_FIFO)
            write_data <= CPU_WRITE_DATA;
    end
    
    //write_control_reg
    always @(posedge CLK)begin
        if(RST == 0)
            ctrl_data <= 0;
        else if(CMD == `WRITE && CPU_ADDR == `CPU_UART_CTRL_REG)
            ctrl_data <= CPU_WRITE_DATA;
    end
    
    // send uart_read_request
    assign UART_READ_REQ = !UART_READ_BUSY && !UART_WRITE_REQ && !read_data_valid && ( UART_READ_RESP_VALID || UART_WRITE_RESP_VALID );
    
    // multiplex data or stat with addr function
    function [`DATA_WIDTH - 1:0] read_data_mux;
        input [`ADDR_WIDTH - 1:0] addr;
        input [`DATA_WIDTH - 1:0] data;
        input [`DATA_WIDTH - 1:0] stat;
        if(addr == `CPU_UART_READ_FIFO)
            read_data_mux = data;
        else if(addr == `CPU_UART_STAT_REG)
            read_data_mux = stat;
    endfunction
    // multiplex data or stat with addr
    assign CPU_READ_DATA = read_data_mux(CPU_ADDR, read_data, {28'h0000000,2'b00,write_data_valid,read_data_valid});

    //read_data_valid
    always @(posedge CLK)begin
        if(RST == 0)
            read_data_valid <= 0;
        else if(UART_READ_RESP_VALID == 1 && UART_READ_RESP[1] == 0)
            read_data_valid <= 1;
        else if(CMD == `READ && CPU_ADDR == `CPU_UART_STAT_REG)
            read_data_valid <= 0;
    end
    
    //read_addr_reg
    always @(posedge CLK)begin
        if(RST == 0)
            read_addr <= 0;
        else
            read_addr <= `UART_UART_READ_FIFO;
    end
    
    //read_data_reg
    always @(posedge CLK)begin
        if(RST == 0)
            read_data <= 0;
        else if(UART_READ_RESP_VALID == 1 && UART_READ_RESP[1] == 0)
            read_data <= UART_READ_DATA;
    end

 
endmodule
