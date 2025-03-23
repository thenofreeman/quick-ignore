const std = @import("std");

const IgnoreTemplate = @import("ignoreregistry.zig").IgnoreTemplate;

const IgnoreLocation = enum {
    local,
    global,
};

const Ignore = struct {
    value: []const u8,
    where: IgnoreLocation,
};

pub const IgnoreFile = struct {
    activePrefix: []const u8,
    useForce: bool,

    templates: std.ArrayList(Ignore),
    rules: std.ArrayList(Ignore),

    pub fn init(allocator: std.mem.Allocator) IgnoreFile {
        return .{
            .activePrefix = ".",
            .useForce = false,
            .templates = std.ArrayList([]const u8).init(allocator),
            .rules = std.ArrayList([]const u8).init(allocator),
        };
    }

    pub fn deinit(self: *IgnoreFile) void {
        _ = self;

        // TODO: do deinit....
    }

    pub fn hasTemplate(self: *IgnoreFile, template: IgnoreTemplate) bool {
        return if (self.templates.get(template)) true else false;
    }

    pub fn addTemplate(self: *IgnoreFile, newTemplate: IgnoreTemplate) void {
        self.templates.add(newTemplate);
    }

    pub fn hasRule(self: *IgnoreFile, rule: []const u8) bool {
        return if (self.rules.get(rule)) true else false;
    }

    pub fn addRule(self: *IgnoreFile, rule: []const u8) void {
        self.rules.add(rule);
    }

    pub fn write(self: *IgnoreFile) !void {
        std.debug.print("Templates:\n", .{});
        for (self.templates) |template| {
            std.debug.print("{s}\n", .{template});
        }

        std.debug.print("Rule:\n", .{});
        for (self.rules) |rule| {
            std.debug.print("{s}\n", .{rule});
        }
    }

    fn loadIgnores

};
