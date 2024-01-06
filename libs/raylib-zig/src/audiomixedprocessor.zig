pub const AudioCallback = struct {
    callback: c_type,

    pub const c_type = ?*const fn (?*anyopaque, c_uint) callconv(.C) void;

    /// Attach audio stream processor to the entire audio pipeline, receives
    /// the samples as <float>s
    pub fn attach(self: AudioCallback) void {
        AttachAudioMixedProcessor(self.callback);
    }

    /// Detach audio stream processor from the entire audio pipeline
    pub fn detach(self: AudioCallback) void {
        DetachAudioMixedProcessor(self.callback);
    }
};

extern "c" fn AttachAudioMixedProcessor(processor: AudioCallback.c_type) void;
extern "c" fn DetachAudioMixedProcessor(processor: AudioCallback.c_type) void;
