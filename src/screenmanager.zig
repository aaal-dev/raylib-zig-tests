// Code was forked from https://codeberg.org/gnarz/zig-raylib-template
//
/// A simple screen manager. It stores all used screens, and their relations.
/// Switching between screens is done automatically when isFinished()
/// for the current screen returns true. Screens may be pushed atop other
/// screens in order to allow for transient menus and stuff.
//
//
const std = @import("std");
const raylib = @import("raylib");
const Screen = @import("screen.zig");

const Allocator = std.mem.Allocator;

const ScreenManager = @This();

const Next = struct {
    sid: usize,
    val: usize,
    nid: usize,
};

allocator: Allocator,
screens: std.ArrayList(Screen),
nexts: std.ArrayList(Next),
stack: std.ArrayList(usize),
should_quit: bool = false,

/// Initialize the screen manager
pub fn init(a: Allocator) Allocator.Error!ScreenManager {
    return .{
        .allocator = a,
        .screens = std.ArrayList(Screen).init(a),
        .nexts = std.ArrayList(Next).init(a),
        .stack = try std.ArrayList(usize).initCapacity(a, 1),
    };
}

/// Deinitialize the screen manager and free allocated memory
pub fn deinit(self: *ScreenManager) void {
    self.clearStack();
    self.stack.deinit();
    self.nexts.deinit();
    self.screens.deinit();
}

/// Draw all currently active screens
pub fn draw(self: *ScreenManager) void {
    for (self.stack.items) |index| {
        self.screens.items[index].draw();
    }
}

/// Update all currently active screens, from bottom to top. If
/// the topmost screen is finished, switch to the next screen
pub fn update(self: *ScreenManager, dt: f32) void {
    for (self.stack.items) |s| {
        self.screens.items[s].update(dt);
    }
    //if (self.screens.items[self.topScreen()].isFinished()) {
    //    self.gotoNext();
    //}
}

/// Add a new screen to manage, return its id
pub fn add(
    self: *ScreenManager,
    screen: Screen,
) Allocator.Error!usize {
    try self.screens.append(screen);
    return self.screens.items.len - 1;
}

pub fn addScreens(
    self: *ScreenManager,
    list: []const ScreenLoadOptions,
) !void {
    for (list) |options| {
        _ = try self.add(options.screen);
    }
}

/// Empty the screen stack and open a screen with `screen_index`.
pub fn goto(self: *ScreenManager, screen_index: usize) void {
    self.clearStack();
    // stack was initialized to hold at least 1 element, so this can not
    // fail
    self.pushInStack(screen_index) catch unreachable;
}

/// Close the current screen and open the next one, as specified
/// with setNext(). If the current screen is a pushed screen, it will be
/// closed and the previou screen will be resumed. If the vaule returned
/// by the getValue() method of the current screen is negative, then
/// should_quit is set to true causing ScreenManager.shouldQuit()
/// to return true.
pub fn gotoNext(self: *ScreenManager) void {
    std.debug.assert(self.stack.items.len > 0);

    // TODO FEATURE: transitions
    var current = self.stack.pop();
    var next = current;

    std.debug.assert(current < self.screens.items.len);

    var val = self.screens.items[current].getValue();
    if (val < 0) {
        self.should_quit = true;
        return;
    }

    if (self.stack.items.len == 0) {
        for (self.nexts.items) |n| {
            if (n.sid == current and n.val == val) {
                next = n.nid;
            }
        }
        if (next != current) {
            self.screens.items[current].deinit();
            self.goto(next);
        }
    } else {
        self.screens.items[current].deinit();
    }
}

/// Specify which screen follows screen with id s, if getValue()
/// on screen s returns v. This allows for multiple followup screens
/// depending on v.
pub fn setNext(
    self: *ScreenManager,
    s: usize,
    v: usize,
    n: usize,
) Allocator.Error!void {
    std.debug.assert(s < self.screens.items.len);
    std.debug.assert(n < self.screens.items.len);

    try self.nexts.append(.{
        .sid = s,
        .val = v,
        .nid = n,
    });
}

pub fn showOver(
    self: *ScreenManager,
    screen_index: usize,
) Allocator.Error!void {
    try self.pushInStack(screen_index);
}

/// Return true when the game loop should exit, false otherwise
pub fn shouldQuit(self: *ScreenManager) bool {
    return self.should_quit;
}

// ------------------------------------------------------------- private --

fn clearStack(self: *ScreenManager) void {
    while (self.stack.popOrNull()) |s| {
        self.screens.items[s].deinit();
    }
}

fn pushInStack(
    self: *ScreenManager,
    screen_index: usize,
) Allocator.Error!void {
    std.debug.assert(screen_index < self.screens.items.len);

    self.screens.items[screen_index].init(self);
    try self.stack.append(screen_index);
}

fn topScreen(self: *ScreenManager) usize {
    std.debug.assert(self.stack.items.len > 0);

    return self.stack.items[self.stack.items.len - 1];
}

const ScreenLoadOptions = struct {
    index: ?u32,
    name: []const u8,
    screen: Screen,
};

test "check if everything passes semantic analysis" {
    std.testing.refAllDecls(@This());
}
