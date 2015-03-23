<?php
	require_once('database.inc.php');
	require_once("mysql_connect_data.inc.php");
	
	$db = new Database($host, $userName, $password, $database);
	$db->openConnection();
	if (!$db->isConnected()) {
		header("Location: cannotConnect.html");
		exit();
	}
	
	
	session_start();
	$_SESSION['db'] = $db;
	$db->closeConnection();
	?>
<html>
<head>
<title>Krusty Cookies Productions</title>
</head>
<body>

<h1 align="center">Krusty Cookies Productions</h1>




<ul>
  <li><a href="production.php">Production</a></li>
  <li><a href="search.php">Searching and Blocking</a></li>
</ul>



</body>
</html>

