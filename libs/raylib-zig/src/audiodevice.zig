pub const AudioDevice = extern struct {
    /// Initialize audio device and context
    pub fn init() void {
        InitAudioDevice();
    }

    /// Close the audio device and context
    pub fn close() void {
        CloseAudioDevice();
    }

    /// Check if audio device has been initialized successfully
    pub fn isReady() bool {
        return IsAudioDeviceReady();
    }

    /// Set master volume (listener)
    pub fn setMasterVolume(volume: f32) void {
        SetMasterVolume(volume);
    }
};

extern "c" fn InitAudioDevice() void;
extern "c" fn CloseAudioDevice() void;
extern "c" fn IsAudioDeviceReady() bool;
extern "c" fn SetMasterVolume(volume: f32) void;
