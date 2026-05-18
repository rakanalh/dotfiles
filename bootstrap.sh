#!/usr/bin/env bash
# bootstrap.sh - Main entry point for Fedora workstation setup
#
# This script orchestrates the Ansible-based installation of packages and dotfiles.
# It handles pre-flight checks, installs Ansible if needed, and runs the bootstrap playbook.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ANSIBLE_DIR="${SCRIPT_DIR}/ansible"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_debug() { echo -e "${BLUE}[DEBUG]${NC} $*"; }

# Check if running on Fedora
check_fedora() {
    if [[ ! -f /etc/fedora-release ]]; then
        log_error "This script requires Fedora Linux"
        exit 1
    fi

    fedora_version=$(rpm -E %fedora)
    if [[ $fedora_version -lt 43 ]]; then
        log_error "This script requires Fedora 43 or later (found: Fedora $fedora_version)"
        exit 1
    fi

    log_info "Detected Fedora $fedora_version"
}

# Install Ansible if not present
install_ansible() {
    if command -v ansible-playbook &> /dev/null; then
        log_info "Ansible already installed: $(ansible --version | head -1)"
        return
    fi

    log_info "Installing Ansible..."
    sudo dnf install -y ansible-core python3-pip

    # Install required collections
    log_info "Installing Ansible collections..."
    ansible-galaxy collection install community.general
}

# Parse command line arguments
parse_args() {
    ANSIBLE_TAGS="all"
    ANSIBLE_SKIP_TAGS=""
    ANSIBLE_EXTRA_VARS=""
    DRY_RUN=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --tags)
                ANSIBLE_TAGS="$2"
                shift 2
                ;;
            --skip-tags)
                ANSIBLE_SKIP_TAGS="$2"
                shift 2
                ;;
            --extra-vars)
                ANSIBLE_EXTRA_VARS="$2"
                shift 2
                ;;
            --dry-run|--check)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Show help message
show_help() {
    cat <<EOF
${GREEN}Fedora Workstation Bootstrap${NC}
Usage: ./bootstrap.sh [OPTIONS]

Bootstrap a Fedora workstation with packages and dotfiles using Ansible.

${YELLOW}OPTIONS:${NC}
    --tags TAGS              Run only specified tags (comma-separated)
                            Examples:
                              --tags shell,dotfiles
                              --tags dev,editors

    --skip-tags TAGS        Skip specified tags
                            Example: --skip-tags nvidia,media

    --extra-vars VARS       Pass extra variables to Ansible
                            Example: --extra-vars "enable_nvidia=false"

    --dry-run, --check      Run in check mode (no changes)

    -h, --help              Show this help message

${YELLOW}COMMON TAG COMBINATIONS:${NC}
    ${BLUE}Minimal:${NC}        --tags shell,dotfiles
    ${BLUE}Developer:${NC}      --tags dev,editors,shell,dotfiles
    ${BLUE}Full install:${NC}   (no --tags, runs everything)

${YELLOW}INDIVIDUAL TAGS:${NC}
    repos           Repository setup (RPM Fusion, COPR, third-party)
    nvidia          NVIDIA drivers (auto-skips if no GPU)
    dev             Development tools (rust, go, python, docker, etc)
    editors         Text editors (neovim, emacs, vscode)
    shell           Modern CLI tools (ripgrep, fzf, bat, etc)
    browsers        Web browsers (chrome - firefox in ISO)
    media           Media applications (vlc, ffmpeg, obs)
    productivity    Office and messaging apps
    fonts           Font packages
    virt            Virtualization (docker, libvirt)
    network         Networking tools (tailscale, etc)
    flatpak         Flatpak applications
    services        Enable systemd services
    dotfiles        Apply GNU Stow dotfiles

${YELLOW}EXAMPLES:${NC}
    # Full bootstrap (everything)
    ./bootstrap.sh

    # Minimal server setup
    ./bootstrap.sh --tags shell,dotfiles

    # Desktop without NVIDIA
    ./bootstrap.sh --skip-tags nvidia

    # Development machine
    ./bootstrap.sh --tags dev,editors,shell,dotfiles

    # Dry run to see what would change
    ./bootstrap.sh --dry-run

EOF
}

# Backup existing configurations
backup_existing_configs() {
    log_info "Creating backup of existing configurations..."

    backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    # Backup key config files if they exist and aren't symlinks
    for file in .zshrc .bashrc .gitconfig .tmux.conf; do
        if [[ -f "$HOME/$file" ]] && [[ ! -L "$HOME/$file" ]]; then
            cp "$HOME/$file" "$backup_dir/"
            log_info "Backed up $file"
        fi
    done

    if [[ $(ls -A "$backup_dir" | wc -l) -eq 0 ]]; then
        rmdir "$backup_dir"
        log_info "No configs to backup (all are already symlinks or don't exist)"
    else
        log_info "Backup created at: $backup_dir"
    fi
}

# Run Ansible playbook
run_ansible() {
    log_info "Running Ansible playbook..."

    cd "$ANSIBLE_DIR"

    # Create log file with proper permissions
    sudo touch /var/log/ansible-dotfiles.log
    sudo chmod 666 /var/log/ansible-dotfiles.log

    ansible_cmd=(
        ansible-playbook
        playbooks/bootstrap.yml
        -i inventory/hosts.yml
        --tags "$ANSIBLE_TAGS"
    )

    [[ -n "$ANSIBLE_SKIP_TAGS" ]] && ansible_cmd+=(--skip-tags "$ANSIBLE_SKIP_TAGS")
    [[ -n "$ANSIBLE_EXTRA_VARS" ]] && ansible_cmd+=(--extra-vars "$ANSIBLE_EXTRA_VARS")
    [[ "$DRY_RUN" == true ]] && ansible_cmd+=(--check --diff)

    # Enable logging
    export ANSIBLE_LOG_PATH=/var/log/ansible-dotfiles.log

    # Ask for sudo password upfront
    sudo -v

    # Keep sudo alive during long-running playbook
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    SUDO_KEEPALIVE_PID=$!

    log_info "Executing: ${ansible_cmd[*]}"

    if "${ansible_cmd[@]}"; then
        kill $SUDO_KEEPALIVE_PID 2>/dev/null || true
        log_info "Ansible playbook completed successfully!"
        return 0
    else
        kill $SUDO_KEEPALIVE_PID 2>/dev/null || true
        log_error "Ansible playbook failed! Check logs for details."
        return 1
    fi
}

# Post-installation summary
post_install_summary() {
    log_info "=========================================="
    log_info "Bootstrap Complete!"
    log_info "=========================================="

    if [[ "$ANSIBLE_TAGS" == *"nvidia"* ]] || [[ -f /var/run/reboot-required ]]; then
        log_warn "NVIDIA drivers installed - REBOOT REQUIRED"
        log_warn "Run: sudo reboot"
    fi

    if [[ "$ANSIBLE_TAGS" == *"shell"* ]]; then
        log_info "Shell tools installed. Start new shell or run:"
        log_info "  source ~/.zshrc"
    fi

    if [[ "$ANSIBLE_TAGS" == *"dev"* ]] && [[ "$ANSIBLE_TAGS" == *"docker"* ]]; then
        log_info "Docker installed. Add user to docker group:"
        log_info "  sudo usermod -aG docker $USER"
        log_info "  newgrp docker"
    fi

    log_info ""
    log_info "Check logs: /var/log/ansible-dotfiles.log"
    log_info "Dotfiles location: $SCRIPT_DIR"
    log_info "=========================================="
}

# Main function
main() {
    log_info "Starting Fedora Workstation Bootstrap"
    log_info "=========================================="

    # Pre-flight checks
    check_fedora
    parse_args "$@"

    # Show what will be installed
    log_info "Configuration:"
    log_info "  Tags: ${ANSIBLE_TAGS}"
    [[ -n "$ANSIBLE_SKIP_TAGS" ]] && log_info "  Skip tags: ${ANSIBLE_SKIP_TAGS}"
    [[ "$DRY_RUN" == true ]] && log_warn "  DRY RUN MODE (no changes will be made)"
    log_info ""

    # Confirm unless dry-run
    if [[ "$DRY_RUN" == false ]]; then
        read -p "Continue with bootstrap? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_warn "Bootstrap cancelled"
            exit 0
        fi
    fi

    # Install prerequisites
    install_ansible

    # Backup existing configs
    [[ "$DRY_RUN" == false ]] && backup_existing_configs

    # Run Ansible
    if run_ansible; then
        post_install_summary
        exit 0
    else
        log_error "Bootstrap failed. See errors above."
        exit 1
    fi
}

main "$@"
