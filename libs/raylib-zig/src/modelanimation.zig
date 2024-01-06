const BoneInfo = @import("boneinfo.zig").BoneInfo;
const Transform = @import("transform.zig").Transform;

pub const ModelAnimation = extern struct {
    boneCount: c_int,
    frameCount: c_int,
    bones: [*c]BoneInfo,
    framePoses: [*c][*c]Transform,

    /// Unload animation data
    pub fn unload(self: ModelAnimation) void {
        UnloadModelAnimation(self);
    }
};

extern "c" fn UnloadModelAnimation(anim: ModelAnimation) void;
