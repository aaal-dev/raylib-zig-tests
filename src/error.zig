const std = @import("std");

pub const Error = struct {
    raw: []const u8, // fields all reference this data
    allocator: std.mem.Allocator, // we copy raw to ensure it outlives the connection

    code: []const u8,
    message: []const u8,
    severity: []const u8,

    pub fn deinit(self: Error) void {
        self.allocator.free(self.raw);
    }
};

pub fn Result(comptime T: type) T {
    return union(enum) {
        ok: T,
        err: Error,

        const Self = @This();

        pub fn unwrap(self: Self) void {
            switch (self) {
                .ok => |ok| return ok,
                .err => |err| {
                    err.deinit();
                    return error.PG;
                },
            }
        }

        pub fn deinit(self: Self) void {
            switch (self) {
                .ok => |value| {
                    if (comptime std.meta.trait.hasFn("deinit")(T)) {
                        value.deinit();
                    }
                },
                .err => |err| err.deinit(),
            }
        }
    };
}
