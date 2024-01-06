const BoundingBox = @import("boundingbox.zig").BoundingBox;
const Color = @import("color.zig").Color;
const Matrix = @import("matrix.zig").Matrix;
const Mesh = @import("mesh.zig").Mesh;
const RayCollision = @import("raycollision.zig").RayCollision;
const Vector3 = @import("vector3.zig").Vector3;

pub const Ray = extern struct {
    position: Vector3,
    direction: Vector3,

    /// Draw a ray line
    pub fn draw(self: Ray, color: Color) void {
        DrawRay(self, color);
    }

    /// Get collision info between ray and sphere
    pub fn getCollisionSphere(
        self: Ray,
        center: Vector3,
        radius: f32,
    ) RayCollision {
        return GetRayCollisionSphere(self, center, radius);
    }

    /// Get collision info between ray and box
    pub fn getCollisionBox(self: Ray, box: BoundingBox) RayCollision {
        return GetRayCollisionBox(self, box);
    }

    /// Get collision info between ray and mesh
    pub fn getCollisionMesh(
        self: Ray,
        mesh: Mesh,
        transform: Matrix,
    ) RayCollision {
        return GetRayCollisionMesh(self, mesh, transform);
    }

    /// Get collision info between ray and triangle
    pub fn getCollisionTriangle(
        self: Ray,
        point_1: Vector3,
        point_2: Vector3,
        point_3: Vector3,
    ) RayCollision {
        return GetRayCollisionTriangle(self, point_1, point_2, point_3);
    }

    /// Get collision info between ray and quad
    pub fn getCollisionQuad(
        self: Ray,
        point_1: Vector3,
        point_2: Vector3,
        point_3: Vector3,
        point_4: Vector3,
    ) RayCollision {
        return GetRayCollisionQuad(
            self,
            point_1,
            point_2,
            point_3,
            point_4,
        );
    }
};

extern "c" fn DrawRay(ray: Ray, color: Color) void;
extern "c" fn GetRayCollisionSphere(
    ray: Ray,
    center: Vector3,
    radius: f32,
) RayCollision;
extern "c" fn GetRayCollisionBox(ray: Ray, box: BoundingBox) RayCollision;
extern "c" fn GetRayCollisionMesh(
    ray: Ray,
    mesh: Mesh,
    transform: Matrix,
) RayCollision;
extern "c" fn GetRayCollisionTriangle(
    ray: Ray,
    p1: Vector3,
    p2: Vector3,
    p3: Vector3,
) RayCollision;
extern "c" fn GetRayCollisionQuad(
    ray: Ray,
    p1: Vector3,
    p2: Vector3,
    p3: Vector3,
    p4: Vector3,
) RayCollision;
