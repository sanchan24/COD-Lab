module decoder (
    input logic [31:0] inst,
    output logic [4:0] rs1_addr,
    output logic [4:0] rs2_addr,
    output logic [4:0] rd_addr,
    output logic [31:0] Imm,
    output logic [2:0] funct3,
    output logic [6:0] funct7,
    output logic [6:0] opcode
);

    always @(*) begin
        // Default values to prevent latches
        rs1_addr = 5'b0;
        rs2_addr = 5'b0;
        rd_addr = 5'b0;
        Imm = 32'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;
        opcode = inst[6:0];

        // Decode based on opcode
        case (opcode)
            7'b0110011: begin   // R-type
                rd_addr = inst[11:7];
                funct3 = inst[14:12];
                rs1_addr = inst[19:15];
                rs2_addr = inst[24:20];
                funct7 = inst[31:25];
            end

            7'b0010011: begin   // I-type
                rd_addr = inst[11:7];
                funct3 = inst[14:12];
                rs1_addr = inst[19:15];
                Imm[11:0] = inst[31:20];
            end

            7'b0000011: begin   // Load
                rd_addr = inst[11:7];
                funct3 = inst[14:12];
                rs1_addr = inst[19:15];
                Imm[11:0] = inst[31:20];
            end

            7'b0100011: begin   // Store
                Imm[4:0] = inst[11:7];
                funct3 = inst[14:12];
                rs1_addr = inst[19:15];
                rs2_addr = inst[24:20];
                Imm[11:5] = inst[31:25];
            end

            7'b1100011: begin   // Branch
                Imm[0] = 1'b0;
                Imm[4:1] = inst[11:8];
                Imm[11] = inst[7];
                funct3 = inst[14:12];
                rs1_addr = inst[19:15];
                rs2_addr = inst[24:20];
                Imm[10:5] = inst[30:25];
                Imm[12] = inst[31];
            end

            default: begin
                // Keep default values for unsupported opcodes
            end
        endcase
    end
endmodule
