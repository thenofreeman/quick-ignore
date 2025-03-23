const std = @import("std");
const clap = @import("clap");

pub const CommandEnum = enum {
    help,
    version,
    add,
    remove,
    list,
};

pub const main_parsers = .{
    .command = clap.parsers.enumeration(CommandEnum),
    .str = clap.parsers.string,
};

pub const main_params = clap.parseParamsComptime(
    \\-g, --global  Add ignores to global ignore file.
    \\-f, --force   Coerce any command and ignore warnings.
    \\<command>
    \\
);

pub const MainArgs = clap.ResultEx(
    clap.Help,
    &main_params,
    main_parsers
);
