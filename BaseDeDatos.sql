CREATE DATABASE IF NOT EXISTS proyecto_tenis
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE proyecto_tenis;

CREATE TABLE categoria (
id_categoria INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);

CREATE TABLE tenis (
id_tenis INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
precio DECIMAL(10,2) NOT NULL,
marca VARCHAR(100),
descripcion TEXT,
imagen VARCHAR(255),
id_categoria INT,
CONSTRAINT fk_tenis_categoria FOREIGN KEY (id_categoria)REFERENCES categoria (id_categoria) 
ON DELETE SET NULL
ON UPDATE CASCADE
);

INSERT INTO categoria (nombre) VALUES
('Deportivos'),
('Casuales'),
('Edición Limitada'),
('Skate'),
('Running');

INSERT INTO tenis (nombre, precio, marca, descripcion, imagen, id_categoria) VALUES
('Nike Air Max 270', 120.00, 'Nike', 'Comodidad y estilo urbano', '/img/airmax270.jpg', 1),
('Adidas Ultraboost 22', 140.00, 'Adidas', 'Ideales para correr largas distancias', '/img/ultraboost22.jpg', 5),
('Vans Old Skool', 69.99, 'Vans', 'Clásicos de skate y uso casual', '/img/vansoldskool.jpg', 4),
('Jordan 1 Retro High OG', 180.00, 'Jordan', 'Edición limitada para coleccionistas', '/img/jordan1.jpg', 3);
