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

// Retrieve the id_menu from the request
$idMenu = $_POST['id_menu'];

// Delete the cart item from the database
$sql = "DELETE FROM cart WHERE id_menu = '$idMenu'";

if ($conn->query($sql) === TRUE) {
    echo 'Cart item deleted successfully';
} else {
    echo 'Failed to delete cart item: ' . $conn->error;
}

// Close the database connection
$conn->close();

?>
