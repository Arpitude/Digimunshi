<?php
include "cors.php";
session_start();
include "db.php";


$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["status" => "error", "message" => "Invalid JSON body"]);
    exit();
}

$name = isset($data["name"]) ? mysqli_real_escape_string($conn, $data["name"]) : '';
$email = isset($data["email"]) ? mysqli_real_escape_string($conn, $data["email"]) : '';
$password = isset($data["password"]) ? password_hash($data["password"], PASSWORD_DEFAULT) : '';

if (!$name || !$email || !$password) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit();
}

$q = "INSERT INTO users (name, email, password) 
      VALUES ('$name', '$email', '$password')";

if (mysqli_query($conn, $q)) {
    echo json_encode(["status" => "success", "message" => "Registration successful"]);
} else {
    echo json_encode(["status" => "error", "message" => "Email already exists or database error: " . mysqli_error($conn)]);
}
?>
