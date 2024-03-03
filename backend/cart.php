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

// Retrieve the phone number from the query parameters
$phnum = $_GET['phnum'];

// Fetch cart items for the given phone number from the database
$sql = "SELECT menu.id, menu.name, menu.price, cart.qty
FROM cart
INNER JOIN menu ON cart.id_menu = menu.id
WHERE cart.phnum ='$phnum'";
$result = $conn->query($sql);

$cartItems = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $cartItems[] = $row;
    }
}

// Return the cart items as JSON response
header('Content-Type: application/json');
echo json_encode($cartItems);

// Close the database connection
$conn->close();

?>