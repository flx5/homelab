<?php
if (!isset($_GET['maintenance'])) {
    die("Missing or invalid mode parameter");
}

$maintenance = $_GET['maintenance'] == 'true' ? "on" : "off";

passthru("/var/www/html/occ maintenance:mode --".$maintenance);