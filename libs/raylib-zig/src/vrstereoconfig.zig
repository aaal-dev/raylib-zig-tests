const Matrix = @import("matrix.zig").Matrix;
const VrDeviceInfo = @import("vrdeviceinfo.zig").VrDeviceInfo;

/// VrStereoConfig, VR stereo rendering configuration for simulator
pub const VrStereoConfig = extern struct {
    projection: [2]Matrix,
    viewOffset: [2]Matrix,
    leftLensCenter: [2]f32,
    rightLensCenter: [2]f32,
    leftScreenCenter: [2]f32,
    rightScreenCenter: [2]f32,
    scale: [2]f32,
    scaleIn: [2]f32,

    /// Load VR stereo config for VR simulator device parameters
    pub fn load(config: VrDeviceInfo) VrStereoConfig {
        return LoadVrStereoConfig(config);
    }

    /// Unload VR stereo config
    pub fn unload(self: VrStereoConfig) void {
        UnloadVrStereoConfig(self);
    }
};

extern "c" fn LoadVrStereoConfig(device: VrDeviceInfo) VrStereoConfig;
extern "c" fn UnloadVrStereoConfig(config: VrStereoConfig) void;
