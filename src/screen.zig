// Code was forked from https://codeberg.org/gnarz/zig-raylib-template
//
/// Screen struct. Screens are singletons, sharing a common interface.
/// Thus there is no state stored in the struct, but rather
/// in the implementation.
//
//
const ScreenManager = @import("screenmanager.zig");
const Screen = @This();

manager: ?*ScreenManager = null,
vtable: VTable,

pub const VTable = struct {
    init: *const fn (*Screen) void,
    deinit: *const fn (*Screen) void,
    update: *const fn (*Screen, f32) void,
    draw: *const fn (*Screen) void,
    isFinished: *const fn (*Screen) bool,
    getValue: *const fn (*Screen) i32,
};

pub fn init(self: *Screen, manager: *ScreenManager) void {
    self.manager = manager;
    self.vtable.init(self);
}

pub fn deinit(self: *Screen) void {
    self.vtable.deinit(self);
}

pub fn update(self: *Screen, dt: f32) void {
    self.vtable.update(self, dt);
}

pub fn draw(self: *Screen) void {
    self.vtable.draw(self);
}

pub fn isFinished(self: *Screen) bool {
    return self.vtable.isFinished(self);
}

test "basic compilation" {
    @import("std").testing.refAllDecls(@This());
}
