const std = @import("std");
const common = @import("common.zig");

const input = @embedFile("day2input.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var safe_reports_count: i32 = 0;
    var reports = std.mem.split(u8, input, "\n");
    while (reports.next()) |report| {
        var parsed_levels = std.ArrayList(i32).init(allocator);
        defer parsed_levels.deinit();

        var levels = std.mem.split(u8, report, " ");
        while (levels.next()) |level| {
            const parsed = try std.fmt.parseInt(i32, level, 10);
            try parsed_levels.append(parsed);
        }

        var safe: bool = true;
        const ascending: bool = parsed_levels.items[0] < parsed_levels.items[1];
        for (parsed_levels.items[0..parsed_levels.items.len-1],1..) |current,i| {
            const next = parsed_levels.items[i];
            const within_limits = 
            if (ascending) current < next and current + 3 >= next 
            else current > next and current <= next + 3;
            if (!within_limits) {
                safe = false;
                break;
            }
        }
        if (safe) safe_reports_count += 1;
    }

    std.debug.print("Day 2 Part 1: {d}\n", .{safe_reports_count});
}