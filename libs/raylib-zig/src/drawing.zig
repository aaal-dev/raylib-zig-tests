const Camera2D = @import("camera2d.zig").Camera2D;
const Camera3D = @import("camera3d.zig").Camera3D;
const Color = @import("color.zig").Color;
const RenderTexture2D = @import("rendertexture2d.zig").RenderTexture2D;
const Shader = @import("shader.zig").Shader;
const VrStereoConfig = @import("vrstereoconfig.zig").VrStereoConfig;

/// Set background color (framebuffer clear color)
pub fn clearBackground(color: Color) void {
    ClearBackground(color);
}

/// Setup canvas (framebuffer) to start drawing
pub fn beginDrawing() void {
    BeginDrawing();
}

/// End canvas drawing and swap buffers (double buffering)
pub fn endDrawing() void {
    EndDrawing();
}

/// Begin 2D mode with custom camera (2D)
pub fn beginMode2D(camera: Camera2D) void {
    BeginMode2D(camera);
}

/// Ends 2D mode with custom camera
pub fn endMode2D() void {
    EndMode2D();
}

/// Begin 3D mode with custom camera (3D)
pub fn beginMode3D(camera: Camera3D) void {
    BeginMode3D(camera);
}

/// Ends 3D mode and returns to default 2D orthographic mode
pub fn endMode3D() void {
    EndMode3D();
}

/// Begin drawing to render texture
pub fn beginTextureMode(target: RenderTexture2D) void {
    BeginTextureMode(target);
}

/// Ends drawing to render texture
pub fn endTextureMode() void {
    EndTextureMode();
}

/// Begin custom shader drawing
pub fn beginShaderMode(shader: Shader) void {
    BeginShaderMode(shader);
}

/// End custom shader drawing (use default shader)
pub fn endShaderMode() void {
    EndShaderMode();
}

/// Begin blending mode (alpha, additive, multiplied, subtract, custom)
pub fn beginBlendMode(mode: i32) void {
    BeginBlendMode(@as(c_int, mode));
}

/// End blending mode (reset to default: alpha blending)
pub fn endBlendMode() void {
    EndBlendMode();
}

/// Begin scissor mode (define screen area for following drawing)
pub fn beginScissorMode(x: i32, y: i32, width: i32, height: i32) void {
    BeginScissorMode(
        @as(c_int, x),
        @as(c_int, y),
        @as(c_int, width),
        @as(c_int, height),
    );
}

/// End scissor mode
pub fn endScissorMode() void {
    EndScissorMode();
}

/// Begin stereo rendering (requires VR simulator)
pub fn beginVrStereoMode(config: VrStereoConfig) void {
    BeginVrStereoMode(config);
}

/// End stereo rendering (requires VR simulator)
pub fn endVrStereoMode() void {
    EndVrStereoMode();
}

extern "c" fn ClearBackground(color: Color) void;
extern "c" fn BeginDrawing() void;
extern "c" fn EndDrawing() void;
extern "c" fn BeginMode2D(camera: Camera2D) void;
extern "c" fn EndMode2D() void;
extern "c" fn BeginMode3D(camera: Camera3D) void;
extern "c" fn EndMode3D() void;
extern "c" fn BeginTextureMode(target: RenderTexture2D) void;
extern "c" fn EndTextureMode() void;
extern "c" fn BeginShaderMode(shader: Shader) void;
extern "c" fn EndShaderMode() void;
extern "c" fn BeginBlendMode(mode: c_int) void;
extern "c" fn EndBlendMode() void;
extern "c" fn BeginScissorMode(x: c_int, y: c_int, width: c_int, height: c_int) void;
extern "c" fn EndScissorMode() void;
extern "c" fn BeginVrStereoMode(config: VrStereoConfig) void;
extern "c" fn EndVrStereoMode() void;
