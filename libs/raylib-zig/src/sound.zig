const AudioStream = @import("audiostream.zig").AudioStream;
const Wave = @import("wave.zig").Wave;
pub const Sound = extern struct {
    stream: AudioStream,
    frameCount: c_uint,

    /// Load sound from file
    pub fn load(filename: [:0]const u8) Sound {
        return LoadSound(@ptrCast(filename));
    }

    /// Load sound from wave data
    pub fn fromWave(wave: Wave) Sound {
        return LoadSoundFromWave(wave);
    }

    /// Checks if a sound is ready
    pub fn isReady(self: Sound) bool {
        return IsSoundReady(self);
    }

    /// Update sound buffer with new data
    pub fn update(
        self: Sound,
        data: *const anyopaque,
        sample_count: i32,
    ) void {
        UpdateSound(self, data, @as(c_int, sample_count));
    }

    /// Unload sound
    pub fn unload(self: Sound) void {
        UnloadSound(self);
    }

    /// Play a sound
    pub fn play(self: Sound) void {
        PlaySound(self);
    }

    /// Stop playing a sound
    pub fn stop(self: Sound) void {
        StopSound(self);
    }

    /// Pause a sound
    pub fn pause(self: Sound) void {
        PauseSound(self);
    }

    /// Resume a paused sound
    pub fn doResume(self: Sound) void {
        ResumeSound(self);
    }

    pub fn playMulti(self: Sound) void {
        PlaySoundMulti(self);
    }

    pub fn stopMulti(_: Sound) void {
        StopSoundMulti();
    }

    pub fn getPlayngCount() i32 {
        return @as(i32, GetSoundsPlaying());
    }

    /// Check if a sound is currently playing
    pub fn isPlaying(self: Sound) bool {
        return IsSoundPlaying(self);
    }

    /// Set volume for a sound (1.0 is max level)
    pub fn setVolume(self: Sound, volume: f32) void {
        SetSoundVolume(self, volume);
    }

    /// Set pitch for a sound (1.0 is base level)
    pub fn setPitch(self: Sound, pitch: f32) void {
        SetSoundPitch(self, pitch);
    }

    /// Set pan for a sound (0.5 is center)
    pub fn setPan(self: Sound, pan: f32) void {
        SetSoundPan(self, pan);
    }
};

extern "c" fn LoadSound(fileName: [*c]const u8) Sound;
extern "c" fn LoadSoundFromWave(wave: Wave) Sound;
extern "c" fn IsSoundReady(sound: Sound) bool;
extern "c" fn UpdateSound(
    sound: Sound,
    data: *const anyopaque,
    sampleCount: c_int,
) void;
extern "c" fn UnloadSound(sound: Sound) void;
extern "c" fn PlaySound(sound: Sound) void;
extern "c" fn StopSound(sound: Sound) void;
extern "c" fn PauseSound(sound: Sound) void;
extern "c" fn ResumeSound(sound: Sound) void;
extern "c" fn PlaySoundMulti(sound: Sound) void;
extern "c" fn StopSoundMulti() void;
extern "c" fn GetSoundsPlaying() c_int;
extern "c" fn IsSoundPlaying(sound: Sound) bool;
extern "c" fn SetSoundVolume(sound: Sound, volume: f32) void;
extern "c" fn SetSoundPitch(sound: Sound, pitch: f32) void;
extern "c" fn SetSoundPan(sound: Sound, pan: f32) void;
