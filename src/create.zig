const std = @import("std");
const templates = @import("templates.zig");
const fs = std.fs;
const mem = std.mem;

pub fn run(allocator: std.mem.Allocator, project_name: []const u8) !void {
    var dir = fs.cwd().openDir(project_name, .{}) catch |err| {
        switch (err) {
            error.FileNotFound => {},
            else => return err,
        }

        try fs.cwd().makeDir(project_name);
        std.debug.print("Creating {s}...\n", .{project_name});

        try createAllFile(allocator, project_name);

        std.debug.print("{s} successfully created.\n", .{project_name});
        return;
    };
    defer dir.close();
    std.debug.print("Error: directory {s} already exists.\n", .{project_name});
    return error.ProjectAlreadyExists;
}

fn createAllFile(allocator: std.mem.Allocator, project_name: []const u8) !void {
    try createMainFile(allocator, project_name);
    try createBuildFile(allocator, project_name);
    try createReadme(allocator, project_name);
    try createGitIgnore(allocator, project_name);
}

fn createMainFile(allocator: std.mem.Allocator, project_name: []const u8) !void {
    const src_path = try fs.path.join(allocator, &[_][]const u8{ project_name, "src" });
    try fs.cwd().makeDir(src_path);

    const main_path = try fs.path.join(allocator, &[_][]const u8{ project_name, "src/main.zig" });
    const main_file = try fs.cwd().createFile(main_path, .{});
    defer main_file.close();
    try main_file.writeAll(templates.MAIN_FILE_CONTENT);
}

fn createBuildFile(allocator: std.mem.Allocator, project_name: []const u8) !void {
    const build_path = try fs.path.join(allocator, &[_][]const u8{ project_name, "build.zig" });
    const build_file = try fs.cwd().createFile(build_path, .{});
    defer build_file.close();
    const build_content = try std.fmt.allocPrint(allocator, templates.BUILD_TEMPLATE, .{project_name});
    try build_file.writeAll(build_content);
}

fn createReadme(allocator: std.mem.Allocator, project_name: []const u8) !void {
    const readme_path = try fs.path.join(allocator, &[_][]const u8{ project_name, "README.md" });
    const readme_file = try fs.cwd().createFile(readme_path, .{});
    defer readme_file.close();
    const readme_content = try std.fmt.allocPrint(allocator, templates.README_TEMPLATE, .{project_name});
    try readme_file.writeAll(readme_content);
}

fn createGitIgnore(allocator: std.mem.Allocator, project_name: []const u8) !void {
    const gitignore_path = try fs.path.join(allocator, &[_][]const u8{ project_name, ".gitignore" });
    const gitignore_file = try fs.cwd().createFile(gitignore_path, .{});
    defer gitignore_file.close();
    try gitignore_file.writeAll(templates.GITIGNORE_CONTENT);
}
