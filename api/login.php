<?php
require_once 'conexion.php';

$data = json_decode(file_get_contents("php://input"), true);

$email = $data['email'];
$password = $data['password'];

$stmt = $conexion->prepare("SELECT * FROM usuarios WHERE email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch();

if ($user && password_verify($password, $user['password'])) {

    echo json_encode([
        "usuario" => [
            "id" => $user['id'],
            "nombre" => $user['nombre'],
            "email" => $user['email'],
            "tipo" => $user['tipo']
        ]
    ]);

} else {
    echo json_encode(["mensaje" => "Login incorrecto"]);
}
