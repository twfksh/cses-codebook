const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const args = b.args orelse {
        std.log.err("Usage: zig build run -- <pattern> [input_file]", .{});
        std.process.exit(1);
    };

    if (args.len == 0) {
        std.log.err("Please provide a pattern to match", .{});
        std.process.exit(1);
    }

    const pattern = args[0];
    const input_file = if (args.len > 1) args[1] else null;

    const matched_file = findMatchingFile(b.allocator, pattern) catch |err| switch (err) {
        error.FileNotFound => {
            std.log.err("No files found matching pattern '{s}' in src/", .{pattern});
            std.process.exit(1);
        },
        error.MultipleMatches => {
            std.log.err("Multiple files match '{s}'. Be more specific.", .{pattern});
            std.process.exit(1);
        },
        else => {
            std.log.err("Error: {}", .{err});
            std.process.exit(1);
        },
    };

    std.log.info("Building: {s}", .{matched_file});

    const exe = b.addExecutable(.{
        .name = pattern,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.addCSourceFile(.{
        .file = b.path(matched_file),
        .flags = &.{
            "-std=c++23",
            "-Wall",
            "-Wextra",
        },
    });

    exe.linkLibCpp();
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (input_file) |file| {
        std.fs.cwd().access(file, .{}) catch {
            std.log.err("Input file '{s}' not found", .{file});
            std.process.exit(1);
        };

        std.log.info("Using input file: {s}", .{file});
        run_cmd.setStdIn(.{ .lazy_path = b.path(file) });
    }

    if (args.len > 2) {
        run_cmd.addArgs(args[2..]);
    }

    const run_step = b.step("run", "Run the matched program");
    run_step.dependOn(&run_cmd.step);
}

fn findMatchingFile(allocator: std.mem.Allocator, pattern: []const u8) ![]const u8 {
    var src_dir = std.fs.cwd().openDir("src", .{ .iterate = true }) catch {
        std.log.err("src/ directory not found", .{});
        return error.FileNotFound;
    };
    defer src_dir.close();

    var matches = std.array_list.Managed([]const u8).init(allocator);
    defer {
        for (matches.items) |match| {
            allocator.free(match);
        }
        matches.deinit();
    }

    var iterator = src_dir.iterate();
    while (iterator.next() catch null) |entry| {
        if (entry.kind != .file) continue;
        if (!std.mem.endsWith(u8, entry.name, ".cpp")) continue;

        if (std.mem.indexOf(u8, entry.name, pattern) != null) {
            try matches.append(try allocator.dupe(u8, entry.name));
        }
    }

    if (matches.items.len == 0) {
        return error.FileNotFound;
    }

    if (matches.items.len > 1) {
        std.log.info("Found multiple matches:", .{});
        for (matches.items) |match| {
            std.log.info("  - {s}", .{match});
        }
        return error.MultipleMatches;
    }

    const filename = matches.items[0];
    return std.fmt.allocPrint(allocator, "src/{s}", .{filename});
}
