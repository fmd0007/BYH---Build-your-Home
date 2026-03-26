DROP DATABASE IF EXISTS byh_buildyourhome;
CREATE DATABASE byh_buildyourhome CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE byh_buildyourhome;

-- =========================
-- TABLA: usuarios
-- =========================
DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  telefono VARCHAR(20) DEFAULT NULL,
  direccion VARCHAR(255) DEFAULT NULL,
  ciudad VARCHAR(100) DEFAULT NULL,
  rol ENUM('cliente','profesional','admin') NOT NULL DEFAULT 'cliente',
  estado_validacion ENUM('pendiente','validado','rechazado') DEFAULT 'pendiente',
  activo TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- TABLA: categorias
-- =========================
DROP TABLE IF EXISTS categorias;
CREATE TABLE categorias (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- TABLA: profesional_categorias
-- =========================
DROP TABLE IF EXISTS profesional_categorias;
CREATE TABLE profesional_categorias (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  profesional_id INT UNSIGNED NOT NULL,
  categoria_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_profcat (profesional_id, categoria_id),
  KEY fk_profcat_categoria (categoria_id),
  CONSTRAINT fk_profcat_profesional
    FOREIGN KEY (profesional_id) REFERENCES usuarios(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_profcat_categoria
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- TABLA: servicios
-- =========================
DROP TABLE IF EXISTS servicios;
CREATE TABLE servicios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  cliente_id INT UNSIGNED NOT NULL,
  profesional_id INT UNSIGNED NOT NULL,
  categoria_id INT UNSIGNED DEFAULT NULL,
  titulo VARCHAR(150) NOT NULL,
  descripcion TEXT NOT NULL,
  direccion_trabajo VARCHAR(255) NOT NULL,
  fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_programada DATETIME DEFAULT NULL,
  estado ENUM('pendiente','aceptado','en_proceso','completado','cancelado','rechazado') NOT NULL DEFAULT 'pendiente',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY fk_serv_cliente (cliente_id),
  KEY fk_serv_profesional (profesional_id),
  KEY fk_serv_categoria (categoria_id),
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

-- =========================
-- TABLA: valoraciones
-- =========================
DROP TABLE IF EXISTS valoraciones;
CREATE TABLE valoraciones (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  servicio_id INT UNSIGNED NOT NULL,
  puntuacion TINYINT UNSIGNED NOT NULL,
  comentario TEXT DEFAULT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_servicio_valorado (servicio_id),
  CONSTRAINT fk_val_servicio
    FOREIGN KEY (servicio_id) REFERENCES servicios(id)
    ON DELETE CASCADE,
  CONSTRAINT chk_puntuacion CHECK (puntuacion BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- DATOS INICIALES
-- =========================

INSERT INTO categorias (nombre, descripcion) VALUES
('Fontanería', 'Reparaciones e instalaciones de fontanería'),
('Electricidad', 'Instalaciones y reparaciones eléctricas'),
('Pintura', 'Pintura de interiores y exteriores'),
('Carpintería', 'Trabajos de madera y mobiliario'),
('Albañilería', 'Obras y reformas de construcción');

INSERT INTO usuarios (nombre, apellidos, email, password_hash, telefono, direccion, ciudad, rol, estado_validacion, activo)
VALUES
('Admin', 'Principal', 'admin@byh.com', '123456', NULL, NULL, 'Málaga', 'admin', 'validado', 1),
('Juan', 'Martín', 'juan@correo.com', '123456', '600111222', 'Calle Sol 12', 'Málaga', 'cliente', 'validado', 1),
('Pedro', 'López', 'pedro@correo.com', '123456', '600333444', 'Calle Luna 8', 'Málaga', 'profesional', 'validado', 1),
('Antonio', 'Ruiz', 'antonio@correo.com', '123456', '600555666', 'Avenida Mar 20', 'Málaga', 'profesional', 'pendiente', 1);

INSERT INTO profesional_categorias (profesional_id, categoria_id) VALUES
(3, 1),
(3, 2),
(4, 5);

INSERT INTO servicios (cliente_id, profesional_id, categoria_id, titulo, descripcion, direccion_trabajo, estado)
VALUES
(2, 3, 1, 'Reparación de fuga de agua', 'Tengo una fuga en el fregadero de la cocina', 'Calle Sol 12, Málaga', 'pendiente');

-- Ejemplo de valoración futura
-- INSERT INTO valoraciones (servicio_id, puntuacion, comentario)
-- VALUES (1, 5, 'Muy buen profesional, rápido y amable');
