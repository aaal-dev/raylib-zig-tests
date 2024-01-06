pub const Config = struct {
    /// System/Window config flags
    /// NOTE: Every bit registers one state (use it with bit masks)
    /// By default all flags are set to 0
    pub const Flags = packed struct(u16) {
        _: bool = false, //0
        fullscreen_mode: bool = false, //2,
        window_resizable: bool = false, //4,
        window_undecorated: bool = false, //8,
        window_transparent: bool = false, //16,
        msaa_4x_hint: bool = false, //32,
        vsync_hint: bool = false, //64,
        window_hidden: bool = false, //128,
        window_always_run: bool = false, //256,
        window_minimized: bool = false, //512,
        window_maximized: bool = false, //1024,
        window_unfocused: bool = false, //2048,
        window_topmost: bool = false, //4096,
        window_highdpi: bool = false, //8192,
        window_mouse_passthrough: bool = false, //16384,
        interlaced_hint: bool = false, //65536,

        pub fn to_u16(self: Flags) u16 {
            return @bitCast(self);
        }
    };

    /// Setup init configuration flags (view FLAGS)
    pub fn setFlags(flags: Flags) void {
        SetConfigFlags(@as(c_uint, flags.to_u16()));
    }
};

extern "c" fn SetConfigFlags(flags: c_uint) void;
