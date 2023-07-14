`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/26 14:29:03
// Design Name: 
// Module Name: dummy_core
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
`include "core_inst.vh"
`include "cpu_memory_map-uart.vh"
`include "define.vh"

module dummy_core(
    input CLK,
    input RST,
    input [`DATA_WIDTH - 1 : 0]RDATA,
    output [`DATA_WIDTH - 1 : 0]WDATA,
    output [`ADDR_WIDTH - 1 : 0]ADDR,
    output WE
    
    );
    
    reg [1:0]prog_stat;
    reg [`ADDR_WIDTH - 1 : 0]addr;
    reg [`DATA_WIDTH - 1 : 0]data;
    reg we;
    
    assign ADDR = addr;
    assign WDATA = data;
    assign WE = we;
    
    always @(posedge CLK)begin
        if(RST == 0)begin
            prog_stat <= `READ_RX_FIFO_STATE;
            addr <= `CPU_UART_STAT_REG;
            data <= 0;
            we <= 0;
        end
        else begin
            case(prog_stat)
                `READ_RX_FIFO_STATE : begin
                    if (RDATA[0] ==1)begin      // Rx_FIFO receive valid data
                        addr <= `CPU_UART_READ_FIFO;
                        prog_stat <= `READ_RX_FIFO;
                    end
                end
                `READ_RX_FIFO : begin
                    addr <= `CPU_UART_STAT_REG;
                    prog_stat <= `READ_TX_FIFO_STATE;
                    data <= RDATA;
                end
                `READ_TX_FIFO_STATE : begin
                    if (RDATA[1] == 0)begin     // Tx_FIFO is not full
                        addr <= `CPU_UART_WRITE_FIFO;
                        prog_stat <= `WRITE_TX_FIFO;
                        we <= 1;
                    end
                end
                `WRITE_TX_FIFO : begin
                    prog_stat <= `READ_RX_FIFO_STATE;
                    addr <= `CPU_UART_STAT_REG;
                    we <= 0;
                end
            endcase 
        end
    end
endmodule
