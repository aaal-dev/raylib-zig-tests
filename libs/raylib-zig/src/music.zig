const AudioStream = @import("audiostream.zig").AudioStream;

pub const Music = extern struct {
    stream: AudioStream,
    frameCount: c_uint,
    looping: bool,
    ctxType: c_int,
    ctxData: ?*anyopaque,

    /// Load music stream from file
    pub fn load(file_name: [:0]const u8) Music {
        return LoadMusicStream(@ptrCast(file_name));
    }

    /// Load music stream from data
    pub fn fromMemory(
        file_type: [:0]const u8,
        data: []const u8,
        data_size: i32,
    ) Music {
        return LoadMusicStreamFromMemory(
            @ptrCast(file_type),
            @ptrCast(data),
            @intCast(data_size),
        );
    }

    /// Checks if a music stream is ready
    pub fn isReady(self: Music) bool {
        return IsMusicReady(self);
    }

    /// Unload music stream
    pub fn unload(self: Music) void {
        UnloadMusicStream(self);
    }

    /// Start music playing
    pub fn play(self: Music) void {
        PlayMusicStream(self);
    }

    /// Check if music is playing
    pub fn isPlaying(self: Music) bool {
        return IsMusicStreamPlaying(self);
    }

    /// Updates buffers for music streaming
    pub fn update(self: Music) void {
        UpdateMusicStream(self);
    }

    /// Stop music playing
    pub fn stop(self: Music) void {
        StopMusicStream(self);
    }

    /// Pause music playing
    pub fn pause(self: Music) void {
        PauseMusicStream(self);
    }

    /// Resume playing paused music
    pub fn doResume(self: Music) void {
        ResumeMusicStream(self);
    }

    /// Seek music to a position (in seconds)
    pub fn seek(self: Music, position: f32) void {
        SeekMusicStream(self, position);
    }

    /// Set volume for music (1.0 is max level)
    pub fn setVolume(self: Music, volume: f32) void {
        SetMusicVolume(self, volume);
    }

    /// Set pitch for a music (1.0 is base level)
    pub fn setPitch(self: Music, pitch: f32) void {
        SetMusicPitch(self, pitch);
    }

    /// Set pan for a music (0.5 is center)
    pub fn setPan(self: Music, pan: f32) void {
        SetMusicPan(self, pan);
    }

    /// Get music time length (in seconds)
    pub fn getTimeLangth(self: Music) f32 {
        return GetMusicTimeLength(self);
    }

    /// Get current music time played (in seconds)
    pub fn getTimePlayed(self: Music) f32 {
        return GetMusicTimePlayed(self);
    }
};

extern "c" fn LoadMusicStream(fileName: [*c]const u8) Music;
extern "c" fn LoadMusicStreamFromMemory(
    fileType: [*c]const u8,
    data: [*c]const u8,
    dataSize: c_int,
) Music;
extern "c" fn IsMusicReady(music: Music) bool;
extern "c" fn UnloadMusicStream(music: Music) void;
extern "c" fn PlayMusicStream(music: Music) void;
extern "c" fn IsMusicStreamPlaying(music: Music) bool;
extern "c" fn UpdateMusicStream(music: Music) void;
extern "c" fn StopMusicStream(music: Music) void;
extern "c" fn PauseMusicStream(music: Music) void;
extern "c" fn ResumeMusicStream(music: Music) void;
extern "c" fn SeekMusicStream(music: Music, position: f32) void;
extern "c" fn SetMusicVolume(music: Music, volume: f32) void;
extern "c" fn SetMusicPitch(music: Music, pitch: f32) void;
extern "c" fn SetMusicPan(music: Music, pan: f32) void;
extern "c" fn GetMusicTimeLength(music: Music) f32;
extern "c" fn GetMusicTimePlayed(music: Music) f32;
