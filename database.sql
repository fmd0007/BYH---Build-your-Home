-- ========================
-- BASE DE DATOS
-- ========================
CREATE DATABASE buildyourhome;
USE buildyourhome;

-- ========================
-- USUARIOS
-- ========================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellidos VARCHAR(150),
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    password VARCHAR(255),
    tipo ENUM('cliente','trabajador'),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- CATEGORÍAS
-- ========================
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    categoria_padre INT NULL,
);

-- ========================
-- PROFESIONALES
-- ========================
CREATE TABLE profesionales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_categoria INT,
    descripcion TEXT,
    experiencia INT,
    puntuacion DECIMAL(2,1) DEFAULT 0,
    ubicacion VARCHAR(150),
    imagen VARCHAR(255),
    verificado BOOLEAN DEFAULT TRUE,
);

-- ========================
-- MENSAJES (CHAT)
-- ========================
CREATE TABLE mensajes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_emisor INT,
    id_receptor INT,
    mensaje TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

-- ========================
-- VALORACIONES
-- ========================
CREATE TABLE valoraciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_profesional INT,
    estrellas INT CHECK (estrellas BETWEEN 1 AND 5),
    comentario TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

-- ========================
-- CONTRATACIONES / PAGOS
-- ========================
CREATE TABLE contrataciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_profesional INT,
    precio DECIMAL(10,2),
    metodo_pago ENUM('tarjeta','bizum','transferencia'),
    estado ENUM('pendiente','pagado','cancelado') DEFAULT 'pendiente',
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);
