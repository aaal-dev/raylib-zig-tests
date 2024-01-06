const Quaternion = @import("quaternion.zig").Quaternion;
const Vector3 = @import("vector3.zig").Vector3;

pub const Transform = extern struct {
    translation: Vector3,
    rotation: Quaternion,
    scale: Vector3,
};
