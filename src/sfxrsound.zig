const std = @import("std");
const raylib = @import("raylib");
const sfxr = @import("sfxr");

const buffer_size = 4096;
const sample_rate = 44100;
const sample_size = 16; // (bits)
const channels = 1;

pub const SfxrSound = @This();

sound: sfxr.Sound,
stream: raylib.AudioStream,

pub fn init(sound_params: sfxr.SoundParams) SfxrSound {
    return .{
        .sound = sfxr.Sound.init(sound_params),
        .stream = raylib.AudioStream.load(
            sample_rate,
            sample_size,
            channels,
        ),
    };
}

pub fn deinit(self: *SfxrSound) void {
    self.stream.unload();
}

pub fn play(self: *SfxrSound) void {
    self.sound.play();
    self.stream.play();
}

pub fn update(self: *SfxrSound, delta_time: f32) void {
    _ = delta_time;
    if (self.stream.isProcessed()) {
        const buffer = self.sound.update();
        self.stream.update(buffer.data, buffer.frame_count);
    }
}

pub fn genSound(preset_type: sfxr.SoundPresetType) SfxrSound {
    const sound_params = sfxr.loadPreset(preset_type);
    return SfxrSound.init(sound_params);
}
