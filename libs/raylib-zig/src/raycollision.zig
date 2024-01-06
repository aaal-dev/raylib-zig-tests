const Vector3 = @import("vector3.zig").Vector3;

const RayCollision = extern struct {
    hit: bool,
    distance: f32,
    point: Vector3,
    normal: Vector3,
};
