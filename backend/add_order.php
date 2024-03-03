<?php

// Database configuration
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

// Retrieve the parameters from the POST request
$phnum = $_POST['phnum'];
$totalPrice = $_POST['total_price'];
$date = $_POST['date'];

// Insert the order into the database
$sql = "INSERT INTO receipt (phnum, date, totalprice) VALUES ('$phnum', '$date', '$totalPrice')";

if ($conn->query($sql) === TRUE) {
    echo 'Order added successfully';
} else {
    echo 'Failed to add order';
}

// Close the database connection
$conn->close();

?>
