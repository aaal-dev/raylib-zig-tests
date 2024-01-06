const Vector2 = @import("vector2.zig").Vector2;

/// Mouse buttons
pub const MouseButton = enum(c_int) {
    left = 0,
    right = 1,
    middle = 2,
    side = 3,
    extra = 4,
    forward = 5,
    back = 6,

    pub fn isPressed(self: MouseButton) bool {
        return IsMouseButtonPressed(self);
    }

    pub fn isDown(self: MouseButton) bool {
        return IsMouseButtonDown(self);
    }

    pub fn isReleased(self: MouseButton) bool {
        return IsMouseButtonReleased(self);
    }

    pub fn isUp(self: MouseButton) bool {
        return IsMouseButtonUp(self);
    }
};

const Mouse = struct {
    /// Mouse cursor
    pub const Cursor = enum(c_int) {
        default = 0,
        arrow = 1,
        ibeam = 2,
        crosshair = 3,
        pointing_hand = 4,
        resize_ew = 5,
        resize_ns = 6,
        resize_nwse = 7,
        resize_nesw = 8,
        resize_all = 9,
        not_allowed = 10,
    };

    pub fn getX() i32 {
        return @as(i32, GetMouseX());
    }

    pub fn getY() i32 {
        return @as(i32, GetMouseY());
    }

    pub fn getPosition() Vector2 {
        return GetMousePosition();
    }

    pub fn getDelta() Vector2 {
        return GetMouseDelta();
    }

    pub fn setPosition(x: i32, y: i32) void {
        SetMousePosition(@as(c_int, x), @as(c_int, y));
    }

    pub fn setOffset(offsetX: i32, offsetY: i32) void {
        SetMouseOffset(@as(c_int, offsetX), @as(c_int, offsetY));
    }

    pub fn setScale(scaleX: f32, scaleY: f32) void {
        SetMouseScale(scaleX, scaleY);
    }

    pub fn getWheelMove() f32 {
        return GetMouseWheelMove();
    }

    pub fn getWheelMoveV() Vector2 {
        return GetMouseWheelMoveV();
    }

    pub fn setCursor(cursor: Cursor) void {
        SetMouseCursor(cursor);
    }
};

extern "c" fn IsMouseButtonPressed(button: Mouse.Button) bool;
extern "c" fn IsMouseButtonDown(button: Mouse.Button) bool;
extern "c" fn IsMouseButtonReleased(button: Mouse.Button) bool;
extern "c" fn IsMouseButtonUp(button: Mouse.Button) bool;
extern "c" fn GetMouseX() c_int;
extern "c" fn GetMouseY() c_int;
extern "c" fn GetMousePosition() Vector2;
extern "c" fn GetMouseDelta() Vector2;
extern "c" fn SetMousePosition(x: c_int, y: c_int) void;
extern "c" fn SetMouseOffset(offsetX: c_int, offsetY: c_int) void;
extern "c" fn SetMouseScale(scaleX: f32, scaleY: f32) void;
extern "c" fn GetMouseWheelMove() f32;
extern "c" fn GetMouseWheelMoveV() Vector2;
extern "c" fn SetMouseCursor(cursor: c_int) void;
