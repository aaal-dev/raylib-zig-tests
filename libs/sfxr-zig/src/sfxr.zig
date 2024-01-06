const std = @import("std");
const math = @import("math.zig");
const Random = @import("random.zig");

// --------------------------------------------------- sound parametrization --

var master_vol: f32 = 0.05;
var sound_vol: f32 = 0.5;

const WaveType = enum(u2) {
    square = 0,
    sawtooth = 1,
    sine = 2,
    noise = 3,
};

const EnvelopeStage = enum(u2) {
    attack = 0,
    decay = 1,
    release = 2,
};

pub const SoundParams = struct {
    wave_type: WaveType = .square,

    env_attack: f32 = 0.0,
    env_decay: f32 = 0.3,
    env_sustain_vol: f32 = 0.0,
    env_release: f32 = 0.4,

    base_freq: f32 = 0.3,
    freq_limit: f32 = 0.0,
    freq_ramp: f32 = 0.0,
    freq_dramp: f32 = 0.0,

    vib_strength: f32 = 0.0,
    vib_speed: f32 = 0.0,
    vib_delay: f32 = 0.0,

    arp_speed: f32 = 0.0,
    arp_mod: f32 = 0.0,

    duty: f32 = 0.0,
    duty_ramp: f32 = 0.0,

    repeat_speed: f32 = 0.0,

    pha_offset: f32 = 0.0,
    pha_ramp: f32 = 0.0,

    filter_on: bool = false,
    lpf_resonance: f32 = 0.0,
    lpf_freq: f32 = 1.0,
    lpf_ramp: f32 = 0.0,
    hpf_freq: f32 = 0.0,
    hpf_ramp: f32 = 0.0,

    pub fn reset(self: *SoundParams) void {
        self.* = .{};
    }

    pub fn randomize(self: *SoundParams) void {
        var random = Random.init(0x1234567);
        self.base_freq = math.powByTwo(f32, random.float(f32, 2.0) - 1.0);

        if (random.boolean()) {
            self.base_freq = math.pow(f32, random.float(f32, 2.0) - 1.0, 3.0) + 0.5;
        }

        self.freq_limit = 0.0;
        self.freq_ramp = math.pow(f32, random.float(f32, 2.0) - 1.0, 5.0);

        if (self.base_freq > 0.7 and self.freq_ramp > 0.2) {
            self.freq_ramp = -self.freq_ramp;
        }

        if (self.base_freq < 0.2 and self.freq_ramp < -0.05) {
            self.freq_ramp = -self.freq_ramp;
        }

        self.freq_dramp = math.pow(f32, random.float(f32, 2.0) - 1.0, 3.0);

        self.duty = random.float(f32, 2.0) - 1.0;
        self.duty_ramp = math.pow(f32, random.float(f32, 2.0) - 1.0, 3.0);

        self.vib_strength = math.pow(f32, random.float(f32, 2.0) - 1.0, 3.0);
        self.vib_speed = random.float(f32, 2.0) - 1.0;
        self.vib_delay = random.float(f32, 2.0) - 1.0;

        self.env_attack = math.pow(f32, random.float(f32, 2.0) - 1.0, 3.0);
        self.env_decay = math.powByTwo(f32, random.float(f32, 2.0) - 1.0);
        self.env_sustain_vol = math.powByTwo(f32, random.float(f32, 0.8));
        self.env_release = random.float(f32, 2.0) - 1.0;

        if (self.env_attack + self.env_decay + self.env_release < 0.2) {
            self.env_decay += 0.2 + random.float(f32, 0.3);
            self.env_release += 0.2 + random.float(f32, 0.3);
        }

        self.lpf_resonance = random.float(f32, 2.0) - 1.0;
        self.lpf_freq = 1.0 - math.pow(f32, random.float(f32, 1.0), 3.0);
        self.lpf_ramp = math.pow(f32, random.float(f32, 2.0) - 1.0, 3.0);

        if (self.lpf_freq < 0.1 and self.lpf_ramp < -0.05) {
            self.lpf_ramp = -self.lpf_ramp;
        }

        self.hpf_freq = math.pow(f32, random.float(f32, 1.0), 5.0);
        self.hpf_ramp = math.pow(f32, random.float(f32, 2.0) - 1.0, 5.0);

        self.pha_offset = math.pow(f32, random.float(f32, 2.0) - 1.0, 3.0);
        self.pha_ramp = math.pow(f32, random.float(f32, 2.0) - 1.0, 3.0);

        self.repeat_speed = random.float(f32, 2.0) - 1.0;
        self.arp_speed = random.float(f32, 2.0) - 1.0;
        self.arp_mod = random.float(f32, 2.0) - 1.0;
    }

    pub fn mutate(self: *SoundParams) void {
        self.base_freq += fmutation();
        // self.freq_limit += fmutation();
        self.freq_ramp += fmutation();
        self.freq_dramp += fmutation();

        self.duty += fmutation();
        self.duty_ramp += fmutation();

        self.vib_strength += fmutation();
        self.vib_speed += fmutation();
        self.vib_delay += fmutation();

        self.env_attack += fmutation();
        self.env_decay += fmutation();
        self.env_sustain_vol += fmutation();
        self.env_release += fmutation();

        self.lpf_resonance += fmutation();
        self.lpf_freq += fmutation();
        self.lpf_ramp += fmutation();

        self.hpf_freq += fmutation();
        self.hpf_ramp += fmutation();

        self.pha_offset += fmutation();
        self.pha_ramp += fmutation();

        self.repeat_speed += fmutation();

        self.arp_speed += fmutation();
        self.arp_mod += fmutation();
    }

    fn fmutation() f32 {
        var random = Random.init(0x1234567);
        return if (random.boolean()) {
            random.float(f32, 0.1) - 0.05;
        } else 0.0;
    }
};

// -------------------------------------------------------- sound generation --
pub const SoundPresetType = enum(u3) {
    coin = 0,
    shoot = 1,
    explosion = 2,
    powerup = 3,
    hit = 4,
    jump = 5,
    select = 6,
};

pub fn loadPreset(preset_type: SoundPresetType) SoundParams {
    return switch (preset_type) {
        .coin => genCoin(),
        .shoot => genShoot(),
        .explosion => genExplosion(),
        .powerup => genPowerUp(),
        .hit => genHit(),
        .jump => genJump(),
        .select => genSelect(),
    };
}

pub fn genCoin() SoundParams {
    var random = Random.init(0x1234567);
    var params = SoundParams{};

    params.base_freq = 0.4 + random.float(f32, 0.5);
    params.env_decay = random.float(f32, 0.1);
    params.env_sustain_vol = 0.3 + random.float(f32, 0.3);
    params.env_release = 0.1 + random.float(f32, 0.4);

    if (random.boolean()) {
        params.arp_speed = 0.5 + random.float(f32, 0.2);
        params.arp_mod = 0.2 + random.float(f32, 0.4);
    }

    return params;
}

pub fn genShoot() SoundParams {
    var random = Random.init(0x1234567);
    var params = SoundParams{};

    params.wave_type = @enumFromInt(random.integer(i32, 2));
    if (params.wave_type == .sine and random.boolean()) {
        params.wave_type = @enumFromInt(random.integer(i32, 1));
    }

    params.base_freq = 0.5 + random.float(f32, 0.5);
    params.freq_limit = params.base_freq - 0.2 - random.float(f32, 0.6);
    if (params.freq_limit < 0.2) {
        params.freq_limit = 0.2;
    }

    params.freq_ramp = -0.15 - random.float(f32, 0.2);

    if (random.integer(i32, 2) == 0) {
        params.base_freq = 0.3 + random.float(f32, 0.6);
        params.freq_limit = random.float(f32, 0.1);
        params.freq_ramp = -0.35 - random.float(f32, 0.3);
    }

    if (random.boolean()) {
        params.duty = random.float(f32, 0.5);
        params.duty_ramp = random.float(f32, 0.2);
    } else {
        params.duty = 0.4 + random.float(f32, 0.5);
        params.duty_ramp = -random.float(f32, 0.7);
    }

    params.env_decay = 0.1 + random.float(f32, 0.2);
    params.env_release = random.float(f32, 0.4);

    if (random.boolean()) {
        params.env_sustain_vol = random.float(f32, 0.3);
    }

    if (random.integer(i32, 2) == 0) {
        params.pha_offset = random.float(f32, 0.2);
        params.pha_ramp = -random.float(f32, 0.2);
    }

    // if (random.boolean()) {
    params.hpf_freq = random.float(f32, 0.3);
    // }

    return params;
}

pub fn genExplosion() SoundParams {
    var random = Random.init(0x1234567);
    var params = SoundParams{};

    params.wave_type = .noise;

    if (random.boolean()) {
        params.base_freq = 0.1 + random.float(f32, 0.4);
        params.freq_ramp = -0.1 + random.float(f32, 0.4);
    } else {
        params.base_freq = 0.2 + random.float(f32, 0.7);
        params.freq_ramp = -0.2 - random.float(f32, 0.2);
    }

    params.base_freq *= params.base_freq;

    if (random.integer(i32, 4) == 0) {
        params.freq_ramp = 0.0;
    }

    if (random.integer(i32, 2) == 0) {
        params.repeat_speed = 0.3 + random.float(f32, 0.5);
    }

    params.env_decay = 0.1 + random.float(f32, 0.3);
    params.env_release = random.float(f32, 0.5);
    params.env_sustain_vol = 0.2 + random.float(f32, 0.6);

    if (random.boolean()) {
        params.pha_offset = -0.3 + random.float(f32, 0.9);
        params.pha_ramp = -random.float(f32, 0.3);
    }

    if (random.boolean()) {
        params.vib_strength = random.float(f32, 0.7);
        params.vib_speed = random.float(f32, 0.6);
    }

    if (random.integer(i32, 2) == 0) {
        params.arp_speed = 0.6 + random.float(f32, 0.3);
        params.arp_mod = 0.8 - random.float(f32, 1.6);
    }

    return params;
}

pub fn genPowerUp() SoundParams {
    var random = Random.init(0x1234567);
    var params = SoundParams{};

    if (random.boolean()) {
        params.wave_type = .sawtooth;
    } else {
        params.duty = random.float(f32, 0.6);
    }

    if (random.boolean()) {
        params.base_freq = 0.2 + random.float(f32, 0.3);
        params.freq_ramp = 0.1 + random.float(f32, 0.4);
        params.repeat_speed = 0.4 + random.float(f32, 0.4);
    } else {
        params.base_freq = 0.2 + random.float(f32, 0.3);
        params.freq_ramp = 0.05 + random.float(f32, 0.2);

        if (random.boolean()) {
            params.vib_strength = random.float(f32, 0.7);
            params.vib_speed = random.float(f32, 0.6);
        }
    }

    params.env_decay = random.float(f32, 0.4);
    params.env_release = 0.1 + random.float(f32, 0.4);

    return params;
}

pub fn genHit() SoundParams {
    var random = Random.init(0x1234567);
    var params = SoundParams{};

    params.wave_type = @enumFromInt(random.integer(i32, 2));

    if (params.wave_type == .sine) {
        params.wave_type = .noise;
    }

    if (params.wave_type == .square) {
        params.duty = random.float(f32, 0.6);
    }

    params.base_freq = 0.2 + random.float(f32, 0.6);
    params.freq_ramp = -0.3 - random.float(f32, 0.4);
    params.env_decay = random.float(f32, 0.1);
    params.env_release = 0.1 + random.float(f32, 0.2);

    if (random.boolean()) {
        params.hpf_freq = random.float(f32, 0.3);
    }

    return params;
}

pub fn genJump() SoundParams {
    var random = Random.init(0x1234567);
    var params = SoundParams{};

    params.duty = random.float(f32, 0.6);
    params.base_freq = 0.3 + random.float(f32, 0.3);
    params.freq_ramp = 0.1 + random.float(f32, 0.2);
    params.env_decay = 0.1 + random.float(f32, 0.3);
    params.env_release = 0.1 + random.float(f32, 0.2);

    if (random.boolean()) {
        params.hpf_freq = random.float(f32, 0.3);
    }

    if (random.boolean()) {
        params.lpf_freq = 1.0 - random.float(f32, 0.6);
    }

    return params;
}

pub fn genSelect() SoundParams {
    var random = Random.init(0x1234567);
    var params = SoundParams{};

    params.wave_type = @enumFromInt(random.integer(i32, 1));

    params.base_freq = 0.2 + random.float(f32, 0.4);

    if (params.wave_type == .square) {
        params.duty = random.float(f32, 0.6);
    }
    params.env_decay = 0.1 + random.float(f32, 0.1);
    params.env_release = random.float(f32, 0.2);
    params.hpf_freq = 0.1;

    return params;
}

// -------------------------------------------------------- sound processing --

const SoundProcessorParams = struct {
    on_play: bool = false,
    phase: i32 = 0,
    fperiod: f64 = 0,
    fperiod_max: f64 = 0,
    fslide: f64 = 0,
    fdslide: f64 = 0,
    period: i32 = 0,
    square_duty: f32 = 0,
    square_slide: f32 = 0,
    env_stage: EnvelopeStage = .attack,
    env_time: i32 = 0,
    env_attack: i32 = 0,
    env_decay: i32 = 0,
    env_sustain_vol: f32 = 0,
    env_release: i32 = 0,
    env_vol: f32 = 0,
    fphase: f32 = 0,
    fdphase: f32 = 0,
    iphase: i32 = 0,
    phaser_buffer: [1024]f32 = undefined,
    ipp: i32 = 0,
    noise_buffer: [32]f32 = undefined,
    fltp: f32 = 0,
    fltdp: f32 = 0,
    fltw: f32 = 0,
    fltw_d: f32 = 0,
    fltdmp: f32 = 0,
    fltphp: f32 = 0,
    flthp: f32 = 0,
    flthp_d: f32 = 0,
    vib_phase: f32 = 0,
    vib_speed: f32 = 0,
    vib_amp: f32 = 0,
    rep_time: i32 = 0,
    rep_limit: i32 = 0,
    arp_time: i32 = 0,
    arp_limit: i32 = 0,
    arp_mod: f64 = 0,

    pub fn init(params: SoundParams) SoundProcessorParams {
        var random = Random.init(0x1234567);
        var self = SoundProcessorParams{};

        self.fperiod = 100.0 / (math.powByTwo(f32, params.base_freq) + 0.001);

        self.period = @intFromFloat(self.fperiod);

        self.fperiod_max = 100.0 / (math.powByTwo(f32, params.freq_limit) + 0.001);

        self.fslide = 1.0 - math.pow(f32, params.freq_ramp, 3.0) * 0.01;
        self.fdslide = -math.pow(f32, params.freq_dramp, 3.0) * 0.000001;

        self.square_duty = 0.5 - params.duty * 0.5;
        self.square_slide = -params.duty_ramp * 0.00005;

        self.arp_mod = if (0.0 <= params.arp_mod)
            1.0 - math.powByTwo(f32, params.arp_mod) * 0.9
        else
            1.0 - math.powByTwo(f32, params.arp_mod) * 10.0;

        self.arp_limit = if (params.arp_speed == 1.0)
            0.0
        else
            @intFromFloat(math.powByTwo(f32, 1.0 - params.arp_speed) * 20000 + 32);

        // ------------------------------------------------------------------------

        // reset filter
        self.fltw = math.pow(f32, params.lpf_freq, 3.0) * 0.1;
        self.fltw_d = 1.0 + params.lpf_ramp * 0.0001;
        self.fltdmp = 5.0 / (1.0 + math.powByTwo(f32, params.lpf_resonance) * 20.0) * (0.01 + self.fltw);

        if (self.fltdmp > 0.8) {
            self.fltdmp = 0.8;
        }

        self.flthp = math.pow(f32, params.hpf_freq, 2.0) * 0.1;
        self.flthp_d = 1.0 + params.hpf_ramp * 0.0003;

        // reset vibrato
        self.vib_speed = math.powByTwo(f32, params.vib_speed) * 0.01;
        self.vib_amp = params.vib_strength * 0.5;

        // reset envelope
        self.env_attack = @intFromFloat(math.powByTwo(f32, params.env_attack) * 100000.0);
        self.env_decay = @intFromFloat(math.powByTwo(f32, params.env_decay) * 100000.0);
        self.env_sustain_vol = params.env_sustain_vol;
        self.env_release = @intFromFloat(math.powByTwo(f32, params.env_release) * 100000.0);

        self.fphase = math.powByTwo(f32, params.pha_offset) * 1020.0;

        if (params.pha_offset < 0.0) {
            self.fphase = -self.fphase;
        }

        self.fdphase = math.powByTwo(f32, params.pha_ramp) * 1.0;

        if (params.pha_ramp < 0.0) {
            self.fdphase = -self.fdphase;
        }

        self.iphase = @intFromFloat(std.math.fabs(self.fphase));

        @memset(self.phaser_buffer[0..], 0);

        @setEvalBranchQuota(2000);
        inline for (0..32) |buffer_index| {
            self.noise_buffer[buffer_index] = random.float(f32, 2) - 1;
        }

        self.rep_limit = if (params.repeat_speed == 0.0)
            0.0
        else
            @intFromFloat(math.powByTwo(f32, 1.0 - params.repeat_speed) * 20000 + 32);

        return self;
    }
};

pub const Sound = struct {
    defaults: SoundProcessorParams,
    processed: SoundProcessorParams,

    pub fn init(sound_params: SoundParams) Sound {
        const processor_params = SoundProcessorParams.init(sound_params);
        return .{
            .defaults = processor_params,
            .processed = processor_params,
        };
    }

    pub fn play(self: *Sound) void {
        self.*.defaults = self.*.processed;
    }

    pub fn reset(self: *Sound) void {
        self.processed.fperiod = self.defaults.fperiod;
        self.processed.period = self.defaults.period;
        self.processed.fperiod_max = self.defaults.fperiod_max;
        self.processed.fslide = self.defaults.fslide;
        self.processed.fdslide = self.defaults.fdslide;
        self.processed.square_duty = self.defaults.square_duty;
        self.processed.square_slide = self.defaults.square_slide;
        self.processed.arp_mod = self.defaults.arp_mod;
        self.processed.arp_limit = self.defaults.arp_limit;
    }

    pub fn update(self: *Sound) SoundBuffer {
        var sound: *SoundProcessorParams = &(self.processed);

        var buffer = SoundBuffer{
            .data = undefined,
            .frame_count = sound.rep_time, // FIXME
        };

        for (buffer.data, 0..@as(usize, @intCast(buffer.frame_count))) |*frame, i| {
            sound.rep_time += 1;

            if (sound.rep_limit != 0 and sound.rep_time >= sound.rep_limit) {
                sound.rep_time = 0;
                self.reset();
            }

            // frequency envelopes/arpeggios
            sound.arp_time += 1;

            if (sound.arp_limit != 0 and sound.arp_time >= sound.arp_limit) {
                sound.arp_limit = 0;
                sound.fperiod *= sound.arp_mod;
            }

            sound.fslide += sound.fdslide;
            sound.fperiod *= sound.fslide;

            if (sound.fperiod > sound.fperiod_max) {
                sound.fperiod = sound.fperiod_max;

                if (sound.fperiod_max > 0.0) {
                    if (sound.looping) {
                        self.resetParams();
                    } else {
                        sound.playing_sample = false;
                        buffer.frame_count = i;
                        return buffer;
                    }
                }
            }

            var rfperiod = sound.fperiod;

            if (sound.vib_amp > 0.0) {
                sound.vib_phase += sound.vib_speed;
                rfperiod = (sound.fperiod * (1.0 + std.math.sin(sound.vib_phase) * sound.vib_amp));
            }

            sound.period = @intFromFloat(rfperiod);

            if (sound.period < 8) {
                sound.period = 8;
            }

            sound.square_duty += sound.square_slide;

            if (sound.square_duty < 0.0) {
                sound.square_duty = 0.0;
            }

            if (sound.square_duty > 0.5) {
                sound.square_duty = 0.5;
            }

            // volume envelope
            sound.env_time += 1;

            const fenv_time: f32 = @floatFromInt(sound.env_time);

            switch (sound.env_stage) {
                .attack => {
                    if (sound.env_time > sound.env_attack) {
                        sound.env_time = 0;
                        sound.env_stage = .decay;
                    }

                    const fenv_length: f32 = @floatFromInt(sound.env_attack);
                    const fenv_delta = fenv_time / fenv_length;
                    sound.env_vol = fenv_delta;
                },
                .decay => {
                    if (sound.env_time > sound.env_decay) {
                        sound.env_time = 0;
                        sound.env_stage = .release;
                    }

                    const fenv_length: f32 = @floatFromInt(sound.env_attack);
                    const fenv_delta = fenv_time / fenv_length;
                    sound.env_vol = 1.0 + math.pow(f32, 1.0 - fenv_delta, 1.0) * 2.0 * sound.env_sustain_vol;
                },
                .release => {
                    if (sound.env_time > sound.env_release) {
                        sound.env_time = 0;
                    }

                    if (sound.looping) {
                        self.reset();
                    } else {
                        sound.playing_sample = false;
                        buffer.frame_count = i;
                        return buffer;
                    }
                    const fenv_length: f32 = @floatFromInt(sound.env_attack);
                    const fenv_delta = fenv_time / fenv_length;
                    sound.env_vol = 1.0 - fenv_delta;
                },
            }

            // phaser step
            sound.fphase += sound.fdphase;
            sound.iphase = @intFromFloat(std.math.fabs(sound.fphase));

            if (sound.iphase > 1023) {
                sound.iphase = 1023;
            }

            if (sound.flthp_d != 0.0) {
                sound.flthp *= sound.flthp_d;

                if (sound.flthp < 0.00001) {
                    sound.flthp = 0.00001;
                }

                if (sound.flthp > 0.1) {
                    sound.flthp = 0.1;
                }
            }

            // supersampling
            var ssample: f32 = 0.0;
            for (0..8) |ii| {
                _ = ii; // 8x supersampling
                var sample: f32 = 0.0;
                sound.phase += 1;

                if (sound.phase >= sound.period) {
                    sound.phase = @mod(sound.phase, sound.period);

                    if (sound.wave_type == 3) {
                        var random = Random.init(0x1234567);

                        inline for (0..32) |index| {
                            sound.noise_buffer[index] = random.float(f32, 2.0) - 1.0;
                        }
                    }
                }

                // base waveform
                const fphase: f32 = @floatFromInt(sound.phase);
                const fperiod: f32 = @floatFromInt(sound.period);
                var fp = fphase / fperiod;
                switch (sound.wave_type) {
                    .square => {
                        // square
                        if (fp < sound.square_duty) {
                            sample = 0.5;
                        } else {
                            sample = -0.5;
                        }
                    },
                    .sawtooth => {
                        // sawtooth
                        sample = 1.0 - fp * 2;
                    },
                    .sine => {
                        // sine
                        sample = std.math.sin(fp * 2 * std.math.pi);
                    },
                    .noise => {
                        // noise
                        const index = @divTrunc(sound.phase * 32, sound.period);
                        sample = sound.noise_buffer[@intCast(index)];
                    },
                    else => {},
                }

                // lp filter
                var pp = sound.fltp;
                sound.fltw *= sound.fltw_d;
                if (sound.fltw < 0.0) sound.fltw = 0.0;
                if (sound.fltw > 0.1) sound.fltw = 0.1;
                if (sound.lpf_freq != 1.0) {
                    sound.fltdp += (sample - sound.fltp) * sound.fltw;
                    sound.fltdp -= sound.fltdp * sound.fltdmp;
                } else {
                    sound.fltp = sample;
                    sound.fltdp = 0.0;
                }
                sound.fltp += sound.fltdp;

                // hp filter
                sound.fltphp += sound.fltp - pp;
                sound.fltphp -= sound.fltphp * sound.flthp;
                sample = sound.fltphp;

                // phaser
                sound.phaser_buffer[@intCast(sound.ipp & 1023)] = sample;

                const index: i32 = @intCast((sound.ipp - sound.iphase + 1024) & 1023);
                sample += sound.phaser_buffer[index];
                sound.ipp = (sound.ipp + 1) & 1023;
                // final accumulation and envelope application
                ssample += sample * sound.env_vol;
            }
            ssample = ssample / 8 * sound.master_vol;
            ssample *= 2.0 * sound.sound_vol;

            frame.* = std.math.clamp(ssample, -1, 1);
        }
        // buffer.frame_count FIXME calculate frame count
        return buffer;
    }
};

pub const SoundBuffer = struct {
    data: []u8,
    frame_count: i32,
};
