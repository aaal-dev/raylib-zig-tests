const Camera = @import("camera.zig").Camera;
const Matrix = @import("matrix.zig").Matrix;
const Vector3 = @import("vector3.zig").Vector3;

const Enums = @import("enums.zig");
const CameraMode = Enums.CameraMode;
const CameraProjection = Enums.CameraProjection;

pub const Camera3D = extern struct {
    position: Vector3,
    target: Vector3,
    up: Vector3,
    fovy: f32,
    projection: CameraProjection,

    const Self = @This();

    pub fn begin(self: Self) void {
        BeginMode3D(self);
    }

    pub fn end(_: Self) void {
        EndMode3D();
    }

    /// Get camera transform matrix (view matrix)
    pub fn getMatrix(self: Self) Matrix {
        return GetCameraMatrix(self);
    }

    pub fn setMode(self: Self, mode: CameraMode) void {
        SetCameraMode(self, mode);
    }

    pub fn update(self: *Self) void {
        UpdateCamera(self);
    }
};

extern "c" fn BeginMode3D(camera: Camera3D) void;
extern "c" fn EndMode3D() void;
extern "c" fn GetCameraMatrix(camera: Camera) Matrix;
extern "c" fn SetCameraMode(camera: Camera, mode: CameraMode) void;
extern "c" fn UpdateCamera(camera: [*c]Camera) void;
