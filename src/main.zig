const std = @import("std");

const U3 = std.meta.Int(.unsigned, 3); //so i can test what bit it is same lenght as mask

const U1 = std.meta.Int(.unsigned, 1); //bits
const commands = struct {
    cycles: u8,
    lenght: u8,
    operation: []const u8,
};
var opcode_table: [256]commands = undefined;
pub fn opcodes_to_table() !void() {
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
    //first row
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
    //second row
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
    //third row
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
    //fourth row
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
    opcode_table[10 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LC C,D" };
    opcode_table[11 + 64] = commands{ .cycles = 1, .lenght = 1, .operation = "LC C,E" };
}
pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile("tetris.gb", .{}); //it is set as tetris.gb for test
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);
    var list = std.ArrayList([]U1).init(allocator); //i have to make it dynamic because
    //idk how big it will get because of diffrent .gb file sizes
    //Todo have to add a system to check how big a file is from the info at the start of the file

    _ = try file.readAll(buffer);

    const stdout = std.io.getStdOut().writer();
    const mask: u8 = 0b1000_0000;
    for (buffer) |byte| {
        var bits: [8]U1 = undefined;

        for (0..8) |i| {
            const u8i: U3 = @truncate(i); // truncate to do stuff with mask to 3 bits
            bits[i] = if ((byte & (mask >> @as(U3, u8i))) != 0) @as(U1, 1) else @as(U1, 0);
        }
        try list.append(&bits);
    }

    try stdout.writeByte('\n');
    var first256: [256][]U1 = undefined; //test for the tertris.gb
    //later will be changed to check for every cartrige
    for (0..256) |i| {
        first256[i] = list.items[i];
    }
    var header: [80][]U1 = undefined; //idk what to do with it yet
    for (256..336) |i| {
        header[i - 256] = list.items[i];
    }
    const len = list.items.len;
    //because that works for some reason but not in the for statement
    var code: [32432][]U1 = undefined;
    for (336..len) |i| {
        code[i - 336] = list.items[i];
    }

    defer list.deinit(); // to get rit of the bits of tertis.gb
    // dont really know if i have to place it here or right after the list
}

//Todo turn the bits into asm code with the op codes of the gameboy
