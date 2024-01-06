const BoneInfo = @import("boneinfo.zig").BoneInfo;
const BoundingBox = @import("boundingbox.zig").BoundingBox;
const Color = @import("color.zig").Color;
const Material = @import("material.zig").Material;
const Matrix = @import("matrix.zig").Matrix;
const Mesh = @import("mesh.zig").Mesh;
const ModelAnimation = @import("modelanimation.zig").ModelAnimation;
const Transform = @import("transform.zig").Transform;
const Vector3 = @import("vector3.zig").Vector3;

pub const Model = extern struct {
    transform: Matrix,
    meshCount: c_int,
    materialCount: c_int,
    meshes: [*c]Mesh,
    materials: [*c]Material,
    meshMaterial: [*c]c_int,
    boneCount: c_int,
    bones: [*c]BoneInfo,
    bindPose: [*c]Transform,

    const Self = @This();

    /// Load model from files (meshes and materials)
    pub fn load(fileName: [:0]const u8) Self {
        return LoadModel(fileName);
    }

    /// Load model from generated mesh (default material)
    pub fn fromMesh(mesh: Mesh) Self {
        return LoadModelFromMesh(mesh);
    }

    /// Unload model (including meshes) from memory (RAM and/or VRAM)
    pub fn unload(self: Self) void {
        UnloadModel(self);
    }

    /// Draw a model (with texture if set)
    pub fn draw(self: Self, position: Vector3, scale: f32, tint: Color) void {
        return DrawModel(self, position, scale, tint);
    }

    /// Draw a model with extended parameters
    pub fn drawEx(
        self: Self,
        position: Vector3,
        rotationAxis: Vector3,
        rotationAngle: f32,
        scale: Vector3,
        tint: Color,
    ) void {
        return DrawModelEx(
            self,
            position,
            rotationAxis,
            rotationAngle,
            scale,
            tint,
        );
    }

    /// Draw a model wires (with texture if set)
    pub fn drawWires(
        self: Self,
        position: Vector3,
        scale: f32,
        tint: Color,
    ) void {
        return DrawModelWires(self, position, scale, tint);
    }

    /// Draw a model wires (with texture if set) with extended parameters
    pub fn draWiresEx(
        self: Self,
        position: Vector3,
        rotationAxis: Vector3,
        rotationAngle: f32,
        scale: Vector3,
        tint: Color,
    ) void {
        return DrawModelWiresEx(
            self,
            position,
            rotationAxis,
            rotationAngle,
            scale,
            tint,
        );
    }

    /// Compute model bounding box limits (considers all meshes)
    pub fn getBoundingBox(self: Model) BoundingBox {
        return GetModelBoundingBox(self);
    }

    /// Check model animation skeleton match
    pub fn isAnimationValid(self: Model, anim: ModelAnimation) bool {
        return IsModelAnimationValid(self, anim);
    }

    /// Check if a model is ready
    pub fn isReady(self: Model) bool {
        return IsModelReady(self);
    }

    /// Update model animation pose
    pub fn updateAnimation(
        self: Model,
        anim: ModelAnimation,
        frame: i32,
    ) void {
        UpdateModelAnimation(self, anim, @as(c_int, frame));
    }
};

extern "c" fn DrawModel(
    model: Model,
    position: Vector3,
    scale: f32,
    tint: Color,
) void;
extern "c" fn DrawModelEx(
    model: Model,
    position: Vector3,
    rotationAxis: Vector3,
    rotationAngle: f32,
    scale: Vector3,
    tint: Color,
) void;
extern "c" fn DrawModelWires(
    model: Model,
    position: Vector3,
    scale: f32,
    tint: Color,
) void;
extern "c" fn DrawModelWiresEx(
    model: Model,
    position: Vector3,
    rotationAxis: Vector3,
    rotationAngle: f32,
    scale: Vector3,
    tint: Color,
) void;
extern "c" fn GetModelBoundingBox(model: Model) BoundingBox;
extern "c" fn IsModelAnimationValid(model: Model, anim: ModelAnimation) bool;
extern "c" fn IsModelReady(model: Model) bool;
extern "c" fn LoadModel(fileName: [*c]const u8) Model;
extern "c" fn LoadModelFromMesh(mesh: Mesh) Model;
extern "c" fn UnloadModel(model: Model) void;
extern "c" fn UnloadModelKeepMeshes(model: Model) void;
extern "c" fn UpdateModelAnimation(
    model: Model,
    anim: ModelAnimation,
    frame: c_int,
) void;
