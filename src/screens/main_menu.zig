const raylib = @import("raylib");
const sfxr = @import("../sfxrsound.zig");

const Screen = @import("../screen.zig");

const title_text1 = raylib.Text{ .text = "Title Screen" };
const title_text2 = raylib.Text{ .text = "Press 1 for options, 2 for game" };

var title1_size: raylib.Vec2(i32) = .{ .x = 0, .y = 0 };
var title_text1_size: i32 = 40;
var title_width1: i32 = 0;
var title_height1: i32 = 0;
var title_text2_size: i32 = 20;
var title_width2: i32 = 0;
var title_height2: i32 = 0;
var result: i32 = 0;

var done: bool = false;

var sfxr_coin: sfxr.SfxrSound = undefined;
var music: raylib.Music = undefined;
var coin: raylib.Sound = undefined;

pub fn load() Screen {
    return .{ .vtable = .{
        .init = init,
        .deinit = deinit,
        .update = update,
        .draw = draw,
        .isFinished = isFinished,
        .getValue = getValue,
    } };
}

fn init(_: *Screen) void {
    sfxr_coin = sfxr.genSound(.coin);

    music = raylib.Music.load("resources/ambient.ogg");
    music.setVolume(1.0);
    music.play();

    coin = raylib.Sound.load("resources/coin.wav");

    var size = title_text1.measureEx(
        raylib.Font.getDefault(),
        @floatFromInt(title_text1_size),
        1.0,
    );
    title1_size.init(@intFromFloat(size.x), @intFromFloat(size.y));
    title_width1 = @intFromFloat(size.x);
    title_height1 = @intFromFloat(size.y);

    size = title_text2.measureEx(
        raylib.Font.getDefault(),
        @floatFromInt(title_text2_size),
        1.0,
    );
    title_width2 = @intFromFloat(size.x);
    title_height2 = @intFromFloat(size.y);

    done = false;
    result = 0;
}

fn deinit(_: *Screen) void {}

fn update(_: *Screen, dt: f32) void {
    music.update();
    sfxr_coin.update(dt);

    if (raylib.KeyboardKey.key_one.isPressed()) {
        done = true; // OPTIONS
        //main.fx_coin.play();
        sfxr_coin.play();
    } else if (raylib.KeyboardKey.key_two.isPressed()) {
        result = 1; // GAME
        done = true;
        coin.play();
    }
}

fn draw(_: *Screen) void {
    raylib.clearBackground(raylib.Color.ray_white);
    var xpos = (raylib.Screen.getWidth() - title_width1) >> 1;
    var ypos = ((raylib.Screen.getHeight() - title_height1) >> 1) - title_height1;
    title_text1.draw(xpos, ypos, title_text1_size, raylib.Color.black);

    xpos = (raylib.Screen.getWidth() - title_width2) >> 1;
    ypos = (raylib.Screen.getHeight() - title_height2) >> 1;
    title_text2.draw(xpos, ypos, title_text2_size, raylib.Color.red);
}

fn isFinished(_: *Screen) bool {
    return done;
}

fn getValue(_: *Screen) i32 {
    return result;
}

test "basic compilation" {
    @import("std").testing.refAllDecls(@This());
}
