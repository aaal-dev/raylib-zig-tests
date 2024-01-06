const ConfigFlags = @import("enums.zig").ConfigFlags;
const Image = @import("image.zig").Image;
const Vector2 = @import("vector2.zig").Vector2;

pub const Window = extern struct {
    /// Initialize window and OpenGL context
    pub fn init(width: i32, height: i32, title: [:0]const u8) void {
        InitWindow(
            @as(c_int, width),
            @as(c_int, height),
            @ptrCast(title),
        );
    }

    /// Close window and unload OpenGL context
    pub fn close() void {
        CloseWindow();
    }

    /// Check if KEY_ESCAPE pressed or Close icon pressed
    pub fn shouldClose() bool {
        return WindowShouldClose();
    }

    /// Check if window has been initialized successfully
    pub fn isReady() bool {
        return IsWindowReady();
    }

    /// Check if window is currently fullscreen
    pub fn isFullscreen() bool {
        return IsWindowFullscreen();
    }

    /// Check if window is currently hidden (only PLATFORM_DESKTOP)
    pub fn isHidden() bool {
        return IsWindowHidden();
    }

    /// Check if window is currently minimized (only PLATFORM_DESKTOP)
    pub fn isMinimized() bool {
        return IsWindowMinimized();
    }

    /// Check if window is currently maximized (only PLATFORM_DESKTOP)
    pub fn isMaximized() bool {
        return IsWindowMaximized();
    }

    /// Check if window is currently focused (only PLATFORM_DESKTOP)
    pub fn isFocused() bool {
        return IsWindowFocused();
    }

    /// Check if window has been resized last frame
    pub fn isResized() bool {
        return IsWindowResized();
    }

    /// Check if one specific window flag is enabled
    pub fn isState(flag: u32) bool {
        return IsWindowState(@as(c_uint, flag));
    }

    /// Set window configuration state using flags (only PLATFORM_DESKTOP)
    pub fn setState(flags: ConfigFlags) void {
        SetWindowState(flags);
    }

    /// Clear window configuration state flags
    pub fn clearState(flags: ConfigFlags) void {
        ClearWindowState(flags);
    }

    /// Toggle window state: fullscreen/windowed (only PLATFORM_DESKTOP)
    pub fn toggleFullscreen() void {
        ToggleFullscreen();
    }

    /// Set window state: maximized, if resizable (only PLATFORM_DESKTOP)
    pub fn maximize() void {
        MaximizeWindow();
    }

    /// Set window state: minimized, if resizable (only PLATFORM_DESKTOP)
    pub fn minimize() void {
        MinimizeWindow();
    }

    /// Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
    pub fn restore() void {
        RestoreWindow();
    }

    /// Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
    pub fn setIcon(image: Image) void {
        SetWindowIcon(image);
    }

    /// Set icon for window (multiple images, RGBA 32bit,
    /// only PLATFORM_DESKTOP)
    pub fn setIcons(images: [*]Image, count: i32) void {
        SetWindowIcons(images, count);
    }

    /// Set title for window (only PLATFORM_DESKTOP)
    pub fn setTitle(title: [:0]const u8) void {
        SetWindowTitle(@ptrCast(title));
    }

    /// Set window position on screen (only PLATFORM_DESKTOP)
    pub fn setPosition(x: i32, y: i32) void {
        SetWindowPosition(@as(c_int, x), @as(c_int, y));
    }

    /// Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
    pub fn setMinSize(width: i32, height: i32) void {
        SetWindowMinSize(@as(c_int, width), @as(c_int, height));
    }

    /// Set window dimensions
    pub fn setSize(width: i32, height: i32) void {
        SetWindowSize(@as(c_int, width), @as(c_int, height));
    }

    /// Set window opacity [0.0f..1.0f] (only PLATFORM_DESKTOP)
    pub fn setOpacity(opacity: f32) void {
        SetWindowOpacity(opacity);
    }

    /// Set window focused (only PLATFORM_DESKTOP)
    pub fn setFocused() void {
        SetWindowFocused();
    }

    /// Get native window handle
    pub fn getHandle() *anyopaque {
        return GetWindowHandle();
    }

    /// Get window position XY on monitor
    pub fn getPosition() Vector2 {
        return GetWindowPosition();
    }

    /// Get window scale DPI factor
    pub fn getScaleDPI() Vector2 {
        return GetWindowScaleDPI();
    }
};

extern "c" fn InitWindow(width: c_int, height: c_int, title: [*c]const u8) void;
extern "c" fn WindowShouldClose() bool;
extern "c" fn CloseWindow() void;
extern "c" fn IsWindowReady() bool;
extern "c" fn IsWindowFullscreen() bool;
extern "c" fn IsWindowHidden() bool;
extern "c" fn IsWindowMinimized() bool;
extern "c" fn IsWindowMaximized() bool;
extern "c" fn IsWindowFocused() bool;
extern "c" fn IsWindowResized() bool;
extern "c" fn IsWindowState(flag: c_uint) bool;
extern "c" fn SetWindowState(flags: ConfigFlags) void;
extern "c" fn ClearWindowState(flags: ConfigFlags) void;
extern "c" fn ToggleFullscreen() void;
extern "c" fn MaximizeWindow() void;
extern "c" fn MinimizeWindow() void;
extern "c" fn RestoreWindow() void;
extern "c" fn SetWindowIcon(image: Image) void;
extern "c" fn SetWindowIcons(images: [*c]Image, count: c_int) void;
extern "c" fn SetWindowTitle(title: [*c]const u8) void;
extern "c" fn SetWindowPosition(x: c_int, y: c_int) void;
extern "c" fn SetWindowMinSize(width: c_int, height: c_int) void;
extern "c" fn SetWindowSize(width: c_int, height: c_int) void;
extern "c" fn SetWindowOpacity(opacity: f32) void;
extern "c" fn SetWindowFocused() void;
extern "c" fn GetWindowHandle() *anyopaque;
extern "c" fn GetWindowPosition() Vector2;
extern "c" fn GetWindowScaleDPI() Vector2;
