#!/bin/bash
# =====================================================================
#  labs-entrypoint.sh — auto-fix bind-mount permissions
# =====================================================================
#  The labs write result.txt into each lesson directory
#  (e.g. Less-1/result.txt) on every request:
#
#       $fp = fopen('result.txt','a');
#       fwrite($fp, 'ID:'.$id."\n");
#
#  On a native-Linux bind mount the webroot files are owned by the HOST
#  user (often uid 1000), which Apache's www-data (uid 33) cannot write.
#  So fopen() returns false and PHP 8's fwrite(false, ...) throws a fatal
#  TypeError. Because the lessons set error_reporting(0), the page dies
#  silently and shows no login/password data.
#
#  (On macOS Docker Desktop the file-sharing layer hides this, which is
#  why the same stack "works on Mac but not on Kali/Linux".)
#
#  Fix: at container start, detect who owns the mounted webroot and remap
#  www-data to that uid/gid. Apache then runs as the mount owner and can
#  write result.txt. This does NOT change ownership of the host's files.
# =====================================================================
set -e

WEBROOT=/var/www/html
UID_TARGET=$(stat -c '%u' "$WEBROOT" 2>/dev/null || echo 0)
GID_TARGET=$(stat -c '%g' "$WEBROOT" 2>/dev/null || echo 0)

if [ "$UID_TARGET" != "0" ] && [ "$UID_TARGET" != "$(id -u www-data)" ]; then
    groupmod -o -g "$GID_TARGET" www-data 2>/dev/null || true
    usermod  -o -u "$UID_TARGET" -g "$GID_TARGET" www-data 2>/dev/null || true
    echo "[labs-entrypoint] Remapped www-data -> ${UID_TARGET}:${GID_TARGET} (bind-mount owner)."
elif [ "$UID_TARGET" = "0" ]; then
    # Root-owned mount: can't remap, so relax permissions instead (lab only).
    chmod -R a+rwX "$WEBROOT" 2>/dev/null || true
    echo "[labs-entrypoint] Webroot is root-owned; applied a+rwX fallback."
fi

# Hand off to the stock PHP image entrypoint + CMD (apache2-foreground).
exec docker-php-entrypoint "$@"
