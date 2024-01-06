const BoundingBox = @import("boundingbox.zig").BoundingBox;
const Image = @import("image.zig").Image;
const Material = @import("material.zig").Material;
const Matrix = @import("matrix.zig").Matrix;
const Model = @import("model.zig").Model;
const Vector3 = @import("vector3.zig").Vector3;

pub const Mesh = extern struct {
    vertexCount: c_int,
    triangleCount: c_int,
    vertices: [*c]f32,
    texcoords: [*c]f32,
    texcoords2: [*c]f32,
    normals: [*c]f32,
    tangents: [*c]f32,
    colors: [*c]u8,
    indices: [*c]c_ushort,
    animVertices: [*c]f32,
    animNormals: [*c]f32,
    boneIds: [*c]u8,
    boneWeights: [*c]f32,
    vaoId: c_uint,
    vboId: [*c]c_uint,

    pub fn draw(self: Mesh, material: Material, transform: Matrix) void {
        DrawMesh(self, material, transform);
    }

    pub fn drawInstanced(
        self: Mesh,
        material: Material,
        transforms: []const Matrix,
    ) void {
        DrawMeshInstanced(self, material, transforms);
    }

    /// Export mesh data to file, returns true on success
    pub fn exportMesh(self: Mesh, fileName: [:0]const u8) bool {
        return ExportMesh(self, @ptrCast(fileName));
    }

    /// Generate polygonal mesh
    pub fn genPoly(sides: i32, radius: f32) Mesh {
        return GenMeshPoly(@as(c_int, sides), radius);
    }

    /// Generate plane mesh (with subdivisions)
    pub fn genPlane(width: f32, length: f32, res_x: i32, res_z: i32) Mesh {
        return GenMeshPlane(
            width,
            length,
            @as(c_int, res_x),
            @as(c_int, res_z),
        );
    }

    /// Generate cuboid mesh
    pub fn genCube(width: f32, height: f32, length: f32) Mesh {
        return GenMeshCube(width, height, length);
    }

    /// Generate sphere mesh (standard sphere)
    pub fn genSphere(radius: f32, rings: i32, slices: i32) Mesh {
        return GenMeshSphere(radius, @as(c_int, rings), @as(c_int, slices));
    }

    /// Generate half-sphere mesh (no bottom cap)
    pub fn genHemiSphere(radius: f32, rings: i32, slices: i32) Mesh {
        return GenMeshHemiSphere(
            radius,
            @as(c_int, rings),
            @as(c_int, slices),
        );
    }

    /// Generate cylinder mesh
    pub fn genCylinder(radius: f32, height: f32, slices: i32) Mesh {
        return GenMeshCylinder(radius, height, @as(c_int, slices));
    }

    /// Generate cone/pyramid mesh
    pub fn genCone(radius: f32, height: f32, slices: i32) Mesh {
        return GenMeshCone(radius, height, @as(c_int, slices));
    }

    /// Generate torus mesh
    pub fn genTorus(radius: f32, size: f32, radSeg: i32, sides: i32) Mesh {
        return GenMeshTorus(
            radius,
            size,
            @as(c_int, radSeg),
            @as(c_int, sides),
        );
    }

    /// Generate trefoil knot mesh
    pub fn genKnot(radius: f32, size: f32, radSeg: i32, sides: i32) Mesh {
        return GenMeshKnot(
            radius,
            size,
            @as(c_int, radSeg),
            @as(c_int, sides),
        );
    }

    /// Generate heightmap mesh from image data
    pub fn genHeightmap(heightmap: Image, size: Vector3) Mesh {
        return GenMeshHeightmap(heightmap, size);
    }

    /// Generate cubes-based map mesh from image data
    pub fn genCubicmap(cubicmap: Image, cubeSize: Vector3) Mesh {
        return GenMeshCubicmap(cubicmap, cubeSize);
    }

    /// Compute mesh bounding box limits
    pub fn getMeshBoundingBox(self: Mesh) BoundingBox {
        return GetMeshBoundingBox(self);
    }

    /// Load model from generated mesh (default material)
    pub fn toModel(self: Mesh) Model {
        return LoadModelFromMesh(self);
    }

    /// Unload mesh data from CPU and GPU
    pub fn unloadMesh(self: Mesh) void {
        UnloadMesh(self);
    }

    /// Update mesh vertex data in GPU for a specific buffer index
    pub fn updateMeshBuffer(
        self: Mesh,
        index: i32,
        data: *const anyopaque,
        dataSize: i32,
        offset: i32,
    ) void {
        UpdateMeshBuffer(
            self,
            @as(c_int, index),
            data,
            @as(c_int, dataSize),
            @as(c_int, offset),
        );
    }
};

extern "c" fn DrawMesh(
    mesh: Mesh,
    material: Material,
    transform: Matrix,
) void;
extern "c" fn DrawMeshInstanced(
    mesh: Mesh,
    material: Material,
    transforms: [*c]const Matrix,
    instances: c_int,
) void;
extern "c" fn ExportMesh(mesh: Mesh, fileName: [*c]const u8) bool;
extern "c" fn GenMeshPoly(sides: c_int, radius: f32) Mesh;
extern "c" fn GenMeshPlane(
    width: f32,
    length: f32,
    resX: c_int,
    resZ: c_int,
) Mesh;
extern "c" fn GenMeshCube(width: f32, height: f32, length: f32) Mesh;
extern "c" fn GenMeshSphere(radius: f32, rings: c_int, slices: c_int) Mesh;
extern "c" fn GenMeshHemiSphere(radius: f32, rings: c_int, slices: c_int) Mesh;
extern "c" fn GenMeshCylinder(radius: f32, height: f32, slices: c_int) Mesh;
extern "c" fn GenMeshCone(radius: f32, height: f32, slices: c_int) Mesh;
extern "c" fn GenMeshTorus(
    radius: f32,
    size: f32,
    radSeg: c_int,
    sides: c_int,
) Mesh;
extern "c" fn GenMeshKnot(
    radius: f32,
    size: f32,
    radSeg: c_int,
    sides: c_int,
) Mesh;
extern "c" fn GenMeshHeightmap(heightmap: Image, size: Vector3) Mesh;
extern "c" fn GenMeshCubicmap(cubicmap: Image, cubeSize: Vector3) Mesh;
extern "c" fn GetMeshBoundingBox(mesh: Mesh) BoundingBox;
extern "c" fn LoadModelFromMesh(mesh: Mesh) Model;
extern "c" fn UnloadMesh(mesh: Mesh) void;
extern "c" fn UpdateMeshBuffer(
    mesh: Mesh,
    index: c_int,
    data: *const anyopaque,
    dataSize: c_int,
    offset: c_int,
) void;
