const std = @import("std");
const clap = @import("clap");

const IgnoreFile = @import("ignorefile.zig").IgnoreFile;
const core = @import("core.zig");
const Commands = @import("commands.zig");

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

    var ignorefile = IgnoreFile.init(allocator);
    defer ignorefile.deinit();

    if (res.args.global != 0) {
        ignorefile.activePrefix = "~";
    }

    if (res.args.force != 0) {
        ignorefile.useForce = true;
    }

    const command = res.positionals[0] orelse return error.MissingCommand;
    switch (command) {
        .help => try Commands.help(ignorefile),
        .version => try Commands.version(ignorefile),
        .add => try Commands.add(allocator, &it, ignorefile),
        .remove => try Commands.remove(allocator, &it, ignorefile),
        .list => try Commands.list(allocator, &it, ignorefile),
    }
}
