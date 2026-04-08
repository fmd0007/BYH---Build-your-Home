<?php
declare(strict_types=1);

ini_set('display_errors', '0');
error_reporting(0);

require_once 'conexion.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id <= 0) {
    http_response_code(400);
    echo json_encode([
        'mensaje' => 'ID no válido'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

$sql = "
    SELECT 
        u.id,
        u.nombre,
        u.apellidos,
        u.telefono,
        u.direccion,
        u.ciudad,
        u.estado_validacion,
        GROUP_CONCAT(DISTINCT c.nombre ORDER BY c.nombre SEPARATOR ', ') AS categorias,
        COALESCE(AVG(v.puntuacion), 0) AS rating,
        COUNT(v.id) AS reviews
    FROM usuarios u
    LEFT JOIN profesional_categorias pc ON u.id = pc.profesional_id
    LEFT JOIN categorias c ON pc.categoria_id = c.id
    LEFT JOIN servicios s ON s.profesional_id = u.id
    LEFT JOIN valoraciones v ON v.servicio_id = s.id
    WHERE u.id = :id AND u.rol = 'profesional'
    GROUP BY u.id, u.nombre, u.apellidos, u.telefono, u.direccion, u.ciudad, u.estado_validacion
    LIMIT 1
";

try {
    $stmt = $conexion->prepare($sql);
    $stmt->execute([':id' => $id]);
    $fila = $stmt->fetch();

    if (!$fila) {
        http_response_code(404);
        echo json_encode([
            'mensaje' => 'Profesional no encontrado'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    $nombreCompleto = trim($fila['nombre'] . ' ' . $fila['apellidos']);
    $categorias = $fila['categorias'] ?: 'Profesional del hogar';

    echo json_encode([
        'profesional' => [
            'id' => (int)$fila['id'],
            'nombre' => $nombreCompleto,
            'profesion' => $categorias,
            'rating' => round((float)$fila['rating'], 1),
            'reviews' => (int)$fila['reviews'],
            'ubicacion' => $fila['ciudad'] ?: 'Sin ubicación',
            'img' => 'https://via.placeholder.com/400x300?text=BYH',
            'verificado' => ($fila['estado_validacion'] === 'validado')
        ],
        'descripcion' => 'Profesional con experiencia en el sector, atención personalizada y trabajo garantizado.',
        'telefono' => $fila['telefono'],
        'direccion' => $fila['direccion']
    ], JSON_UNESCAPED_UNICODE);

} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'mensaje' => 'Error al cargar el perfil'
    ], JSON_UNESCAPED_UNICODE);
}