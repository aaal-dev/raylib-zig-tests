const MaterialMap = @import("materialmap.zig").MaterialMap;
const Shader = @import("shader.zig").Shader;

pub const Material = extern struct {
    shader: Shader,
    maps: [*c]MaterialMap,
    params: [4]f32,

    /// Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
    pub fn loadDefault() Material {
        return LoadMaterialDefault();
    }

    /// Check if a material is ready
    pub fn isReady(self: Material) bool {
        return IsMaterialReady(self);
    }

    /// Unload material from GPU memory (VRAM)
    pub fn unload(self: Material) void {
        UnloadMaterial(self);
    }
};

extern "c" fn LoadMaterialDefault() Material;
extern "c" fn IsMaterialReady(material: Material) bool;
extern "c" fn UnloadMaterial(material: Material) void;
