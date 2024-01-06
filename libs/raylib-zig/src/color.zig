const Vector3 = @import("vector3.zig").Vector3;
const Vector4 = @import("vector4.zig").Vector4;

pub const Color = extern struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,

    const Self = @This();

    pub const light_gray = Self.init(200, 200, 200, 255);
    pub const gray = Self.init(130, 130, 130, 255);
    pub const dark_gray = Self.init(80, 80, 80, 255);
    pub const yellow = Self.init(253, 249, 0, 255);
    pub const gold = Self.init(255, 203, 0, 255);
    pub const orange = Self.init(255, 161, 0, 255);
    pub const pink = Self.init(255, 161, 0, 255);
    pub const red = Self.init(230, 41, 55, 255);
    pub const maroon = Self.init(190, 33, 55, 255);
    pub const green = Self.init(0, 228, 48, 255);
    pub const lime = Self.init(0, 158, 47, 255);
    pub const dark_green = Self.init(0, 117, 44, 255);
    pub const sky_blue = Self.init(102, 191, 255, 255);
    pub const blue = Self.init(0, 121, 241, 255);
    pub const dark_blue = Self.init(0, 82, 172, 255);
    pub const purple = Self.init(200, 122, 255, 255);
    pub const violet = Self.init(135, 60, 190, 255);
    pub const dark_purple = Self.init(112, 31, 126, 255);
    pub const beige = Self.init(211, 176, 131, 255);
    pub const brown = Self.init(127, 106, 79, 255);
    pub const dark_brown = Self.init(76, 63, 47, 255);

    pub const white = Self.init(255, 255, 255, 255);
    pub const black = Self.init(0, 0, 0, 255);
    pub const blank = Self.init(0, 0, 0, 0);
    pub const magenta = Self.init(255, 0, 255, 255);
    pub const ray_white = Self.init(245, 245, 245, 255);

    pub fn init(r: u8, g: u8, b: u8, a: u8) Self {
        return Self{ .r = r, .g = g, .b = b, .a = a };
    }

    /// Get Color from normalized values [0..1]
    pub fn fromNormalized(normalized: Vector4) Self {
        return ColorFromNormalized(normalized);
    }

    /// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
    pub fn fromHSV(hue: f32, saturation: f32, value: f32) Self {
        return ColorFromHSV(hue, saturation, value);
    }

    /// Get Color structure from hexadecimal value
    pub fn fromInt(hexValue: u32) Self {
        return GetColor(hexValue);
    }

    /// Get Color from a source pixel pointer of certain format
    pub fn fromPixel(pixel: *anyopaque, format: i32) Color {
        return GetPixelColor(pixel, @as(c_int, format));
    }

    /// Get color with alpha applied, alpha goes from 0.0f to 1.0f
    pub fn fade(self: Self, a: f32) Self {
        return Fade(self, a);
    }

    /// Get color multiplied with another color
    pub fn tint(self: Self, t: Self) Self {
        return ColorTint(self, t);
    }

    /// Get Color normalized as float [0..1]
    pub fn normalize(self: Self) Vector4 {
        return ColorNormalize(self);
    }

    /// Get color with brightness correction, brightness factor goes
    /// from -1.0f to 1.0f
    pub fn brightness(self: Self, factor: f32) Color {
        return ColorBrightness(self, factor);
    }

    /// Get color with contrast correction, contrast values between
    /// -1.0f and 1.0f
    pub fn constrast(self: Self, c: f32) Self {
        return ColorContrast(self, c);
    }

    /// Get color with alpha applied, alpha goes from 0.0f to 1.0f
    pub fn alpha(self: Self, a: f32) Self {
        return ColorAlpha(self, a);
    }

    /// Get src alpha-blended into dst color with tint
    pub fn alphaBlend(self: Color, other: Color, tint_color: Color) Color {
        return ColorAlphaBlend(self, other, tint_color);
    }

    /// Get hexadecimal value for a Color
    pub fn toInt(self: Self) Self {
        return ColorToInt(self);
    }

    /// Get HSV values for a Color, hue [0..360], saturation/value [0..1]
    pub fn toHSV(self: Self) Vector3 {
        return ColorToHSV(self);
    }
};

extern "c" fn ColorToInt(color: Color) c_int;
extern "c" fn ColorNormalize(color: Color) Vector4;
extern "c" fn ColorFromNormalized(normalized: Vector4) Color;
extern "c" fn ColorToHSV(color: Color) Vector3;
extern "c" fn ColorFromHSV(hue: f32, saturation: f32, value: f32) Color;
extern "c" fn ColorTint(color: Color, tint: Color) Color;
extern "c" fn ColorBrightness(color: Color, factor: f32) Color;
extern "c" fn ColorContrast(color: Color, contrast: f32) Color;
extern "c" fn ColorAlpha(color: Color, alpha: f32) Color;
extern "c" fn ColorAlphaBlend(dst: Color, src: Color, tint: Color) Color;
extern "c" fn GetColor(hexValue: c_uint) Color;
extern "c" fn GetPixelColor(srcPtr: *anyopaque, format: c_int) Color;
extern "c" fn Fade(color: Color, alpha: f32) Color;
