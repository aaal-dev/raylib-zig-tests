pub const Log = struct {
    /// Trace log level
    /// NOTE: Organized by priority level
    pub const Level = enum(c_int) {
        log_all = 0,
        log_trace = 1,
        log_debug = 2,
        log_info = 3,
        log_warning = 4,
        log_error = 5,
        log_fatal = 6,
        log_none = 7,
    };

    /// Show trace log messages
    /// (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
    pub fn write(logLevel: Level, text: [:0]const u8) void {
        TraceLog(logLevel, @as([*c]const u8, @ptrCast(text)));
    }

    /// Set the current threshold (minimum) log level
    pub fn setLevel(logLevel: Level) void {
        SetTraceLogLevel(logLevel);
    }
};

extern "c" fn TraceLog(logLevel: c_int, text: [*c]const u8, ...) void;
extern "c" fn SetTraceLogLevel(logLevel: c_int) void;
