const std = @import("std");

const U3 = std.meta.Int(.unsigned, 3);

const U1 = std.meta.Int(.unsigned, 1);

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile("tetris.gb", .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);
    var list = std.ArrayList([]U1).init(allocator);

    _ = try file.readAll(buffer);

    const stdout = std.io.getStdOut().writer();
    const mask: u8 = 0b1000_0000;
    for (buffer) |byte| {
        var bits: [8]U1 = undefined;

        for (0..8) |i| {
            const u8i: U3 = @truncate(i);
            bits[i] = if ((byte & (mask >> @as(U3, u8i))) != 0) @as(U1, 1) else @as(U1, 0);
        }
        try list.append(&bits);
    }
    try stdout.writeAll(&list);
    try stdout.writeByte('\n');
    defer list.deinit(); // Free memory when done
}
