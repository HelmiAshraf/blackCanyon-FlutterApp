<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "food";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

// Fetch menus from the database
$sql = 'SELECT * FROM menu';
$result = $conn->query($sql);

$menus = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $menus[] = $row;
    }
}

// Return the menus as JSON response
header('Content-Type: application/json');
echo json_encode($menus);

// Close the database connection
$conn->close();

?>