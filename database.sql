-- BYH - Build Your Home

DROP DATABASE IF EXISTS byh_buildyourhome;
CREATE DATABASE byh_buildyourhome CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE byh_buildyourhome;

DROP TABLE IF EXISTS valoraciones;
DROP TABLE IF EXISTS servicios;
DROP TABLE IF EXISTS portafolio_fotos;
DROP TABLE IF EXISTS profesional_categorias;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS categorias;

CREATE TABLE categorias (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_categoria_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO categorias (id, nombre, descripcion) VALUES
(1,'Fontanería','Reparaciones e instalaciones de fontanería'),
(2,'Electricidad','Instalaciones y reparaciones eléctricas'),
(3,'Pintura','Pintura de interiores y exteriores'),
(4,'Carpintería','Trabajos de madera y mobiliario'),
(5,'Albañilería','Obras y reformas de construcción');

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

-- Contraseña del admin: admin123
INSERT INTO usuarios (id, nombre, apellidos, email, password_hash, telefono, direccion, ciudad, rol, estado_validacion, activo, created_at) VALUES
(1,'Admin','Principal','admin@byh.com','$2y$10$lNBi0mOLCZ4sQ7Y0D4yTo.PY2iD2U4xj7x0xKQ6Q6lqjD4Nf0p8S6',NULL,NULL,'Málaga','admin','validado',1,NOW());

CREATE TABLE profesional_categorias (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  profesional_id INT UNSIGNED NOT NULL,
  categoria_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_profcat (profesional_id, categoria_id),
  KEY fk_profcat_categoria (categoria_id),
  CONSTRAINT fk_profcat_categoria FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE CASCADE,
  CONSTRAINT fk_profcat_profesional FOREIGN KEY (profesional_id) REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE portafolio_fotos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  profesional_id INT UNSIGNED NOT NULL,
  url_foto VARCHAR(255) NOT NULL,
  descripcion VARCHAR(255) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY fk_foto_profesional (profesional_id),
  CONSTRAINT fk_foto_profesional FOREIGN KEY (profesional_id) REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  CONSTRAINT fk_serv_categoria FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE SET NULL,
  CONSTRAINT fk_serv_cliente FOREIGN KEY (cliente_id) REFERENCES usuarios (id) ON DELETE CASCADE,
  CONSTRAINT fk_serv_profesional FOREIGN KEY (profesional_id) REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE valoraciones (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  servicio_id INT UNSIGNED NOT NULL,
  puntuacion TINYINT UNSIGNED NOT NULL,
  comentario TEXT DEFAULT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_val_servicio (servicio_id),
  CONSTRAINT fk_val_servicio FOREIGN KEY (servicio_id) REFERENCES servicios (id) ON DELETE CASCADE,
  CONSTRAINT chk_puntuacion CHECK (puntuacion BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
