// Code was forked from https://codeberg.org/gnarz/zig-raylib-template
//
/// A simple resource manager. All resources are allocated in one place,
/// and also released together when the resource manager is deinitialized.
/// The ownership of all resources remains with the resource manager at all
/// times! The raylib resource structs only carry pointers to allocated memory,
/// so they can be copied without problems as long as you remember who owns
/// the data.
//
//
const std = @import("std");
const raylib = @import("raylib");

const Allocator = std.mem.Allocator;

const Font = raylib.Font;
const Model = raylib.Model;
const Music = raylib.Music;
const Sound = raylib.Sound;
const Shader = raylib.Shader;
const Image = raylib.Image;
const Texture = raylib.Texture;
// more stuff...

const Resource = union(enum) {
    font: Font,
    image: Image,
    model: Model,
    music: Music,
    shader: Shader,
    sound: Sound,
    texture: Texture,
};

const ResourceList = std.ArrayList(Resource);

allocator: Allocator,
resources: ResourceList,

const ResourceManager = @This();

pub fn init(a: Allocator) Allocator.Error!ResourceManager {
    return .{
        .allocator = a,
        .resources = ResourceList.init(a),
    };
}

pub fn deinit(self: *ResourceManager) void {
    for (self.resources.items) |res| {
        switch (res) {
            .font => res.font.unload(),
            .image => res.image.unload(),
            .model => res.model.unload(),
            .music => res.music.unload(),
            .shader => res.shader.unload(),
            .sound => res.sound.unload(),
            .texture => res.texture.unload(),
        }
    }
    self.resources.deinit();
}

pub fn loadFont(
    self: *ResourceManager,
    filename: [:0]const u8,
) Allocator.Error!Font {
    var res = try self.resources.addOne();
    res.* = .{ .font = Font.load(filename) };
    return res.*.font;
}

pub fn loadImage(
    self: *ResourceManager,
    filename: [:0]const u8,
) Allocator.Error!Image {
    var res = try self.resources.addOne();
    res.* = .{ .image = Image.load(filename) };
    return res.*.image;
}

pub fn loadModel(
    self: *ResourceManager,
    filename: [:0]const u8,
) Allocator.Error!Model {
    var res = try self.resources.addOne();
    res.* = .{ .model = Model.load(filename) };
    return res.*.model;
}

pub fn loadMusic(
    self: *ResourceManager,
    filename: [:0]const u8,
) Allocator.Error!Music {
    var res = try self.resources.addOne();
    res.* = .{ .music = Music.load(filename) };
    return res.*.music;
}

pub fn loadShader(
    self: *ResourceManager,
    vshader: [:0]const u8,
    fshader: [:0]const u8,
) Allocator.Error!Shader {
    var res = try self.resources.addOne();
    res.* = .{ .shader = Shader.load(vshader, fshader) };
    return res.*.shader;
}

pub fn loadSound(
    self: *ResourceManager,
    filename: [:0]const u8,
) Allocator.Error!Sound {
    var res = try self.resources.addOne();
    res.* = .{ .sound = Sound.load(filename) };
    return res.*.sound;
}

pub fn loadTexture(
    self: *ResourceManager,
    filename: [:0]const u8,
) Allocator.Error!Texture {
    var res = try self.resources.addOne();
    res.* = .{ .texture = Texture.load(filename) };
    return res.*.texture;
}

test "basic compilation" {
    std.testing.refAllDecls(@This());
}
