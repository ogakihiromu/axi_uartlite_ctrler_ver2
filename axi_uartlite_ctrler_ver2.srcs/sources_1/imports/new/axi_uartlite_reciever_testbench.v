`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/22 00:53:39
// Design Name: 
// Module Name: axi_uartlite_reciever_testbench
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


module axi_uartlite_reciever_testbench(
    );
    parameter RATE = 9600;
    parameter DATA_SIZE = 8;
    parameter DATA_NUM = 17;
    time    BIT_CYC;
    
    reg clk;
    reg rst;
    reg rx;   
    wire tx;
    wire done;
    
    reg[7:0] data;
    integer     r_bit_count;
    integer     r_data_count;
    
    reg s_flag = 0;
    integer s_data_count = 0;
    
    core_system core_system(
        .CLK(clk),
        .RST(rst),
        .RX(rx),
        .TX(tx)
    );
    
    always #5 clk = ~clk;     
    
    always@(*)begin
        if(s_flag == 0 && tx == 0)
            s_flag <=1;
    end
    
    always@(*)begin
        while(s_flag)begin
            s_data_count = s_data_count + 1;
            for(s_data_count = 0;s_data_count<10;s_data_count=s_data_count+1)
                #BIT_CYC;
            if(s_data_count == DATA_NUM)
                s_flag <= 0;
        end
    end   
    
    initial begin
    
// config_phase
// 
        BIT_CYC = 1000000000/RATE;      // ns/bit
        clk = 0;
        rst = 0;    // active_high
        rx = 1;     // serial_no_data
        
        data = 8'h1;   // trans_data

        #50;

        rst = 1;
        
        #1000;
        
        rst = 0;
        
        #100;
        
// serial_signal_recieve_phase
// 
// description:
//      data_size: 8 bit
// 
        for(r_data_count=0; r_data_count<DATA_NUM; r_data_count=r_data_count+1)begin
            rx  =1'b0;  // start_bit
            #BIT_CYC;
            for(r_bit_count=0; r_bit_count<DATA_SIZE; r_bit_count=r_bit_count+1)begin
                rx = data[r_bit_count];
                #BIT_CYC;
            end
            rx  =1'b1;
            #BIT_CYC;   // stop_bit
            #10000;
            r_bit_count = 0;
            data = data + 1;
        end

// serial_signal_send_phase
// 
// description:
//      data_size: 8 bit
//         
        
        
        #31210000;
        
        $finish;
        
    end
endmodule
