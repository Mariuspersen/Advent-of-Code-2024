const std = @import("std");
const common = @import("common.zig");

const input = @embedFile("day1input.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var left = std.ArrayList(i32).init(allocator);
    var right = std.ArrayList(i32).init(allocator);
    defer left.deinit();
    defer right.deinit();

    var lines = std.mem.splitAny(u8, input, "\n");
    while (lines.next()) |line| {
        var numbers = std.mem.split(u8, line, "   ");
        const n1 = numbers.next() orelse return error.NotEnoughNumbersOnLine;
        const n2 = numbers.next() orelse return error.NotEnoughNumbersOnLine;

        const left_number = try std.fmt.parseInt(i32, n1, 10);
        const right_number = try std.fmt.parseInt(i32, n2, 10);
        try left.append(left_number);
        try right.append(right_number);
    }

    std.mem.sort(i32, left.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, right.items, {}, std.sort.asc(i32));

    var acc: i32 = 0;
    for (left.items, right.items) |l,r| {
        acc += if (l > r) l - r else r - l;
    }
    
    var acc_part2: i32 = 0;
    var count_part2: i32 = 0;
    for (left.items) |l| {
        for (right.items) |r| {
            if (l == r) count_part2 += 1;
        }
        acc_part2 += l * count_part2;
        count_part2 = 0;
    }

    std.debug.print("Part 1: {d}\n", .{acc});
    std.debug.print("Part 2: {d}\n", .{acc_part2});

}