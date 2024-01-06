const Color = @import("color.zig").Color;
const Texture2D = @import("texture2d.zig").Texture2D;

pub const MaterialMap = extern struct {
    texture: Texture2D,
    color: Color,
    value: f32,
};
