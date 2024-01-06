const std = @import("std");
const raylib_zig = @import("libs/raylib-zig/build.zig");
const sfxr_zig = @import("libs/sfxr-zig/build.zig");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const raylib_options = b.addOptions();
    raylib_options.addOption(bool, "platform_drm", false);
    raylib_options.addOption(bool, "raygui", false);

    const exe = b.addExecutable(.{
        .name = "raylib-test",
        .optimize = optimize,
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
    });

    const raylib_zig_module = raylib_zig.createModule(b);
    exe.addModule("raylib", raylib_zig_module);

    const sfxr_zig_module = sfxr_zig.createModule(b);
    exe.addModule("sfxr", sfxr_zig_module);

    const system_raylib_state = b.option(
        bool,
        "system-raylib",
        "link to preinstalled raylib libraries",
    ) orelse false;

    if (system_raylib_state) {
        exe.linkSystemLibrary("raylib");
    } else {
        const raylib_zig_library = raylib_zig.createStaticLibrary(b, .{
            .target = target,
            .optimize = optimize,
        });
        exe.linkLibrary(raylib_zig_library);
    }

    // exe.install();
    const install_exe = b.addInstallArtifact(exe, .{});
    b.getInstallStep().dependOn(&install_exe.step);

    // const run_exe = exe.run();
    const run_exe = std.build.RunStep.create(b, "run raylib-test");
    run_exe.addArtifactArg(exe);

    run_exe.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_exe.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_exe.step);

    // -------------------------------------------------------------- Tests --
    const exe_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);

    // --------------------------------------------------------------- Docs --
    // const docs = b.addTest(.{
    //     .root_source_file = .{ .path = "src/main.zig" },
    //     .optimize = optimize,
    // });
    // docs.emit_docs = .emit;
    //
    // const docs_step = b.step("docs", "Generate docs");
    // docs_step.dependOn(&docs.step);
}
