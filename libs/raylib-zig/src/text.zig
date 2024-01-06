const Color = @import("color.zig").Color;
const Font = @import("font.zig").Font;
const Vector2 = @import("vector2.zig").Vector2;

pub const Text = extern struct {
    text: [*c]const u8,
    //font: Font,

    /// Draw text (using default font)
    pub fn draw(
        self: Text,
        pos_x: i32,
        pos_y: i32,
        font_size: i32,
        color: Color,
    ) void {
        DrawText(
            self.text,
            @as(c_int, pos_x),
            @as(c_int, pos_y),
            @as(c_int, font_size),
            color,
        );
    }

    /// Measure string width for default font
    pub fn measure(self: Text, font_size: i32) i32 {
        return @as(i32, MeasureText(self.text, @as(c_int, font_size)));
    }

    /// Measure string size for Font
    pub fn measureEx(
        self: Text,
        font: Font,
        fontSize: f32,
        spacing: f32,
    ) Vector2 {
        return MeasureTextEx(font, self.text, fontSize, spacing);
    }
};

extern "c" fn DrawText(
    text: [*c]const u8,
    posX: c_int,
    posY: c_int,
    fontSize: c_int,
    color: Color,
) void;
extern "c" fn MeasureText(text: [*c]const u8, fontSize: c_int) c_int;
extern "c" fn MeasureTextEx(
    font: Font,
    text: [*c]const u8,
    fontSize: f32,
    spacing: f32,
) Vector2;
