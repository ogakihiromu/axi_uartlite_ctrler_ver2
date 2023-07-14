/* Width-related constants */
`define INST_WIDTH 32 // Instruction width
`define PC_WIDTH 30 // pc (program counter) width
`define ADDR_WIDTH 32 // Imem addr width
`define DATA_WIDTH 32 // Imem data width
`define WORD_WDITH 32 // Word width
`define HALF_WORD_WIDTH 16 // Half word width
`define BYTE_WIDTH 8 // Byte data width
`define ADDR_LOWER_2bit_WIDTH 2 // Lower 2bit width

`define SHAMT_WIDTH 5 // SHift AMounT
`define REG_ADDR_WIDTH 5 // Number of Regsiters
`define ALU_OP_WIDTH 5 // ALU Opecode width
`define OP_WIDTH 7 // Opecode width
`define FUNCT3_WIDTH 3 // funct3 width
`define FUNCT7_WIDTH 7 // funct7 width
`define MASK_WIDTH 4 // data memory mask width

`define CPU_STATE_WIDTH 2 // CPU state width

/* NOP instruction */
`define NOP_32BIT 32'b000000000000_00000_000_00000_0010011 // ADDI x0, x0, 0 (= NOP)

/* Memory Size */
`define IMEM_SIZE (64*1024) // Instruction Memory Size in byte (default 64KiB)
`define DMEM_SIZE (512*1024*1024) // Data Memory Size in byte (default 512KiB)

/* Upper Limit */
`define IMEM_MIN_ADDR 32'h00000000
`define IMEM_MAX_ADDR 32'h0000FFFC // Imem max address
`define DMEM_MIN_ADDR 32'h00010000
`define DMEM_MAX_ADDR 32'h0007FFFC // Dmem max address

/* Forwarding (for ID, EX) */
`define EX_MA_FORWARDING_2BIT 2'b01 // from EX_MA forwarding
`define MA_WB_FORWARDING_2BIT 2'b11 // from MA_WB forwarding
`define NO_FORWARDING_2BIT 2'b00 // No forwarding

/* Forwarding (for MA) */
`define EX_MA_FORWARDING_1BIT 1'b1 // from EX_MA forwarding
`define MA_WB_FORWARDING_1BIT 1'b1 // from MA_WB forwarding
`define NO_FORWARDING_1BIT 1'b0 // from MA_WB forwarding

/* Hazard detection */
`define HAZARD_DETECT 1'b1
`define NO_HAZARD_DETECT 1'b0

/* Detect error */
`define DETECT_ERROR 1'b1 // alignment error or decode error
`define NO_DETECT_ERROR 1'b0