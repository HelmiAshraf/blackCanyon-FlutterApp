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

// Fetch order details for the given phone number from the database
$sql = "SELECT u.opt, u.name as customer_name,u.phnum as customer_phnum, r.date, m.name as menu_name, ct.qty, m.price, r.totalprice
FROM user u
INNER JOIN receipt r ON u.phnum = r.phnum
INNER JOIN cart ct ON u.phnum = ct.phnum
INNER JOIN menu m ON ct.id_menu = m.id
WHERE u.phnum = '$phnum'";

$result = $conn->query($sql);

$orderDetails = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $orderDetails[] = $row;
    }
}

// Return the response as JSON
header('Content-Type: application/json');
echo json_encode($orderDetails);

// Close the database connection
$conn->close();

?>