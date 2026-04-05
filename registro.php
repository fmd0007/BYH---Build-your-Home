<?php
header("Content-Type: application/json");
require_once "conexion.php";

$data = json_decode(file_get_contents("php://input"), true);

$nombre = $data["nombre"] ?? "";
$apellidos = $data["apellidos"] ?? "";
$email = $data["email"] ?? "";
$password = $data["password"] ?? "";
$rol = $data["rol"] ?? "cliente";

if (!$nombre || !$email || !$password) {
    echo json_encode(["ok" => false, "mensaje" => "Faltan datos"]);
    exit;
}

$password_hash = password_hash($password, PASSWORD_DEFAULT);

$sql = "INSERT INTO usuarios (nombre, apellidos, email, password_hash, rol, estado_validacion, activo)
        VALUES (?, ?, ?, ?, ?, 'pendiente', 1)";
$stmt = $conexion->prepare($sql);

try {
    $stmt->execute([$nombre, $apellidos, $email, $password_hash, $rol]);
    echo json_encode(["ok" => true, "mensaje" => "Usuario registrado"]);
} catch (PDOException $e) {
    echo json_encode(["ok" => false, "mensaje" => "Error al registrar"]);
}
?>
