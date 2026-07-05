-- =====================================================================
--  Privileges + challenges DB for the 'aio' lab user
-- =====================================================================
--  The compose file only grants 'aio' rights on the `security` database.
--  Challenge lessons (Less-54..65) call setup-db-challenge.php, which runs
--  `CREATE DATABASE challenges ...` and creates tables on the fly — that
--  needs broader privileges. This is a deliberately vulnerable lab, so we
--  grant the lab user full rights on the DB server.
-- =====================================================================

-- Pre-create the challenges database (setup-db-challenge.php will
-- drop/recreate it, which now works because aio has the privilege).
CREATE DATABASE IF NOT EXISTS challenges CHARACTER SET gbk;

-- aio can connect from any host inside the docker network.
GRANT ALL PRIVILEGES ON *.* TO 'aio'@'%' IDENTIFIED BY 'toor' WITH GRANT OPTION;

FLUSH PRIVILEGES;
