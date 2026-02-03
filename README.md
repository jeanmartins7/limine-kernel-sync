# Limine Kernel Sync (Pacman Hook)

> **Automated Kernel Synchronization for Arch Linux/CachyOS with Limine Bootloader.**

## 🚩 The Problem
On Arch-based distributions (like CachyOS), default post-transaction hooks often assume `systemd-boot` or `grub` presence. When migrating to **Limine**, these hooks may fail to update the kernel image in the `/boot` partition.

This leads to a **"Split Brain"** scenario:
1.  **Disk:** Pacman updates modules to the new version (e.g., `6.18.8`).
2.  **Boot:** The `/boot/vmlinuz` file remains outdated (e.g., `6.18.7`).
3.  **Result:** The system boots with the old kernel, fails to load the new modules, and crashes (Kernel Panic or Emergency Mode).

## 🛠 The Solution
This project provides a **Pacman Hook** and a helper script managed by **GNU Stow**.

Every time `linux-cachyos` or headers are updated:
1.  The hook triggers **automatically**.
2.  The script locates the freshest kernel in `/usr/lib/modules`.
3.  It copies the kernel image to `/boot/vmlinuz-linux-cachyos`.
4.  It regenerates the `initramfs` using `mkinitcpio`.

This ensures your boot partition is **always in sync** with your installed modules.

---

## 📂 Project Structure

This repository uses a `stow`-compatible structure to keep your system clean.

```text
.
├── Makefile                  # Automation for installation/uninstallation
├── README.md                 # Documentation
└── system/                   # The package content
    ├── etc/
    │   └── pacman.d/
    │       └── hooks/
    │           └── 90-limine-kernel-sync.hook  # The Trigger
    └── usr/
        └── local/
            └── bin/
                └── limine-kernel-sync          # The Logic
```

## 🚀 Installation

### Prerequisites
- Arch Linux or CachyOS.

- Limine Bootloader installed.

- GNU Stow (sudo pacman -S stow).

- Make (sudo pacman -S make).

### Steps
1. Clone the repository:

```bash
git clone [https://github.com/jeanmartins7/limine-kernel-sync.git](https://github.com/jeanmartins7/limine-kernel-sync.git)
cd limine-kernel-sync
```
2. Make the script executable:

```bash
chmod +x system/usr/local/bin/limine-kernel-sync
```
3. Install using Make (via Stow):

```bash 
sudo make install
```

### 🧪 Verification

To verify that the hook is correctly installed and working, you can force a package reinstall:

```bash
sudo pacman -S linux-cachyos linux-cachyos-headers
```

To verify that the hook is correctly installed and working, you can force a package reinstall:


```Plaintext
(3/6) Syncing Kernel image for Limine (Stow Managed)...
[INFO] Starting Limine Kernel Synchronization...
[INFO] Deploying kernel from: /usr/lib/modules/6.18.8-3-cachyos/vmlinuz
[SUCCESS] Synchronization finished. Boot is consistent.
```

### 🗑 Uninstallation

If you decide to stop using this or switch bootloaders, simply run:

```bash
cd limine-kernel-sync
sudo make uninstall
```


Stow will cleanly remove the symlinks, leaving no trash behind.

### 📝 Configuration

If you need to change the kernel name or paths, edit the script at: `system/usr/local/bin/limine-kernel-sync``

Key variables:

```bash
readonly KERNEL_NAME_PATTERN="*-cachyos"
readonly TARGET_KERNEL_NAME="vmlinuz-linux-cachyos"
```

### License
MIT
