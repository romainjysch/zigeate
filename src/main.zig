const std = @import("std");
const create = @import("create.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 2) {
        printHelp();
        std.process.exit(1);
    }

    if (std.mem.eql(u8, args[1], "-h") or std.mem.eql(u8, args[1], "--help")) {
        printHelp();
        std.process.exit(0);
    }

    const project_name = args[1];
    try create.run(allocator, project_name);
}

fn printHelp() void {
    std.debug.print(
        \\zigeate - a minimalist alternative to `zig init`
        \\
        \\Usage:
        \\  zigeate [project_name]  Create a new project in a new directory
        \\  zigeate -h | --help     Print this help and exit
        \\
        \\Example:
        \\  zigeate my_new_project
        \\
    , .{});
}
