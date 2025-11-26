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
3.  **Docker Compose:** (Usually bundled with Docker Desktop, or installable via `apt install docker-compose` on Linux).

---

## ⏱️ Setup & Installation Guide

Follow these simple steps to get the entire lab environment running in minutes.


```bash
git clone https://github.com/KhitMinnyo/sqli-labs.git
cd sqli-labs
docker-compose up -d --build 
```
Once docker-compose up is finished, your labs are ready. You can access it http://localhost/ . 

### Database Initialization

When you first access the SQLi Labs page (`http://localhost`), you must initialize the database before starting any lessons.

**Action Required:**

1.  Navigate to the main lab page (`http://localhost`).
2.  Click the **"Setup / reset database"** link in the menu.

This step creates the necessary tables and populates them with user data, fully preparing the labs for use.


## Notice
The database credentials are set for easy lab access. You can view or modify them in the docker-compose.yml file and ensure they match the application code (sql-connections/db-creds.inc).



## Stopping
To stop the containers and remove all associated network/volumes (including all database data), run:

```bash
docker-compose down -v
```