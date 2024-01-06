/// Cursor-related functions
pub const Cursor = extern struct {
    /// Shows cursor
    pub fn show(_: Cursor) void {
        ShowCursor();
    }

    /// Hides cursor
    pub fn hide(_: Cursor) void {
        HideCursor();
    }

    /// Check if cursor is not visible
    pub fn isHidden(_: Cursor) bool {
        return IsCursorHidden();
    }

    /// Enables cursor (unlock cursor)
    pub fn enable(_: Cursor) void {
        EnableCursor();
    }

    /// Disables cursor (lock cursor)
    pub fn disable(_: Cursor) void {
        DisableCursor();
    }

    /// Check if cursor is on screen
    pub fn isOnScreen(_: Cursor) bool {
        return IsCursorOnScreen();
    }
};

extern "c" fn ShowCursor() void;
extern "c" fn HideCursor() void;
extern "c" fn IsCursorHidden() bool;
extern "c" fn EnableCursor() void;
extern "c" fn DisableCursor() void;
extern "c" fn IsCursorOnScreen() bool;
