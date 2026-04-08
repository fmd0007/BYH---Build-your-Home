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

$nombre = trim((string)($input['nombre'] ?? ''));
$apellidos = trim((string)($input['apellidos'] ?? ''));
$email = trim((string)($input['email'] ?? ''));
$password = (string)($input['password'] ?? '');
$rol = trim((string)($input['rol'] ?? 'cliente'));
$especialidad = trim((string)($input['especialidad'] ?? ''));

if ($nombre === '' || $email === '' || $password === '') {
    http_response_code(400);
    echo json_encode([
        'mensaje' => 'Faltan campos obligatorios'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode([
        'mensaje' => 'Correo electrónico no válido'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

if (!in_array($rol, ['cliente', 'profesional'], true)) {
    http_response_code(400);
    echo json_encode([
        'mensaje' => 'Rol no válido'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

try {
    $check = $conexion->prepare("SELECT id FROM usuarios WHERE email = :email LIMIT 1");
    $check->execute([':email' => $email]);

    if ($check->fetch()) {
        http_response_code(409);
        echo json_encode([
            'mensaje' => 'Ese correo ya está registrado'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    $passwordHash = password_hash($password, PASSWORD_DEFAULT);
    $estadoValidacion = ($rol === 'profesional') ? 'pendiente' : 'validado';

    $stmt = $conexion->prepare("
        INSERT INTO usuarios (
            nombre, apellidos, email, password_hash, telefono, direccion, ciudad, rol, estado_validacion, activo, created_at
        ) VALUES (
            :nombre, :apellidos, :email, :password_hash, NULL, NULL, NULL, :rol, :estado_validacion, 1, NOW()
        )
    ");

    $stmt->execute([
        ':nombre' => $nombre,
        ':apellidos' => $apellidos,
        ':email' => $email,
        ':password_hash' => $passwordHash,
        ':rol' => $rol,
        ':estado_validacion' => $estadoValidacion
    ]);

    $usuarioId = (int)$conexion->lastInsertId();

    if ($rol === 'profesional' && $especialidad !== '') {
        $buscarCategoria = $conexion->prepare("SELECT id FROM categorias WHERE nombre = :nombre LIMIT 1");
        $buscarCategoria->execute([':nombre' => $especialidad]);
        $categoria = $buscarCategoria->fetch();

        if ($categoria) {
            $insertRelacion = $conexion->prepare("
                INSERT INTO profesional_categorias (profesional_id, categoria_id)
                VALUES (:profesional_id, :categoria_id)
            ");
            $insertRelacion->execute([
                ':profesional_id' => $usuarioId,
                ':categoria_id' => $categoria['id']
            ]);
        }
    }

    echo json_encode([
        'mensaje' => 'Usuario registrado correctamente',
        'usuario' => [
            'id' => $usuarioId,
            'nombre' => trim($nombre . ' ' . $apellidos),
            'email' => $email,
            'rol' => $rol,
            'estado_validacion' => $estadoValidacion
        ]
    ], JSON_UNESCAPED_UNICODE);

} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'mensaje' => 'Error al registrar el usuario'
    ], JSON_UNESCAPED_UNICODE);
}