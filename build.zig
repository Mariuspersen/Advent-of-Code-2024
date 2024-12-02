const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const days = [_]*std.Build.Step.Compile{
        b.addExecutable(.{
            .name = "day1",
            .root_source_file = b.path("src/day1.zig"),
            .target = target,
            .optimize = optimize,
        }),
        b.addExecutable(.{
            .name = "day2",
            .root_source_file = b.path("src/day2.zig"),
            .target = target,
            .optimize = optimize,
        }),
    };

    const run_step = b.step("run", "Run the app");

    for (days) |compile| {
        b.installArtifact(compile);
        
        const run = b.addRunArtifact(compile);
        run.step.dependOn(b.getInstallStep());

        if (b.args) |args| {
            run.addArgs(args);
        }
        
        run_step.dependOn(&run.step);
    }
}
