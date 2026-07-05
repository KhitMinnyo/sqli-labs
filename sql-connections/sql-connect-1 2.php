<?php

//including the Mysql connect parameters.
include("../sql-connections/db-creds.inc");
@error_reporting(0);

// Turn off strict mysqli reporting to prevent exceptions on query failure
// (PHP 8+ defaults to MYSQLI_REPORT_STRICT which throws exceptions instead of returning false)
mysqli_report(MYSQLI_REPORT_OFF);

@$con1 = mysqli_connect($host,$dbuser,$dbpass);
// Check connection
if (!$con1)
{
    echo "Failed to connect to MySQL: " . mysqli_error($con1);
}


    @mysqli_select_db($con1,$dbname1) or die ( "Unable to connect to the database: $dbname1".mysqli_error($con1));






$sql_connect_1 = "SQL Connect included";

############################################
# For Challenge series--- Randomizing the Table names.

?>




 
