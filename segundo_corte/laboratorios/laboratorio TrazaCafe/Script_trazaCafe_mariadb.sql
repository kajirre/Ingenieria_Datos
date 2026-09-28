

CREATE DATABASE IF NOT EXISTS trazacafe;
USE trazacafe;

-- tablas independientes (sin FK)

CREATE TABLE fincas (
    id_finca INT AUTO_INCREMENT PRIMARY KEY,
    nombre_finca VARCHAR(30) NOT NULL,
    caficultor_responsable VARCHAR(30) NOT NULL,
    departamento VARCHAR(30) NOT NULL,
    municipio VARCHAR(30) NOT NULL,
    altitud INT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE catadores (
    id_catador INT AUTO_INCREMENT PRIMARY KEY,
    nombre_catador VARCHAR(50) NOT NULL
);

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    num_cliente INT NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(30) NOT NULL
);

-- tablas dependientes (con FK)

CREATE TABLE lotes (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    id_finca INT NOT NULL,
    codigo_lote VARCHAR(20) NOT NULL UNIQUE,
    variedad VARCHAR(30) NOT NULL,
    proceso VARCHAR(30) NOT NULL,
    fecha_cosecha DATE NOT NULL,
    kilo_lote DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_lotes_finca FOREIGN KEY (id_finca) REFERENCES fincas(id_finca)
);

CREATE TABLE cataciones (
    id_catacion INT AUTO_INCREMENT PRIMARY KEY,
    id_catador INT NOT NULL,
    id_lote INT NOT NULL,
    puntaje DECIMAL(5,2) NOT NULL,
    CONSTRAINT fk_cataciones_catador FOREIGN KEY (id_catador) REFERENCES catadores(id_catador),
    CONSTRAINT fk_cataciones_lote FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
);

CREATE TABLE tostiones (
    id_tostion INT AUTO_INCREMENT PRIMARY KEY,
    id_lote INT NOT NULL,
    fecha_tostion DATE NOT NULL,
    kilos_entrada DECIMAL(10,2) NOT NULL,
    kilos_salida DECIMAL(10,2) NOT NULL,
    perfil VARCHAR(20) NOT NULL,
    CONSTRAINT fk_tostiones_lote FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE detalle_pedido (
    id_detalle_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_tostion INT NOT NULL,
    kilos DECIMAL(10,2) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_detalle_pedido_tostion FOREIGN KEY (id_tostion) REFERENCES tostiones(id_tostion)
);

/* Reflexion Reto 2:
   si se intenta crear primero la tabla de lotes antes que la de fincas, 
   el sale un error de llave foránea pues aun no existe la tabla fincas donde .
   se encuentra id_finca que es la llave foranea de la tabla lotes
*/