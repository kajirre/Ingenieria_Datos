DROP DATABASE IF EXISTS;
CREATE DATABASE cicloverde CHARACTER SET utf8mb4;


USE cicloverde;


-- TABLAS CON LLAVES PRMARIAS

CREATE TABLE estaciones(
	id_estacion INT PRIMARY KEY NOT NULL, 
	nombre VARCHAR(50) NOT NULL,
	barrio VARCHAR (50) NOT NULL,
	capacidad INT NOT NULL,
	activa BOOL NOT NULL
);


CREATE TABLE accesorios(
	id_accesorio INT PRIMARY KEY NOT NULL, 
	nombre VARCHAR(40) NOT NULL,
	precio DECIMAL(8,2) NOT NULL
);


-- TABLAS CON LLAVES SECUNDARIAS

CREATE TABLE bicicletas (
	id_bici int PRIMARY KEY NOT NULL, 
	codigo VARCHAR(10) NOT NULL, 
	modelo VARCHAR(40) NOT NULL, 
	estado VARCHAR(10) NOT NULL, 
	km_recorridos DECIMAL(7,1) NOT NULL, 
	id_estacion INT NOT NULL,
	FOREIGN KEY (id_estacion) REFERENCES estaciones(id_estacion)
);

CREATE TABLE usuarios(
	id_usuario INT PRIMARY KEY NOT NULL, 
	documento INT(15) NOT NULL, 
	nombres VARCHAR(50) NOT NULL, 
	apellidos VARCHAR(50) NOT NULL, 
	email VARCHAR(80), 
	telefono VARCHAR(15), 
	plan VARCHAR(10) NOT NULL, 
	fecha_registro DATE NOT NULL,
	id_referido INT,
	FOREIGN KEY (id_referido) REFERENCES usuarios(id_usuario)
);

CREATE TABLE viajes(
	id_viaje INT PRIMARY KEY NOT NULL, 
	id_usuario INT NOT NULL,
	id_bici INT NOT NULL, 
	id_estacion_origen INT NOT NULL,
	id_estacion_destino INT, 
	fecha_inicio DATETIME NOT NULL, 
	fecha_fin DATETIME, 
	km DECIMAL(5.1) NOT NULL, 
	estado VARCHAR(20) NOT NULL, 
	calificacion INT,
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
	FOREIGN KEY (id_bici) REFERENCES bicicletas(id_bici)
);

CREATE TABLE viaje_accesorio (
	id_viaje INT PRIMARY KEY NOT NULL, 
	id_accesorio INT NOT NULL, 
	cantidad INT NOT NULL,
	FOREIGN KEY (id_accesorio) REFERENCES accesorios(id_accesorio)
);

CREATE TABLE historial_bicicletas(
	id_historial INT PRIMARY KEY NOT NULL, 
	id_bicicleta INT NOT NULL,
	estacion_anterior VARCHAR(10) NOT NULL,
	estacion_nuevo VARCHAR(10) NOT NULL,
	fecha_cambio DATETIME NOT NULL
);







-- =====================================================================
-- DATOS INICIALES — Operación Pedal (CicloVerde S.A.S.)
-- Ejecutar inmediatamente después del DDL de R2.
-- =====================================================================
INSERT INTO estaciones (id_estacion, nombre, barrio, capacidad, activa) VALUES
(1, 'Estación Las Aguas', 'La Candelaria', 12, TRUE)
(2, 'Estación Parque 93', 'Chapinero', 15, TRUE),
(3, 'Estación Usaquén', 'Usaquén', 10, TRUE),
(4, 'Estación Kennedy', 'Kennedy', 8, FALSE);


INSERT INTO bicicletas (id_bici, codigo, modelo, estado, km_recorridos, id_estacion)
VALUES
(1, 'CV-E01','Volta E2','ACTIVA', 1350.5, 1),
(2, 'CV-E02', 'Volta E2','ACTIVA', 820.0, 1),
(3, 'CV-M01','Urbana M1','ACTIVA', 240.0, 1),
(4, 'CV-E03','Volta E3','ACTIVA', 1620.0, 2),
(5, 'CV-M02','Urbana M1','TALLER',95.5, 2),
(6, 'CV-E04','Volta E3','ACTIVA', 410.0, 3),
(7, 'CV-M03', 'Urbana M2','BAJA',2100.0, 3),
(8, 'CV-E-PRO', 'Prototipo Volta X', 'ACTIVA', 60.0, 3);

-- Los usuarios que refieren se insertan antes que sus referidos.Universidad del Rosario
INSERT INTO usuarios (id_usuario, documento, nombres, apellidos, email, telefono, plan, fecha_registro, id_referidor) VALUES
(1, '1036101001', 'Valentina', 'Ríos Mejía','vale.rios@gmail.com','3001234567', 'PREMIUM', '2025-11-03', NULL),
(2, '1036101002', 'Santiago', 'Gómez Ruiz','sgomez@urosario.edu.co','3012223344', 'BASICO', '2026-01-15', 1),
(3, '1036101003', 'Isabella', 'Torres Cano','isa.torres@hotmail.com', NULL,'PREMIUM', '2026-02-20', 1),
(4, '1036101004', 'Mateo','Herrera Díaz', NULL,'312456789', 'BASICO', '2026-03-31', 2),
(5, '1036101005', 'Camila','Ortiz León','camila.ortiz@urosario.edu.co','3157654321', 'BASICO', '2026-05-10', NULL),
(6, '1036101006', 'Sebastián', 'Vargas Pino','sebas.vargas@gmail.com','3209876543', 'PREMIUM', '2026-07-01', 3),
(7, '1036101007', 'Daniela','Cruz Mora','DCRUZ@UROSARIO.EDU.CO','3104445566', 'BASICO', '2026-09-12', NULL),
(8, '1036101008', 'Andrés','Patiño Gil',NULL,NULL,'BASICO', '2026-10-01', 5);


INSERT INTO accesorios (id_accesorio, nombre, precio) VALUES
(1, 'Casco',2500),
(2, 'Candado',1500),
(3, 'Canasta',1000),
(4, 'Luz recargable', 2000);

INSERT INTO viajes (id_viaje, id_usuario, id_bici, id_estacion_origen,
id_estacion_destino, fecha_inicio, fecha_fin, km, estado, calificacion) VALUES
(1, 1, 1, 1, 2, '2026-10-01 07:10:00', '2026-10-01 07:32:00', 5.2, 'FINALIZADO',5),
(2, 2, 3, 1, 3,'2026-10-01 08:00:00', '2026-10-01 08:25:00', 3.8, 'FINALIZADO',4),
(3, 3, 4, 2, 1, '2026-10-02 18:05:00', '2026-10-02 18:40:00', 6.0, 'FINALIZADO',2),
(4, 1, 2, 1, 1,'2026-10-03 12:00:00', '2026-10-03 12:15:00', 2.1, 'FINALIZADO',NULL),
(5, 3, 6, 3, 2,'2026-10-04 09:30:00', '2026-10-04 09:58:00', 4.4, 'FINALIZADO',3),
(6, 5, 1, 2, NULL, '2026-10-05 10:00:00', NULL, 0.0, 'CANCELADO',NULL),
(7, 6, 4, 2, 3, '2026-10-06 17:20:00', '2026-10-06 18:05:00', 11.0, 'FINALIZADO',5),
(8, 2, 2, 1, 2,'2026-10-08 07:45:00', '2026-10-08 08:05:00', 4.9, 'FINALIZADO',1),
(9, 3, 6, 3, NULL, '2026-10-09 14:00:00', NULL, 0.8, 'CANCELADO',NULL),
(10, 1, 6, 3, 1, '2026-10-11 06:50:00', '2026-10-11 07:20:00', 6.0, 'FINALIZADO',4),
(11, 5, 3, 1, 3, '2026-10-12 16:00:00', '2026-10-12 16:18:00', 2.7, 'FINALIZADO',5),
(12, 6, 8, 3, NULL, '2026-10-14 11:00:00', NULL, 0.0, 'CANCELADO',NULL),
(13, 4, 2, 1, NULL, '2026-10-15 19:30:00', NULL, 1.2, 'EN_CURSO',NULL),
(14, 2, 6, 3, NULL, '2026-10-15 19:45:00', NULL, NULL);



INSERT INTO viaje_accesorio (id_viaje, id_accesorio, cantidad) VALUES
(1, 1, 1), (1, 2, 1),(3, 1, 1),(5, 3, 1),(7, 1, 1), (7, 3, 1),(8, 2, 1),(10, 1, 1),(11, 2, 1),(13, 1, 1);
