const std = @import("std");

pub const pow = std.math.pow;

pub fn powByTwo(comptime T: type, value: T) T {
    return @as(T, value * value);
}
