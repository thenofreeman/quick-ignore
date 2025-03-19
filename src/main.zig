const std = @import("std");
const clap = @import("clap");

const core = @import("core.zig");
const Commands = @import("commands.zig");

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
        &core.main_params,
        core.main_parsers,
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
        .help => try Commands.help(res),
        .version => try Commands.version(res),
        .add =>  try Commands.add(allocator, &it, res),
        .remove => try Commands.remove(allocator, &it, res),
        .list => try Commands.list(allocator, &it, res),
    }
}
