<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$pallet = $_REQUEST['pallet'];
	$db->openConnection();
	$pallet = $db->getPalletInfo($pallet);
	$db->closeConnection();

?>

<html>
<head><title>Search Result</title><head>
<body><h1>Search Result</h1>
	<?php 
		if(empty($pallet)){
			print "No such pallet exists";
		}else{
			foreach($pallet as $row){
				if($row['isBlocked'] == 1){ ?>
					<form method="post" action="unblock.php">
					<?php 
						print $row['PalletID'] . " " . $row['Location'] . " Yes"; 
						$_SESSION['unblock'] = $row['PalletID'];
						?>
					<input type=submit value="Unblock">
				<?php }else{ ?>
					<form method="post" action="block2.php">
					<?php 
						print $row['PalletID'] . " " . $row['Location'] . " No"; 
						$_SESSION['block'] = $row['PalletID'];
						?>
					<input type=submit value="Block">
				<?php }		
			}
		} ?>
<br>
<form method="post" action="index.php">
	<input type=submit value="Return to home page">
</form>	
</body>
</html>
