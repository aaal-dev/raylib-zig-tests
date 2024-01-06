const AudioCallback = @import("audiomixedprocessor.zig").AudioCallback;

pub const AudioStream = extern struct {
    const AudioBuffer = opaque {};
    const AudioProcessor = opaque {};

    buffer: ?*AudioBuffer,
    processor: ?*AudioProcessor,
    sample_rate: c_uint,
    sample_size: c_uint,
    channels: c_uint,

    /// Load audio stream (to stream raw audio pcm data)
    pub fn load(
        sample_rate: u32,
        sample_size: u32,
        channels: u32,
    ) AudioStream {
        return LoadAudioStream(
            @as(c_uint, sample_rate),
            @as(c_uint, sample_size),
            @as(c_uint, channels),
        );
    }

    /// Checks if an audio stream is ready
    pub fn isReady(self: AudioStream) bool {
        return IsAudioStreamReady(self);
    }

    /// Unload audio stream and free memory
    pub fn unload(self: AudioStream) void {
        UnloadAudioStream(self);
    }

    /// Update audio stream buffers with data
    pub fn update(
        self: AudioStream,
        data: *const anyopaque,
        frame_count: i32,
    ) void {
        UpdateAudioStream(self, data, @as(c_int, frame_count));
    }

    /// Check if any audio stream buffers requires refill
    pub fn isProcessed(self: AudioStream) bool {
        return IsAudioStreamProcessed(self);
    }

    /// Play audio stream
    pub fn play(self: AudioStream) void {
        PlayAudioStream(self);
    }

    /// Pause audio stream
    pub fn pause(self: AudioStream) void {
        PauseAudioStream(self);
    }

    /// Resume audio stream
    pub fn doResume(self: AudioStream) void {
        ResumeAudioStream(self);
    }

    /// Check if audio stream is playing
    pub fn isPlaying(self: AudioStream) bool {
        return IsAudioStreamPlaying(self);
    }

    /// Stop audio stream
    pub fn stop(self: AudioStream) void {
        StopAudioStream(self);
    }

    /// Set volume for audio stream (1.0 is max level)
    pub fn setVolume(self: AudioStream, volume: f32) void {
        SetAudioStreamVolume(self, volume);
    }

    /// Set pitch for audio stream (1.0 is base level)
    pub fn setPitch(self: AudioStream, pitch: f32) void {
        SetAudioStreamPitch(self, pitch);
    }

    /// Set pan for audio stream (0.5 is centered)
    pub fn setPan(self: AudioStream, pan: f32) void {
        SetAudioStreamPan(self, pan);
    }

    /// Default size for new audio streams
    pub fn setBufferSizeDefault(size: i32) void {
        SetAudioStreamBufferSizeDefault(@as(c_int, size));
    }

    /// Audio thread callback to request new data
    pub fn setCallback(self: AudioStream, callback: AudioCallback) void {
        SetAudioStreamCallback(self, callback.callback);
    }

    /// Attach audio stream processor to stream, receives the samples as <float>s
    pub fn attachProcessor(self: AudioStream, processor: AudioCallback) void {
        AttachAudioStreamProcessor(self, processor.callback);
    }

    /// Detach audio stream processor from stream
    pub fn detachProcessor(self: AudioStream, processor: AudioCallback) void {
        DetachAudioStreamProcessor(self, processor.callback);
    }
};

extern "c" fn LoadAudioStream(
    sampleRate: c_uint,
    sampleSize: c_uint,
    channels: c_uint,
) AudioStream;
extern "c" fn IsAudioStreamReady(stream: AudioStream) bool;
extern "c" fn UnloadAudioStream(stream: AudioStream) void;
extern "c" fn UpdateAudioStream(
    stream: AudioStream,
    data: *const anyopaque,
    frameCount: c_int,
) void;
extern "c" fn IsAudioStreamProcessed(stream: AudioStream) bool;
extern "c" fn PlayAudioStream(stream: AudioStream) void;
extern "c" fn PauseAudioStream(stream: AudioStream) void;
extern "c" fn ResumeAudioStream(stream: AudioStream) void;
extern "c" fn IsAudioStreamPlaying(stream: AudioStream) bool;
extern "c" fn StopAudioStream(stream: AudioStream) void;
extern "c" fn SetAudioStreamVolume(stream: AudioStream, volume: f32) void;
extern "c" fn SetAudioStreamPitch(stream: AudioStream, pitch: f32) void;
extern "c" fn SetAudioStreamPan(stream: AudioStream, pan: f32) void;
extern "c" fn SetAudioStreamBufferSizeDefault(size: c_int) void;
extern "c" fn SetAudioStreamCallback(
    stream: AudioStream,
    callback: AudioCallback.c_type,
) void;
extern "c" fn AttachAudioStreamProcessor(
    stream: AudioStream,
    processor: AudioCallback.c_type,
) void;
extern "c" fn DetachAudioStreamProcessor(
    stream: AudioStream,
    processor: AudioCallback.c_type,
) void;
