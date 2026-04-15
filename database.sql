
-- =========================
-- TABLA: categorias
-- =========================
CREATE TABLE categorias (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(255)
);

INSERT INTO categorias (nombre, descripcion) VALUES
('Fontanería', 'Reparaciones e instalaciones de fontanería'),
('Electricidad', 'Instalaciones y reparaciones eléctricas'),
('Pintura', 'Trabajos de pintura'),
('Carpintería', 'Trabajos de madera'),
('Albañilería', 'Reformas y obras');

-- =========================
-- TABLA: usuarios
-- =========================
CREATE TABLE usuarios (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  telefono VARCHAR(20),
  direccion VARCHAR(255),
  ciudad VARCHAR(100),
  rol ENUM('cliente','profesional','admin') DEFAULT 'cliente',
  estado_validacion ENUM('pendiente','validado','rechazado') DEFAULT 'pendiente',
  activo TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Admin (contraseña: admin123)
INSERT INTO usuarios (nombre, apellidos, email, password_hash, ciudad, rol, estado_validacion) VALUES
('Admin','Principal','admin@byh.com','$2y$10$lNBi0mOLCZ4sQ7Y0D4yTo.PY2iD2U4xj7x0xKQ6Q6lqjD4Nf0p8S6','Málaga','admin','validado');

-- Profesionales de prueba
INSERT INTO usuarios (nombre, apellidos, email, password_hash, telefono, direccion, ciudad, rol, estado_validacion) VALUES
('Carlos','Mendoza','carlos@byh.com','$2y$10$lNBi0mOLCZ4sQ7Y0D4yTo.PY2iD2U4xj7x0xKQ6Q6lqjD4Nf0p8S6','600111111','Calle Reforma 1','Málaga','profesional','validado'),
('Laura','Sánchez','laura@byh.com','$2y$10$lNBi0mOLCZ4sQ7Y0D4yTo.PY2iD2U4xj7x0xKQ6Q6lqjD4Nf0p8S6','600222222','Avenida Centro 12','Málaga','profesional','validado'),
('Miguel','Torres','miguel@byh.com','$2y$10$lNBi0mOLCZ4sQ7Y0D4yTo.PY2iD2U4xj7x0xKQ6Q6lqjD4Nf0p8S6','600333333','Calle Jardín 8','Málaga','profesional','validado'),
('Ana','Ramírez','ana@byh.com','$2y$10$lNBi0mOLCZ4sQ7Y0D4yTo.PY2iD2U4xj7x0xKQ6Q6lqjD4Nf0p8S6','600444444','Plaza Norte 3','Málaga','profesional','validado');

-- Cliente de prueba
INSERT INTO usuarios (nombre, apellidos, email, password_hash, ciudad, rol, estado_validacion) VALUES
('Paco','Gómez','paco@byh.com','$2y$10$lNBi0mOLCZ4sQ7Y0D4yTo.PY2iD2U4xj7x0xKQ6Q6lqjD4Nf0p8S6','Málaga','cliente','validado');

-- =========================
-- TABLA: profesional_categorias
-- =========================
CREATE TABLE profesional_categorias (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  profesional_id INT UNSIGNED,
  categoria_id INT UNSIGNED,
  FOREIGN KEY (profesional_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
);

INSERT INTO profesional_categorias (profesional_id, categoria_id) VALUES
(2,5), -- Albañilería
(3,2), -- Electricidad
(4,1), -- Fontanería
(5,3); -- Pintura

-- =========================
-- TABLA: servicios
-- =========================
CREATE TABLE servicios (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT UNSIGNED,
  profesional_id INT UNSIGNED,
  categoria_id INT UNSIGNED,
  titulo VARCHAR(150),
  descripcion TEXT,
  direccion_trabajo VARCHAR(255),
  estado ENUM('pendiente','aceptado','en_proceso','completado','cancelado','rechazado') DEFAULT 'pendiente',
  FOREIGN KEY (cliente_id) REFERENCES usuarios(id),
  FOREIGN KEY (profesional_id) REFERENCES usuarios(id),
  FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- =========================
-- TABLA: valoraciones
-- =========================
CREATE TABLE valoraciones (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  servicio_id INT UNSIGNED,
  puntuacion TINYINT,
  comentario TEXT,
  FOREIGN KEY (servicio_id) REFERENCES servicios(id)
);
