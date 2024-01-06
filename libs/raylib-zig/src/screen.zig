pub const Screen = extern struct {
    /// Get current screen width
    pub fn getWidth() i32 {
        return @as(i32, GetScreenWidth());
    }

    /// Get current screen height
    pub fn getHeight() i32 {
        return @as(i32, GetScreenHeight());
    }
};

extern "c" fn GetScreenWidth() c_int;
extern "c" fn GetScreenHeight() c_int;
