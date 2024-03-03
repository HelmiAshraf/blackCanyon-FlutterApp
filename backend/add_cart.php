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

// Get the phnum and id_menu from the request body
$phnum = $_POST['phnum'];
$idMenu = $_POST['id_menu'];

$query = "SELECT price FROM menu where id=$idMenu";

// Execute the query
$result = mysqli_query($conn, $query);

if ($result) {
    // Check if any rows were returned
    if (mysqli_num_rows($result) > 0) {
        // Fetch the result row as an associative array
        $row = mysqli_fetch_assoc($result);

        // Access the price value
        $price = $row['price'];
    } }

// Prepare and bind the SQL statement
$stmt = $conn->prepare('INSERT INTO cart (phnum, id_menu, price) VALUES (?, ?, ?)');
$stmt->bind_param('ssi', $phnum, $idMenu, $price);

// Execute the statement
if ($stmt->execute() === TRUE) {
    // Item successfully added to the cart
    echo 'Item added to cart';
} else {
    // Failed to add item to cart
    echo 'Failed to add item to cart';
}

// Close the prepared statement and database connection
$stmt->close();
$conn->close();
