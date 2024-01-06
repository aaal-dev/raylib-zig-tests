pub const Rectangle = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    pub fn create(x: f32, y: f32, width: f32, height: f32) Rectangle {
        return .{
            .x = x,
            .y = y,
            .width = width,
            .height = height,
        };
    }

    pub fn checkCollision(self: Rectangle, rec2: Rectangle) bool {
        return CheckCollisionRecs(self, rec2);
    }

    pub fn getCollision(self: Rectangle, rec2: Rectangle) Rectangle {
        return GetCollisionRec(self, rec2);
    }
};

extern "c" fn CheckCollisionRecs(rec1: Rectangle, rec2: Rectangle) bool;
extern "c" fn GetCollisionRec(rec1: Rectangle, rec2: Rectangle) Rectangle;
