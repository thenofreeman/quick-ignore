const std = @import("std");
const clap = @import("clap");

// git ignore = quig
// quig add .zig-out/
// quig add config/something
// quig add - zig
// quig list
// quig list --all
// quig --global add .zig-out/
// quig list --global
// quig remove .zig-out/
// quig version

const SubCommands = enum {
    help,
    version,
    add,
    remove,
    list,
};

const main_parsers = .{
    .command = clap.parsers.enumeration(SubCommands),
    .str = clap.parsers.string,
};

const main_params = clap.parseParamsComptime(
    \\<command>
    \\
);

const MainArgs = clap.ResultEx(
    clap.Help,
    &main_params,
    main_parsers
);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var it = try std.process.ArgIterator.initWithAllocator(allocator);
    defer it.deinit();

    _ = it.next();

    var diagnostic = clap.Diagnostic{};

    var res = clap.parseEx(
        clap.Help,
        &main_params,
        main_parsers,
        &it,
        .{
            .diagnostic = &diagnostic,
            .allocator = allocator,
            .terminating_positional = 0,
    }) catch |err| {
        diagnostic.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    const command = res.positionals[0] orelse return error.MissingCommand;
    switch (command) {
        .help =>  try commandHelp(res),
        .version => try commandVersion(res),
        .add =>  try commandAdd(allocator, &it, res),
        .remove =>  try commandRemove(allocator, &it, res),
        .list => try commandList(allocator, &it, res),
    }
}

fn commandHelp(main_args: MainArgs) !void {
    _ = main_args;

    std.debug.print("--help\n", .{});
}

fn commandVersion(main_args: MainArgs) !void {
    _ = main_args;

    std.debug.print("Quick Ignore. Version 0.1 beta.\n", .{});
}

fn commandAdd(allocator: std.mem.Allocator, it: *std.process.ArgIterator, main_args: MainArgs) !void {
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

fn commandRemove(allocator: std.mem.Allocator, it: *std.process.ArgIterator, main_args: MainArgs) !void {
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

fn commandList(allocator: std.mem.Allocator, it: *std.process.ArgIterator, main_args: MainArgs) !void {
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
