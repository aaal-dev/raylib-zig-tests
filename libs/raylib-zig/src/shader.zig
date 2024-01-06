const Matrix = @import("matrix.zig").Matrix;
const Texture2D = @import("texture2d.zig").Texture2D;

const Enums = @import("enums.zig");
const ShaderUniformDataType = Enums.ShaderUniformDataType;

/// Shader
pub const Shader = extern struct {
    /// Shader program id
    id: c_uint,
    /// Shader locations array (RL_MAX_SHADER_LOCATIONS)
    locs: [*c]c_int,

    pub fn activate(self: Shader) void {
        BeginShaderMode(self);
    }

    pub fn deactivate(_: Shader) void {
        EndShaderMode();
    }

    /// Load shader from files and bind default locations
    pub fn load(
        vertex_shader_filename: [:0]const u8,
        fragment_shader_filename: [:0]const u8,
    ) Shader {
        return LoadShader(vertex_shader_filename, fragment_shader_filename);
    }

    /// Load shader from code strings and bind default locations
    pub fn fromMemory(
        vertex_shader_code: [:0]const u8,
        fragment_shader_code: [:0]const u8,
    ) Shader {
        return LoadShaderFromMemory(vertex_shader_code, fragment_shader_code);
    }

    /// Check if a shader is ready
    pub fn isReady(self: Shader) bool {
        return IsShaderReady(self);
    }

    /// Get shader uniform location
    pub fn getUniformLocation(self: Shader, uniform_name: [:0]const u8) i32 {
        return GetShaderLocation(self, uniform_name);
    }

    /// Get shader attribute location
    pub fn getAttributeLocation(self: Shader, attrib_name: [:0]const u8) i32 {
        return GetShaderLocationAttrib(self, attrib_name);
    }

    /// Set shader uniform value
    pub fn setValue(
        self: Shader,
        location_index: i32,
        value: *const anyopaque,
        uniform_type: ShaderUniformDataType,
    ) void {
        SetShaderValue(self, location_index, value, uniform_type);
    }

    /// Set shader uniform value vector
    pub fn setValueV(
        self: Shader,
        location_index: i32,
        value: *const anyopaque,
        uniform_type: ShaderUniformDataType,
        count: i32,
    ) void {
        SetShaderValueV(self, location_index, value, uniform_type, count);
    }

    /// Set shader uniform value (matrix 4x4)
    pub fn setValueMatrix(
        self: Shader,
        location_index: i32,
        mat: Matrix,
    ) void {
        SetShaderValueMatrix(self, location_index, mat);
    }

    /// Set shader uniform value for texture (sampler2d)
    pub fn setValueTexture(
        self: Shader,
        location_index: i32,
        texture: Texture2D,
    ) void {
        SetShaderValueTexture(self, location_index, texture);
    }

    /// Unload shader from GPU memory (VRAM)
    pub fn unload(self: Shader) void {
        UnloadShader(self);
    }
};

extern "c" fn BeginShaderMode(shader: Shader) void;
extern "c" fn EndShaderMode() void;

extern "c" fn LoadShader(
    vsFileName: [*c]const u8,
    fsFileName: [*c]const u8,
) Shader;
extern "c" fn LoadShaderFromMemory(
    vsCode: [*c]const u8,
    fsCode: [*c]const u8,
) Shader;
extern "c" fn IsShaderReady(shader: Shader) bool;
extern "c" fn GetShaderLocation(
    shader: Shader,
    uniformName: [*c]const u8,
) c_int;
extern "c" fn GetShaderLocationAttrib(
    shader: Shader,
    attribName: [*c]const u8,
) c_int;
extern "c" fn SetShaderValue(
    shader: Shader,
    locIndex: c_int,
    value: *const anyopaque,
    uniformType: c_int,
) void;
extern "c" fn SetShaderValueV(
    shader: Shader,
    locIndex: c_int,
    value: *const anyopaque,
    uniformType: c_int,
    count: c_int,
) void;
extern "c" fn SetShaderValueMatrix(
    shader: Shader,
    locIndex: c_int,
    mat: Matrix,
) void;
extern "c" fn SetShaderValueTexture(
    shader: Shader,
    locIndex: c_int,
    texture: Texture2D,
) void;
extern "c" fn UnloadShader(shader: Shader) void;
