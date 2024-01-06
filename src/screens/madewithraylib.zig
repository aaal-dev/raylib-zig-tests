const raylib = @import("raylib");
const Screen = @import("../screen.zig").Screen;

var done = false;
var result = 0;

const LOG_INFO = raylib.Log.Level.log_info;

const raylib_text_size = -1;
const MWR_font_size = 30;
const MWR_padding = 8;
const made_with_text = raylib.Text{ .text = "made with" };
const raylib_text = raylib.Text{ .text = "raylib" };

var badge: raylib.RenderTexture2D = undefined;
var init_completed = false;

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

fn init() void {
    raylib.Log.write(LOG_INFO, "MWR: Initializing badge...");

    if (raylib_text_size == -1) {
        raylib_text_size = raylib_text.measure(MWR_font_size);
    }

    badge = raylib.RenderTexture.load(
        raylib_text_size + MWR_padding * 2,
        MWR_font_size + MWR_padding * 2,
    );

    init_completed = true;

    raylib.Log.write(LOG_INFO, "MWR: Finished initialized badge.");
}

fn deinit() void {
    if (!init_completed) {
        raylib.Log.write(LOG_INFO, "MWR: Badge hasn't been initialized.");
        return;
    }

    raylib.Log.write(LOG_INFO, "MWR: Destroying badge...");

    badge.unload();

    init_completed = false;

    raylib.Log.write(LOG_INFO, "MWR: Finished destroying badge.");

}

fn update() void {}

fn draw() void {
    if (!init_completed) {
        raylib.Log.write(LOG_INFO, "MWR: The badge isn't initialized.");
        return;
    }

    var width: f32 = (raylib_text_size + MWR_padding * 2) * scale;
    var height: f32 = (MWR_font_size + MWR_padding * 2) * scale;

    var actualRect = raylib.Rectangle{
        .x = pos.x,
        .y = pos.y,
        .width = width,
        .height = height,
    };

    if (center) {
        actualRect.x -= width / 2;
        actualRect.y -= height / 2;
    }

    if (directToWebsite) {
        const inBounds = CheckCollisionPointRec(
            raylib.Mouse.getPosition(),
            actualRect,
        );

        const cursor = if (inBounds) {
            raylib.Mouse.Cursor.pointing_hand;
        } else {
            raylib.Mouse.Cursor.arrow;
        };

        raylib.Mouse.setCursor(cursor);

        const lmb_pressed = raylib.MouseButton.left.isPressed();
        if (inBounds and lmb_pressed) {
            OpenURL("https://www.raylib.com/");
        }
    }

    badge.beginDrawMode();
        raylib.clearBackground(raylib.Color.ray_white);
        made_with_text.draw(
            MWR_padding,
            MWR_padding,
            1,
            raylib.Color.dark_grey,
        );
        raylib_text.draw(
            MWR_padding,
            MWR_padding,
            MWR_font_size,
            raylib.Color.black,
        );
    badge.endDrawMode();

    badge.texture.drawPro(
        (Rectangle){0, 0, madeWithRaylibBadge.texture.width, -madeWithRaylibBadge.texture.height},
        actualRect, (Vector2){0, 0}, 0, WHITE
    );
    
}

fn isFinished() bool {
    return done;
}

fn getValue() i32 {
    return result;
}
