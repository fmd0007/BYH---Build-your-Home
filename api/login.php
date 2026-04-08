<?php
declare(strict_types=1);

ini_set('display_errors', '0');
error_reporting(0);

require_once 'conexion.php';

$input = json_decode(file_get_contents('php://input'), true);

if (!is_array($input)) {
    http_response_code(400);
    echo json_encode([
        'mensaje' => 'Datos no válidos'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

$email = trim((string)($input['email'] ?? ''));
$password = (string)($input['password'] ?? '');

if ($email === '' || $password === '') {
    http_response_code(400);
    echo json_encode([
        'mensaje' => 'Faltan credenciales'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

try {
    $stmt = $conexion->prepare("
        SELECT id, nombre, apellidos, email, password_hash, rol, estado_validacion, activo
        FROM usuarios
        WHERE email = :email
        LIMIT 1
    ");
    $stmt->execute([':email' => $email]);
    $usuario = $stmt->fetch();

    if (!$usuario) {
        http_response_code(401);
        echo json_encode([
            'mensaje' => 'Correo o contraseña incorrectos'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    if ((int)$usuario['activo'] !== 1) {
        http_response_code(403);
        echo json_encode([
            'mensaje' => 'La cuenta está desactivada'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    if (!password_verify($password, $usuario['password_hash'])) {
        http_response_code(401);
        echo json_encode([
            'mensaje' => 'Correo o contraseña incorrectos'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    echo json_encode([
        'mensaje' => 'Inicio de sesión correcto',
        'usuario' => [
            'id' => (int)$usuario['id'],
            'nombre' => trim($usuario['nombre'] . ' ' . $usuario['apellidos']),
            'email' => $usuario['email'],
            'rol' => $usuario['rol'],
            'estado_validacion' => $usuario['estado_validacion']
        ]
    ], JSON_UNESCAPED_UNICODE);

} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'mensaje' => 'Error al iniciar sesión'
    ], JSON_UNESCAPED_UNICODE);
}