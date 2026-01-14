# Windows Dual Boot Setup for CachyOS

This document outlines the steps to add Windows 11 to the GRUB boot menu and configure automatic mounting of the Windows NTFS partition at boot in CachyOS.

## Adding Windows to GRUB Boot Menu

1. Detect other operating systems:
   ```
   sudo os-prober
   ```
   This should output something like `/dev/sda1:Windows 11:Windows:chain`

2. Enable OS probing in GRUB configuration:
   - Edit `/etc/default/grub`
   - Uncomment the line: `GRUB_DISABLE_OS_PROBER=false`

3. Regenerate GRUB configuration:
   ```
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```
   Windows should now appear in the GRUB menu.

### Alternative: Manual Custom Entry (for UEFI systems)
If automatic detection doesn't work, add a custom entry to `/etc/grub.d/40_custom`:

```
menuentry "Windows 11" {
    insmod part_msdos
    insmod ntfs
    set root='hd0,msdos1'
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

Then regenerate GRUB config as above.

## Mounting Windows Drive at Boot

To access Windows files from CachyOS, mount the NTFS partition automatically.

1. Identify the partition UUID:
   ```
   sudo blkid /dev/sda1
   ```
   Note the UUID (e.g., `4800A96C00A961A4`).

2. Create a mount point:
   ```
   sudo mkdir /run/media/duck/windows
   ```

3. Add an entry to `/etc/fstab`:
   ```
   UUID=4800A96C00A961A4 /run/media/duck/windows ntfs-3g uid=1000,gid=1000,umask=022 0 0
   ```
   - `ntfs-3g` ensures proper NTFS support.
   - `uid=1000,gid=1000` sets ownership to the user (assuming UID 1000).
   - `umask=022` provides read/write access for the user.

4. Reload systemd to recognize fstab changes:
   ```
   sudo systemctl daemon-reload
   ```

5. Test mounting:
   ```
   sudo mount -a
   ```
   Verify the drive is accessible at `/run/media/duck/windows`.

The Windows partition will now mount automatically at boot, allowing access to its contents.
