const std = @import("std");
const clap = @import("clap");

const MainArgs = @import("core.zig").MainArgs;

pub fn help(main_args: MainArgs) !void {
    _ = main_args;

    std.debug.print("--help\n", .{});
}

pub fn version(main_args: MainArgs) !void {
    _ = main_args;

    std.debug.print("Quick Ignore. Version 0.1 beta.\n", .{});
}

pub fn add(allocator: std.mem.Allocator, it: *std.process.ArgIterator, main_args: MainArgs) !void {
    _ = main_args;

    const params = comptime clap.parseParamsComptime(
        \\-t, --template <str>...  Ingore using a template.
        \\<str>...                 Ignore specific paths
    );

    var diagnostic = clap.Diagnostic{};
    var res = clap.parseEx(clap.Help, &params, clap.parsers.default, it, .{
        .diagnostic = &diagnostic,
        .allocator = allocator,
    }) catch |err| {
        diagnostic.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    // ??? only one of these options

    for (res.args.template) |t| {
        std.debug.print("--template = {s}\n", .{t});
    }

    for (res.positionals[0]) |path| {
        std.debug.print("--path = {s}\n", .{path});
    }
}

pub fn remove(allocator: std.mem.Allocator, it: *std.process.ArgIterator, main_args: MainArgs) !void {
    _ = main_args;

    const params = comptime clap.parseParamsComptime(
        \\-t, --template <str>...  Un-Ingore using a template.
        \\<str>...                 Un-Ignore specific paths
    );

    var diagnostic = clap.Diagnostic{};
    var res = clap.parseEx(clap.Help, &params, clap.parsers.default, it, .{
        .diagnostic = &diagnostic,
        .allocator = allocator,
    }) catch |err| {
        diagnostic.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    // ??? only one of these options

    for (res.args.template) |t| {
        std.debug.print("--template = {s}\n", .{t});
    }

    for (res.positionals[0]) |path| {
        std.debug.print("--path = {s}\n", .{path});
    }
}

pub fn list(allocator: std.mem.Allocator, it: *std.process.ArgIterator, main_args: MainArgs) !void {
    _ = main_args;

    const params = comptime clap.parseParamsComptime(
        \\-h, --help  Display list help and exit.
        \\-a, --all   List all potentially ignored files.
    );

    var diagnostic = clap.Diagnostic{};
    var res = clap.parseEx(clap.Help, &params, clap.parsers.default, it, .{
        .diagnostic = &diagnostic,
        .allocator = allocator,
    }) catch |err| {
        diagnostic.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0) {
        std.debug.print("--help\n", .{});
    }

    if (res.args.all != 0) {
        std.debug.print("--list\n", .{});
    }
}
