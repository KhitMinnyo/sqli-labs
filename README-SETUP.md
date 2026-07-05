# SQLi-Labs — Kali Setup + Burp Guide

Audi-1's SQLi-Labs, ported to PHP 8.2 and packaged with Docker, fixed to run
on Kali Linux and to let Burp intercept all lab traffic.

---

## 1. What was fixed

1. **Removed `platform: linux/amd64` on the db service.**
   On an arm64 Kali host (e.g. an Apple-Silicon VM) the amd64 pin makes the
   `db` container fail to start; the `web` container then waits for the DB
   forever and `localhost` never comes up.

2. **Wired up the empty DB init folder.**
   `sql-connections/sql-config/` had no scripts, so no tables or data were
   loaded. Added `01-security.sql` (schema + data) and `02-grants.sql`
   (creates the `challenges` DB and grants the `aio` user the privileges the
   challenge lessons need).

3. **Fixed PHP 8 fatal in Less-17..22.**
   `get_magic_quotes_gpc()` was removed in PHP 8.0; calling it aborted the
   login handler. It is now guarded with `function_exists()`.

4. **Enabled output buffering (`output_buffering = 4096`).**
   Cookie lessons (Less-20/21/22) call `setcookie()` / `header()` after HTML
   output. The base image ships with buffering off, so those calls failed
   ("headers already sent") and login never worked. Buffering restores it.

5. **Avoided host port conflicts.**
   - web   -> `localhost:8000`
   - tomcat -> `localhost:8081` (was `8080`, which collides with Burp's
     default proxy listener on `8080`).

6. **Added a dedicated static-IP network** for Burp interception (see below).

7. **Made menu links Burp-friendly.**
   Hard-coded `http://localhost...` links were replaced: same-host links are
   relative, cross-host links use the static container IPs, so every request
   goes through the proxy.

8. **`setup-db.php` now returns Home** after seeding the DB (Home button +
   auto-redirect to the main menu).

---

## 2. Running

```bash
cd sqli-labs

# clean up any old containers/network first
docker compose down -v

# build + start everything in one command
docker compose up -d --build

# watch logs (check that db becomes healthy)
docker compose logs -f
```

On first run, seed the database once by visiting:
`http://localhost:8000/sql-connections/setup-db.php`
(it redirects back to the main menu when done). Challenge lessons
(Less-54..65) set themselves up automatically on first visit.

### Access URLs
| Purpose | URL |
|---|---|
| Normal browsing | `http://localhost:8000` |
| **Through Burp (static IP)** | `http://172.30.0.10` |
| Tomcat WAF lessons (Less-29..32) | `http://172.30.0.20:8080` or `http://localhost:8081` |

---

## 3. Why Burp doesn't catch localhost

Firefox (and most browsers) are hard-wired to send `localhost` / `127.0.0.1`
straight out, bypassing the proxy, so those requests never reach Burp.

**Fix:** don't use localhost — use the dedicated IP `172.30.0.10`. On
Linux/Kali the Docker bridge subnet is reachable directly from the host, so
requests to that IP are routed through the proxy. The compose file defines a
dedicated `172.30.0.0/24` network and gives the web container the static IP
`172.30.0.10` (same class-C subnet).

---

## 4. Intercepting with Burp (Firefox)

1. Burp -> **Proxy -> Proxy settings**: confirm the listener is `127.0.0.1:8080`.
2. Firefox -> **Settings -> Network Settings -> Manual proxy**:
   - HTTP Proxy: `127.0.0.1`  Port: `8080`
   - Tick **"Also use this proxy for HTTPS"**.
   - **Clear** `localhost, 127.0.0.1` from the **"No proxy for"** box.
3. Browse to **`http://172.30.0.10/Less-1/?id=1`**.
4. Check **Burp -> Proxy -> HTTP history / Intercept** — the request appears.

> Tip: FoxyProxy makes this easier — add a pattern for `172.30.0.10` and
> point it at the Burp proxy.

---

## 5. Troubleshooting

- **`bind: address already in use`** — change the host port (`8000` / `8081`)
  or stop the conflicting service (`sudo ss -ltnp | grep :80`).
- **Can't reach `172.30.0.10`** — the subnet may clash with a host network.
  Change it (e.g. `172.31.0.0/24`) in the compose file and adjust the IPs.
- **DB errors / missing tables** — run `docker compose down -v` to clear the
  volume, then `up` again (init scripts only run on the first boot).
- **Subnet overlap** — inspect with `docker network ls` / `docker network inspect`.
