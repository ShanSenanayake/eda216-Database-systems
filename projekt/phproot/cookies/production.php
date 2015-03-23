	<?php
	require_once('database.inc.php');
	session_start();
	$db = $_SESSION['db'];
	$db->openConnection();
	$cookies = $db->getCookieNames();
	$db->closeConnection();
	?>

<html>
<head><title>Production</title><head>
<body><h1>Production</h1>
	<form method=post action="produce.php">
		Select type of cookie:
		<br>
		<select name="cookieName" size=10>
		<?php
			$first = true;
			foreach ($cookies as $row) {
				
				if ($first) {
					print "<option selected>";
					$first = false;
				} else {
					print "<option>";
				}
				print $row['cookiename'];
			
		}
		?>
		</select>
	<br>
    Select number of pallets
	<br>
    <input type="text" size="20" name="nbrPallets" >
    <input type="submit" value="Create Batch">
</form>
<br>
<br>
<form action="index.php">
    <input type="submit" value="Return to home page">
</form>
</body>
</html>
