pub const Wave = extern struct {
    frameCount: c_uint,
    sampleRate: c_uint,
    sampleSize: c_uint,
    channels: c_uint,
    data: ?*anyopaque,

    /// Load wave data from file
    pub fn load(filename: [:0]const u8) Wave {
        return LoadWave(filename);
    }

    /// Load wave from memory buffer,
    /// file_type refers to extension: i.e. '.wav'
    pub fn fromMemory(
        file_type: [:0]const u8,
        file_data: [:0]const u8,
        data_size: i32,
    ) Wave {
        return LoadWaveFromMemory(file_type, file_data, data_size);
    }

    /// Checks if wave data is ready
    pub fn isReady(self: Wave) bool {
        return IsWaveReady(self);
    }

    /// Unload wave data
    pub fn unload(self: Wave) void {
        UnloadWave(self);
    }

    /// Export wave data to file, returns true on success
    pub fn exportInFile(self: Wave, filename: [:0]const u8) bool {
        return ExportWave(self, filename);
    }

    /// Export wave sample data to code (.h), returns true on success
    pub fn exportAsCode(self: Wave, filename: [:0]const u8) bool {
        return ExportWaveAsCode(self, filename);
    }

    /// Copy a wave to a new wave
    pub fn copy(self: Wave) Wave {
        return WaveCopy(self);
    }

    /// Crop a wave to defined samples range
    pub fn crop(self: *Wave, init_sample: i32, final_sample: i32) void {
        WaveCrop(self, init_sample, final_sample);
    }

    /// Convert wave data to desired format
    pub fn format(
        self: *Wave,
        sample_rate: i32,
        sample_size: i32,
        channels: i32,
    ) void {
        WaveFormat(self, sample_rate, sample_size, channels);
    }

    /// Load samples data from wave as a 32bit float data array
    pub fn loadSamples(self: Wave) [*c]f32 {
        LoadWaveSamples(self);
    }

    /// Unload samples data loaded with LoadWaveSamples()
    pub fn unloadSamples(samples: [*c]f32) void {
        UnloadWaveSamples(samples);
    }
};

extern "c" fn LoadWave(fileName: [*c]const u8) Wave;
extern "c" fn LoadWaveFromMemory(
    fileType: [*c]const u8,
    fileData: [*c]const u8,
    dataSize: c_int,
) Wave;
extern "c" fn IsWaveReady(wave: Wave) bool;
extern "c" fn UnloadWave(wave: Wave) void;
extern "c" fn ExportWave(wave: Wave, fileName: [*c]const u8) bool;
extern "c" fn ExportWaveAsCode(wave: Wave, fileName: [*c]const u8) bool;
extern "c" fn WaveCopy(wave: Wave) Wave;
extern "c" fn WaveCrop(
    wave: [*c]Wave,
    initSample: c_int,
    finalSample: c_int,
) void;
extern "c" fn WaveFormat(
    wave: [*c]Wave,
    sampleRate: c_int,
    sampleSize: c_int,
    channels: c_int,
) void;
extern "c" fn LoadWaveSamples(wave: Wave) [*c]f32;
extern "c" fn UnloadWaveSamples(samples: [*c]f32) void;
