const raylib = @import("raylib");
const Screen = @import("../screen.zig");
const ResourceManager = @import("../resourcemanager.zig").ResourceManager;

pub fn load() Screen {
    return .{ .vtable = .{
        .init = LogoScreen.init,
        .deinit = LogoScreen.deinit,
        .update = LogoScreen.update,
        .draw = LogoScreen.draw,
        .isFinished = LogoScreen.isFinished,
        .getValue = LogoScreen.getValue,
    } };
}

const LogoScreen = struct {
    const logo_text = raylib.Text{ .text = "Logo Screen" };

    var alpha: f32 = 0.0;
    var logo_text_size: i32 = 40;
    var logo_width: i32 = 0;
    var logo_height: i32 = 0;

    var alpha_going_up: bool = true;
    var done: bool = false;

    fn init(_: *Screen) void {
        var logo_size = logo_text.measureEx(
            raylib.Font.getDefault(),
            @floatFromInt(logo_text_size),
            1.0,
        );
        logo_width = @intFromFloat(logo_size.x);
        logo_height = @intFromFloat(logo_size.y);
        done = false;
    }

    fn deinit(_: *Screen) void {}

    fn update(self: *Screen, _: f32) void {
        if (alpha_going_up) {
            alpha += 0.01;
            if (alpha > 1.0) {
                alpha_going_up = false;
                alpha = 1.0;
            }
        } else {
            alpha -= 0.01;
            if (alpha < 0.0) {
                done = true;
                alpha = 0.0;
                const main_menu = @import("main_menu.zig").load();
                const index = self.manager.?.add(main_menu) catch {
                    @panic("OOM");
                };
                self.manager.?.goto(index);
            }
        }
    }

    fn draw(_: *Screen) void {
        raylib.clearBackground(raylib.Color.ray_white);
        var xpos = (raylib.Screen.getWidth() - logo_width) >> 1;
        var ypos = (raylib.Screen.getHeight() - logo_height) >> 1;
        logo_text.draw(
            xpos,
            ypos,
            logo_text_size,
            raylib.Color.black.fade(alpha),
        );
    }

    fn isFinished(_: *Screen) bool {
        return done;
    }

    fn getValue(_: *Screen) i32 {
        return 0;
    }
};
