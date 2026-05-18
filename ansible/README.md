# Dotfiles Ansible Automation

Automated Fedora workstation setup using Ansible. Installs packages, configures repositories, and applies dotfiles via GNU Stow.

## Overview

This automation:
- Skips base system & KDE desktop (already in Fedora KDE ISO)
- Installs additional packages you've explicitly chosen
- Configures repositories (RPM Fusion, COPR, third-party)
- Manages Flatpak applications
- Applies dotfiles via existing stow.sh (unchanged)
- Handles git submodules (nvim, doom)
- Installs Rust via rustup (not DNF)
- Auto-detects and installs NVIDIA drivers

## Requirements

- Fedora 43 or later
- Fedora KDE ISO installation (base system + KDE already present)
- Internet connection
- sudo access

## Quick Start

```bash
# From dotfiles directory
cd ~/.dotfiles

# Dry-run (see what would change, no actual changes)
./bootstrap.sh --dry-run

# Full installation
./bootstrap.sh

# Minimal installation (shell tools + dotfiles only)
./bootstrap.sh --tags shell,dotfiles

# Developer setup
./bootstrap.sh --tags dev,editors,shell,dotfiles
```

## Available Roles

### Infrastructure
- **prerequisites** - System checks and validation
- **repositories** - RPM Fusion, COPR, third-party repos
- **systemd-services** - Enable Docker, Tailscale, libvirtd, etc.

### Development
- **development** - Language stacks and tools
  - Rust (via rustup - stable toolchain)
  - Python (3, 3.11, 3.12 with pip, virtualenv)
  - Node.js (with npm)
  - C/C++ (gcc, clang, llvm, cmake)
  - Docker CE, Podman, Buildah
  - Git, GitHub CLI
  - PostgreSQL, MariaDB, SQLite clients
- **editors** - Neovim, Emacs, VS Code Insiders

### Shell & CLI
- **shell-tools** - Modern command-line utilities
  - zsh, zsh-autosuggestions, zsh-syntax-highlighting
  - starship (prompt)
  - atuin (history)
  - ripgrep, fd-find, bat, eza, fzf, zoxide
  - tmux, zellij
  - htop, btop
  - nmap, httpie, jq, yq

### Applications
- **browsers** - Google Chrome Canary
- **media** - VLC, FFmpeg, OBS Studio, GIMP, Krita
- **productivity** - LibreOffice, Telegram, Thunderbird
- **fonts** - Fira Code, Source Code Pro, Noto, FontAwesome
- **flatpak** - Discord, Slack, VS Code, Obsidian, Zoom, OpenRA, Ferdium

### Networking & Virtualization
- **networking** - Tailscale, Cloudflare WARP, OpenVPN, WireGuard
- **virtualization** - QEMU/KVM, libvirt, virt-manager
- **nvidia-drivers** - Auto-detect GPU, install akmods

### Dotfiles
- **dotfiles** - Apply GNU Stow configs, initialize submodules

## Installation Tags

### Common Combinations

```bash
# Everything (default)
./bootstrap.sh

# Minimal (shell + dotfiles)
./bootstrap.sh --tags shell,dotfiles

# Developer workstation
./bootstrap.sh --tags dev,editors,shell,dotfiles

# Desktop without development
./bootstrap.sh --tags shell,browsers,media,productivity,fonts,flatpak,dotfiles

# Skip specific roles
./bootstrap.sh --skip-tags nvidia,media
```

### Individual Tags

| Tag | Description |
|-----|-------------|
| `repos` | Repository setup (RPM Fusion, COPR, etc.) |
| `nvidia` | NVIDIA drivers (auto-skips if no GPU) |
| `dev` | Development tools and languages |
| `editors` | Text editors and IDEs |
| `shell` | Modern CLI utilities |
| `browsers` | Web browsers |
| `media` | Media applications |
| `productivity` | Office and messaging apps |
| `fonts` | Font packages |
| `virt` | Virtualization tools |
| `network` | Networking tools |
| `flatpak` | Flatpak applications |
| `services` | Enable systemd services |
| `dotfiles` | Apply dotfiles via stow |

## Configuration

### Feature Flags

Edit `ansible/inventory/group_vars/all/main.yml`:

```yaml
# Enable/disable major components
enable_nvidia: true
enable_development: true
enable_editors: true
enable_shell_tools: true
enable_browsers: true
enable_media: true
enable_productivity: true
enable_fonts: true
enable_virtualization: false  # Disabled by default
enable_networking: true
enable_flatpak: true

# Development stack toggles
dev_rust_enabled: true
dev_python_enabled: true
dev_nodejs_enabled: true
dev_cpp_enabled: true
dev_containers_enabled: true
```

### Customizing Packages

Each role has a `vars/packages.yml` file. Edit to add/remove packages:

```bash
# Example: Add a shell tool
vim ansible/roles/shell-tools/vars/packages.yml

# Add package to appropriate list
shell_tools_modern:
  - ripgrep
  - fd-find
  - bat
  - lsd  # New addition

# Run just that role
./bootstrap.sh --tags shell
```

### Adding Flatpak Apps

Edit `ansible/inventory/group_vars/all/flatpaks.yml`:

```yaml
flatpak_apps:
  - name: App Name
    id: com.example.AppId
    category: productivity
```

## Maintenance

### Update All Packages

```bash
# Update DNF packages
sudo dnf update -y

# Update Flatpaks
flatpak update -y

# Update Rust toolchain
rustup update stable
```

### Re-apply Dotfiles

```bash
./bootstrap.sh --tags dotfiles
```

### Add New Package

1. Edit role's `vars/packages.yml`
2. Run: `./bootstrap.sh --tags <role-name>`
3. Commit changes to git

### Kernel Updates

After kernel update with NVIDIA drivers:

```bash
# Rebuild akmods
sudo akmods --force

# Or re-run nvidia role
./bootstrap.sh --tags nvidia
```

## Special Notes

### Rust Installation

Rust is installed via **rustup** (not DNF packages):
- Default toolchain: stable
- Includes rust-analyzer component
- Located in `~/.cargo/bin/`
- Add to PATH: `source ~/.cargo/env` (or restart shell)

### NVIDIA Drivers

- Auto-detects GPU presence
- Skips installation if no NVIDIA GPU found
- Uses akmods for automatic kernel module builds
- **Requires reboot** after installation
- Takes 5-10 minutes to build kernel modules

### Docker

After Docker installation:

```bash
# Add user to docker group (already done by Ansible)
# Apply group membership:
newgrp docker
# Or logout/login
```

### Stow Integration

- Existing `stow.sh` remains **unchanged**
- Ansible calls it after installing packages
- Submodules (nvim, doom) initialized automatically
- Safe to re-run

## Troubleshooting

### Dry-Run First

Always test with dry-run:

```bash
./bootstrap.sh --dry-run
```

### Check Logs

```bash
tail -f /var/log/ansible-dotfiles.log
```

### Role-Specific Issues

Run individual roles:

```bash
# Test specific role
./bootstrap.sh --tags shell --dry-run

# Run for real
./bootstrap.sh --tags shell
```

### NVIDIA Module Not Loading

```bash
# Check if module built
modinfo nvidia

# Rebuild akmods
sudo akmods --force

# Check current kernel has modules
ls /lib/modules/$(uname -r)/extra/nvidia/

# Reboot if needed
sudo reboot
```

### Repository Conflicts

```bash
# List enabled repos
dnf repolist

# Disable problematic repo
sudo dnf config-manager --set-disabled <repo-name>
```

### Flatpak Issues

```bash
# Check Flathub remote
flatpak remotes

# Re-add if missing
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Update metadata
flatpak update
```

## Directory Structure

```
ansible/
├── ansible.cfg           # Ansible configuration
├── inventory/
│   ├── hosts.yml        # Localhost inventory
│   └── group_vars/
│       └── all/         # Variables
│           ├── main.yml       # Core config & feature flags
│           ├── repos.yml      # Repository definitions
│           ├── services.yml   # Systemd services
│           └── flatpaks.yml   # Flatpak apps
├── playbooks/
│   └── bootstrap.yml    # Main playbook
├── roles/
│   ├── prerequisites/
│   ├── repositories/
│   ├── development/
│   ├── editors/
│   ├── shell-tools/
│   ├── browsers/
│   ├── media/
│   ├── productivity/
│   ├── fonts/
│   ├── networking/
│   ├── virtualization/
│   ├── flatpak/
│   ├── systemd-services/
│   ├── nvidia-drivers/
│   └── dotfiles/
└── README.md            # This file
```

## Files NOT Modified

These existing files remain unchanged:
- `stow.sh` - Dotfile symlink script
- All stow packages (shell/, nvim/, git/, etc.)
- Git submodules (nvim, doom)

## Development

### Adding a New Role

1. Create role structure:
   ```bash
   mkdir -p ansible/roles/new-role/{tasks,vars,defaults}
   ```

2. Create `vars/packages.yml`:
   ```yaml
   ---
   new_role_packages:
     - package1
     - package2
   ```

3. Create `tasks/main.yml`:
   ```yaml
   ---
   - name: Load package variables
     include_vars: packages.yml
     tags: ['new-role']

   - name: Install packages
     dnf:
       name: "{{ new_role_packages }}"
       state: present
     become: true
     tags: ['new-role']
   ```

4. Create `defaults/main.yml`:
   ```yaml
   ---
   new_role_enabled: true
   ```

5. Add to `playbooks/bootstrap.yml`:
   ```yaml
   - role: new-role
     tags: ['new-role']
     when: new_role_enabled | default(true)
   ```

## License

Personal dotfiles automation. Use as reference.

## Author

rakanalh
