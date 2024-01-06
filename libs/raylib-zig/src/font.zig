const Color = @import("color.zig").Color;
const GlyphInfo = @import("glyphinfo.zig").GlyphInfo;
const Image = @import("image.zig").Image;
const Rectangle = @import("rectangle.zig").Rectangle;
const Texture2D = @import("texture2d.zig").Texture2D;

pub const Font = extern struct {
    baseSize: c_int,
    glyphCount: c_int,
    glyphPadding: c_int,
    texture: Texture2D,
    recs: [*c]Rectangle,
    glyphs: [*c]GlyphInfo,

    /// Get the default Font
    pub fn getDefault() Font {
        return GetFontDefault();
    }

    /// Load font from file into GPU memory (VRAM)
    pub fn load(filename: [:0]const u8) Font {
        return LoadFont(@ptrCast(filename));
    }

    /// Load font from file with extended parameters, use NULL for fontChars
    /// and 0 for glyphCount to load the default character set
    pub fn loadEx(
        filename: [:0]const u8,
        fontsize: i32,
        font_chars: []i32,
        glyph_count: i32,
    ) Font {
        return LoadFontEx(
            @ptrCast(filename),
            @as(c_int, fontsize),
            @ptrCast(font_chars),
            @as(c_int, glyph_count),
        );
    }

    /// Export font as code file, returns true on success
    pub fn exportAsCode(self: Font, fileName: [:0]const u8) bool {
        return ExportFontAsCode(self, @ptrCast(fileName));
    }

    /// Load font from Image (XNA style)
    pub fn fromImage(image: Image, key: Color, firstChar: i32) Font {
        return LoadFontFromImage(image, key, @as(c_int, firstChar));
    }

    /// Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
    pub fn fromMemory(
        fileType: [:0]const u8,
        fileData: ?[]const u8,
        fontSize: i32,
        fontChars: []i32,
    ) Font {
        return LoadFontFromMemory(
            @ptrCast(fileType),
            @ptrCast(fileData),
            @as(c_int, fontSize),
            @ptrCast(fontChars),
        );
    }

    /// Get glyph index position in font for a codepoint (unicode character),
    /// fallback to '?' if not found
    pub fn getGlyphIndex(self: Font, codepoint: i32) i32 {
        return @as(i32, GetGlyphIndex(self, @as(c_int, codepoint)));
    }

    /// Get glyph font info data for a codepoint (unicode character),
    /// fallback to '?' if not found
    pub fn getGlyphInfo(self: Font, codepoint: i32) GlyphInfo {
        return GetGlyphInfo(self, @as(c_int, codepoint));
    }

    /// Get glyph rectangle in font atlas for a codepoint (unicode character),
    /// fallback to '?' if not found
    pub fn getGlyphAtlasRec(self: Font, codepoint: i32) Rectangle {
        return GetGlyphAtlasRec(self, @as(c_int, codepoint));
    }

    /// Check if a font is ready
    pub fn isReady(self: Font) bool {
        return IsFontReady(self);
    }

    /// Unload font from GPU memory (VRAM)
    pub fn unload(self: Font) void {
        UnloadFont(self);
    }
};

extern "c" fn ExportFontAsCode(font: Font, fileName: [*c]const u8) bool;
extern "c" fn GetFontDefault() Font;
extern "c" fn GetGlyphIndex(font: Font, codepoint: c_int) c_int;
extern "c" fn GetGlyphInfo(font: Font, codepoint: c_int) GlyphInfo;
extern "c" fn GetGlyphAtlasRec(font: Font, codepoint: c_int) Rectangle;
extern "c" fn IsFontReady(font: Font) bool;
extern "c" fn LoadFont(fileName: [*c]const u8) Font;
extern "c" fn LoadFontEx(
    fileName: [*c]const u8,
    fontSize: c_int,
    fontChars: [*c]c_int,
    glyphCount: c_int,
) Font;
extern "c" fn LoadFontFromImage(
    image: Image,
    key: Color,
    firstChar: c_int,
) Font;
extern "c" fn LoadFontFromMemory(
    fileType: [*c]const u8,
    fileData: [*c]const u8,
    dataSize: c_int,
    fontSize: c_int,
    fontChars: [*c]c_int,
    glyphCount: c_int,
) Font;
extern "c" fn UnloadFont(font: Font) void;
