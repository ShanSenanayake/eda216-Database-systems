<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$db->openConnection();
	$pallets = $db->getPallets();
	$db->closeConnection();
?>

<html>
<head><title>Search and Block</title><head>
<body><h1>Search and Block</h1>
<form method=post action="block.php">
		Select pallet to block:
		<br>
		<select name="pallet" size=10>
		<?php
			$first = true;
			foreach ($pallets as $row) {
				
				if ($first) {
					print "<option selected>";
					$first = false;
				} else {
					print "<option>";
				}
				print $row['PalletID'] . " " . $row['Location'];
			
		}
		?>
		</select>
		<br>
    <input type="submit" value="Block">
</form>
<form method=post action="search.php">
 Search for pallet with ID:
	<br>
    <input type="text" size="20" name="pallet" >
    <input type="submit" value="Search">
</form>
<form action="index.php">
    <input type="submit" value="Return to home page">
</form>

</body>
</html>
