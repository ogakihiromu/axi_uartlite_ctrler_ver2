`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/19 01:54:28
// Design Name: 
// Module Name: axi_uartlite_controller
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

module axi_uartlite_controller(
    input CLK,
    input RST,      // rst
    input RX,       // from host pc to fpga
    output TX,      // from fpga to host pc
    output [`DATA_WIDTH - 1 : 0]READ_DATA,  // from uart to controller
    input [`DATA_WIDTH - 1 : 0]WRITE_DATA,   // from controller to uart
    input [`ADDR_WIDTH - 1 : 0]ADDR,
    input [1:0]CMD,
    output [1:0]STATE
    );
    
////////////////////
// axi_lite_wire
////////////////////
    wire interrupt;     // don't use
    wire awvalid;
    wire awready;
    wire [`ADDR_WIDTH - 1 : 0]awaddr;
    wire [3:0]wstrb;
    wire wvalid;
    wire wready;
    wire [`DATA_WIDTH - 1 : 0]wdata;
    wire [1:0]bresp;
    wire bvalid;
    wire bready;
    wire arvalid;
    wire arready;
    wire [`ADDR_WIDTH - 1 : 0]araddr;
    wire [1:0]rresp;
    wire rvalid;
    wire rready;
    wire [`DATA_WIDTH - 1 : 0]rdata;

////////////////////
// io_side_simplebus <-> uart_controller wire
////////////////////
    wire write_req;
    wire [`ADDR_WIDTH - 1 : 0]write_addr;
    wire [`DATA_WIDTH - 1 : 0]write_data;
    wire write_busy;
    wire read_req;
    wire [`ADDR_WIDTH - 1 : 0]read_addr;
    wire [`DATA_WIDTH - 1 : 0]read_data;
    wire read_busy;

////////////////////
// uart_controller_module
////////////////////

    uart_controller uart_controller(
        .CLK(CLK),
        .RST(RST),
        .CMD(CMD),
        .CPU_ADDR(ADDR),
        .CPU_WRITE_DATA(WRITE_DATA),
        .CPU_READ_DATA(READ_DATA),
        
        .UART_WRITE_REQ(write_req),
        .UART_WRITE_ADDR(write_addr),
        .UART_WRITE_DATA(write_data),
        .UART_WRITE_BUSY(write_busy),
        .UART_WRITE_RESP_VALID(bvalid),
        .UART_WRITE_RESP(bresp),
        .UART_READ_REQ(read_req), 
        .UART_READ_ADDR(read_addr),
        .UART_READ_DATA(read_data),
        .UART_READ_BUSY(read_busy),
        .UART_READ_RESP_VALID(rvalid),
        .UART_READ_RESP(rresp)
    );

////////////////////
// uart_module
////////////////////
    axi_uartlite_0 uart (
        .s_axi_aclk(CLK),        // input wire s_axi_aclk
        .s_axi_aresetn(RST),  // input wire s_axi_aresetn
        .interrupt(interrupt),          // output wire interrupt
        .s_axi_awaddr(awaddr),    // input wire [3 : 0] s_axi_awaddr
        .s_axi_awvalid(awvalid),  // input wire s_axi_awvalid
        .s_axi_awready(awready),  // output wire s_axi_awready
        .s_axi_wdata(wdata),      // input wire [31 : 0] s_axi_wdata
        .s_axi_wstrb(wstrb),      // input wire [3 : 0] s_axi_wstrb
        .s_axi_wvalid(wvalid),    // input wire s_axi_wvalid
        .s_axi_wready(wready),    // output wire s_axi_wready
        .s_axi_bresp(bresp),      // output wire [1 : 0] s_axi_bresp
        .s_axi_bvalid(bvalid),    // output wire s_axi_bvalid
        .s_axi_bready(bready),    // input wire s_axi_bready
        .s_axi_araddr(araddr),    // input wire [3 : 0] s_axi_araddr
        .s_axi_arvalid(arvalid),  // input wire s_axi_arvalid
        .s_axi_arready(arready),  // output wire s_axi_arready
        .s_axi_rdata(rdata),      // output wire [31 : 0] s_axi_rdata
        .s_axi_rresp(rresp),      // output wire [1 : 0] s_axi_rresp
        .s_axi_rvalid(rvalid),    // output wire s_axi_rvalid
        .s_axi_rready(rready),    // input wire s_axi_rready
        .rx(RX),                        // input wire rx
        .tx(TX)                        // output wire tx
    );

////////////////////
// io_side_simplebus_module
////////////////////

    io_side_controller io_side_controller (
        .M_AXI_ACLK(CLK),  //(negedge)
        .M_AXI_ARESETN(RST),
        
        .WRITE_ADDR(write_addr),
        .WRITE_DATA(write_data),
        .WRITE_REQ(write_req),
        .WRITE_BUSY(write_busy),
        .WRITE_RESP(write_resp),
        .READ_ADDR(read_addr),
        .READ_DATA(read_data),
        .READ_REQ(read_req),
        .READ_BUSY(read_busy),
        .READ_RESP(read_resp),
        
        .M_AXI_AWPROT(),
        .M_AXI_AWVALID(awvalid),
        .M_AXI_AWREADY(awready),
        .M_AXI_AWADDR(awaddr),
        .M_AXI_WSTRB(wstrb),
        .M_AXI_WVALID(wvalid),
        .M_AXI_WREADY(wready),
        .M_AXI_WDATA(wdata),
        .M_AXI_BRESP(bresp),
        .M_AXI_BVALID(bvalid),
        .M_AXI_BREADY(bready),
        .M_AXI_ARPROT(),
        .M_AXI_ARVALID(arvalid),
        .M_AXI_ARREADY(arready),
        .M_AXI_ARADDR(araddr),
        .M_AXI_RRESP(rresp),
        .M_AXI_RVALID(rvalid),
        .M_AXI_RREADY(rready),
        .M_AXI_RDATA(rdata)
    );

endmodule
