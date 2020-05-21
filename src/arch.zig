const builtin = @import("builtin");
pub usingnamespace @import("arch/" ++ @tagName(builtin.arch) ++ ".zig");