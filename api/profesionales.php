<?php
declare(strict_types=1);

require_once 'conexion.php';

$cat = $_GET['cat'] ?? 'todas';

$sql = "
    SELECT 
        u.id,
        u.nombre,
        u.apellidos,
        u.ciudad,
        u.estado_validacion,
        c.nombre AS categoria_nombre,
        c.descripcion AS categoria_descripcion
    FROM usuarios u
    LEFT JOIN profesional_categorias pc ON u.id = pc.profesional_id
    LEFT JOIN categorias c ON pc.categoria_id = c.id
    WHERE u.rol = 'profesional'
";

$params = [];

if ($cat !== 'todas') {
    $mapa = [
        'albanileria' => 'Albañilería',
        'electricista' => 'Electricidad',
        'fontaneria' => 'Fontanería',
        'pintura' => 'Pintura',
        'reformas' => 'Carpintería',
        'limpieza' => 'Limpieza'
    ];

    if (isset($mapa[$cat])) {
        $sql .= " AND c.nombre = :categoria";
        $params[':categoria'] = $mapa[$cat];
    }
}

$sql .= " ORDER BY u.id DESC";

$stmt = $conexion->prepare($sql);
$stmt->execute($params);
$resultados = $stmt->fetchAll();

$profesionales = [];

foreach ($resultados as $fila) {
    $nombreCompleto = trim($fila['nombre'] . ' ' . $fila['apellidos']);

    $categoriaSlug = strtolower($fila['categoria_nombre'] ?? '');
    $categoriaSlug = str_replace(
        ['á', 'é', 'í', 'ó', 'ú', 'ñ', ' '],
        ['a', 'e', 'i', 'o', 'u', 'n', '_'],
        $categoriaSlug
    );

    $profesionales[] = [
        'id' => (int)$fila['id'],
        'nombre' => $nombreCompleto,
        'profesion' => $fila['categoria_nombre'] ?? 'Profesional del hogar',
        'categoria' => $categoriaSlug,
        'rating' => 4.8,
        'reviews' => 12,
        'ubicacion' => $fila['ciudad'] ?? 'Sin ubicación',
        'img' => 'https://via.placeholder.com/400x300?text=BYH',
        'verificado' => $fila['estado_validacion'] === 'validado'
    ];
}

echo json_encode($profesionales, JSON_UNESCAPED_UNICODE);