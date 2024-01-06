const Matrix = @import("matrix.zig").Matrix;
const Vector2 = @import("vector2.zig").Vector2;

pub const Camera2D = extern struct {
    offset: Vector2,
    target: Vector2,
    rotation: f32,
    zoom: f32,

    const Self = @This();

    pub fn begin(self: Self) void {
        BeginMode2D(self);
    }

    pub fn end(_: Self) void {
        EndMode2D();
    }

    /// Get camera 2d transform matrix
    pub fn getMatrix(self: Self) Matrix {
        return GetCameraMatrix2D(self);
    }
};

extern "c" fn BeginMode2D(camera: Camera2D) void;
extern "c" fn EndMode2D() void;
extern "c" fn GetCameraMatrix2D(camera: Camera2D) Matrix;
