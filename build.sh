#!/usr/bin/env bash
# =====================================================================
#  build.sh — normal build & start (keeps the database volume)
# =====================================================================
#  Use this for day-to-day: builds any changed images and (re)starts
#  the stack. Your `security` DB data is preserved.
#
#  Usage:  ./build.sh
# =====================================================================
set -euo pipefail

# Always run from the folder this script lives in (where compose file is).
cd "$(dirname "$0")"

# Kali needs root for Docker, so always use sudo.
DC="sudo docker compose"

echo "==> Building images and starting containers..."
$DC up -d --build

echo
echo "==> Status:"
$DC ps

cat <<'EOF'

==> Done. Access the labs:
    PHP labs (Burp / static IP) : http://172.30.0.10
    PHP labs (direct)           : http://localhost:8000
    WAF lessons (Burp)          : http://172.30.0.20:8080/waf/
    WAF lessons (direct)        : http://localhost:8081/waf/
EOF
