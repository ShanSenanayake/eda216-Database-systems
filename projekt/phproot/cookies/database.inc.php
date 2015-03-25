<?php
/*
 * Class Database: interface to the movie database from PHP.
 *
 * You must:
 *
 * 1) Change the function userExists so the SQL query is appropriate for your tables.
 * 2) Write more functions.
 *
 */
class Database {
	private $host;
	private $userName;
	private $password;
	private $database;
	private $conn;
	
	/**
	 * Constructs a database object for the specified user.
	 */
	public function __construct($host, $userName, $password, $database) {
		$this->host = $host;
		$this->userName = $userName;
		$this->password = $password;
		$this->database = $database;
	}
	
	/** 
	 * Opens a connection to the database, using the earlier specified user
	 * name and password.
	 *
	 * @return true if the connection succeeded, false if the connection 
	 * couldn't be opened or the supplied user name and password were not 
	 * recognized.
	 */
	public function openConnection() {
		try {
			$this->conn = new PDO("mysql:host=$this->host;dbname=$this->database", 
					$this->userName,  $this->password);
			$this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		} catch (PDOException $e) {
			$error = "Connection error: " . $e->getMessage();
			print $error . "<p>";
			unset($this->conn);
			return false;
		}
		return true;
	}
	
	/**
	 * Closes the connection to the database.
	 */
	public function closeConnection() {
		$this->conn = null;
		unset($this->conn);
	}

	/**
	 * Checks if the connection to the database has been established.
	 *
	 * @return true if the connection has been established
	 */
	public function isConnected() {
		return isset($this->conn);
	}
	
	/**
	 * Execute a database query (select).
	 *
	 * @param $query The query string (SQL), with ? placeholders for parameters
	 * @param $param Array with parameters 
	 * @return The result set
	 */
	private function executeQuery($query, $param = null) {
		try {
			$stmt = $this->conn->prepare($query);
			$stmt->execute($param);
			$result = $stmt->fetchAll();
		} catch (PDOException $e) {
			$error = "*** Internal error: " . $e->getMessage() . "<p>" . $query;
			die($error);
		}
		return $result;
	}
	
	/**
	 * Execute a database update (insert/delete/update).
	 *
	 * @param $query The query string (SQL), with ? placeholders for parameters
	 * @param $param Array with parameters 
	 * @return The number of affected rows
	 */
	private function executeUpdate($query, $param = null) {
				try {
			$stmt = $this->conn->prepare($query);
			$stmt->execute($param);
		} catch (PDOException $e) {
			$error = "*** Internal error: " . $e->getMessage() . "<p>" . $query;
			die($error);
		}
	}
	

	/*
	 * *** Add functions ***
	 */
	public function getCookieNames(){
		$sql = "select cookiename from cookies";
		$result = $this->executeQuery($sql,null);
		return $result;
	}

	public function createBatch($cookieName,$nbrPallets){
		$sql = "select IngredientName, Amount from recipeEntries where cookieName = ?";
		$result = $this->executeQuery($sql,array($cookieName));
		$this->conn->beginTransaction();
		$sql2 = "select * from Ingredients where IngredientName = ?";
		foreach($result as $row) {
			$result2 = $this->executeQuery($sql2,array($row['IngredientName']));
			foreach($result2 as $row2){
				if($row2['Stock'] < $row['Amount']*$nbrPallets){
					$this->conn->rollback();
					return -1;
				}else{
					$stock = ($row2['Stock']- $row['Amount']*$nbrPallets);
					$ingredientName = $row['IngredientName'];
					$sql = "update ingredients set stock = ? where ingredientName = ?";
					$this->executeUpdate($sql,array($stock,$ingredientName));
				}
			}
		}
		$sql = "select curdate()";
		$date = $this->executeQuery($sql,null);
		$sql = "insert into batches values(?,null,?)";
		foreach($date as $attr){
			$this->executeUpdate($sql,array($cookieName,$attr['curdate()']));
		}
		$sql = "select last_insert_id()";
		$result = $this->executeQuery($sql,null);
		$lastID = -1;
		foreach($result as $attr){
			$lastID = $attr['last_insert_id()'];
		}
		$sql = "insert into pallets values(null,'hemma',?)";
		for($x = 0; $x<$nbrPallets;$x++){
			$this->executeUpdate($sql,array($lastID));
		}
		$this->conn->commit();
		return $lastID;
	
	
	}
	
	public function getPallets(){
		$sql = "select * from pallets where isblocked = 0";
		$result = $this->executeQuery($sql,null);
		return $result;
	}

	public function blockPallet($pallet){
		$this->setBlock(1,$pallet);
	}
	public function unblockPallet($pallet){
		$this->setBlock(0,$pallet);
	}

	public function setBlock($blockBool,$pallet){
		$sql = "update pallets set isBlocked = ? where palletId = ?";
		$this->executeUpdate($sql,array($blockBool ,$pallet)); 
	}


	public function getPalletInfo($pallet){
		$sql = "select * from pallets where palletId = ?";
		$palletInfo = $this->executeQuery($sql,array($pallet));
		return $palletInfo; 
	}

	public function getTheatreInfo($movieName, $date){
		$sql = "select * from moviePerformance where movieName = ? and performanceDate = ?";
	$result = $this->executeQuery($sql,array($movieName,$date));
	return $result;
	}
	
	public function bookTicket($movieName, $date,$user){
		$this->conn->beginTransaction();
		$sql = "select * from moviePerformance where movieName = ? and performanceDate = ?";
	$result = $this->executeQuery($sql,array($movieName,$date));
	foreach($result as $row){
		if($row['seats'] == 0){
			$this->conn->rollback();
			return -1;
		}else{
			$sql = "update movieperformance set seats = ? where performanceDate = ? and movieName =  ?";
			$seats = $row['seats'] -1;
			$this->executeUpdate($sql,array($seats,$date,$movieName));
			$sql = "insert into reservation values(null,?,?,?)";
			$this->executeUpdate($sql,array($user,$movieName,$date));
			$sql = "select last_insert_id()";
			$deli = $this->executeQuery($sql,null);
			foreach($deli as $attr){
				$this->conn->commit();
				return $attr['last_insert_id()'];
			}
		}
	}
	}
}
?>
