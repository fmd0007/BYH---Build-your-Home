<?php
header('Content-Type: application/json; charset=utf-8');

$host = 'sql202.infinityfree.com';
$dbname = 'byh_database';   
$user = 'if0_41669466';
$pass = 'rafaelsabio1';         

try {
    $conexion = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $user,
        $pass
    );
    $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch (PDOException $e) {
    echo json_encode(["mensaje" => "Error de conexión"]);
    exit;
}
