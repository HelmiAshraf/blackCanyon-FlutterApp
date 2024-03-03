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

// Retrieve the parameters from the request body
$phnum = $_POST['phnum'];
$id_menu = $_POST['id_menu'];
$quantity = $_POST['quantity'];
$price = $_POST['price'];

// Update the cart item quantity and price in the database
$sql = "UPDATE cart SET qty = '$quantity', price = '$price' WHERE phnum = '$phnum' AND id_menu = '$id_menu'";

if ($conn->query($sql) === TRUE) {
    // Cart item quantity and price updated successfully
    echo 'Cart item quantity and price updated successfully';
} else {
    // Failed to update cart item quantity and price
    echo 'Failed to update cart item quantity and price: ' . $conn->error;
}

// Close the database connection
$conn->close();
