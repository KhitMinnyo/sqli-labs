# 🛡️ SQLi Labs - Dockerized Setup

This repository provides a complete, pre-configured environment for web hacking practice, including the classic **SQLi-Labs** and integrated **WAF Bypass Labs** (Java/Tomcat), all running seamlessly via Docker Compose.

The configuration has been specifically optimized for modern PHP versions and Docker networking to resolve common connection issues.

---

## ⚠️ Important Notice

**Disclaimer:** This project is intended solely for **educational and authorized security testing purposes**. It is designed to be run in a safe, isolated environment (your local machine via Docker).

This Dockerized setup is a custom version based on the original **Audi1/SQLi-Labs** and its related WAF components. **All credit for the original vulnerable PHP and JSP code goes to the original authors.** I have merely adapted the environment files (`Dockerfile`, `docker-compose.yml`, and internal connection details) to ensure proper functionality on modern Docker platforms (including Apple Silicon/ARM64).

---

## 🚀 Key Features

* **All-in-One Environment:** Runs both PHP-based SQLi Labs and Java-based WAF Labs simultaneously.
* **Dockerized:** Ensures cross-platform compatibility (macOS, Linux, Windows).
* **Persistent Database:** MariaDB is automatically initialized with all required tables and users.
* **Networking:** Properly configured for inter-container communication, solving common `localhost` and `Connection Refused` errors.

---

## ⚙️ Requirements

To run this project, you need the following software installed on your machine:

1.  **Git:** For cloning the repository.
2.  **Docker Desktop / Docker Engine:** (Required for macOS, Windows, or Linux).
3.  **Docker Compose v2:** (Bundled with Docker Desktop, or install the plugin via `apt install docker-compose-plugin` on Linux — invoked as `docker compose`).

---

## ⏱️ Setup & Installation Guide

Follow these simple steps to get the entire lab environment running in minutes.


```bash
git clone https://github.com/KhitMinnyo/sqli-labs.git
cd sqli-labs
docker compose up -d --build
```
Once the build finishes, your labs are ready.

### Access URLs

| Purpose | URL |
|---|---|
| Normal browsing | `http://localhost:8000` |
| Through Burp (static IP) | `http://172.30.0.10` |
| Tomcat WAF labs (Less-29..32) | `http://172.30.0.20:8080` or `http://localhost:8081` |

> Runs natively on both **amd64** and **arm64** (Apple Silicon) — no emulation.

### Database Initialization

The database is **initialized automatically on first boot** (schema, data, the
`challenges` DB and user grants are loaded from `sql-connections/sql-config/`),
so you can start the lessons right away.

To **reset** the database at any time, open
`http://localhost:8000/sql-connections/setup-db.php`
(it re-seeds everything, then returns you to the main menu).

### Intercepting with Burp

Browsers bypass the proxy for `localhost`/`127.0.0.1`, so Burp never sees that
traffic. Browse the lab via its dedicated IP **`http://172.30.0.10`** instead —
on Linux the Docker bridge IP is reachable directly and routes through Burp.
Set Firefox's proxy to `127.0.0.1:8080` and clear `localhost, 127.0.0.1` from
the "No proxy for" list. Full details are in `README-SETUP.md`.


## Notice
The database credentials are set for easy lab access. You can view or modify them in the docker-compose.yml file and ensure they match the application code (sql-connections/db-creds.inc).



## Stopping
To stop the containers and remove all associated network/volumes (including all database data), run:

```bash
docker compose down -v
```
