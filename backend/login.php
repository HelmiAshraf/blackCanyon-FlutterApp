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

// Retrieve data from the Flutter app
$name = $_POST['name'];
$phoneNumber = $_POST['phone_number'];
$option = $_POST['option'];

// Insert the data into the database
$sql = "INSERT INTO user (name, phnum, opt) VALUES ('$name', '$phoneNumber', '$option')";

if ($conn->query($sql) === true) {
    // Data inserted successfully
    echo 'Data inserted successfully';
} else {
    // Error occurred while inserting data
    echo 'Error: ' . $sql . '<br>' . $conn->error;
}

// Close the database connection
$conn->close();

?>