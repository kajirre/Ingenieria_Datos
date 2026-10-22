-- =====================================================================
-- DATOS INICIALES — Proyecto Cóndor (DronAndes Express S.A.S.)
-- Corte: 30 de septiembre de 2026, 18:00
-- Script COMÚN para MySQL y PostgreSQL. Ejecutar DESPUÉS del DDL (R2).
-- =====================================================================

-- ============================
-- CREANDO LA BASE DE DATOS
-- ============================ 
DROP DATABASE IF EXISTS DronAndesExpress;
CREATE DATABASE DronAndesExpress CHARACTER SET utf8mb4;

USE DronAndesExpress;


-- ============================
--   CREANDO LAS TABLAS
-- ============================
 CREATE TABLE bases(
	id_base INT PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	municipio VARCHAR(50) NOT NULL,
	departamento VARCHAR(50) NOT NULL,
	capacidad_drones INT NOT NULL,
	fecha_apertura DATE NOT NULL
);



CREATE TABLE tipos_carga(
	id_tipo int primary key,
	nombre varchar(30) not null,
	tarifa_kg int not null,
	requiere_frio bool not null
);


create table clientes(
	id_cliente int primary key,
	tipo varchar(30) not null,
	nombre varchar(50) not null,
	nit_documento varchar(50) not null,
	email varchar(50),
	telefono varchar(40),
	municipio varchar(40) not null,
	fecha_registro DATE
);


CREATE TABLE entregas(
	id_entrega INT PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL,
	id_cliente INT NOT NULL,
	id_dron INT NOT NULL,
	id_piloto INT NOT NULL,
	fecha_programada DATETIME NOT NULL,
	fecha_entrega DATETIME,
	municipio_destino VARCHAR(30) NOT NULL,
	distancia_km DECIMAL(5,2),
	prioridad VARCHAR(30) NOT NULL,
	estado VARCHAR(30) NOT NULL,
	calificacion INT
);


-- ============================

-- CREANDO LAS TABLAS CON FK

-- ============================


create table drones(
	id_dron int primary key,
	codigo_serie varchar(30) not null,
	modelo varchar(30) not null,
	carga_max_kg decimal (10,2) not null,
	autonomia_km decimal (6,1)not null,
	estado varchar(20) not null,
	horas_vuelo decimal(6,1) not null,
	fecha_adquisicion DATE not null,
	id_base int NOT null,
	FOREIGN KEY (id_base) REFERENCES bases(id_base)
);



create table pilotos(
	id_piloto int primary key,
	documento varchar(30) not null,
	nombres varchar(50) not null,
	apellidos varchar(50) not null,
	email varchar(50) not null,
	licencia varchar(3) not null,
	fecha_ingreso DATE not null,
	id_supervisor int,
	id_base int NOT null,
	FOREIGN KEY (id_supervisor) REFERENCES pilotos(id_piloto), -- porque piloto tambien es profesor
	FOREIGN KEY (id_base) REFERENCES bases(id_base)
);

-- ALTER TABLE clientes MODIFY telefono VARCHAR(30) NOT NULL; ALTER TABLE clientes MODIFY telefono VARCHAR(30) NULL; ALTER TABLE clientes MODIFY email VARCHAR(50) NULL;



CREATE TABLE carga_entrega(
	id_entrega INT,
	id_tipo INT,
	peso_kg DECIMAL(5,2),
	unidades INT,
	FOREIGN KEY (id_tipo) REFERENCES tipos_carga(id_tipo),
	FOREIGN KEY (id_entrega) REFERENCES entregas(id_entrega)
);


CREATE TABLE mantenimientos(
	id_mantenimiento INT PRIMARY KEY, 
	id_dron INT, 
	fecha DATE,
	tipo VARCHAR(30), 
	descripcion VARCHAR (100), 
	costo BIGINT NOT NULL,
	FOREIGN KEY (id_dron) REFERENCES drones(id_dron) 
);




-- ============================
--    INSERTANDO DATOS
-- ============================


INSERT INTO bases (id_base, nombre, municipio, departamento, capacidad_drones, fecha_apertura) VALUES
(1, 'Base Cóndor', 'Rionegro', 'Antioquia', 6, '2024-02-15'),
(2, 'Base Colibrí', 'Guatapé', 'Antioquia', 4, '2024-08-01'),
(3, 'Base Frailejón', 'Tunja', 'Boyacá', 5, '2025-01-20'),
(4, 'Base Guadua', 'Salento', 'Quindío', 3, '2026-07-01');



INSERT INTO tipos_carga (id_tipo, nombre, tarifa_kg, requiere_frio) VALUES
(1, 'Vacunas', 12000, TRUE),
(2, 'Muestras de laboratorio', 10000, TRUE),
(3, 'Medicamentos', 8000, FALSE),
(4, 'Documentos', 5000, FALSE),
(5, 'Repuestos', 4500, FALSE),
(6, 'Alimentos', 3500, FALSE);



INSERT INTO drones (id_dron, codigo_serie, modelo, carga_max_kg, autonomia_km, estado,
horas_vuelo, fecha_adquisicion, id_base) VALUES
(1, 'DA-CX4-01', 'Cóndor X4', 8.00, 45.0, 'ACTIVO', 312.5, '2024-02-20', 1),
(2, 'DA-CX4-02', 'Cóndor X4', 8.00, 45.0, 'ACTIVO', 468.0, '2024-03-10', 1),
(3, 'DA-CX6-01', 'Cóndor X6', 15.00, 60.0, 'ACTIVO', 205.0, '2025-01-15', 1),
(4, 'DA-COL-01', 'Colibrí Mini', 2.50, 25.0, 'ACTIVO', 520.5, '2024-08-05', 2),
(5, 'DA-COL-02', 'Colibrí Mini', 2.50, 25.0, 'MANTENIMIENTO', 610.0, '2024-08-05', 2),
(6, 'DA-ALB-01', 'Albatros H8', 25.00, 90.0, 'ACTIVO', 98.0, '2025-02-01', 3),
(7, 'DA-CX6-02', 'Cóndor X6', 15.00, 60.0, 'ACTIVO', 150.5, '2025-03-12', 3),
(8, 'DA-ALB-02', 'Albatros H8', 25.00, 90.0, 'RETIRADO', 890.0, '2024-05-01', 3);



-- Los supervisores (id_supervisor NULL) se insertan primero.
INSERT INTO pilotos (id_piloto, documento, nombres, apellidos, email, licencia, fecha_ingreso, id_supervisor, id_base) VALUES
(1, '1036600111', 'Laura', 'Restrepo Gil', 'laura.restrepo@dronandes.co', 'C', '2024-02-01', NULL, 1),
(2, '1049600222', 'Camilo', 'Duarte Rojas', 'camilo.duarte@dronandes.co', 'C', '2025-01-10', NULL, 3),
(3, '1036600333', 'Mateo', 'Zapata Vélez', 'mateo.zapata@dronandes.co', 'B', '2024-04-15', 1, 1),
(4, '1036600444', 'Sara', 'Montoya Ruiz', 'sara.montoya@dronandes.co', 'B', '2024-08-10', 1, 2),
(5, '1036600555', 'Julián', 'Patiño Cruz', 'julian.patino@dronandes.co', 'A', '2025-06-01', 1, 2),
(6, '1049600666', 'Daniela', 'Suárez León', 'daniela.suarez@dronandes.co', 'B', '2025-02-01', 2, 3),
(7, '1049600777', 'Tomás', 'Becerra Niño', 'tomas.becerra@dronandes.co', 'A', '2026-06-15', 2, 3);



INSERT INTO clientes (id_cliente, tipo, nombre, nit_documento, email, telefono, municipio, fecha_registro) VALUES
(1, 'HOSPITAL', 'Hospital San Juan de Dios de Rionegro', '890980000-1', 'compras@hsjdrionegro.org', '6045310000', 'Rionegro', '2024-03-01'),
(2, 'FARMACIA', 'Droguería La Esperanza', '71234567', 'esperanza.drogueria@gmail.com', '3104567890', 'Guatapé', '2024-09-12'),
(3, 'HOSPITAL', 'E.S.E. Hospital San Rafael de Tunja', '891800231-6', 'Logistica@HSRTunja.gov.co', '6087405050', 'Tunja', '2025-01-25'),
(4, 'ONG', 'Fundación Alas para el Campo', '900456789-2', 'contacto@alasparaelcampo.org', NULL, 'Marinilla', '2024-11-03'),
(5, 'COMERCIO', 'Repuestos Agrícolas El Arriero', '900123456-7', NULL, '31245678', 'El Peñol', '2025-04-18'),
(6, 'PERSONA', 'Mariana Gómez Arango', '1040123456', 'mariana.gomez@hotmail.com', '3157778899', 'Guarne', '2025-07-07'),
(7, 'FARMACIA', 'Farmacia Botica del Páramo', '900777888-1', 'boticaparamo@gmail.com', '3209998877', 'Ventaquemada', '2025-02-14'),
(8, 'COMERCIO', 'Café de Altura Las Nubes', '901222333-4', 'ventas@cafelasnubes.co', '3001112233', 'Salento', '2026-07-20'),
(9, 'PERSONA', 'Jorge Iván Ríos', '79888777', NULL, NULL, 'Rionegro', '2026-08-30'),
(10, 'ONG', 'Corporación Montaña Viva', '900999111-0', 'info@montanaviva.org', '310555444', 'Sáchica', '2025-09-01');



INSERT INTO entregas (id_entrega, codigo, id_cliente, id_dron, id_piloto, fecha_programada,
fecha_entrega, municipio_destino, distancia_km, prioridad, estado, calificacion) VALUES
(1, 'ENT-0001', 1, 1, 3, '2026-08-03 08:00:00', '2026-08-03 08:42:00', 'San Vicente', 18.5, 'VITAL', 'ENTREGADA', 5),
(2, 'ENT-0002', 1, 3, 1, '2026-08-05 09:30:00', '2026-08-05 10:20:00', 'Concepción', 32.0, 'VITAL', 'ENTREGADA', 4),
(3, 'ENT-0003', 2, 4, 4, '2026-08-07 14:00:00', '2026-08-07 14:25:00', 'San Rafael', 12.0, 'NORMAL', 'ENTREGADA', 5),
(4, 'ENT-0004', 4, 2, 3, '2026-08-10 07:45:00', '2026-08-10 08:30:00', 'El Carmen de Viboral', 22.4, 'URGENTE', 'ENTREGADA', 3),
(5, 'ENT-0005', 5, 3, 1, '2026-08-12 11:00:00', NULL, 'El Peñol', 15.0, 'NORMAL', 'CANCELADA', NULL),
(6, 'ENT-0006', 3, 6, 2, '2026-08-14 06:30:00', '2026-08-14 07:40:00', 'Ramiriquí', 48.0, 'VITAL', 'ENTREGADA', 5),
(7, 'ENT-0007', 10, 7, 6, '2026-08-18 10:00:00', '2026-08-18 10:35:00', 'Samacá', 20.5, 'NORMAL', 'ENTREGADA', 4),
(8, 'ENT-0008', 3, 8, 6, '2026-08-20 08:15:00', NULL, 'Chíquiza', 35.0, 'URGENTE', 'FALLIDA', NULL),
(9, 'ENT-0009', 6, 4, 5, '2026-08-22 16:00:00', '2026-08-22 16:20:00', 'Guarne', 9.5, 'NORMAL', 'ENTREGADA', 2),
(10, 'ENT-0010', 1, 1, 1, '2026-08-25 07:00:00', '2026-08-25 07:50:00', 'Sonsón', 41.0, 'VITAL', 'ENTREGADA', 5),
(11, 'ENT-0011', 10, 6, 2, '2026-08-27 09:00:00', '2026-08-27 10:05:00', 'Sáchica', 52.5, 'URGENTE', 'ENTREGADA', NULL),
(12, 'ENT-0012', 2, 5, 4, '2026-08-29 13:00:00', NULL, 'Alejandría', 14.0, 'NORMAL', 'CANCELADA', NULL),
(13, 'ENT-0013', 4, 2, 1, '2026-09-01 08:00:00', '2026-09-01 08:55:00', 'Granada', 38.0, 'URGENTE', 'ENTREGADA', 4),
(14, 'ENT-0014', 1, 3, 1, '2026-09-03 10:30:00', '2026-09-03 11:15:00', 'Abejorral', 44.0, 'VITAL', 'ENTREGADA', 5),
(15, 'ENT-0015', 7, 7, 6, '2026-09-08 15:00:00', '2026-09-08 15:30:00', 'Turmequé', 17.0, 'NORMAL', 'ENTREGADA', 3),
(16, 'ENT-0016', 3, 6, 2, '2026-09-15 06:00:00', '2026-09-15 07:10:00', 'Miraflores', 58.0, 'VITAL', 'ENTREGADA', 4),
(17, 'ENT-0017', 6, 2, 3, '2026-09-21 17:00:00', NULL, 'Guarne', 10.0, 'NORMAL', 'CANCELADA', NULL),
(18, 'ENT-0018', 10, 7, 6, '2026-09-30 17:40:00', NULL, 'Villa de Leyva', 26.0, 'NORMAL', 'EN_VUELO', NULL),
(19, 'ENT-0019', 1, 1, 1, '2026-10-01 07:30:00', NULL, 'Nariño', 47.0, 'VITAL', 'PROGRAMADA', NULL),
(20, 'ENT-0020', 3, 6, 6, '2026-10-02 06:00:00', NULL, 'Pesca', 39.0, 'VITAL', 'PROGRAMADA', NULL);



INSERT INTO carga_entrega (id_entrega, id_tipo, peso_kg, unidades) VALUES
(1, 1, 3.00, 60), (1, 3, 2.00, 15), (2, 2, 1.50, 30), (2, 3, 4.00, 40),
(3, 3, 1.80, 12), (4, 3, 3.50, 25),  (4, 4, 0.50, 3), (5, 5, 6.00, 4),
(6, 1, 5.00, 100), (6, 2, 2.00, 40), (7, 3, 6.00, 50), (8, 1, 8.00, 160), 
(8, 3, 4.00, 30), (9, 4, 0.80, 5), (10, 1, 4.00, 80), (10, 2, 1.00, 20), 
(10, 3, 2.50, 20), (11, 3, 7.00, 60), (11, 4, 1.00, 6),
(13, 3, 5.00, 40), (13, 5, 2.00, 2), (14, 1, 6.00, 120), (14, 2, 3.00, 60),
(15, 3, 3.00, 25), (15, 4, 0.30, 2), (16, 1, 10.00, 200), (16, 3, 8.00, 70),
(18, 3, 4.00, 35), (19, 1, 3.50, 70), (20, 2, 2.50, 50), (20, 1, 6.00, 120);


INSERT INTO mantenimientos (id_mantenimiento, id_dron, fecha, tipo, descripcion, costo) VALUES
(1, 2, '2026-03-15', 'PREVENTIVO', 'Cambio de hélices', 350000),
(2, 4, '2026-04-02', 'PREVENTIVO', 'Calibración de GPS', 180000),
(3, 5, '2026-09-25', 'CORRECTIVO', 'Falla en motor 3', 1250000),
(4, 8, '2026-08-21', 'CORRECTIVO', 'Impacto en aterrizaje, evaluación de daños', 2800000),
(5, 1, '2026-06-10', 'PREVENTIVO', 'Revisión general de 300 horas', 420000),
(6, 6, '2026-07-05', 'PREVENTIVO', NULL, 260000),
(7, 5, '2026-05-14', 'PREVENTIVO', 'Cambio de baterías', 950000),
(8, 2, '2026-09-12', 'CORRECTIVO', 'Sensor de altitud defectuoso', 610000);


/* Queremos hacer una campaña a los clientes de tipo 'FARMACIA'. 
 * Escribe una consulta que devuelva el nombre del cliente y su municipio, 
 * pero solo de los clientes que sean de tipo 'FARMACIA' y que se hayan 
 * registrado a partir del 1 de enero de 2025 (usando el operador >=). 
 * Ordena los resultados por el nombre de forma descendente (de la Z a la A).
 * 
-- quiero ver el nombre y el municipio -> select
-- de la tabla clientes -> from clientes
-- condiciones WHERE
-- que sea tipo "farmacia" -> tipo = 'farmacia'
-- que se halla registrado desde el 1 enero del 2025 -> fecha_registro >= '2025-01-01'
-- se unen con AND
-- ordenar por nombre decendente -> OREDER BY nombre DESC
*/

SELECT c.nombre, c.municipio  
FROM clientes c
WHERE c.tipo = 'FARMACIA' AND c.fecha_registro >= '2025-01-01'
ORDER BY c.nombre DESC;



/* La gerencia quiere saber cuántas entregas ha recibido 
 * cada cliente que sea de tipo 'HOSPITAL' 
 * (sin importar el estado de la entrega, cuéntalas todas).
 * Necesito que me devuelvas dos columnas:
 *  El nombre del cliente (puedes usar el alias cliente).
 *  El número total de entregas que tiene ese cliente 
 * (puedes usar el alias total_entregas).
 * */

SELECT c.nombre as cliente, COUNT(e.id_entrega) as total_entregas  -- COUT = cuenta cuantos registros hay
FROM clientes c INNER JOIN entregas e ON c.id_cliente = e.id_cliente 
-- cruzar la tabla clientes c con la tabla entregas e 
-- pero solo donde el id_cliente de cliente c conincide 
--             con el id_cliente de entregas e   
-- porque id_clientes en entrega es FK
WHERE  c.tipo = 'HOSPITAL' -- que solo sea hospital
GROUP BY c.nombre; -- contar las entregas, PERO por grupos separados por   
                    -- cada nombre de cliente


/*El área de mantenimiento quiere un reporte de los 
 * tipos de carga (tabla tipos_carga), pero solo de aquellos 
 * que hayan transportado más de 10 kilogramos en total en todas las entregas.
Devuélveme dos columnas:
    El nombre del tipo de carga (alias tipo_carga).
    La suma total de los kilos transportados (alias kg_totales).
 * */

/*Siempre es: 
 * SELECT -> FROM -> JOIN -> WHERE -> GROUP BY -> HAVING -> ORDER BY.*/
SELECT tc.nombre as tipo_carga, SUM(ce.peso_kg) as kg_totales 
FROM tipos_carga tc INNER JOIN carga_entrega ce ON tc.id_tipo = ce.id_tipo  
GROUP BY tc.nombre
HAVING SUM(ce.peso_kg ) >= 10.0;

/*
 * La analogía del HAVING:
 * Imagina que eres el gerente de un supermercado. 
 * El WHERE es el portero, que revisa los productos uno por uno
 * cuando entran (filtra filas individuales). 
 * El GROUP BY es el empacador, que junta todos los productos 
 * de una misma marca en una sola bolsa. 
 * El HAVING es tú al final del día, revisando las bolsas ya cerradas: 
 * "Solo me quedo con las bolsas que pesen más de 10 kg". 
 * Tú no puedes usar el WHERE para esto, porque el portero no sabe cuánto 
 * va a pesar la bolsa completa. Por eso se usa el HAVING.*/



/* Comercial quiere premiar a los mejores clientes. 
 * Lista el nombre de los clientes (alias cliente) 
 * y la calificación promedio de sus entregas (alias calificacion_promedio),
 * pero solo de aquellas entregas que estén en estado 'ENTREGADA' 
 * y que tengan una calificación registrada (es decir, que no sea nula)
 * */

SELECT c.nombre as cliente,  AVG(e.calificacion) AS calificacion_promedio -- AVG es sacar promedio
FROM clientes c INNER JOIN  entregas e ON c.id_cliente = e.id_cliente 
WHERE e.estado = 'ENTREGADA' AND e.calificacion IS NOT NULL 
GROUP BY c.nombre
HAVING AVG(e.calificacion ) >= 3
ORDER BY calificacion_promedio DESC;


/*-------------------------------------------------------------------------*/
-- La empresa contrató un nuevo cliente. Inserta un registro en la tabla 
-- clientes con estos datos:

INSERT INTO clientes (id_cliente ,tipo, nombre, nit_documento, email, telefono, municipio, fecha_registro) 
VALUES (NULL,'PERSONA', 'Carlos Perez', '12345678', 'carlos@correo.com', '3001234567', 'Medellin', '2026-10-22');


/*----------------------------------------------------------------------------------- */

-- ==========================================
-- R10: VISTAS (VIEW)
-- ==========================================
-- Una vista es como una "tabla virtual" que guarda una consulta.
CREATE OR REPLACE VIEW vw_resumen_entregas AS
SELECT 
    e.codigo, 
    c.nombre AS cliente, 
    e.distancia_km,
    e.estado
FROM entregas e
INNER JOIN clientes c ON e.id_cliente = c.id_cliente;

-- Para probarla:
-- SELECT * FROM vw_resumen_entregas WHERE estado = 'ENTREGADA';


-- ==========================================
-- R11: PROCEDIMIENTO ALMACENADO (SP)
-- ==========================================
-- Un procedimiento es un bloque de código que se guarda en la BD.
-- Usamos DELIMITER para que MySQL no se confunda con los punto y coma.
DELIMITER //

CREATE PROCEDURE sp_buscar_entregas_cliente(IN p_id_cliente INT)
BEGIN
    -- Validación simple (opcional)
    IF (SELECT COUNT(*) FROM clientes WHERE id_cliente = p_id_cliente) > 0 THEN
        SELECT codigo, estado, distancia_km 
        FROM entregas 
        WHERE id_cliente = p_id_cliente;
    ELSE
        SELECT 'El cliente no existe' AS Error;
    END IF;
END //

DELIMITER ;

-- Para probarlo:
-- CALL sp_buscar_entregas_cliente(1);


-- ==========================================
-- R12: TRIGGER (Disparador)
-- ==========================================
-- Un trigger se ejecuta "automáticamente" cuando pasa algo (INSERT, UPDATE, DELETE).
-- Vamos a hacer un trigger que evite insertar entregas con distancia negativa.

DELIMITER //

CREATE TRIGGER trg_validar_distancia
BEFORE INSERT ON entregas
FOR EACH ROW
BEGIN
    IF NEW.distancia_km < 0 THEN
        -- SIGNAL lanza un error personalizado y cancela la inserción
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La distancia no puede ser negativa.';
    END IF;
END //

DELIMITER ;

-- Para probarlo (esto DEBE fallar):
-- INSERT INTO entregas (id_entrega, codigo, id_cliente, id_dron, id_piloto, fecha_programada, municipio_destino, distancia_km, prioridad, estado) 
-- VALUES (99, 'ENT-0099', 1, 1, 1, '2026-10-22 10:00:00', 'Test', -5.0, 'NORMAL', 'PROGRAMADA');


-- ==========================================
-- TRANSACCIONES (START TRANSACTION / ROLLBACK)
-- ==========================================
-- Una transacción es un "botón de deshacer" (Undo) para SQL. 
-- Si algo falla a la mitad, deshacemos todo con ROLLBACK.

START TRANSACTION;

-- Imagina que intentamos actualizar dos tablas a la vez:
UPDATE entregas SET estado = 'ENTREGADA' WHERE id_entrega = 1;
-- Si aquí nos damos cuenta de que nos equivocamos, podemos hacer:
ROLLBACK; 
-- (ROLLBACK deshace el UPDATE de arriba).

-- Si todo estuviera bien, en lugar de ROLLBACK usaríamos:
-- COMMIT;











