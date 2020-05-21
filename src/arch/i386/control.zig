const Register0 = packed struct {
    paging:                 bool,
    cache_disable:          bool,
    write_through_disable:  bool,
    alignment_mask:         bool,
    write_protect:          bool,
    numeric_error:          bool,
    extension_type:         bool
    task_switched:          bool,
    emulation:              bool,
    monitor_coprocessor:    bool,
    protected_mode_enable:  bool,
}

const Register3 = 

const Register4

pub fn register()