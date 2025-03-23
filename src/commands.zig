const std = @import("std");
const clap = @import("clap");

const IgnoreFile = @import("ignorefile.zig").IgnoreFile;
const MainArgs = @import("core.zig").MainArgs;

pub fn help(ignorefile: IgnoreFile) !void {
    _ = ignorefile;

    std.debug.print("--help\n", .{});
}

pub fn version(ignorefile: IgnoreFile) !void {
    _ = ignorefile;

    std.debug.print("Quick Ignore. Version 0.1 beta.\n", .{});
}

pub fn add(allocator: std.mem.Allocator, it: *std.process.ArgIterator, ignorefile: IgnoreFile) !void {
    const params = comptime clap.parseParamsComptime(
        \\-t, --template  Specified ignores are part of a template
        \\<str>...        Specify what to ignore
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

    if (res.args.template != 0) {
        for (res.positionals[0]) |templateKey| {
            const template = ignoreTemplates.get(templateKey) catch |err| {
                _ = err;
                std.debug.print("Template '{s}' doesn't exist'.", .{templateKey});
                continue;
            };

            if (ignorefile.hasTemplate(template)) {
                std.debug.print("Template '{s}' is already ignored.", .{template});
            } else {
                ignorefile.addTemplate(template);
                std.debug.print("Template '{s}' added.", .{template});
            }
        }
    } else {
        for (res.positionals[0]) |rule| {
            if (ignorefile.hasRule(rule)) {
                std.debug.print("Rule '{s}' is already ignored.", .{rule});
            } else {
                ignorefile.addRule(rule);
            }
        }
    }

    // try ignorefile.write();
}

pub fn remove(allocator: std.mem.Allocator, it: *std.process.ArgIterator, main_args: MainArgs) !void {
    _ = main_args;

    const params = comptime clap.parseParamsComptime(
        \\-t, --template <str>...  Un-Ingore using a template.
        \\<str>...                 Un-Ignore specific paths.
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
