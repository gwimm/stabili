const descriptor = @import("descriptor.zig");

fn Handler(routine: ServiceRoutine) type {
    return fn () callconv(.Interrupt) void;
    //  return switch(routine) {
    //      .doubleFault,
    //      .invalidTaskStateSegment,
    //      .segmentNotPresent,
    //      .stackSegmentFault,
    //      .generalProtectionFault,
    //      .pageFault,
    //      .machineCheck,
    //      => fn (Context) callconv(.Interrupt) void,
    //      else => fn (Context, i32) callconv(.Interrupt) void,
    //  };
}

pub const ServiceRoutine = enum {
    divideByZero                = 0,
    singleStepDebug,
    nonMaskable,
    breakpoint,
    overflow,
    boundRangeExceeded,
    invalidOpcode,
    deviceNotAvailable,
    doubleFault,
    coprocessorSegmentOverrun,
    invalidTaskStateSegment,
    segmentNotPresent,
    stackSegmentFault,
    generalProtectionFault,
    pageFault                   = 14,
//  reserved
    x87FloatPoint               = 16,
    alignmentCheck,
    machineCheck,
    simdFloatPoint              = 19,
    security                    = 30,
};

pub fn default(comptime routine: ServiceRoutine) Handler(routine) {
    return struct {
        fn func() callconv(.Interrupt) void {
            // @panic(@tagName(routine));
            @panic("what the fuck");
        }
    }.func;
}

pub fn register(comptime num: ServiceRoutine, handler: Handler(num)) void {
    // descriptor.table[@enumToInt(num)] = .{
    descriptor.table[0] = .{
        .base_low   = @truncate(u16, @ptrToInt(handler)),
        .base_high  = @truncate(u16, @ptrToInt(handler) >> 16),

        .selector   = 1,
        .gate_type  = .interrupt32,
        .privilege  = .kernel,

        .present    = true,
        .segment    = 0,
    };
}