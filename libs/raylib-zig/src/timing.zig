/// Set target FPS (maximum)
pub fn setTargetFPS(fps: i32) void {
    SetTargetFPS(@as(c_int, fps));
}

/// Get current FPS
pub fn getFPS() i32 {
    return @as(i32, GetFPS());
}

/// Get time in seconds for last frame drawn (delta time)
pub fn getFrameTime() f32 {
    return GetFrameTime();
}

/// Get elapsed time in seconds since InitWindow()
pub fn getTime() f64 {
    return GetTime();
}

extern "c" fn SetTargetFPS(fps: c_int) void;
extern "c" fn GetFPS() c_int;
extern "c" fn GetFrameTime() f32;
extern "c" fn GetTime() f64;
