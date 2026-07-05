<?php
/*
 * Global compatibility shim (loaded via php.ini auto_prepend_file).
 *
 * The SQLi-Labs code pulls in shared files with CWD-relative paths such as
 *   include("../sql-connections/sqli-connect.php");
 * These only resolve when PHP's current working directory is the running
 * script's own folder. Under this Apache/PHP setup the CWD is NOT the script
 * directory, so those includes fail, $con1 is never created, and the page
 * dies silently (no data shown).
 *
 * Forcing the working directory to the main script's directory on every
 * request makes all of the labs' relative includes resolve correctly,
 * without having to edit each of the 68+ lesson files.
 */
if (!empty($_SERVER['SCRIPT_FILENAME'])) {
    @chdir(dirname($_SERVER['SCRIPT_FILENAME']));
}
