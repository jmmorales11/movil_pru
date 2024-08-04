<?php

//CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: *");

$servername = "localhost:3307";
$username = "root";
$password = "root";
$dbname = "pruba";

// Create connection
$connection = new mysqli($servername, $username, $password, $dbname);

if ($connection-> connect_error) {
    die("Fail Connection bb " . $connection->connect_error);
} 

//consulta
$query =  "SELECT * FROM tb_productos_06";
$resultados = $connection->query($query);

//procesamiento de datos
$data = [];

if ($resultados->num_rows > 0) {
    $data = $resultados->fetch_all(MYSQLI_ASSOC);
} 

echo json_encode($data);

//cerrar conexion
$connection->close();


?>