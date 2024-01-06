const std = @import("std");
const Vector2 = @import("vector2.zig").Vector2;

pub const Monitor = extern struct {
    number: i32,

    /// Get number of connected monitors
    pub fn getCount() i32 {
        return @as(i32, GetMonitorCount());
    }

    /// Get current connected monitor
    pub fn getCurrent() Monitor {
        return .{ .number = @as(i32, GetCurrentMonitor()) };
    }

    /// Get specified monitor position
    pub fn getPosition(self: Monitor) Vector2 {
        return GetMonitorPosition(@as(c_int, self.number));
    }

    /// Get specified monitor width (current video mode used by monitor)
    pub fn getWidth(self: Monitor) i32 {
        return @as(i32, GetMonitorWidth(@as(c_int, self.number)));
    }

    /// Get specified monitor height (current video mode used by monitor)
    pub fn getHeight(self: Monitor) i32 {
        return @as(i32, GetMonitorHeight(@as(c_int, self.number)));
    }

    /// Get specified monitor physical width in millimetres
    pub fn getPhysicalWidth(self: Monitor) i32 {
        return @as(i32, GetMonitorPhysicalWidth(@as(c_int, self.number)));
    }

    /// Get specified monitor physical height in millimetres
    pub fn getPhysicalHeight(self: Monitor) i32 {
        return @as(i32, GetMonitorPhysicalHeight(@as(c_int, self.number)));
    }

    /// Get specified monitor refresh rate
    pub fn getRefreshRate(self: Monitor) i32 {
        return @as(i32, GetMonitorRefreshRate(@as(c_int, self.number)));
    }

    /// Get the human-readable, UTF-8 encoded name of the specified monitor
    pub fn getName(self: Monitor) [:0]const u8 {
        return std.mem.span(GetMonitorName(@as(c_int, self.number)));
    }

    /// Set monitor for the current window (fullscreen mode)
    pub fn setMonitor(self: Monitor) void {
        SetWindowMonitor(@as(c_int, self.number));
    }
};

extern "c" fn GetMonitorCount() c_int;
extern "c" fn GetCurrentMonitor() c_int;
extern "c" fn GetMonitorPosition(monitor: c_int) Vector2;
extern "c" fn GetMonitorWidth(monitor: c_int) c_int;
extern "c" fn GetMonitorHeight(monitor: c_int) c_int;
extern "c" fn GetMonitorPhysicalWidth(monitor: c_int) c_int;
extern "c" fn GetMonitorPhysicalHeight(monitor: c_int) c_int;
extern "c" fn GetMonitorRefreshRate(monitor: c_int) c_int;
extern "c" fn GetMonitorName(monitor: c_int) [*c]const u8;
extern "c" fn SetWindowMonitor(monitor: c_int) void;
