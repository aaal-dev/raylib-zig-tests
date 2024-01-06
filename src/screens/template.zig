const Screen = @import("../screen.zig").Screen;

pub fn load() Screen {
    return .{
        .init = init,
        .deinit = deinit,
        .update = update,
        .draw = draw,
        .isFinished = isFinished,
        .getValue = getValue,
    };
}

fn init() void {}

fn deinit() void {}

fn update() void {}

fn draw() void {}

fn isFinished() bool {
    return false;
}

fn getValue() i32 {
    return 0;
}
