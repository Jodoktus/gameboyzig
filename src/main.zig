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
    try stdout.writeAll(&list);
    try stdout.writeByte('\n');
    defer list.deinit(); // to get rit of the bits of tertis.gb
    // dont really know if i have to place it here or right after the list
}
