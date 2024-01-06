const std = @import("std");

const sfxr_zig_dir = struct {
    fn getSrcDir() []const u8 {
        return std.fs.path.dirname(@src().file) orelse ".";
    }
}.getSrcDir();

pub const module = std.Build.CreateModuleOptions{
    .source_file = .{ .path = sfxr_zig_dir ++ "/src/sfxr.zig" },
    .dependencies = &[_]std.Build.ModuleDependency{},
};

pub fn createModule(b: *std.Build) *std.Build.Module {
    return b.createModule(.{
        .source_file = .{ .path = sfxr_zig_dir ++ "/src/sfxr.zig" },
        .dependencies = &[_]std.Build.ModuleDependency{},
    });
}
