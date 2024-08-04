<?php
// Encabezados CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE");
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

// Obtener datos del DELETE
$producto_id = isset($_POST['producto_id']) ? $connec->real_escape_string($_POST['producto_id']) : '';

// Validar datos
if (empty($producto_id)) {
    echo json_encode(['mensaje' => 'Error', 'error' => 'ID del producto no proporcionado']);
    $connec->close();
    exit();
}

// Preparar y ejecutar la consulta SQL
$sql = "DELETE FROM tb_productos_06 WHERE id_productos = '$producto_id'";

if ($connec->query($sql) === TRUE) {
    echo json_encode(['mensaje' => 'Éxito']);
} else {
    echo json_encode(['mensaje' => 'Error', 'error' => $connec->error]);
}

// Cerrar conexión
$connec->close();
?>
