const Texture = @import("texture.zig").Texture;
const RenderTexture2D = @import("rendertexture2d.zig").RenderTexture2D;

pub const RenderTexture = extern struct {
    id: c_uint,
    texture: Texture,
    depth: Texture,

    pub fn load(width: i32, height: i32) RenderTexture {
        return LoadRenderTexture(width, height);
    }

    pub fn unload(self: RenderTexture) void {
        UnloadRenderTexture(self);
    }

    pub fn beginDrawMode(self: RenderTexture2D) void {
        BeginTextureMode(self);
    }

    pub fn endDrawMode(_: RenderTexture2D) void {
        EndTextureMode();
    }
};

extern "c" fn LoadRenderTexture(width: c_int, height: c_int) RenderTexture2D;
extern "c" fn UnloadRenderTexture(target: RenderTexture2D) void;
extern "c" fn BeginTextureMode(target: RenderTexture2D) void;
extern "c" fn EndTextureMode() void;
