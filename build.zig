const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const t = target.result;
    const toybox_dep = b.dependency("toybox", .{
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "toybox",
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibC();
    if (t.isGnu()) {
        exe.linkSystemLibrary("crypt");
    }
    exe.link_gc_sections = true;
    exe.defineCMacro("TOYBOX_VERSION", "\"1.8.10\"");
    exe.addCSourceFiles(.{
        .root = toybox_dep.path("."),
        .files = &toybox_src,
        .flags = &.{},
    });
    exe.addIncludePath(toybox_dep.path("."));
    exe.addIncludePath(toybox_dep.path("lib"));
    exe.addIncludePath(.{ .path = "include" });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}

const toybox_src = [_][]const u8{
    "main.c",
    "lib/args.c",
    "lib/commas.c",
    "lib/deflate.c",
    "lib/dirtree.c",
    "lib/elf.c",
    "lib/env.c",
    "lib/hash.c",
    "lib/lib.c",
    "lib/llist.c",
    "lib/net.c",
    "lib/password.c",
    "lib/portability.c",
    "lib/tty.c",
    "lib/utf8.c",
    "lib/xwrap.c",
    "toys/lsb/dmesg.c",
    "toys/lsb/gzip.c",
    "toys/lsb/hostname.c",
    "toys/lsb/killall.c",
    "toys/lsb/md5sum.c",
    "toys/lsb/mknod.c",
    "toys/lsb/mktemp.c",
    "toys/lsb/mount.c",
    "toys/lsb/pidof.c",
    "toys/lsb/seq.c",
    "toys/lsb/su.c",
    "toys/lsb/sync.c",
    "toys/lsb/umount.c",
    "toys/net/ftpget.c",
    "toys/net/host.c",
    "toys/net/httpd.c",
    "toys/net/ifconfig.c",
    "toys/net/microcom.c",
    "toys/net/netcat.c",
    "toys/net/netstat.c",
    "toys/net/ping.c",
    "toys/net/rfkill.c",
    "toys/net/sntp.c",
    "toys/net/tunctl.c",
    "toys/net/wget.c",
    "toys/other/acpi.c",
    "toys/other/ascii.c",
    "toys/other/base64.c",
    "toys/other/blkdiscard.c",
    "toys/other/blkid.c",
    "toys/other/blockdev.c",
    "toys/other/bzcat.c",
    "toys/other/chroot.c",
    "toys/other/chrt.c",
    "toys/other/clear.c",
    "toys/other/count.c",
    "toys/other/devmem.c",
    "toys/other/dos2unix.c",
    "toys/other/eject.c",
    "toys/other/factor.c",
    "toys/other/fallocate.c",
    "toys/other/flock.c",
    "toys/other/fmt.c",
    "toys/other/free.c",
    "toys/other/freeramdisk.c",
    "toys/other/fsfreeze.c",
    "toys/other/fsync.c",
    "toys/other/getopt.c",
    "toys/other/gpiod.c",
    "toys/other/help.c",
    "toys/other/hexedit.c",
    "toys/other/hwclock.c",
    "toys/other/i2ctools.c",
    "toys/other/inotifyd.c",
    "toys/other/insmod.c",
    "toys/other/ionice.c",
    "toys/other/linux32.c",
    "toys/other/login.c",
    "toys/other/losetup.c",
    "toys/other/lsattr.c",
    "toys/other/lsmod.c",
    "toys/other/lsusb.c",
    "toys/other/makedevs.c",
    "toys/other/mcookie.c",
    "toys/other/memeater.c",
    "toys/other/mix.c",
    "toys/other/mkpasswd.c",
    "toys/other/mkswap.c",
    "toys/other/modinfo.c",
    "toys/other/mountpoint.c",
    "toys/other/nbd_client.c",
    "toys/other/nbd_server.c",
    "toys/other/nsenter.c",
    "toys/other/oneit.c",
    "toys/other/openvt.c",
    "toys/other/partprobe.c",
    "toys/other/pivot_root.c",
    "toys/other/pmap.c",
    "toys/other/printenv.c",
    "toys/other/pwdx.c",
    "toys/other/pwgen.c",
    "toys/other/readahead.c",
    "toys/other/readelf.c",
    "toys/other/readlink.c",
    "toys/other/reboot.c",
    "toys/other/reset.c",
    "toys/other/rev.c",
    "toys/other/rmmod.c",
    "toys/other/rtcwake.c",
    "toys/other/setfattr.c",
    "toys/other/setsid.c",
    "toys/other/sha3sum.c",
    "toys/other/shred.c",
    "toys/other/shuf.c",
    "toys/other/stat.c",
    "toys/other/swapoff.c",
    "toys/other/swapon.c",
    "toys/other/switch_root.c",
    "toys/other/sysctl.c",
    "toys/other/tac.c",
    "toys/other/taskset.c",
    "toys/other/timeout.c",
    "toys/other/truncate.c",
    "toys/other/ts.c",
    "toys/other/uclampset.c",
    "toys/other/uptime.c",
    "toys/other/usleep.c",
    "toys/other/uuidgen.c",
    "toys/other/vconfig.c",
    "toys/other/vmstat.c",
    "toys/other/w.c",
    "toys/other/watch.c",
    "toys/other/watchdog.c",
    "toys/other/which.c",
    "toys/other/xxd.c",
    "toys/other/yes.c",
    "toys/posix/basename.c",
    "toys/posix/cal.c",
    "toys/posix/cat.c",
    "toys/posix/chgrp.c",
    "toys/posix/chmod.c",
    "toys/posix/cksum.c",
    "toys/posix/cmp.c",
    "toys/posix/comm.c",
    "toys/posix/cp.c",
    "toys/posix/cpio.c",
    "toys/posix/cut.c",
    "toys/posix/date.c",
    "toys/posix/dd.c",
    "toys/posix/df.c",
    "toys/posix/dirname.c",
    "toys/posix/du.c",
    "toys/posix/echo.c",
    "toys/posix/env.c",
    "toys/posix/expand.c",
    "toys/posix/false.c",
    "toys/posix/file.c",
    "toys/posix/find.c",
    "toys/posix/fold.c",
    "toys/posix/getconf.c",
    "toys/posix/grep.c",
    "toys/posix/head.c",
    "toys/posix/iconv.c",
    "toys/posix/id.c",
    "toys/posix/kill.c",
    "toys/posix/link.c",
    "toys/posix/ln.c",
    "toys/posix/logger.c",
    "toys/posix/ls.c",
    "toys/posix/mkdir.c",
    "toys/posix/mkfifo.c",
    "toys/posix/nice.c",
    "toys/posix/nl.c",
    "toys/posix/nohup.c",
    "toys/posix/od.c",
    "toys/posix/paste.c",
    "toys/posix/patch.c",
    "toys/posix/printf.c",
    "toys/posix/ps.c",
    "toys/posix/pwd.c",
    "toys/posix/renice.c",
    "toys/posix/rm.c",
    "toys/posix/rmdir.c",
    "toys/posix/sed.c",
    "toys/posix/sleep.c",
    "toys/posix/sort.c",
    "toys/posix/split.c",
    "toys/posix/strings.c",
    "toys/posix/tail.c",
    "toys/posix/tar.c",
    "toys/posix/tee.c",
    "toys/posix/test.c",
    "toys/posix/time.c",
    "toys/posix/touch.c",
    "toys/posix/true.c",
    "toys/posix/tsort.c",
    "toys/posix/tty.c",
    "toys/posix/ulimit.c",
    "toys/posix/uname.c",
    "toys/posix/uniq.c",
    "toys/posix/unlink.c",
    "toys/posix/uudecode.c",
    "toys/posix/uuencode.c",
    "toys/posix/wc.c",
    "toys/posix/who.c",
    "toys/posix/xargs.c",
};