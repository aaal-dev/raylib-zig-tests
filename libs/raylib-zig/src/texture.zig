const Color = @import("color.zig").Color;
const Image = @import("image.zig").Image;
const Rectangle = @import("rectangle.zig").Rectangle;
const NPatchInfo = @import("npatchinfo.zig").NPatchInfo;
const Texture2D = @import("texture2d.zig").Texture2D;
const TextureCubemap = @import("texturecubemap.zig").TextureCubemap;
const Vector2 = @import("vector2.zig").Vector2;

const Enums = @import("enums.zig");
const PixelFormat = Enums.PixelFormat;

pub const Texture = extern struct {
    id: c_uint,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: PixelFormat,

    /// Draw a Texture2D
    pub fn draw(self: Texture, posX: i32, posY: i32, tint: Color) void {
        DrawTexture(self, posX, posY, tint);
    }

    /// Draw a Texture2D with position defined as Vector2
    pub fn drawV(self: Texture, position: Vector2, tint: Color) void {
        DrawTextureV(self, position, tint);
    }

    /// Draw a Texture2D with extended parameters
    pub fn drawEx(
        self: Texture,
        position: Vector2,
        rotation: f32,
        scale: f32,
        tint: Color,
    ) void {
        DrawTextureEx(self, position, rotation, scale, tint);
    }

    /// Draw a part of a texture defined by a rectangle
    pub fn drawRec(
        self: Texture,
        source: Rectangle,
        position: Vector2,
        tint: Color,
    ) void {
        DrawTextureRec(self, source, position, tint);
    }

    /// Draw a part of a texture defined by a rectangle with 'pro' parameters
    pub fn drawPro(
        self: Texture,
        source: Rectangle,
        dest: Rectangle,
        origin: Vector2,
        rotation: f32,
        tint: Color,
    ) void {
        DrawTexturePro(self, source, dest, origin, rotation, tint);
    }

    /// Draws a texture (or part of it) that stretches or shrinks nicely
    pub fn drawNPatch(
        self: Texture,
        nPatchInfo: NPatchInfo,
        dest: Rectangle,
        origin: Vector2,
        rotation: f32,
        tint: Color,
    ) void {
        DrawTextureNPatch(self, nPatchInfo, dest, origin, rotation, tint);
    }

    /// Check if a texture is ready
    pub fn isReady(self: Texture) bool {
        return IsTextureReady(self);
    }

    /// Load texture from file into GPU memory (VRAM)
    pub fn load(fileName: [:0]const u8) Texture {
        return LoadTexture(fileName);
    }

    /// Load texture from image data
    pub fn fromImage(image: Image) Texture {
        return LoadTextureFromImage(image);
    }

    /// Load cubemap from image, multiple image cubemap layouts supported
    pub fn fromCubemap(image: Image, layout: i32) Texture {
        return LoadTextureCubemap(image, layout);
    }

    pub fn toImage(self: Texture) Image {
        return LoadImageFromTexture(self);
    }

    /// Unload texture from GPU memory (VRAM)
    pub fn unload(self: Texture) void {
        UnloadTexture(self);
    }

    /// Update GPU texture with new data
    pub fn update(texture: Texture, pixels: *const anyopaque) void {
        UpdateTexture(texture, pixels);
    }

    /// Update GPU texture rectangle with new data
    pub fn updateWithRec(
        texture: Texture,
        rec: Rectangle,
        pixels: *const anyopaque,
    ) void {
        UpdateTextureRec(texture, rec, pixels);
    }
};

extern "c" fn DrawTexture(
    texture: Texture2D,
    posX: c_int,
    posY: c_int,
    tint: Color,
) void;
extern "c" fn DrawTextureV(
    texture: Texture2D,
    position: Vector2,
    tint: Color,
) void;
extern "c" fn DrawTextureEx(
    texture: Texture2D,
    position: Vector2,
    rotation: f32,
    scale: f32,
    tint: Color,
) void;
extern "c" fn DrawTextureRec(
    texture: Texture2D,
    source: Rectangle,
    position: Vector2,
    tint: Color,
) void;
extern "c" fn DrawTexturePro(
    texture: Texture2D,
    source: Rectangle,
    dest: Rectangle,
    origin: Vector2,
    rotation: f32,
    tint: Color,
) void;
extern "c" fn DrawTextureNPatch(
    texture: Texture2D,
    nPatchInfo: NPatchInfo,
    dest: Rectangle,
    origin: Vector2,
    rotation: f32,
    tint: Color,
) void;
extern "c" fn IsTextureReady(texture: Texture) bool;
extern "c" fn LoadImageFromTexture(texture: Texture) Image;
extern "c" fn LoadTexture(fileName: [*c]const u8) Texture;
extern "c" fn LoadTextureFromImage(image: Image) Texture;
extern "c" fn LoadTextureCubemap(image: Image, layout: c_int) TextureCubemap;
extern "c" fn UnloadTexture(texture: Texture) void;
extern "c" fn UpdateTexture(texture: Texture, pixels: *const anyopaque) void;
extern "c" fn UpdateTextureRec(
    texture: Texture,
    rec: Rectangle,
    pixels: *const anyopaque,
) void;
