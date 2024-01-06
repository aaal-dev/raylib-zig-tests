const std = @import("std");

pub const lib_name = "raylib";

const raylib_zig_dir = struct {
    fn getSrcDir() []const u8 {
        return std.fs.path.dirname(@src().file) orelse ".";
    }
}.getSrcDir();
const raylib_srcdir = raylib_zig_dir ++ "/libs/raylib/src";

pub const modules = struct {
    pub const raylib = std.Build.CreateModuleOptions{
        .source_file = .{ .path = raylib_zig_dir ++ "/lib.zig" },
        .dependencies = &[_]std.Build.ModuleDependency{},
    };
};

pub const CompileOptions = struct {
    optimize: std.builtin.OptimizeMode,
    target: std.zig.CrossTarget,
};

pub fn addLibTo(
    compile_step: *std.Build.Step.Compile,
    options: CompileOptions,
) *std.Build.CompileStep {
    const b = compile_step.step.owner;

    const module = b.createModule(modules.raylib);
    compile_step.addModule(lib_name, module);

    const library = createStaticLibrary(b, options);
    compile_step.linkLibrary(library);
}

pub fn createStaticLibrary(
    b: *std.Build,
    options: CompileOptions,
) *std.Build.Step.Compile {
    const raylib_flags = &[_][]const u8{
        "-std=gnu99",
        "-D_GNU_SOURCE",
        "-DGL_SILENCE_DEPRECATION=199309L",
        // https://github.com/raysan5/raylib/issues/1891
        "-fno-sanitize=undefined",
    };

    const raylib = b.addStaticLibrary(.{
        .name = "raylib",
        .target = options.target,
        .optimize = options.optimize,
    });
    raylib.linkLibC();

    const platform_drm = b.option(
        bool,
        "platform_drm",
        "Uses platform specific libs",
    ) orelse false;

    if (!platform_drm) {
        raylib.addIncludePath(
            .{ .path = raylib_srcdir ++ "/external/glfw/include" },
        );
    }

    raylib.addCSourceFiles(&.{
        raylib_srcdir ++ "/raudio.c",
        raylib_srcdir ++ "/rcore.c",
        raylib_srcdir ++ "/rmodels.c",
        raylib_srcdir ++ "/rshapes.c",
        raylib_srcdir ++ "/rtext.c",
        raylib_srcdir ++ "/rtextures.c",
        raylib_srcdir ++ "/utils.c",
    }, raylib_flags);

    // var gen_step =
    // raylib.step.dependOn(&gen_step.step);

    const raygui = b.option(
        bool,
        "raygui",
        "Uses raygui",
    ) orelse false;

    if (raygui) {
        var gen_step = std.build.Step.WriteFile.create(b);
        raylib.step.dependOn(&gen_step.step);
        _ = gen_step.add(
            raylib_srcdir ++ "/raygui.c",
            "#define RAYGUI_IMPLEMENTATION\n#include \"raygui.h\"\n",
        );
        raylib.addCSourceFile(.{
            .file = .{ .path = raylib_srcdir ++ "/raygui.c" },
            .flags = raylib_flags,
        });
        raylib.addIncludePath(.{ .path = raylib_srcdir });
        raylib.addIncludePath(.{
            .path = raylib_srcdir ++ "/../../raygui/src",
        });
    }

    switch (options.target.getOsTag()) {
        .windows => {
            raylib.addCSourceFiles(
                &.{raylib_srcdir ++ "/rglfw.c"},
                raylib_flags,
            );
            raylib.addIncludePath(.{ .path = "external/glfw/deps/mingw" });
            raylib.linkSystemLibrary("winmm");
            raylib.linkSystemLibrary("gdi32");
            raylib.linkSystemLibrary("opengl32");

            raylib.defineCMacro("PLATFORM_DESKTOP", null);
        },
        .linux => {
            if (!platform_drm) {
                raylib.addCSourceFiles(
                    &.{raylib_srcdir ++ "/rglfw.c"},
                    raylib_flags,
                );
                raylib.addIncludePath(.{ .path = "/usr/include" });
                raylib.linkSystemLibrary("GL");
                raylib.linkSystemLibrary("rt");
                raylib.linkSystemLibrary("dl");
                raylib.linkSystemLibrary("m");
                raylib.linkSystemLibrary("X11");

                raylib.defineCMacro("PLATFORM_DESKTOP", null);
            } else {
                raylib.addIncludePath(.{ .path = "/usr/include/libdrm" });
                raylib.linkSystemLibrary("GLESv2");
                raylib.linkSystemLibrary("EGL");
                raylib.linkSystemLibrary("drm");
                raylib.linkSystemLibrary("gbm");
                raylib.linkSystemLibrary("pthread");
                raylib.linkSystemLibrary("rt");
                raylib.linkSystemLibrary("m");
                raylib.linkSystemLibrary("dl");

                raylib.defineCMacro("PLATFORM_DRM", null);
                raylib.defineCMacro("GRAPHICS_API_OPENGL_ES2", null);
                raylib.defineCMacro("EGL_NO_X11", null);
                raylib.defineCMacro("DEFAULT_BATCH_BUFFER_ELEMENT", "2048");
            }
        },
        .freebsd, .openbsd, .netbsd, .dragonfly => {
            raylib.addCSourceFiles(
                &.{raylib_srcdir ++ "/rglfw.c"},
                raylib_flags,
            );
            raylib.linkSystemLibrary("GL");
            raylib.linkSystemLibrary("rt");
            raylib.linkSystemLibrary("dl");
            raylib.linkSystemLibrary("m");
            raylib.linkSystemLibrary("X11");
            raylib.linkSystemLibrary("Xrandr");
            raylib.linkSystemLibrary("Xinerama");
            raylib.linkSystemLibrary("Xi");
            raylib.linkSystemLibrary("Xxf86vm");
            raylib.linkSystemLibrary("Xcursor");

            raylib.defineCMacro("PLATFORM_DESKTOP", null);
        },
        .macos => {
            // On macos rglfw.c include Objective-C files.
            const raylib_flags_extra_macos = &[_][]const u8{
                "-ObjC",
            };
            raylib.addCSourceFiles(
                &.{raylib_srcdir ++ "/rglfw.c"},
                raylib_flags ++ raylib_flags_extra_macos,
            );
            raylib.linkFramework("Foundation");
            raylib.linkFramework("CoreServices");
            raylib.linkFramework("CoreGraphics");
            raylib.linkFramework("AppKit");
            raylib.linkFramework("IOKit");

            raylib.defineCMacro("PLATFORM_DESKTOP", null);
        },
        .emscripten => {
            raylib.defineCMacro("PLATFORM_WEB", null);
            raylib.defineCMacro("GRAPHICS_API_OPENGL_ES2", null);

            if (b.sysroot == null) {
                @panic("Pass '--sysroot \"$EMSDK/upstream/emscripten\"'");
            }

            const cache_include = std.fs.path.join(
                b.allocator,
                &.{ b.sysroot.?, "cache", "sysroot", "include" },
            ) catch @panic("Out of memory");
            defer b.allocator.free(cache_include);

            var dir = std.fs.openDirAbsolute(
                cache_include,
                std.fs.Dir.OpenDirOptions{
                    .access_sub_paths = true,
                    .no_follow = true,
                },
            ) catch @panic("No emscripten cache. Generate it!");
            dir.close();

            raylib.addIncludePath(.{ .path = cache_include });
        },
        else => {
            @panic("Unsupported OS");
        },
    }

    return raylib;
}

pub fn createModule(b: *std.Build) *std.Build.Module {
    return b.createModule(.{
        .source_file = .{ .path = raylib_zig_dir ++ "/lib.zig" },
        .dependencies = &[_]std.Build.ModuleDependency{},
    });
}
