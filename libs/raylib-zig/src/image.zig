const Color = @import("color.zig").Color;
const Font = @import("font.zig").Font;
const Rectangle = @import("rectangle.zig").Rectangle;
const Texture = @import("texture.zig").Texture;
const Texture2D = @import("texture2d.zig").Texture2D;
const Vector2 = @import("vector2.zig").Vector2;

const Enums = @import("enums.zig");
const PixelFormat = Enums.PixelFormat;

pub const Image = extern struct {
    data: ?*anyopaque,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: PixelFormat,

    /// Load image from file into CPU memory (RAM)
    pub fn load(fileName: [:0]const u8) Image {
        return LoadImage(fileName);
    }

    /// Load image from RAW file data
    pub fn loadRaw(
        fileName: [:0]const u8,
        width: i32,
        height: i32,
        format: PixelFormat,
        headerSize: i32,
    ) Image {
        return LoadImageRaw(
            fileName,
            width,
            height,
            format,
            headerSize,
        );
    }

    /// Load image sequence from file (frames appended to image.data)
    pub fn loadAnim(fileName: [:0]const u8, frames: *i32) Image {
        return LoadImageAnim(fileName, frames);
    }

    /// Load image from memory buffer, fileType refers to extension: i.e. '.png'
    pub fn fromMemory(
        file_type: [*c]const u8,
        file_data: [*c]const u8,
        data_size: c_int,
    ) Image {
        return LoadImageFromMemory(file_type, file_data, data_size);
    }

    /// Load image from GPU texture data
    pub fn fromTexture(texture: Texture) Image {
        return LoadImageFromTexture(texture);
    }

    /// Load image from screen buffer and (screenshot)
    pub fn fromScreen() Image {
        return LoadImageFromScreen();
    }

    /// Check if an image is ready
    pub fn isReady(self: Image) bool {
        return IsImageReady(self);
    }

    /// Unload image from CPU memory (RAM)
    pub fn unload(self: Image) void {
        UnloadImage(self);
    }

    /// Export image data to file, returns true on success
    pub fn exportToFile(self: Image, fileName: [:0]const u8) bool {
        return ExportImage(self, fileName);
    }

    /// Export image to memory buffer
    pub fn exportToMemory(
        self: Image,
        file_type: [:0]const u8,
        file_size: *i32,
    ) []u8 {
        return ExportImageToMemory(self, file_type, file_size);
    }

    /// Export image as code file defining an array of bytes, returns true
    /// on success
    pub fn exportAsCode(self: Image, fileName: [:0]const u8) bool {
        return ExportImageAsCode(self, fileName);
    }

    /// Generate image: plain color
    pub fn genColor(width: i32, height: i32, color: Color) Image {
        return GenImageColor(width, height, color);
    }

    /// Generate image: linear gradient, direction in degrees [0..360],
    /// 0=Vertical gradient
    pub fn genGradientLinear(
        width: i32,
        height: i32,
        direction: i32,
        left: Color,
        right: Color,
    ) Image {
        return GenImageGradientLinear(width, height, direction, left, right);
    }

    /// Generate image: radial gradient
    pub fn genGradientRadial(
        width: i32,
        height: i32,
        density: f32,
        inner: Color,
        outer: Color,
    ) Image {
        return GenImageGradientRadial(
            width,
            height,
            density,
            inner,
            outer,
        );
    }

    /// Generate image: square gradient
    pub fn genGradientSquare(
        width: i32,
        height: i32,
        density: f32,
        inner: Color,
        outer: Color,
    ) Image {
        return GenImageGradientSquare(
            width,
            height,
            density,
            inner,
            outer,
        );
    }

    /// Generate image: checked
    pub fn genChecked(
        width: i32,
        height: i32,
        checksX: i32,
        checksY: i32,
        col1: Color,
        col2: Color,
    ) Image {
        return GenImageChecked(
            width,
            height,
            checksX,
            checksY,
            col1,
            col2,
        );
    }

    /// Generate image: white noise
    pub fn genWhiteNoise(width: i32, height: i32, factor: f32) Image {
        return GenImageWhiteNoise(width, height, factor);
    }

    /// Generate image: perlin noise
    pub fn genPerlinNoise(
        width: i32,
        height: i32,
        offsetX: i32,
        offsetY: i32,
        scale: f32,
    ) Image {
        _ = scale;
        return GenImagePerlinNoise(width, height, offsetX, offsetY);
    }

    /// Generate image: cellular algorithm, bigger tileSize means bigger cells
    pub fn genCellular(width: i32, height: i32, tileSize: i32) Image {
        return GenImageCellular(width, height, tileSize);
    }

    /// Generate image: grayscale image from text data
    pub fn genText(width: i32, height: i32, text: [:0]const u8) Image {
        return GenImageText(width, height, text);
    }

    /// Create an image duplicate (useful for transformations)
    pub fn copy(self: Image) Image {
        return ImageCopy(self);
    }

    /// Create an image from another image piece
    pub fn copyRectangle(self: Image, rec: Rectangle) Image {
        return ImageFromImage(self, rec);
    }

    /// Create an image from text (default font)
    pub fn fromText(text: [:0]const u8, fontSize: i32, color: Color) Image {
        return ImageText(text, fontSize, color);
    }

    /// Create an image from text (custom sprite font)
    pub fn fromTextEx(
        font: Font,
        text: [:0]const u8,
        fontSize: f32,
        spacing: f32,
        t: Color,
    ) Image {
        return ImageTextEx(font, text, fontSize, spacing, t);
    }

    // @todo: use PixelFormat enum for newFormat
    /// Convert image data to desired format
    pub fn setFormat(self: *Image, newFormat: i32) Image {
        ImageFormat(self, newFormat);
    }

    /// Convert image to POT (power-of-two)
    pub fn toPOT(self: *Image, fill: Color) void {
        ImageToPOT(self, fill);
    }

    /// Crop an image to a defined rectangle
    pub fn crop(self: *Image, rec: Rectangle) void {
        ImageCrop(self, rec);
    }

    /// Crop image depending on alpha value
    pub fn alphaCrop(self: *Image, threshold: f32) void {
        ImageAlphaCrop(self, threshold);
    }

    /// Clear alpha channel to desired color
    pub fn alphaClear(self: *Image, color: Color, threshold: f32) void {
        ImageAlphaClear(self, color, threshold);
    }

    /// Apply alpha mask to image
    pub fn alphaMask(self: *Image, am: Image) void {
        ImageAlphaMask(self, am);
    }

    /// Premultiply alpha channel
    pub fn alphaPremultiply(self: *Image) void {
        ImageAlphaPremultiply(self);
    }

    /// Apply Gaussian blur using a box blur approximation
    pub fn blurGaussian(self: *Image, blurSize: i32) void {
        ImageBlurGaussian(self, blurSize);
    }

    /// Resize image (Bicubic scaling algorithm)
    pub fn resize(self: *Image, newWidth: i32, newHeight: i32) void {
        ImageResize(self, newWidth, newHeight);
    }

    /// Resize image (Nearest-Neighbor scaling algorithm)
    pub fn resizeNN(self: *Image, newWidth: i32, newHeight: i32) void {
        ImageResizeNN(self, newWidth, newHeight);
    }

    /// Resize canvas and fill with color
    pub fn resizeCanvas(
        self: *Image,
        newWidth: i32,
        newHeight: i32,
        offsetX: i32,
        offsetY: i32,
        fill: Color,
    ) void {
        ImageResizeCanvas(
            self,
            newWidth,
            newHeight,
            offsetX,
            offsetY,
            fill,
        );
    }

    /// Compute all mipmap levels for a provided image
    pub fn mimaps(self: *Image) void {
        ImageMipmaps(self);
    }

    /// Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
    pub fn dither(
        self: *Image,
        rBpp: i32,
        gBpp: i32,
        bBpp: i32,
        aBpp: i32,
    ) void {
        ImageDither(self, rBpp, gBpp, bBpp, aBpp);
    }

    /// Flip image vertically
    pub fn flipVertical(self: *Image) void {
        ImageFlipVertical(self);
    }

    // Flip image horizontally
    pub fn flipHorizontal(self: *Image) void {
        ImageFlipHorizontal(self);
    }

    /// Rotate image by input angle in degrees (-359 to 359)
    pub fn rotate(self: *Image, degrees: i32) void {
        ImageRotate(self, degrees);
    }

    /// Rotate image clockwise 90deg
    pub fn rotateCW(self: *Image) void {
        ImageRotateCW(self);
    }

    /// Rotate image counter-clockwise 90deg
    pub fn rotateCCW(self: *Image) void {
        ImageRotateCCW(self);
    }

    /// Modify image color: tint
    pub fn tint(self: *Image, color: Color) void {
        ImageColorTint(self, color);
    }

    /// Modify image color: invert
    pub fn invert(self: *Image) void {
        ImageColorInvert(self);
    }

    /// Modify image color: grayscale
    pub fn grayscale(self: *Image) void {
        ImageColorGrayscale(self);
    }

    /// Modify image color: contrast (-100 to 100)
    pub fn contrast(self: *Image, c: f32) void {
        ImageColorContrast(self, c);
    }

    /// Modify image color: brightness (-255 to 255)
    pub fn brightness(self: *Image, b: i32) void {
        ImageColorBrightness(self, @as(c_int, b));
    }

    /// Modify image color: replace color
    pub fn replaceColor(self: *Image, color: Color, replace: Color) void {
        ImageColorReplace(self, color, replace);
    }

    /// Load color data from image as a Color array (RGBA - 32bit)
    pub fn loadColors(image: Image) []Color {
        var res: []Color = .{
            .ptr = @ptrCast(LoadImageColors(image)),
            .len = @intCast(image.width * image.height),
        };
        return res;
    }

    /// Load colors palette from image as a Color array (RGBA - 32bit)
    pub fn loadPalette(image: Image, maxPaletteSize: i32) []Color {
        var colorCount: i32 = 0;
        var res: []Color = .{
            .ptr = @ptrCast(LoadImagePalette(
                image,
                @as(c_int, maxPaletteSize),
                @ptrCast(&colorCount),
            )),
            .len = @intCast(colorCount),
        };
        return res;
    }

    /// Unload color data loaded with LoadImageColors()
    pub fn unloadColors(colors: []Color) void {
        UnloadImageColors(@ptrCast(colors));
    }

    /// Unload colors palette loaded with LoadImagePalette()
    pub fn unloadPalette(colors: []Color) void {
        UnloadImagePalette(@ptrCast(colors));
    }

    /// Get image alpha border rectangle
    pub fn getAlphaBorder(self: Image, threshold: f32) Rectangle {
        return GetImageAlphaBorder(self, threshold);
    }

    /// Get image pixel color at (x, y) position
    pub fn getColor(self: Image, x: i32, y: i32) Color {
        return GetImageColor(self, x, y);
    }

    /// Clear image background with given color
    pub fn clearBackground(self: *Image, color: Color) void {
        ImageClearBackground(self, color);
    }

    /// Draw pixel within an image
    pub fn drawPixel(self: *Image, posX: i32, posY: i32, color: Color) void {
        ImageDrawPixel(self, posX, posY, color);
    }

    /// Draw pixel within an image (Vector version)
    pub fn drawPixelV(self: *Image, position: Vector2, color: Color) void {
        ImageDrawPixelV(self, position, color);
    }

    /// Draw line within an image
    pub fn drawLine(
        self: *Image,
        startPosX: i32,
        startPosY: i32,
        endPosX: i32,
        endPosY: i32,
        color: Color,
    ) void {
        ImageDrawLine(
            self,
            startPosX,
            startPosY,
            endPosX,
            endPosY,
            color,
        );
    }

    /// Draw line within an image (Vector version)
    pub fn drawLineV(
        self: *Image,
        start: Vector2,
        end: Vector2,
        color: Color,
    ) void {
        ImageDrawLineV(self, start, end, color);
    }

    /// Draw a filled circle within an image
    pub fn drawCircle(
        self: *Image,
        centerX: i32,
        centerY: i32,
        radius: i32,
        color: Color,
    ) void {
        ImageDrawCircle(self, centerX, centerY, radius, color);
    }

    /// Draw a filled circle within an image (Vector version)
    pub fn drawCircleV(
        self: *Image,
        center: Vector2,
        radius: i32,
        color: Color,
    ) void {
        ImageDrawCircleV(self, center, radius, color);
    }

    /// Draw circle outline within an image
    pub fn drawCircleLines(
        self: *Image,
        centerX: i32,
        centerY: i32,
        radius: i32,
        color: Color,
    ) void {
        ImageDrawCircleLines(self, centerX, centerY, radius, color);
    }

    /// Draw circle outline within an image (Vector version)
    pub fn drawCircleLinesV(
        self: *Image,
        center: Vector2,
        radius: i32,
        color: Color,
    ) void {
        ImageDrawCircleLinesV(self, center, radius, color);
    }

    /// Draw rectangle within an image
    pub fn drawRectangle(
        self: *Image,
        posX: i32,
        posY: i32,
        width: i32,
        height: i32,
        color: Color,
    ) void {
        ImageDrawRectangle(self, posX, posY, width, height, color);
    }

    /// Draw rectangle within an image (Vector version)
    pub fn drawRectangleV(
        self: *Image,
        position: Vector2,
        size: Vector2,
        color: Color,
    ) void {
        ImageDrawRectangleV(self, position, size, color);
    }

    /// Draw rectangle within an image
    pub fn drawRectangleRec(self: *Image, rec: Rectangle, color: Color) void {
        ImageDrawRectangleRec(self, rec, color);
    }

    /// Draw rectangle lines within an image
    pub fn drawRectangleLines(
        self: *Image,
        rec: Rectangle,
        thick: i32,
        color: Color,
    ) void {
        ImageDrawRectangleLines(self, rec, thick, color);
    }

    /// Draw a source image within a destination image (tint applied to source)
    pub fn drawImage(
        self: *Image,
        src: Image,
        srcRec: Rectangle,
        dstRec: Rectangle,
        t: Color,
    ) void {
        ImageDraw(self, src, srcRec, dstRec, t);
    }

    /// Draw text (using default font) within an image (destination)
    pub fn drawText(
        self: *Image,
        text: [:0]const u8,
        posX: i32,
        posY: i32,
        fontSize: i32,
        color: Color,
    ) void {
        ImageDrawText(self, text, posX, posY, fontSize, color);
    }

    /// Draw text (custom sprite font) within an image (destination)
    pub fn drawTextEx(
        self: *Image,
        font: Font,
        text: [:0]const u8,
        position: Vector2,
        fontSize: f32,
        spacing: f32,
        t: Color,
    ) void {
        ImageDrawTextEx(
            self,
            font,
            text,
            position,
            fontSize,
            spacing,
            t,
        );
    }

    /// Load texture from image data
    pub fn toTexture(self: Image) Texture {
        return LoadTextureFromImage(self);
    }

    // @todo: use CubemapLayout enum for layout
    pub fn asCubemap(self: Image, layout: i32) Texture {
        return Texture.fromCubemap(self, layout);
    }
};

extern "c" fn IsImageReady(image: Image) bool;
extern "c" fn UnloadImage(image: Image) void;
extern "c" fn ExportImage(image: Image, fileName: [*c]const u8) bool;
extern "c" fn ExportImageToMemory(
    image: Image,
    fileType: [*c]const u8,
    fileSize: *c_int,
) [*c]u8;
extern "c" fn ExportImageAsCode(image: Image, fileName: [*c]const u8) bool;
extern "c" fn GenImageColor(width: c_int, height: c_int, color: Color) Image;
extern "c" fn GenImageGradientLinear(
    width: c_int,
    height: c_int,
    direction: c_int,
    top: Color,
    bottom: Color,
) Image;
extern "c" fn GenImageGradientRadial(
    width: c_int,
    height: c_int,
    density: f32,
    inner: Color,
    outer: Color,
) Image;
extern "c" fn GenImageGradientSquare(
    width: c_int,
    height: c_int,
    density: f32,
    inner: Color,
    outer: Color,
) Image;
extern "c" fn GenImageChecked(
    width: c_int,
    height: c_int,
    checksX: c_int,
    checksY: c_int,
    col1: Color,
    col2: Color,
) Image;
extern "c" fn GenImageWhiteNoise(
    width: c_int,
    height: c_int,
    factor: f32,
) Image;
extern "c" fn GenImagePerlinNoise(
    width: c_int,
    height: c_int,
    offsetX: c_int,
    offsetY: c_int,
    scale: f32,
) Image;
extern "c" fn GenImageCellular(
    width: c_int,
    height: c_int,
    tileSize: c_int,
) Image;
extern "c" fn GenImageText(
    width: c_int,
    height: c_int,
    text: [*c]const u8,
) Image;
extern "c" fn ImageCopy(image: Image) Image;
extern "c" fn ImageFromImage(image: Image, rec: Rectangle) Image;
extern "c" fn ImageText(
    text: [*c]const u8,
    fontSize: c_int,
    color: Color,
) Image;
extern "c" fn ImageTextEx(
    font: Font,
    text: [*c]const u8,
    fontSize: f32,
    spacing: f32,
    tint: Color,
) Image;
extern "c" fn ImageFormat(image: [*c]Image, newFormat: c_int) void;
extern "c" fn ImageToPOT(image: [*c]Image, fill: Color) void;
extern "c" fn ImageCrop(image: [*c]Image, crop: Rectangle) void;
extern "c" fn ImageAlphaCrop(image: [*c]Image, threshold: f32) void;
extern "c" fn ImageAlphaClear(
    image: [*c]Image,
    color: Color,
    threshold: f32,
) void;
extern "c" fn ImageAlphaMask(image: [*c]Image, alphaMask: Image) void;
extern "c" fn ImageAlphaPremultiply(image: [*c]Image) void;
extern "c" fn ImageBlurGaussian(image: [*c]Image, blurSize: c_int) void;
extern "c" fn ImageResize(
    image: [*c]Image,
    newWidth: c_int,
    newHeight: c_int,
) void;
extern "c" fn ImageResizeNN(
    image: [*c]Image,
    newWidth: c_int,
    newHeight: c_int,
) void;
extern "c" fn ImageResizeCanvas(
    image: [*c]Image,
    newWidth: c_int,
    newHeight: c_int,
    offsetX: c_int,
    offsetY: c_int,
    fill: Color,
) void;
extern "c" fn ImageMipmaps(image: [*c]Image) void;
extern "c" fn ImageDither(
    image: [*c]Image,
    rBpp: c_int,
    gBpp: c_int,
    bBpp: c_int,
    aBpp: c_int,
) void;
extern "c" fn ImageFlipVertical(image: [*c]Image) void;
extern "c" fn ImageFlipHorizontal(image: [*c]Image) void;
extern "c" fn ImageRotate(image: [*c]Image, degrees: c_int) void;
extern "c" fn ImageRotateCW(image: [*c]Image) void;
extern "c" fn ImageRotateCCW(image: [*c]Image) void;
extern "c" fn ImageColorTint(image: [*c]Image, color: Color) void;
extern "c" fn ImageColorInvert(image: [*c]Image) void;
extern "c" fn ImageColorGrayscale(image: [*c]Image) void;
extern "c" fn ImageColorContrast(image: [*c]Image, contrast: f32) void;
extern "c" fn ImageColorBrightness(image: [*c]Image, brightness: c_int) void;
extern "c" fn ImageColorReplace(
    image: [*c]Image,
    color: Color,
    replace: Color,
) void;
extern "c" fn UnloadImageColors(colors: [*c]Color) void;
extern "c" fn UnloadImagePalette(colors: [*c]Color) void;
extern "c" fn GetImageAlphaBorder(image: Image, threshold: f32) Rectangle;
extern "c" fn GetImageColor(image: Image, x: c_int, y: c_int) Color;
extern "c" fn ImageClearBackground(dst: [*c]Image, color: Color) void;
extern "c" fn ImageDrawPixel(
    dst: [*c]Image,
    posX: c_int,
    posY: c_int,
    color: Color,
) void;
extern "c" fn ImageDrawPixelV(
    dst: [*c]Image,
    position: Vector2,
    color: Color,
) void;
extern "c" fn ImageDrawLine(
    dst: [*c]Image,
    startPosX: c_int,
    startPosY: c_int,
    endPosX: c_int,
    endPosY: c_int,
    color: Color,
) void;
extern "c" fn ImageDrawLineV(
    dst: [*c]Image,
    start: Vector2,
    end: Vector2,
    color: Color,
) void;
extern "c" fn ImageDrawCircle(
    dst: [*c]Image,
    centerX: c_int,
    centerY: c_int,
    radius: c_int,
    color: Color,
) void;
extern "c" fn ImageDrawCircleV(
    dst: [*c]Image,
    center: Vector2,
    radius: c_int,
    color: Color,
) void;
extern "c" fn ImageDrawCircleLines(
    dst: [*c]Image,
    centerX: c_int,
    centerY: c_int,
    radius: c_int,
    color: Color,
) void;
extern "c" fn ImageDrawCircleLinesV(
    dst: [*c]Image,
    center: Vector2,
    radius: c_int,
    color: Color,
) void;
extern "c" fn ImageDrawRectangle(
    dst: [*c]Image,
    posX: c_int,
    posY: c_int,
    width: c_int,
    height: c_int,
    color: Color,
) void;
extern "c" fn ImageDrawRectangleV(
    dst: [*c]Image,
    position: Vector2,
    size: Vector2,
    color: Color,
) void;
extern "c" fn ImageDrawRectangleRec(
    dst: [*c]Image,
    rec: Rectangle,
    color: Color,
) void;
extern "c" fn ImageDrawRectangleLines(
    dst: [*c]Image,
    rec: Rectangle,
    thick: c_int,
    color: Color,
) void;
extern "c" fn ImageDraw(
    dst: [*c]Image,
    src: Image,
    srcRec: Rectangle,
    dstRec: Rectangle,
    tint: Color,
) void;
extern "c" fn ImageDrawText(
    dst: [*c]Image,
    text: [*c]const u8,
    posX: c_int,
    posY: c_int,
    fontSize: c_int,
    color: Color,
) void;
extern "c" fn ImageDrawTextEx(
    dst: [*c]Image,
    font: Font,
    text: [*c]const u8,
    position: Vector2,
    fontSize: f32,
    spacing: f32,
    tint: Color,
) void;
extern "c" fn LoadImage(fileName: [*c]const u8) Image;
extern "c" fn LoadImageAnim(fileName: [*c]const u8, frames: [*c]c_int) Image;
extern "c" fn LoadImageColors(image: Image) [*c]Color;
extern "c" fn LoadImageFromMemory(
    fileType: [*c]const u8,
    fileData: [*c]const u8,
    dataSize: c_int,
) Image;
extern "c" fn LoadImageFromTexture(texture: Texture2D) Image;
extern "c" fn LoadImageFromScreen() Image;
extern "c" fn LoadImagePalette(
    image: Image,
    maxPaletteSize: c_int,
    colorCount: [*c]c_int,
) [*c]Color;
extern "c" fn LoadImageRaw(
    fileName: [*c]const u8,
    width: c_int,
    height: c_int,
    format: c_int,
    headerSize: c_int,
) Image;
extern "c" fn LoadTextureFromImage(image: Image) Texture;
