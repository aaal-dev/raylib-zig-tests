const std = @import("std");

const Xoshiro256 = std.rand.Xoshiro256;

const Random = @This();

pub fn init(init_seed: u64) Random {
    return .{
        .generator = Xoshiro256.init(init_seed),
    };
}

generator: Xoshiro256,

pub fn seed(self: *Random, value: u64) void {
    self.generator.seed(value);
}

pub fn integer(self: *Random, comptime T: type, value: T) T {
    return @mod(self.generator.random().int(T), value + 1);
}

pub fn float(self: *Random, comptime T: type, range: T) T {
    const base = self.integer(u32, 10000);
    return @as(T, @floatFromInt(base)) / 10000.0 * range;
}

pub fn boolean(self: *Random) bool {
    return self.generator.random().boolean();
}
