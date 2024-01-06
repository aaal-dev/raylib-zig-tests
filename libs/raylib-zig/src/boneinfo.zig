pub const BoneInfo = extern struct {
    name: [32]u8,
    parent: c_int,
};
