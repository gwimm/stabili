/// contains pointers to all the other System Description Tables
pub const RootSystemDescription = packed struct {
    /// located within the first 1KB of the Extended Bios Data
    /// Area, or the memory region 0x00E000 - 0x000FFFF. Scan
    /// for "RSD PTR " with an alignment of 16 bytes
    pub const Pointer = packed struct {
        signature: [8]u8,
        checksum: u8,
        oem_id: [6]u8,
        revision: u8,
        rsdt_address: u32,
        extension: struct {
            length: u32,
            xsdt_address: u64,
            checksum: u8,
            reserved: [3]u8,
        },

        const SIGNATURE = "RSD PTR ";

        pub fn validate(rsdt: Rsdt) bool {
            var sum: u8 = 0;
            for (std.mem.asBytes(&rsdt)) |byte| {
                sum +%= byte;
            }
            return sum == 0;
        }

        pub fn scan() *Self {
            
        }
    };

    signature: [4]u8,
    length: u32,
    revision: u8,
    checksum: u8,
    oem: packed struct {
        id: [6]u8,
        table_id: [8]u8,
        revision: u32,
    },
    creator: packed struct {
        id: u32,
        revision: u32,
    },

    pub fn validateChecksum(rsdt: Rsdt) bool {
        var sum: u8 = 0;
        for (std.mem.asBytes(&rsdt)) |byte| {
            sum +%= byte;
        }
        return sum == 0;
    }
};

pub const Fadt = packed struct {
    header: RootSystemDescription,
    firmware_control: u32,
    dsdt: u32,

    // for ACPI 1.0, present for compatibility
    reserved0: u8,

    preferred_power_management_profile: enum(u8) {
        unspecified         = 0x00,
        desktop             = 0x01,
        mobile              = 0x02,
        workstation         = 0x03,
        server_enterprise   = 0x04,
        server_SOHO         = 0x05,
        appliance_pc        = 0x06,
        server_performace   = 0x07
    },
    sci_interrupt: u16,
    smi_command_port: u32,
    enable: u8,
    disable: u8,
    s4bios_req: u8,
    pstate_control: u8,
    pm1_event_block_a: u32,
    pm1_event_block_b: u32,
    pm1_control_block_a: u32,
    pm1_control_block_b: u32,
    pm2_control_block: u32,
    pm_timer_block: u32,
    gpe: packed struct { block: [2]u32, },
    pm1_event_length: u8,
    pm1_control_length: u8,
    pm2_control_length: u8,
    pm_timer_length: u8,
    gpe_length_0: u8,
    gpe_length_1: u8,
    gpe_base_1: u8,
    cstate_control: u8,
    worst_latency_c2: u16,
    worst_latency_c3: u16,
    flush_size: u16,
    flush_stride: u16,
    duty_offset: u8,
    duty_width: u8,
    day_alarm: u8,
    month_alarm: u8,
    century: u8,

    // in ACPI 2.0+, reserved otherwise
    boot_architecture_flags: u16,
    reserved1: u8,
    flags: u32,

    reset: packed struct {
        register: AddressGeneric,
        value: u8,
    },
    reserved2: [3]u8,

    x: packed struct {
        firmware_control: u64,
        dsdt: u64,
        pm1_event_block_a: AddressGeneric,
        pm1_event_block_b: AddressGeneric,
        pm1_control_block_a: AddressGeneric,
        pm1_control_block_b: AddressGeneric,
        pm2_control_block: AddressGeneric,
        pm_timer_block: AddressGeneric,
        gpe_block: [2]AddressGeneric,
    }

    const SIGNATURE = "FACP";

    /// ACPI RegisterPointer
    pub const AddressGeneric = packed struct {
        address_space: AddressSpace,
        bit: packed struct {
            width: u8,
            offset: u8,
        },
        access_size: AccessSize,
        address: u64,

        const AddressSpace = union(u8) {
            system_memory                   = 0x00,
            system_io                       = 0x01,
            pci_configuration               = 0x02,
            embedded_controller             = 0x03,
            system_management_bus           = 0x04,
            system_cmos                     = 0x05,
            pci_device_bar_target           = 0x06,
            intelligent_platform_management = 0x07,
            general_purpose_io              = 0x08,
            generic_serial_bus              = 0x09,
            platform_communication_channel  = 0x0A,
        };

        const AccessSize = union(u8) {
            legacy_undefined = 0x00,
             8_bit = 0x01,
            16_bit = 0x02,
            32_bit = 0x03,
            64_bit = 0x04,
        };
    }
};