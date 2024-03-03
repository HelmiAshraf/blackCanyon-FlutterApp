<?php

// Assuming you have a database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "food";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Delete all data from the "receipt" table
$sqlReceipt = "DELETE FROM receipt";
if ($conn->query($sqlReceipt) === TRUE) {
    echo "Receipt data deleted successfully<br>";
} else {
    echo "Error deleting receipt data: " . $conn->error . "<br>";
}

// Delete all data from the "cart" table
$sqlCart = "DELETE FROM cart";
if ($conn->query($sqlCart) === TRUE) {
    echo "Cart data deleted successfully<br>";
} else {
    echo "Error deleting cart data: " . $conn->error . "<br>";
}

// Close the database connection
$conn->close();

?>
