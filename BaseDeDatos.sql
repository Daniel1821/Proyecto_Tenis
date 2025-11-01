CREATE DATABASE IF NOT EXISTS proyecto_tenis
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE proyecto_tenis;

CREATE TABLE IF NOT EXISTS categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  UNIQUE KEY uk_categoria_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tenis (
  id_tenis     INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  precio       DECIMAL(10,2) NOT NULL,
  marca        VARCHAR(100),
  descripcion  VARCHAR(500),
  imagen       VARCHAR(255),
  id_categoria INT,
  CONSTRAINT fk_tenis_categoria
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
    ON UPDATE CASCADE ON DELETE SET NULL,
  INDEX idx_tenis_categoria (id_categoria),
  INDEX idx_tenis_nombre (nombre),
  INDEX idx_tenis_marca (marca)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS administrador (
  id_admin INT AUTO_INCREMENT PRIMARY KEY,
  usuario  VARCHAR(50)  NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL              
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(100) NOT NULL,
  correo     VARCHAR(100) NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,          
  telefono   VARCHAR(20),
  direccion  VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS carrito (
  id_carrito     INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente     INT NOT NULL,
  estado         ENUM('ABIERTO','PAGADO') NOT NULL DEFAULT 'ABIERTO',
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_carrito_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
    ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_carrito_cliente (id_cliente)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS carrito_detalle (
  id_detalle   INT AUTO_INCREMENT PRIMARY KEY,
  id_carrito   INT NOT NULL,
  id_tenis     INT NOT NULL,
  cantidad     INT NOT NULL DEFAULT 1,
  precio_unit  DECIMAL(10,2) NOT NULL,  -- precio al momento de agregar
  CONSTRAINT fk_cd_carrito FOREIGN KEY (id_carrito) REFERENCES carrito(id_carrito)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_cd_tenis   FOREIGN KEY (id_tenis)   REFERENCES tenis(id_tenis)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  UNIQUE KEY uk_item_unico (id_carrito, id_tenis),
  INDEX idx_cd_carrito (id_carrito),
  INDEX idx_cd_tenis (id_tenis)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orden (
  id_orden   INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  fecha      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total      DECIMAL(10,2) NOT NULL,
  estado     ENUM('PENDIENTE','PAGADA','CANCELADA') NOT NULL DEFAULT 'PENDIENTE',
  CONSTRAINT fk_orden_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_orden_cliente (id_cliente),
  INDEX idx_orden_fecha (fecha)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orden_detalle (
  id_detalle  INT AUTO_INCREMENT PRIMARY KEY,
  id_orden    INT NOT NULL,
  id_tenis    INT NOT NULL,
  cantidad    INT NOT NULL,
  precio_unit DECIMAL(10,2) NOT NULL,
  subtotal    DECIMAL(10,2) AS (cantidad * precio_unit) STORED,
  CONSTRAINT fk_od_orden FOREIGN KEY (id_orden) REFERENCES orden(id_orden)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_od_tenis FOREIGN KEY (id_tenis) REFERENCES tenis(id_tenis)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_od_orden (id_orden),
  INDEX idx_od_tenis (id_tenis)
) ENGINE=InnoDB;

INSERT INTO administrador (usuario, password)
SELECT 'admin', 'admin123'
WHERE NOT EXISTS (SELECT 1 FROM administrador WHERE usuario='admin');

INSERT INTO categoria (nombre)
SELECT * FROM (SELECT 'Deportivos') AS t
WHERE NOT EXISTS (SELECT 1 FROM categoria WHERE nombre='Deportivos');
INSERT INTO categoria (nombre)
SELECT * FROM (SELECT 'Casuales') AS t
WHERE NOT EXISTS (SELECT 1 FROM categoria WHERE nombre='Casuales');
INSERT INTO categoria (nombre)
SELECT * FROM (SELECT 'Edición Limitada') AS t
WHERE NOT EXISTS (SELECT 1 FROM categoria WHERE nombre='Edición Limitada');

INSERT INTO tenis (nombre, precio, marca, descripcion, imagen, id_categoria)
SELECT * FROM (
  SELECT 'Nike Air Max 270', 120.00, 'Nike', 'Comodidad urbana', '/img/airmax270.jpg',
         (SELECT id_categoria FROM categoria WHERE nombre='Deportivos' LIMIT 1)
) AS t
WHERE NOT EXISTS (SELECT 1 FROM tenis WHERE nombre='Nike Air Max 270');

INSERT INTO tenis (nombre, precio, marca, descripcion, imagen, id_categoria)
SELECT * FROM (
  SELECT 'Adidas Ultraboost 22', 140.00, 'Adidas', 'Para correr largas distancias', '/img/ultraboost22.jpg',
         (SELECT id_categoria FROM categoria WHERE nombre='Deportivos' LIMIT 1)
) AS t
WHERE NOT EXISTS (SELECT 1 FROM tenis WHERE nombre='Adidas Ultraboost 22');

INSERT INTO tenis (nombre, precio, marca, descripcion, imagen, id_categoria)
SELECT * FROM (
  SELECT 'Vans Old Skool', 69.99, 'Vans', 'Clásico de skate', '/img/vansoldskool.jpg',
         (SELECT id_categoria FROM categoria WHERE nombre='Casuales' LIMIT 1)
) AS t
WHERE NOT EXISTS (SELECT 1 FROM tenis WHERE nombre='Vans Old Skool');

