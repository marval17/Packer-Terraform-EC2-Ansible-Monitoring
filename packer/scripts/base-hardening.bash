#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[base-hardening] %s\n' "$*"
}

require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo "This script must run as root." >&2
    exit 1
  fi
}

configure_apt() {
  log "Refreshing package metadata"
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get dist-upgrade -y

  log "Installing baseline packages"
  apt-get install -y \
    ca-certificates \
    curl \
    fail2ban \
    gnupg \
    software-properties-common \
    unattended-upgrades \
    ufw
}

configure_ssh() {
  local sshd_cfg="/etc/ssh/sshd_config"
  log "Hardening SSH daemon settings"

  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$sshd_cfg"
  sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' "$sshd_cfg"
  sed -i 's/^#\?X11Forwarding.*/X11Forwarding no/' "$sshd_cfg"

  if ! grep -q "^ClientAliveInterval" "$sshd_cfg"; then
    printf '\nClientAliveInterval 300\nClientAliveCountMax 2\n' >> "$sshd_cfg"
  else
    sed -i 's/^ClientAliveInterval.*/ClientAliveInterval 300/' "$sshd_cfg"
    sed -i 's/^ClientAliveCountMax.*/ClientAliveCountMax 2/' "$sshd_cfg"
  fi

  systemctl restart ssh
}

configure_firewall() {
  log "Configuring uncomplicated firewall"
  ufw --force reset
  ufw allow OpenSSH
  ufw --force enable
}

configure_fail2ban() {
  log "Ensuring fail2ban is enabled"
  systemctl enable fail2ban
  systemctl restart fail2ban
}

cleanup() {
  log "Cleaning apt cache"
  apt-get autoremove -y
  apt-get clean
}

main() {
  require_root
  configure_apt
  configure_ssh
  configure_firewall
  configure_fail2ban
  cleanup
  log "Base hardening complete"
}

main "$@"
