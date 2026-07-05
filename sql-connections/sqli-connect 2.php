<?php

//including the Mysql connect parameters.
include("../sql-connections/db-creds.inc");
error_reporting(0);

// Turn off strict mysqli reporting to prevent exceptions on query failure
// (PHP 8+ defaults to MYSQLI_REPORT_STRICT which throws exceptions instead of returning false)
mysqli_report(MYSQLI_REPORT_OFF);

//mysql connections for stacked query examples.
$con1 = mysqli_connect($host,$dbuser,$dbpass);

// Check connection
if (mysqli_connect_errno())
{
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
else
{
    @mysqli_select_db($con1, $dbname) or die ( "Unable to connect to the database: $dbname");
}


?>




 
