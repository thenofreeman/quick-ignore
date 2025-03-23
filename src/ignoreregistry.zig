const std = @import("std");

pub const IgnoreTemplate = enum {
    zig,
    macos,
    vim,
};

pub fn buildIgnoreList(allocator: std.mem.Allocator) void {
    var ignoreTemplates = std.AutoHashMap([]const u8, []const u8).init(allocator);

    defer ignoreTemplates.deinit();

    // for each file that ends with .gitignore
    // add its path to the hashmap
    // if its not in templates/,
    //     check templates/community/

    // try ignoreTemplates.put(name, fullpath);
}
