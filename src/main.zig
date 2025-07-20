const std = @import("std");

const U3 = std.meta.Int(.unsigned, 3); //so i can test what bit it is same lenght as mask

const U1 = std.meta.Int(.unsigned, 1); //bits

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
