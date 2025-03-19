const std = @import("std");
const clap = @import("clap");

// git ignore = quig
// quig .zig-out/
// quig config/something
// quig - zig
// quig list
// quig list --all
// quig --global .zig-out/
// quig list --global
// quig -u .zig-out/
// quig version

const SubCommands = enum {
    help,
    list,
    version,
};

const main_parsers = .{
    .command = clap.parsers.enumeration(SubCommands),
};

const main_params = clap.parseParamsComptime(
    \\-h, --help            Display help and exit.
    \\-v, --version         Display version info and exit.
    \\-t, --template
    \\<command>
);

const MainArgs = clap.ResultEx(clap.Help, &main_params, main_parsers);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var it = try std.process.ArgIterator.initWithAllocator(allocator);
    defer it.deinit();

    _ = it.next();

    var diagnostic = clap.Diagnostic{};
    var res = clap.parseEx(clap.Help, &main_params, main_parsers, &it, .{
        .diagnostic = &diagnostic,
        .allocator = allocator,
        .terminating_positional = 0,
    }) catch |err| {
        diagnostic.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0) {
        std.debug.print("--help\n", .{});
    }

    const command = res.positionals[0] orelse return error.MissingCommand;
    switch (command) {
        .help => std.debug.print("--help\n", .{}),
        .list => try listMain(allocator, &it, res),
        .version => std.debug.print("Quick Ignore. Version 0.1 beta.\n", .{}),
    }
}

fn listMain(allocator: std.mem.Allocator, it: *std.process.ArgIterator, main_args: MainArgs) !void {
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
