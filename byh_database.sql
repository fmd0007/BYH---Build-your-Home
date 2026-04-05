-- BYH - Build Your Home
-- Base de datos conceptual del proyecto

DROP DATABASE IF EXISTS byh_buildyourhome;
CREATE DATABASE byh_buildyourhome CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE byh_buildyourhome;

-- TABLA: usuarios
-- Guarda clientes, profesionales y admin
CREATE TABLE usuarios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) DEFAULT NULL,
    direccion VARCHAR(255) DEFAULT NULL,
    ciudad VARCHAR(100) DEFAULT NULL,
    rol ENUM('cliente', 'profesional', 'admin') NOT NULL DEFAULT 'cliente',
    estado_validacion ENUM('pendiente', 'validado', 'rechazado') DEFAULT 'pendiente',
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA: categorias
-- Tipos de servicios disponibles
CREATE TABLE categorias (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA: profesional_categorias
-- Relación entre profesionales y categorías
-- Un profesional puede ofrecer varios servicios
CREATE TABLE profesional_categorias (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    profesional_id INT UNSIGNED NOT NULL,
    categoria_id INT UNSIGNED NOT NULL,
    UNIQUE KEY uq_profcat (profesional_id, categoria_id),
    CONSTRAINT fk_profcat_profesional
        FOREIGN KEY (profesional_id) REFERENCES usuarios(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_profcat_categoria
        FOREIGN KEY (categoria_id) REFERENCES categorias(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA: servicios
-- Solicitudes realizadas por los clientes
CREATE TABLE servicios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT UNSIGNED NOT NULL,
    profesional_id INT UNSIGNED NOT NULL,
    categoria_id INT UNSIGNED DEFAULT NULL,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    direccion_trabajo VARCHAR(255) NOT NULL,
    fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_programada DATETIME DEFAULT NULL,
    estado ENUM('pendiente', 'aceptado', 'en_proceso', 'completado', 'cancelado', 'rechazado') NOT NULL DEFAULT 'pendiente',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_serv_cliente
        FOREIGN KEY (cliente_id) REFERENCES usuarios(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_serv_profesional
        FOREIGN KEY (profesional_id) REFERENCES usuarios(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_serv_categoria
        FOREIGN KEY (categoria_id) REFERENCES categorias(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA: valoraciones
-- Opiniones de los clientes tras finalizar un servicio
CREATE TABLE valoraciones (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    servicio_id INT UNSIGNED NOT NULL UNIQUE,
    puntuacion TINYINT UNSIGNED NOT NULL,
    comentario TEXT DEFAULT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_val_servicio
        FOREIGN KEY (servicio_id) REFERENCES servicios(id)
        ON DELETE CASCADE,
    CONSTRAINT chk_puntuacion CHECK (puntuacion BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- DATOS INICIALES DE PRUEBA

INSERT INTO categorias (nombre, descripcion) VALUES
('Fontanería', 'Reparaciones e instalaciones de fontanería'),
('Electricidad', 'Instalaciones y reparaciones eléctricas'),
('Pintura', 'Trabajos de pintura interior y exterior'),
('Carpintería', 'Trabajos de madera y montaje'),
('Albañilería', 'Reformas y pequeñas obras');

INSERT INTO usuarios (nombre, apellidos, email, password_hash, telefono, direccion, ciudad, rol, estado_validacion, activo) VALUES
('Admin', 'Principal', 'admin@byh.com', '123456', NULL, NULL, 'Málaga', 'admin', 'validado', 1),
('Paco', 'Gómez', 'paco@correo.com', '123456', '600111222', 'Calle Sol 12', 'Málaga', 'cliente', 'validado', 1),
('Pablo', 'López', 'pablo@correo.com', '123456', '600333444', 'Avenida del Mar 10', 'Málaga', 'profesional', 'validado', 1),
('Rafael', 'Ruiz', 'rafa@correo.com', '123456', '600555666', 'Calle Luna 8', 'Málaga', 'profesional', 'pendiente', 1);

INSERT INTO profesional_categorias (profesional_id, categoria_id) VALUES
(3, 1),
(3, 2),
(4, 5);

INSERT INTO servicios (cliente_id, profesional_id, categoria_id, titulo, descripcion, direccion_trabajo, estado) VALUES
(2, 3, 1, 'Arreglo de fuga en cocina', 'Necesito reparar una fuga de agua debajo del fregadero.', 'Calle Sol 12, Málaga', 'pendiente');
