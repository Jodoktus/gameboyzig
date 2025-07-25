const std = @import("std");
const math = std.math;
const U3 = std.meta.Int(.unsigned, 3); //so i can test what bit it is same lenght as mask

const U1 = std.meta.Int(.unsigned, 1); //bits
const commands = struct {
    cycles: u8,
    lenght: u8,
    operation: []const u8,
};
var opcode_table: [512]commands = undefined;
// should i add the +0+0 in the opcode tables or is it to much
pub fn opcodes_to_table() !void() {
    //0th row of 0th table
    opcode_table[0] = commands{ .cycles = 1, .lenght = 1, .operation = "NOP" };
    opcode_table[1] = commands{ .cycles = 3, .lenght = 3, .operation = "LD BC,u16" };
    opcode_table[2] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (BC),A" };
    opcode_table[3] = commands{ .cycles = 2, .lenght = 1, .operation = "INC BC" };
    opcode_table[4] = commands{ .cycles = 1, .lenght = 1, .operation = "INC B" };
    opcode_table[5] = commands{ .cycles = 1, .lenght = 1, .operation = "DEC B" };
    opcode_table[6] = commands{ .cycles = 2, .lenght = 2, .operation = "LD B,u8" };
    opcode_table[7] = commands{ .cycles = 1, .lenght = 1, .operation = "RLCA" };
    opcode_table[8] = commands{ .cycles = 5, .lenght = 3, .operation = "LD (u16),SP" };
    opcode_table[9] = commands{ .cycles = 2, .lenght = 1, .operation = "ADD HL,BC" };
    opcode_table[10] = commands{ .cycles = 2, .lenght = 1, .operation = "LD A,(BC)" };
    opcode_table[11] = commands{ .cycles = 2, .lenght = 1, .operation = "DEC BC" };
    opcode_table[12] = commands{ .cycles = 1, .lenght = 1, .operation = "INC C" };
    opcode_table[13] = commands{ .cycles = 1, .lenght = 1, .operation = "DEC C" };
    opcode_table[14] = commands{ .cycles = 2, .lenght = 2, .operation = "LD C,u8" };
    opcode_table[15] = commands{ .cycles = 1, .lenght = 1, .operation = "RRCA" };
    //1st row
    opcode_table[0 + 16] = commands{ .cycles = 1, .lenght = 1, .operation = "STOP" };
    opcode_table[1 + 16] = commands{ .cycles = 3, .lenght = 3, .operation = "LD DE,u16" };
    opcode_table[2 + 16] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (DE),A" };
    opcode_table[3 + 16] = commands{ .cycles = 2, .lenght = 1, .operation = "INC DE" };
    opcode_table[4 + 16] = commands{ .cycles = 1, .lenght = 1, .operation = "INC D" };
    opcode_table[5 + 16] = commands{ .cycles = 1, .lenght = 1, .operation = "DEC D" };
    opcode_table[6 + 16] = commands{ .cycles = 2, .lenght = 2, .operation = "LD H,u8" };
    opcode_table[7 + 16] = commands{ .cycles = 1, .lenght = 1, .operation = "RLA" };
    opcode_table[8 + 16] = commands{ .cycles = 3, .lenght = 2, .operation = "JR i8" };
    opcode_table[9 + 16] = commands{ .cycles = 2, .lenght = 1, .operation = "ADD HL,DE" };
    opcode_table[10 + 16] = commands{ .cycles = 2, .lenght = 1, .operation = "Ld A,(DE)" };
    opcode_table[11 + 16] = commands{ .cycles = 2, .lenght = 1, .operation = "DEC SP" };
    opcode_table[12 + 16] = commands{ .cycles = 1, .lenght = 1, .operation = "INC E" };
    opcode_table[13 + 16] = commands{ .cycles = 1, .lenght = 1, .operation = "DEC L" };
    opcode_table[14 + 16] = commands{ .cycles = 2, .lenght = 2, .operation = "LD E,u8" };
    opcode_table[15 + 16] = commands{ .cycles = 1, .lenght = 1, .operation = "RRA" };
    //2nd row
    opcode_table[0 + 32] = commands{ .cycles = 2, .lenght = 2, .operation = "JR NZ,i8" };
    opcode_table[1 + 32] = commands{ .cycles = 3, .lenght = 3, .operation = "LD HL,u16" };
    opcode_table[2 + 32] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL+),A" };
    opcode_table[3 + 32] = commands{ .cycles = 2, .lenght = 1, .operation = "INC HL" };
    opcode_table[4 + 32] = commands{ .cycles = 1, .lenght = 1, .operation = "INC H" };
    opcode_table[5 + 32] = commands{ .cycles = 1, .lenght = 1, .operation = "DEC H" };
    opcode_table[6 + 32] = commands{ .cycles = 2, .lenght = 2, .operation = "LD H,u8" };
    opcode_table[7 + 32] = commands{ .cycles = 1, .lenght = 1, .operation = "DAA" };
    opcode_table[8 + 32] = commands{ .cycles = 2, .lenght = 2, .operation = "JR Z,i8" };
    opcode_table[9 + 32] = commands{ .cycles = 2, .lenght = 1, .operation = "ADD HL,HL" };
    opcode_table[10 + 32] = commands{ .cycles = 2, .lenght = 1, .operation = "LD A,(HL+)" };
    opcode_table[11 + 32] = commands{ .cycles = 2, .lenght = 1, .operation = "DEC HL" };
    opcode_table[12 + 32] = commands{ .cycles = 1, .lenght = 1, .operation = "INC L" };
    opcode_table[13 + 32] = commands{ .cycles = 1, .lenght = 1, .operation = "DEC L" };
    opcode_table[14 + 32] = commands{ .cycles = 2, .lenght = 2, .operation = "LD E,u8" };
    opcode_table[15 + 32] = commands{ .cycles = 1, .lenght = 1, .operation = "CPL" };
    //3rd row
    opcode_table[0 + 48] = commands{ .cycles = 2, .lenght = 2, .operation = "JR NC,i8" };
    opcode_table[1 + 48] = commands{ .cycles = 3, .lenght = 3, .operation = "LD SP,u16" };
    opcode_table[2 + 48] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL-),A" };
    opcode_table[3 + 48] = commands{ .cycles = 2, .lenght = 1, .operation = "INC SP" };
    opcode_table[4 + 48] = commands{ .cycles = 3, .lenght = 1, .operation = "INC (HL)" };
    opcode_table[5 + 48] = commands{ .cycles = 3, .lenght = 1, .operation = "DEC (HL)" };
    opcode_table[6 + 48] = commands{ .cycles = 3, .lenght = 2, .operation = "LD (HL),u8" };
    opcode_table[7 + 48] = commands{ .cycles = 1, .lenght = 1, .operation = "SCF" };
    opcode_table[8 + 48] = commands{ .cycles = 2, .lenght = 2, .operation = "JR C,i8" };
    opcode_table[9 + 48] = commands{ .cycles = 2, .lenght = 1, .operation = "ADD HL,SP" };
    opcode_table[10 + 48] = commands{ .cycles = 2, .lenght = 1, .operation = "LD A (HL-)" };
    opcode_table[11 + 48] = commands{ .cycles = 2, .lenght = 1, .operation = "DEC SP" };
    opcode_table[12 + 48] = commands{ .cycles = 1, .lenght = 1, .operation = "INC A" };
    opcode_table[13 + 48] = commands{ .cycles = 1, .lenght = 1, .operation = "DEC A" };
    opcode_table[14 + 48] = commands{ .cycles = 2, .lenght = 2, .operation = "LD A,u8" };
    opcode_table[15 + 48] = commands{ .cycles = 1, .lenght = 1, .operation = "CCF" };
    //4th row
    opcode_table[0 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD B,B" };
    opcode_table[1 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD B,C" };
    opcode_table[2 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD B,D" };
    opcode_table[3 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD B,E" };
    opcode_table[4 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD B,H" };
    opcode_table[5 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD B L" };
    opcode_table[6 + 64] = commands{ .cycles = 2, .lenght = 1, .operation = "LD B,(HL)" };
    opcode_table[7 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD B,A" };
    opcode_table[8 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD C,B" };
    opcode_table[9 + 64] = commands{ .cycles = 1, .lenght = 0, .operation = "LD C,C" };
    opcode_table[10 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD C,D" };
    opcode_table[11 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD C,E" };
    opcode_table[12 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD C,H" };
    opcode_table[13 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD C,L" };
    opcode_table[14 + 64] = commands{ .cycles = 2, .lenght = 1, .operation = "LD C,(HL)" };
    opcode_table[15 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LD C,A" };
    //5th row
    opcode_table[0 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD D,B" };
    opcode_table[1 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD D,C" };
    opcode_table[2 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD D,D" };
    opcode_table[3 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD D,E" };
    opcode_table[4 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD D,H" };
    opcode_table[5 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD D,L" };
    opcode_table[6 + 80] = commands{ .cycles = 2, .lenght = 1, .operation = "LD D,(HL)" };
    opcode_table[7 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD D,A" };
    opcode_table[8 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD E,B" };
    opcode_table[9 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD E,C" };
    opcode_table[10 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD E,D" };
    opcode_table[11 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD D,D" };
    opcode_table[12 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD E,H" };
    opcode_table[13 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD E,L" };
    opcode_table[14 + 80] = commands{ .cycles = 2, .lenght = 1, .operation = "LD E,(HL)" };
    opcode_table[15 + 80] = commands{ .cycles = 1, .lenght = 1, .operation = "LD C,A" };
    //6th row
    opcode_table[0 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD H,B" };
    opcode_table[1 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD H,C" };
    opcode_table[2 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD H,D" };
    opcode_table[3 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD H,E" };
    opcode_table[4 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD H,H" };
    opcode_table[5 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD H,L" };
    opcode_table[6 + 96] = commands{ .cycles = 2, .lenght = 1, .operation = "LD H,(HL)" };
    opcode_table[7 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD H,A" };
    opcode_table[8 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD L,B" };
    opcode_table[9 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD L,C" };
    opcode_table[10 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD L,D" };
    opcode_table[11 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD L,E" };
    opcode_table[12 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD L,H" };
    opcode_table[13 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD L,L" };
    opcode_table[14 + 96] = commands{ .cycles = 2, .lenght = 1, .operation = "LD L,(HL)" };
    opcode_table[15 + 96] = commands{ .cycles = 1, .lenght = 1, .operation = "LD L,A" };
    //7th row
    opcode_table[0 + 112] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL),B" };
    opcode_table[1 + 112] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL),C" };
    opcode_table[2 + 112] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL),D" };
    opcode_table[3 + 112] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL),E" };
    opcode_table[4 + 112] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL),H" };
    opcode_table[5 + 112] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL),L" };
    opcode_table[6 + 112] = commands{ .cycles = 1, .lenght = 1, .operation = "HALT" };
    opcode_table[7 + 112] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (HL),A" };
    opcode_table[8 + 112] = commands{ .cycles = 1, .lenght = 1, .operation = "LD A,B" };
    opcode_table[9 + 112] = commands{ .cycles = 1, .lenght = 1, .operation = "LD A,C" };
    opcode_table[10 + 112] = commands{ .cycles = 1, .lenght = 1, .operation = "LD A,D" };
    opcode_table[11 + 112] = commands{ .cycles = 1, .lenght = 1, .operation = "LD A,E" };
    opcode_table[12 + 112] = commands{ .cycles = 1, .lenght = 1, .operation = "LD A,H" };
    opcode_table[13 + 112] = commands{ .cycles = 1, .lenght = 1, .operation = "LD A,L" };
    opcode_table[14 + 112] = commands{ .cycles = 2, .lenght = 1, .operation = "LD A,(HL)" };
    opcode_table[15 + 112] = commands{ .cycles = 1, .lenght = 1, .operation = "LD A,A" };
    //8th row
    opcode_table[0 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADD A,B" };
    opcode_table[1 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADD A,C" };
    opcode_table[2 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADD A,D" };
    opcode_table[3 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADD A,E" };
    opcode_table[4 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADD A,H" };
    opcode_table[5 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADD A,L" };
    opcode_table[6 + 128] = commands{ .cycles = 2, .lenght = 1, .operation = "ADD A,(HL)" };
    opcode_table[7 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADD A,A" };
    opcode_table[8 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADC A,B" };
    opcode_table[9 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADC A,C" };
    opcode_table[10 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADC A,D" };
    opcode_table[11 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADC A,E" };
    opcode_table[12 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADC A,H" };
    opcode_table[13 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADC A,L" };
    opcode_table[14 + 128] = commands{ .cycles = 2, .lenght = 1, .operation = "ADC A,(HL)" };
    opcode_table[15 + 128] = commands{ .cycles = 1, .lenght = 1, .operation = "ADC A,A" };
    //9th row
    opcode_table[0 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SUB A,B" };
    opcode_table[1 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SUB A,C" };
    opcode_table[2 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SUB A,D" };
    opcode_table[3 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SUB A,E" };
    opcode_table[4 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SUB A,H" };
    opcode_table[5 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SUB A,L" };
    opcode_table[6 + 144] = commands{ .cycles = 2, .lenght = 1, .operation = "SUB A,(HL)" };
    opcode_table[7 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SUB A,A" };
    opcode_table[8 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SBC A,B" };
    opcode_table[9 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SBC A,C" };
    opcode_table[10 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SBC A,D" };
    opcode_table[11 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SBC A,E" };
    opcode_table[12 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SBC A,H" };
    opcode_table[13 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SBC A,L" };
    opcode_table[14 + 144] = commands{ .cycles = 2, .lenght = 1, .operation = "SBC A,(HL)" };
    opcode_table[15 + 144] = commands{ .cycles = 1, .lenght = 1, .operation = "SBC A,A" };
    //10th row
    opcode_table[0 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "AND A,B" };
    opcode_table[1 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "AND A,C" };
    opcode_table[2 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "AND A,D" };
    opcode_table[3 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "AND A,E" };
    opcode_table[4 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "AND A,H" };
    opcode_table[5 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "AND A,L" };
    opcode_table[6 + 160] = commands{ .cycles = 2, .lenght = 1, .operation = "AND A,(HL)" };
    opcode_table[7 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "AND A,A" };
    opcode_table[8 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "XOR A,B" };
    opcode_table[9 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "XOR A,C" };
    opcode_table[10 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "XOR A,D" };
    opcode_table[11 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "XOR A,E" };
    opcode_table[12 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "XOR A,H" };
    opcode_table[13 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "XOR A,L" };
    opcode_table[14 + 160] = commands{ .cycles = 2, .lenght = 1, .operation = "XOR A,(HL)" };
    opcode_table[15 + 160] = commands{ .cycles = 1, .lenght = 1, .operation = "XOR A,A" };
    //11th row
    opcode_table[0 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "OR A,B" };
    opcode_table[1 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "OR A,C" };
    opcode_table[2 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "OR A,D" };
    opcode_table[3 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "OR A,E" };
    opcode_table[4 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "OR A,H" };
    opcode_table[5 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "OR A,L" };
    opcode_table[6 + 176] = commands{ .cycles = 2, .lenght = 1, .operation = "OR A,(HL)" };
    opcode_table[7 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "CP A,A" };
    opcode_table[8 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "CP A,B" };
    opcode_table[9 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "CP A,C" };
    opcode_table[10 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "CP A,D" };
    opcode_table[11 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "CP A,E" };
    opcode_table[12 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "CP A,H" };
    opcode_table[13 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "CP A,L" };
    opcode_table[14 + 176] = commands{ .cycles = 2, .lenght = 1, .operation = "CP A,(HL)" };
    opcode_table[15 + 176] = commands{ .cycles = 1, .lenght = 1, .operation = "CP A,A" };
    //12th row
    opcode_table[0 + 192] = commands{ .cycles = 2, .lenght = 1, .operation = "RET NZ" };
    opcode_table[1 + 192] = commands{ .cycles = 3, .lenght = 1, .operation = "POP BC" };
    opcode_table[2 + 192] = commands{ .cycles = 3, .lenght = 3, .operation = "JP NZ,u16" };
    opcode_table[3 + 192] = commands{ .cycles = 3, .lenght = 3, .operation = "JP u16" };
    opcode_table[4 + 192] = commands{ .cycles = 3, .lenght = 3, .operation = "CALL NZ,u16" };
    opcode_table[5 + 192] = commands{ .cycles = 4, .lenght = 1, .operation = "PUSH BC" };
    opcode_table[6 + 192] = commands{ .cycles = 2, .lenght = 2, .operation = "ADD A,u8" };
    opcode_table[7 + 192] = commands{ .cycles = 4, .lenght = 1, .operation = "RST 00h" };
    opcode_table[8 + 192] = commands{ .cycles = 2, .lenght = 1, .operation = "RET Z" };
    opcode_table[9 + 192] = commands{ .cycles = 4, .lenght = 1, .operation = "RET" };
    opcode_table[10 + 192] = commands{ .cycles = 3, .lenght = 3, .operation = "JP Z,u16" };
    opcode_table[11 + 192] = commands{ .cycles = 1, .lenght = 1, .operation = "PREFIX CB" };
    opcode_table[12 + 192] = commands{ .cycles = 3, .lenght = 3, .operation = "CALL Z,U16" };
    opcode_table[13 + 192] = commands{ .cycles = 6, .lenght = 3, .operation = "CALL u16" };
    opcode_table[14 + 192] = commands{ .cycles = 2, .lenght = 2, .operation = "ADC A,u8" };
    opcode_table[15 + 192] = commands{ .cycles = 4, .lenght = 1, .operation = "RST 00h" };
    //13th row
    opcode_table[0 + 208] = commands{ .cycles = 2, .lenght = 1, .operation = "RET NC" };
    opcode_table[1 + 208] = commands{ .cycles = 3, .lenght = 1, .operation = "POP DE" };
    opcode_table[2 + 208] = commands{ .cycles = 3, .lenght = 3, .operation = "JP NC,u16" };
    opcode_table[3 + 208] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[4 + 208] = commands{ .cycles = 3, .lenght = 3, .operation = "CALL NC,u16" };
    opcode_table[5 + 208] = commands{ .cycles = 4, .lenght = 1, .operation = "PUSH DE" };
    opcode_table[6 + 208] = commands{ .cycles = 2, .lenght = 2, .operation = "SUB A,u8" };
    opcode_table[7 + 208] = commands{ .cycles = 4, .lenght = 1, .operation = "RST 10h" };
    opcode_table[8 + 208] = commands{ .cycles = 2, .lenght = 1, .operation = "RET C" };
    opcode_table[9 + 208] = commands{ .cycles = 4, .lenght = 1, .operation = "RETI" };
    opcode_table[10 + 208] = commands{ .cycles = 3, .lenght = 3, .operation = "JP C,u16" };
    opcode_table[11 + 208] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[12 + 208] = commands{ .cycles = 3, .lenght = 3, .operation = "CALL C,u16" };
    opcode_table[13 + 208] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[14 + 208] = commands{ .cycles = 2, .lenght = 2, .operation = "SBC A,u8" };
    opcode_table[15 + 208] = commands{ .cycles = 4, .lenght = 1, .operation = "RST 08h" };
    //14th row
    opcode_table[0 + 224] = commands{ .cycles = 3, .lenght = 2, .operation = "LD (FF00+u8),A" };
    opcode_table[1 + 224] = commands{ .cycles = 3, .lenght = 1, .operation = "POP HL" };
    opcode_table[2 + 224] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (FF00+C),A" };
    opcode_table[3 + 224] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[4 + 224] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[5 + 224] = commands{ .cycles = 4, .lenght = 1, .operation = "PUSH HL" };
    opcode_table[6 + 224] = commands{ .cycles = 2, .lenght = 2, .operation = "AND A,u8" };
    opcode_table[7 + 224] = commands{ .cycles = 4, .lenght = 1, .operation = "RST 20h" };
    opcode_table[8 + 224] = commands{ .cycles = 4, .lenght = 2, .operation = "ADD SP,i8" };
    opcode_table[9 + 224] = commands{ .cycles = 1, .lenght = 1, .operation = "JP HL" };
    opcode_table[10 + 224] = commands{ .cycles = 4, .lenght = 3, .operation = "LD (u16),A" };
    opcode_table[11 + 224] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[12 + 224] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[13 + 224] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[14 + 224] = commands{ .cycles = 2, .lenght = 2, .operation = "XOR A,u8" };
    opcode_table[15 + 224] = commands{ .cycles = 4, .lenght = 1, .operation = "RST 28h" };
    //15th row
    opcode_table[0 + 240] = commands{ .cycles = 3, .lenght = 2, .operation = "LD A,(FF00+u8)" };
    opcode_table[1 + 240] = commands{ .cycles = 3, .lenght = 1, .operation = "POP AF" };
    opcode_table[2 + 240] = commands{ .cycles = 2, .lenght = 1, .operation = "LD A,(FF00+C)" };
    opcode_table[3 + 240] = commands{ .cycles = 1, .lenght = 1, .operation = "DI" };
    opcode_table[4 + 240] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[5 + 240] = commands{ .cycles = 4, .lenght = 1, .operation = "PUSH AF" };
    opcode_table[6 + 240] = commands{ .cycles = 2, .lenght = 2, .operation = "OR A,u8" };
    opcode_table[7 + 240] = commands{ .cycles = 4, .lenght = 1, .operation = "RST 30h" };
    opcode_table[8 + 240] = commands{ .cycles = 3, .lenght = 2, .operation = "LD HL,SP+i8" };
    opcode_table[9 + 240] = commands{ .cycles = 2, .lenght = 1, .operation = "LS SP,HL" };
    opcode_table[10 + 240] = commands{ .cycles = 2, .lenght = 1, .operation = "LD A,(u16)" };
    opcode_table[11 + 240] = commands{ .cycles = 1, .lenght = 1, .operation = "EI" };
    opcode_table[12 + 240] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[13 + 240] = commands{ .cycles = 0, .lenght = 0, .operation = "" };
    opcode_table[14 + 240] = commands{ .cycles = 2, .lenght = 2, .operation = "CP A,u8" };
    opcode_table[15 + 240] = commands{ .cycles = 4, .lenght = 1, .operation = "RST 38h" };
    //0th row of 1st table
    opcode_table[0 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RLC B" };
    opcode_table[1 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RLC C" };
    opcode_table[2 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RLC D" };
    opcode_table[3 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RLC E" };
    opcode_table[4 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RLC H" };
    opcode_table[5 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RLC L" };
    opcode_table[6 + 0 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RLC (HL)" };
    opcode_table[7 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RLC A" };
    opcode_table[8 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RRC B" };
    opcode_table[9 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RRC C" };
    opcode_table[10 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RRC D" };
    opcode_table[11 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RRC E" };
    opcode_table[12 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RRC H" };
    opcode_table[13 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RRC L" };
    opcode_table[14 + 0 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RRC (HL)" };
    opcode_table[15 + 0 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RRC A" };
    //1st row
    opcode_table[0 + 16 + 255] = commands{ .cycles = 2, .lenght = 2, .operation = "RL B" };
    opcode_table[1 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RL C" };
    opcode_table[2 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RL D" };
    opcode_table[3 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RL E" };
    opcode_table[4 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RL H" };
    opcode_table[5 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RL L" };
    opcode_table[6 + 16 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RL (HL)" };
    opcode_table[7 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RL A" };
    opcode_table[8 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RR B" };
    opcode_table[9 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RR C" };
    opcode_table[10 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RR D" };
    opcode_table[11 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RR E" };
    opcode_table[12 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RR H" };
    opcode_table[13 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RR L" };
    opcode_table[14 + 16 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RR (HL)" };
    opcode_table[15 + 16 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RR A" };
    //2nd row
    opcode_table[0 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SLA B" };
    opcode_table[1 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SLA C" };
    opcode_table[2 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SLA D" };
    opcode_table[3 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SLA E" };
    opcode_table[4 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SLA H" };
    opcode_table[5 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SLA L" };
    opcode_table[6 + 32 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SLA (HL)" };
    opcode_table[7 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SLA A" };
    opcode_table[8 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRA B" };
    opcode_table[9 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRA C" };
    opcode_table[10 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRA D" };
    opcode_table[11 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRA E" };
    opcode_table[12 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRA H" };
    opcode_table[13 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRA L" };
    opcode_table[14 + 32 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SRA (HL)" };
    opcode_table[15 + 32 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRA A" };
    //3rd row
    opcode_table[0 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SWAP B" };
    opcode_table[1 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SWAP C" };
    opcode_table[2 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SWAP D" };
    opcode_table[3 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SWAP E" };
    opcode_table[4 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SWAP H" };
    opcode_table[5 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SWAP L" };
    opcode_table[6 + 48 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SWAP (HL)" };
    opcode_table[7 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SWAP A" };
    opcode_table[8 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRL B" };
    opcode_table[9 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRL C" };
    opcode_table[10 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRL D" };
    opcode_table[11 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRL E" };
    opcode_table[12 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRL H" };
    opcode_table[13 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRL L" };
    opcode_table[14 + 48 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SRL (HL)" };
    opcode_table[15 + 48 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SRL A" };
    //4th row
    opcode_table[0 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 0,B" };
    opcode_table[1 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 0,C" };
    opcode_table[2 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 0,D" };
    opcode_table[3 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 0,E" };
    opcode_table[4 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 0,H" };
    opcode_table[5 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 0,L" };
    opcode_table[6 + 64 + 256] = commands{ .cycles = 3, .lenght = 2, .operation = "BIT 0,(HL)" };
    opcode_table[7 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 0,A" };
    opcode_table[8 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 1,B" };
    opcode_table[9 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 1,C" };
    opcode_table[10 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 1,D" };
    opcode_table[11 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 1,E" };
    opcode_table[12 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 1,H" };
    opcode_table[13 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 1,L" };
    opcode_table[14 + 64 + 256] = commands{ .cycles = 3, .lenght = 2, .operation = "BIT 1,(HL)" };
    opcode_table[15 + 64 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 1,A" };
    //5th row
    opcode_table[0 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 2,B" };
    opcode_table[1 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 2,C" };
    opcode_table[2 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 2,D" };
    opcode_table[3 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 2,E" };
    opcode_table[4 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 2,H" };
    opcode_table[5 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 2,L" };
    opcode_table[6 + 80 + 256] = commands{ .cycles = 3, .lenght = 2, .operation = "BIT 2,(HL)" };
    opcode_table[7 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 2,A" };
    opcode_table[8 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 3,B" };
    opcode_table[9 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 3,C" };
    opcode_table[10 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 3,D" };
    opcode_table[11 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 3,E" };
    opcode_table[12 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 3,H" };
    opcode_table[13 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 3,L" };
    opcode_table[14 + 80 + 256] = commands{ .cycles = 3, .lenght = 2, .operation = "BIT 3,(HL)" };
    opcode_table[15 + 80 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 3,A" };
    //6th row
    opcode_table[0 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 4,B" };
    opcode_table[1 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 4,C" };
    opcode_table[2 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 4,D" };
    opcode_table[3 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 4,E" };
    opcode_table[4 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 4,H" };
    opcode_table[5 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 4,L" };
    opcode_table[6 + 96 + 256] = commands{ .cycles = 3, .lenght = 2, .operation = "BIT 4,(HL)" };
    opcode_table[7 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 4,A" };
    opcode_table[8 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 5,B" };
    opcode_table[9 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 5,C" };
    opcode_table[10 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 5,D" };
    opcode_table[11 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 5,E" };
    opcode_table[12 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 5,H" };
    opcode_table[13 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 5,L" };
    opcode_table[14 + 96 + 256] = commands{ .cycles = 3, .lenght = 2, .operation = "BIT 5,(HL)" };
    opcode_table[15 + 96 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 5,A" };
    //7th row
    opcode_table[0 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 6,B" };
    opcode_table[1 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 6,C" };
    opcode_table[2 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 6,D" };
    opcode_table[3 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 6,E" };
    opcode_table[4 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 6,H" };
    opcode_table[5 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 6,L" };
    opcode_table[6 + 112 + 256] = commands{ .cycles = 3, .lenght = 2, .operation = "BIT 6,(HL)" };
    opcode_table[7 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 6,A" };
    opcode_table[8 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 7,B" };
    opcode_table[9 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 7,C" };
    opcode_table[10 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 7,D" };
    opcode_table[11 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 7,E" };
    opcode_table[12 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 7,H" };
    opcode_table[13 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 7,L" };
    opcode_table[14 + 112 + 256] = commands{ .cycles = 3, .lenght = 2, .operation = "BIT 7,(HL)" };
    opcode_table[15 + 112 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "BIT 7,A" };
    //8th row
    opcode_table[0 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 0,B" };
    opcode_table[1 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 0,C" };
    opcode_table[2 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 0,D" };
    opcode_table[3 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 0,E" };
    opcode_table[4 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 0,H" };
    opcode_table[5 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 0,L" };
    opcode_table[6 + 128 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RES 0,(HL)" };
    opcode_table[7 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 0,A" };
    opcode_table[8 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 1,B" };
    opcode_table[9 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 1,C" };
    opcode_table[10 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 1,D" };
    opcode_table[11 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 1,E" };
    opcode_table[12 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 1,H" };
    opcode_table[13 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 1,L" };
    opcode_table[14 + 128 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RES 1,(HL)" };
    opcode_table[15 + 128 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 1,A" };
    //9th row
    opcode_table[0 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 2,B" };
    opcode_table[1 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 2,C" };
    opcode_table[2 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 2,D" };
    opcode_table[3 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 2,E" };
    opcode_table[4 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 2,H" };
    opcode_table[5 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 2,L" };
    opcode_table[6 + 144 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RES 2,(HL)" };
    opcode_table[7 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 2,A" };
    opcode_table[8 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 3,B" };
    opcode_table[9 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 3,C" };
    opcode_table[10 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 3,D" };
    opcode_table[11 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 3,E" };
    opcode_table[12 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 3,H" };
    opcode_table[13 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 3,L" };
    opcode_table[14 + 144 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RES 3,(HL)" };
    opcode_table[15 + 144 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 3,A" };
    //10th row
    opcode_table[0 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 4,B" };
    opcode_table[1 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 4,C" };
    opcode_table[2 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 4,D" };
    opcode_table[3 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 4,E" };
    opcode_table[4 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 4,H" };
    opcode_table[5 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 4,L" };
    opcode_table[6 + 160 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RES 4,(HL)" };
    opcode_table[7 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 4,A" };
    opcode_table[8 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 5,B" };
    opcode_table[9 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 5,C" };
    opcode_table[10 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 5,D" };
    opcode_table[11 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 5,E" };
    opcode_table[12 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 5,H" };
    opcode_table[13 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 5,L" };
    opcode_table[14 + 160 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RES 5,(HL)" };
    opcode_table[15 + 160 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 5,A" };
    //11th row
    opcode_table[0 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 6,B" };
    opcode_table[1 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 6,C" };
    opcode_table[2 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 6,D" };
    opcode_table[3 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 6,E" };
    opcode_table[4 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 6,H" };
    opcode_table[5 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 6,L" };
    opcode_table[6 + 176 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RES 6,(HL)" };
    opcode_table[7 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 6,A" };
    opcode_table[8 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 7,B" };
    opcode_table[9 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 7,C" };
    opcode_table[10 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 7,D" };
    opcode_table[11 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 7,E" };
    opcode_table[12 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 7,H" };
    opcode_table[13 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 7,L" };
    opcode_table[14 + 176 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "RES 7,(HL)" };
    opcode_table[15 + 176 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "RES 7,A" };
    //12th row
    opcode_table[0 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 0,B" };
    opcode_table[1 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 0,C" };
    opcode_table[2 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 0,D" };
    opcode_table[3 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 0,E" };
    opcode_table[4 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 0,H" };
    opcode_table[5 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 0,L" };
    opcode_table[6 + 192 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SET 0,(HL)" };
    opcode_table[7 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 0,A" };
    opcode_table[8 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 1,B" };
    opcode_table[9 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 1,C" };
    opcode_table[10 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 1,D" };
    opcode_table[11 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 1,E" };
    opcode_table[12 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 1,H" };
    opcode_table[13 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 1,L" };
    opcode_table[14 + 192 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SET 1,(HL)" };
    opcode_table[15 + 192 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 1,A" };
    //13th row
    opcode_table[0 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 2,B" };
    opcode_table[1 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 2,C" };
    opcode_table[2 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 2,D" };
    opcode_table[3 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 2,E" };
    opcode_table[4 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 2,H" };
    opcode_table[5 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 2,L" };
    opcode_table[6 + 208 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SET 2,(HL)" };
    opcode_table[7 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 2,A" };
    opcode_table[8 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 3,B" };
    opcode_table[9 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 3,C" };
    opcode_table[10 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 3,D" };
    opcode_table[11 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 3,E" };
    opcode_table[12 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 3,H" };
    opcode_table[13 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 3,L" };
    opcode_table[14 + 208 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SET 3,(HL)" };
    opcode_table[15 + 208 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 3,A" };
    //14th row
    opcode_table[0 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 4,B" };
    opcode_table[1 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 4,C" };
    opcode_table[2 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 4,D" };
    opcode_table[3 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 4,E" };
    opcode_table[4 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 4,H" };
    opcode_table[5 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 4,L" };
    opcode_table[6 + 224 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SET 4,(HL)" };
    opcode_table[7 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 4,A" };
    opcode_table[8 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 5,B" };
    opcode_table[9 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 5,C" };
    opcode_table[10 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 5,D" };
    opcode_table[11 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 5,E" };
    opcode_table[12 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 5,H" };
    opcode_table[13 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 5,L" };
    opcode_table[14 + 224 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SET 5,(HL)" };
    opcode_table[15 + 224 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 5,A" };
    //15th row
    opcode_table[0 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 6,B" };
    opcode_table[1 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 6,C" };
    opcode_table[2 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 6,D" };
    opcode_table[3 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 6,E" };
    opcode_table[4 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 6,H" };
    opcode_table[5 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 6,L" };
    opcode_table[6 + 240 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SET 6,(HL)" };
    opcode_table[7 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 6,A" };
    opcode_table[8 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 7,B" };
    opcode_table[9 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 7,C" };
    opcode_table[10 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 7,D" };
    opcode_table[11 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 7,E" };
    opcode_table[12 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 7,H" };
    opcode_table[13 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 7,L" };
    opcode_table[14 + 240 + 256] = commands{ .cycles = 4, .lenght = 2, .operation = "SET 7,(HL)" };
    opcode_table[15 + 240 + 256] = commands{ .cycles = 2, .lenght = 2, .operation = "SET 7,A" };
}
const stdout = std.io.getStdOut().writer();
pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile("tetris.gb", .{}); //it is set as tetris.gb for test
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);
    var list = std.ArrayList([]u8).init(allocator); //i have to make it dynamic because
    //idk how big it will get because of diffrent .gb file sizes
    //Todo have to add a system to check how big a file is from the info at the start of the file

    _ = try file.readAll(buffer);

    const mask: u8 = 0b1000_0000;
    for (buffer) |byte| {
        var bits: [8]u8 = undefined;

        for (0..8) |i| {
            const u8i: U3 = @truncate(i); // truncate to do stuff with mask to 3 bits
            bits[i] = if ((byte & (mask >> @as(U3, u8i))) != 0) @as(u8, 1) else @as(u8, 0);
        }
        try list.append(&bits);
    }

    try stdout.writeByte('\n');
    var first256: [256][]u8 = undefined; //test for the tertris.gb
    //later will be changed to check for every cartrige
    for (0..256) |i| {
        first256[i] = list.items[i];
    }
    var header: [80][]u8 = undefined; //idk what to do with it yet
    for (256..336) |i| {
        header[i - 256] = list.items[i];
    }
    const len = list.items.len;
    //because that works for some reason but not in the for statement
    var code: [32432][]u8 = undefined;
    for (336..len) |i| {
        code[i - 336] = list.items[i];
    }
    for (0..len) |i| {
        const item: u8 = bin_into_int(list.items[i]);
        try stdout.print("{}", .{item});
    }
    //for (0..len) |i| {
    //    try stdout.print("{}", .{bin_into_int(list.items[i])});
    //}
    defer list.deinit(); // to get rit of the bits of tertis.gb
    // dont really know if i have to place it here or right after the list
}
pub fn bin_into_int(x: []u8) u8 {
    var a: u8 = 0;
    for (x, 0..) |j, i| {
        std.debug.print("{}", .{j});
        a += j * math.pow(u8, 2, @truncate(i));
    }
    return a;
}
//Todo turn the bits into asm code with the op codes of the gameboy
