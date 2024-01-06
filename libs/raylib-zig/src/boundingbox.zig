const Color = @import("color.zig").Color;
const Vector3 = @import("vector3.zig").Vector3;

pub const BoundingBox = extern struct {
    min: Vector3,
    max: Vector3,

    /// Draw bounding box (wires)
    pub fn drawBoundingBox(self: BoundingBox, color: Color) void {
        DrawBoundingBox(self, color);
    }
};

extern "c" fn DrawBoundingBox(box: BoundingBox, color: Color) void;
