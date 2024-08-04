<?php
// Encabezados CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Configuración de la base de datos
$servername = "localhost:3307";
$username = "root";
$password = "root";
$dbname = "pruba";

// Crear conexión
$connec = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($connec->connect_error) {
    die("Conexión fallida: " . $connec->connect_error);
}

// Obtener datos del POST
$nombre_producto = isset($_POST['nombre_productos']) ? $connec->real_escape_string($_POST['nombre_productos']) : '';
$precio_producto = isset($_POST['precio_producto']) ? $connec->real_escape_string($_POST['precio_producto']) : '';

// Validar datos
if (empty($nombre_producto) || empty($precio_producto)) {
    echo json_encode(['mensaje' => 'Error', 'error' => 'Datos incompletos']);
    $connec->close();
    exit();
}

// Preparar y ejecutar la consulta SQL
$sql = "INSERT INTO tb_productos_06 (nombre_productos, precio_producto) VALUES ('$nombre_producto', '$precio_producto')";

if ($connec->query($sql) === TRUE) {
    echo json_encode(['mensaje' => 'Éxito']);
} else {
    echo json_encode(['mensaje' => 'Error', 'error' => $connec->error]);
}

// Cerrar conexión
$connec->close();
?>
