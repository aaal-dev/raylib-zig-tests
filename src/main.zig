const std = @import("std");
const raylib = @import("raylib");

const allocator = std.heap.c_allocator;

const ResourceManager = @import("resourcemanager.zig");
const ScreenManager = @import("screenmanager.zig");

pub fn main() !void {
    raylib.Config.setFlags(.{
        .vsync_hint = true,
        .window_resizable = true,
    });

    const screen_width = 800;
    const screen_height = 450;

    raylib.Window.init(screen_width, screen_height, "Test Window");
    defer raylib.Window.close();

    raylib.AudioDevice.init();
    defer raylib.AudioDevice.close();

    //const default_buffer_size = 4096;
    //raylib.AudioStream.setBufferSizeDefault(default_buffer_size);

    var resouce_manager = try ResourceManager.init(allocator);
    defer resouce_manager.deinit();

    const font = try resouce_manager.loadFont("resources/mecha.png");
    _ = font;

    var screen_manager = try ScreenManager.init(allocator);
    defer screen_manager.deinit();

    const logo_screen = @import("screens/logo_screen.zig").load();
    const logo_screen_index = try screen_manager.add(logo_screen);
    screen_manager.goto(logo_screen_index);

    const target_fps = 60;
    raylib.setTargetFPS(target_fps);

    while (!raylib.Window.shouldClose()) {
        raylib.beginDrawing();
        defer raylib.endDrawing();

        screen_manager.update(0.0);
        screen_manager.draw();
    }
}
