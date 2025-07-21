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
    opcode_table[16] = commands{ .cycles = 1, .lenght = 1, .operation = "STOP" };
    opcode_table[17] = commands{ .cycles = 3, .lenght = 3, .operation = "LD DE,u16" };
    opcode_table[18] = commands{ .cycles = 2, .lenght = 1, .operation = "LD (DE),A" };
    opcode_table[19] = commands{ .cycles = 2, .lenght = 1, .operation = "INC DE" };
    opcode_table[20] = commands{ .cycles = 1, .lenght = 1, .operation = "INC D" };
    opcode_table[21] = commands{ .cycles = 1, .lenght = 1, .operation = "DEC D" };
    opcode_table[22] = commands{ .cycles = 2, .lenght = 2, .operation = "LD H,u8" };
    opcode_table[23] = commands{ .cycles = 1, .lenght = 1, .operation = "RLA" };
    opcode_table[24] = commands{ .cycles = 3, .lenght = 2, .operation = "JR i8" };
    opcode_table[25] = commands{ .cycles = 2, .lenght = 1, .operation = "ADD HL,DE" };
    opcode_table[26] = commands{ .cycles = 2, .lenght = 1, .operation = "Ld A,(DE)" }; //first 27 opcodes
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
