#!/usr/bin/env bash
# =====================================================================
#  rebuild.sh — full clean rebuild from scratch
# =====================================================================
#  Tears down THIS project's containers, network, volumes and built
#  images, then rebuilds everything fresh. The database is wiped and
#  re-initialised from the SQL seed files.
#
#  Scope is limited to this compose project — other Docker projects on
#  the machine are NOT touched (no `docker system prune -a`).
#
#  Usage:  ./rebuild.sh
# =====================================================================
set -euo pipefail

cd "$(dirname "$0")"

# Kali needs root for Docker, so always use sudo.
DC="sudo docker compose"
DK="sudo docker"

echo "==> Tearing down: containers + network + volumes + built images..."
$DC down -v --rmi all --remove-orphans

echo "==> Pruning dangling build cache (this project's leftovers)..."
$DK builder prune -f >/dev/null || true

echo "==> Rebuilding from scratch and starting..."
$DC up -d --build

echo
echo "==> Status:"
$DC ps

cat <<'EOF'

==> Fresh rebuild complete. Access the labs:
    PHP labs (Burp / static IP) : http://172.30.0.10
    PHP labs (direct)           : http://localhost:8000
    WAF lessons (Burp)          : http://172.30.0.20:8080/waf/
    WAF lessons (direct)        : http://localhost:8081/waf/
EOF
