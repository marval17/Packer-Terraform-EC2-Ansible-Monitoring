#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[install-monitoring] %s\n' "$*"
}

require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo "This script must run as root." >&2
    exit 1
  fi
}

setup_defaults() {
  export DEBIAN_FRONTEND=noninteractive
  NODE_EXPORTER_PORT="${NODE_EXPORTER_PORT:-9100}"
  NODE_EXPORTER_LISTEN_ADDRESS="${NODE_EXPORTER_LISTEN_ADDRESS:-":${NODE_EXPORTER_PORT}"}"
  MONITORING_ALLOWED_CIDRS="${MONITORING_ALLOWED_CIDRS:-}"
  TEXTFILE_DIR="/var/lib/node_exporter/textfile"
}

install_node_exporter() {
  log "Installing Prometheus node exporter"
  apt-get update -y
  apt-get install -y prometheus-node-exporter

  install -d -m 755 -o prometheus -g prometheus "$TEXTFILE_DIR"

  cat <<EOF >/etc/default/prometheus-node-exporter
ARGS="--collector.systemd --collector.processes --collector.textfile.directory=${TEXTFILE_DIR} --web.listen-address=${NODE_EXPORTER_LISTEN_ADDRESS} --web.telemetry-path=/metrics"
EOF

  systemctl daemon-reload
  systemctl enable --now prometheus-node-exporter
}

allow_monitoring_firewall() {
  if ! command -v ufw >/dev/null 2>&1; then
    log "ufw not installed; skipping firewall changes"
    return
  }

  if [[ -z "$MONITORING_ALLOWED_CIDRS" ]]; then
    log "Allowing TCP ${NODE_EXPORTER_PORT} from anywhere"
    ufw allow "${NODE_EXPORTER_PORT}/tcp"
    return
  fi

  IFS=',' read -ra CIDRS <<<"$MONITORING_ALLOWED_CIDRS"
  for cidr in "${CIDRS[@]}"; do
    local trimmed
    trimmed="$(echo "$cidr" | awk '{$1=$1;print}')"
    [[ -z "$trimmed" ]] && continue
    log "Allowing TCP ${NODE_EXPORTER_PORT} from ${trimmed}"
    ufw allow from "$trimmed" to any port "$NODE_EXPORTER_PORT" proto tcp
  done
}

main() {
  require_root
  setup_defaults
  install_node_exporter
  allow_monitoring_firewall
  log "Monitoring agents installed"
}

main "$@"
