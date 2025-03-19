const std = @import("std");
const clap = @import("clap");

pub const main_parsers = .{
    .command = clap.parsers.enumeration(CommandEnum),
    .str = clap.parsers.string,
};

pub const main_params = clap.parseParamsComptime(
    \\<command>
    \\
);

pub const MainArgs = clap.ResultEx(
    clap.Help,
    &main_params,
    main_parsers
);

pub const CommandEnum = enum {
    help,
    version,
    add,
    remove,
    list,
};
