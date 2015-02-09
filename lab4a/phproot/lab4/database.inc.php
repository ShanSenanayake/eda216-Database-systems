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
			$result = $stmt->fetchAll();
		} catch (PDOException $e) {
			$error = "*** Internal error: " . $e->getMessage() . "<p>" . $query;
			die($error);
		}
		return $result;
	}
	
	/**
	 * Check if a user with the specified user id exists in the database.
	 * Queries the Users database table.
	 *
	 * @param userId The user id 
	 * @return true if the user exists, false otherwise.
	 */
	public function userExists($userId) {
		$sql = "select username from Users where username = ?";
		$result = $this->executeQuery($sql, array($userId));
		return count($result) == 1; 
	}

	/*
	 * *** Add functions ***
	 */
	public function getMovieNames(){
		$sql = "select moviename from movies";
		$result = $this->executeQuery($sql,null);
		return $result;
	}

	public function getDates($movieName){
		$sql = "select performanceDate from movieperformance where moviename = ?";
		$result = $this->executeQuery($sql,array($movieName));
		return $result;
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
			$this->executeQuery($sql,array($seats,$date,$movieName));
			$sql = "insert into reservation values(null,?,?,?)";
			$deli =$this->executeQuery($sql,array($user,$movieName,$date));
			foreach($deli as $attr){
				$this->conn->commit();
				return $deli['ID'];
			}
		}
	}
	}
}
?>
