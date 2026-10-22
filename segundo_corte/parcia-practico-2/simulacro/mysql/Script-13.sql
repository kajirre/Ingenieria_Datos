

DROP DATABASE IF EXISTS DronAndesExpress;
CREATE DATABASE DronAndesExpress CHARACTER SET utf8mb4;
USE DronAndesExpress;

-- ============================
-- 1. CREACIÓN DE TABLAS (R2)
-- ============================
CREATE TABLE bases(
	id_base INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(50) NOT NULL,
	municipio VARCHAR(50) NOT NULL,
	departamento VARCHAR(50) NOT NULL,
	capacidad_drones INT NOT NULL,
	fecha_apertura DATE NOT NULL
);

CREATE TABLE tipos_carga(
	id_tipo INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(30) NOT NULL,
	tarifa_kg INT NOT NULL,
	requiere_frio BOOL NOT NULL
);

CREATE TABLE clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(30) NOT NULL,
	nombre VARCHAR(120) NOT NULL, -- Modificado directo para evitar ALTER después
	nit_documento VARCHAR(50) NOT NULL,
	email VARCHAR(50),
	telefono VARCHAR(40),
	municipio VARCHAR(40) NOT NULL,
	fecha_registro DATE
);

CREATE TABLE drones(
	id_dron INT PRIMARY KEY AUTO_INCREMENT,
	codigo_serie VARCHAR(30) NOT NULL,
	modelo VARCHAR(30) NOT NULL,
	carga_max_kg DECIMAL(10,2) NOT NULL,
	autonomia_km DECIMAL(6,1) NOT NULL,
	estado VARCHAR(20) NOT NULL,
	horas_vuelo DECIMAL(6,1) NOT NULL,
	fecha_adquisicion DATE NOT NULL,
	id_base INT NOT NULL,
	FOREIGN KEY (id_base) REFERENCES bases(id_base)
);

CREATE TABLE pilotos(
	id_piloto INT PRIMARY KEY AUTO_INCREMENT,
	documento VARCHAR(30) NOT NULL,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	licencia VARCHAR(3) NOT NULL,
	fecha_ingreso DATE NOT NULL,
	id_supervisor INT,
	id_base INT NOT NULL,
	FOREIGN KEY (id_supervisor) REFERENCES pilotos(id_piloto),
	FOREIGN KEY (id_base) REFERENCES bases(id_base)
);

CREATE TABLE entregas(
	id_entrega INT PRIMARY KEY AUTO_INCREMENT,
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
	calificacion INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_dron) REFERENCES drones(id_dron),
    FOREIGN KEY (id_piloto) REFERENCES pilotos(id_piloto)
);

CREATE TABLE carga_entrega(
	id_entrega INT,
	id_tipo INT,
	peso_kg DECIMAL(5,2),
	unidades INT,
	PRIMARY KEY (id_entrega, id_tipo), -- PK Compuesta
	FOREIGN KEY (id_tipo) REFERENCES tipos_carga(id_tipo),
	FOREIGN KEY (id_entrega) REFERENCES entregas(id_entrega)
);

CREATE TABLE mantenimientos(
	id_mantenimiento INT PRIMARY KEY AUTO_INCREMENT, 
	id_dron INT, 
	fecha DATE,
	tipo VARCHAR(30), 
	descripcion VARCHAR(100), 
	costo BIGINT NOT NULL,
	FOREIGN KEY (id_dron) REFERENCES drones(id_dron) 
);

-- Tabla para el Trigger de auditoría
CREATE TABLE historical_entregas (
    id_historical INT PRIMARY KEY AUTO_INCREMENT,
    id_entrega INT NOT NULL,
    estado_anterior VARCHAR(30),
    estado_nuevo VARCHAR(30),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_entrega) REFERENCES entregas(id_entrega)
);

-- ============================
-- 2. DATOS INICIALES (R2)
-- ============================
-- (Insertando datos exactos de tu archivo)
INSERT INTO bases (id_base, nombre, municipio, departamento, capacidad_drones, fecha_apertura) VALUES
(1, 'Base Cóndor', 'Rionegro', 'Antioquia', 6, '2024-02-15'),
(2, 'Base Colibrí', 'Guatapé', 'Antioquia', 4, '2024-08-01'),
(3, 'Base Frailejón', 'Tunja', 'Boyacá', 5, '2025-01-20'),
(4, 'Base Guadua', 'Salento', 'Quindío', 3, '2026-07-01');

INSERT INTO tipos_carga (id_tipo, nombre, tarifa_kg, requiere_frio) VALUES
(1, 'Vacunas', 12000, TRUE), (2, 'Muestras de laboratorio', 10000, TRUE),
(3, 'Medicamentos', 8000, FALSE), (4, 'Documentos', 5000, FALSE),
(5, 'Repuestos', 4500, FALSE), (6, 'Alimentos', 3500, FALSE);

INSERT INTO drones (id_dron, codigo_serie, modelo, carga_max_kg, autonomia_km, estado, horas_vuelo, fecha_adquisicion, id_base) VALUES
(1, 'DA-CX4-01', 'Cóndor X4', 8.00, 45.0, 'ACTIVO', 312.5, '2024-02-20', 1),
(2, 'DA-CX4-02', 'Cóndor X4', 8.00, 45.0, 'ACTIVO', 468.0, '2024-03-10', 1),
(3, 'DA-CX6-01', 'Cóndor X6', 15.00, 60.0, 'ACTIVO', 205.0, '2025-01-15', 1),
(4, 'DA-COL-01', 'Colibrí Mini', 2.50, 25.0, 'ACTIVO', 520.5, '2024-08-05', 2),
(5, 'DA-COL-02', 'Colibrí Mini', 2.50, 25.0, 'MANTENIMIENTO', 610.0, '2024-08-05', 2),
(6, 'DA-ALB-01', 'Albatros H8', 25.00, 90.0, 'ACTIVO', 98.0, '2025-02-01', 3),
(7, 'DA-CX6-02', 'Cóndor X6', 15.00, 60.0, 'ACTIVO', 150.5, '2025-03-12', 3),
(8, 'DA-ALB-02', 'Albatros H8', 25.00, 90.0, 'RETIRADO', 890.0, '2024-05-01', 3);

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

INSERT INTO entregas (id_entrega, codigo, id_cliente, id_dron, id_piloto, fecha_programada, fecha_entrega, municipio_destino, distancia_km, prioridad, estado, calificacion) VALUES
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
(3, 3, 1.80, 12), (4, 3, 3.50, 25), (4, 4, 0.50, 3), (5, 5, 6.00, 4),
(6, 1, 5.00, 100), (6, 2, 2.00, 40), (7, 3, 6.00, 50), (8, 1, 8.00, 160), 
(8, 3, 4.00, 30), (9, 4, 0.80, 5), (10, 1, 4.00, 80), (10, 2, 1.00, 20), 
(10, 3, 2.50, 20), (11, 3, 7.00, 60), (11, 4, 1.00, 6), (13, 3, 5.00, 40), 
(13, 5, 2.00, 2), (14, 1, 6.00, 120), (14, 2, 3.00, 60), (15, 3, 3.00, 25), 
(15, 4, 0.30, 2), (16, 1, 10.00, 200), (16, 3, 8.00, 70), (18, 3, 4.00, 35), 
(19, 1, 3.50, 70), (20, 2, 2.50, 50), (20, 1, 6.00, 120);

INSERT INTO mantenimientos (id_mantenimiento, id_dron, fecha, tipo, descripcion, costo) VALUES
(1, 2, '2026-03-15', 'PREVENTIVO', 'Cambio de hélices', 350000),
(2, 4, '2026-04-02', 'PREVENTIVO', 'Calibración de GPS', 180000),
(3, 5, '2026-09-25', 'CORRECTIVO', 'Falla en motor 3', 1250000),
(4, 8, '2026-08-21', 'CORRECTIVO', 'Impacto en aterrizaje, evaluación de daños', 2800000),
(5, 1, '2026-06-10', 'PREVENTIVO', 'Revisión general de 300 horas', 420000),
(6, 6, '2026-07-05', 'PREVENTIVO', NULL, 260000),
(7, 5, '2026-05-14', 'PREVENTIVO', 'Cambio de baterías', 950000),
(8, 2, '2026-09-12', 'CORRECTIVO', 'Sensor de altitud defectuoso', 610000);

-- ============================
-- 3. CONSULTAS BÁSICAS (R5, R6, R7)
-- ============================

-- R5: Farmacias registradas despues de 2025
SELECT c.nombre, c.municipio  
FROM clientes c
WHERE c.tipo = 'FARMACIA' AND c.fecha_registro >= '2025-01-01'
ORDER BY c.nombre DESC;

-- R7a: Entregas por cliente HOSPITAL
SELECT c.nombre AS cliente, COUNT(e.id_entrega) AS total_entregas  
FROM clientes c 
INNER JOIN entregas e ON c.id_cliente = e.id_cliente 
WHERE c.tipo = 'HOSPITAL' 
GROUP BY c.nombre;

-- R7b: Suma de kilos por tipo de carga (mayor a 10kg)
SELECT tc.nombre AS tipo_carga, SUM(ce.peso_kg) AS kg_totales 
FROM tipos_carga tc 
INNER JOIN carga_entrega ce ON tc.id_tipo = ce.id_tipo  
GROUP BY tc.nombre
HAVING SUM(ce.peso_kg) >= 10.0;

-- R7c: Promedio de calificacion de clientes
SELECT c.nombre AS cliente, AVG(e.calificacion) AS calificacion_promedio 
FROM clientes c 
INNER JOIN entregas e ON c.id_cliente = e.id_cliente 
WHERE e.estado = 'ENTREGADA' AND e.calificacion IS NOT NULL 
GROUP BY c.nombre
HAVING AVG(e.calificacion) >= 3
ORDER BY calificacion_promedio DESC;

-- ============================
-- 4. OPERACIONES DML (R4)
-- ============================
-- R4a: Insertar cliente (Ahora el ID es automático)
INSERT INTO clientes (tipo, nombre, nit_documento, email, telefono, municipio, fecha_registro) 
VALUES ('PERSONA', 'Carlos Perez', '12345678', 'carlos@correo.com', '3001234567', 'Medellin', '2026-10-22');

-- R4b: Actualizar datos
UPDATE clientes 
SET telefono = '3109998877', municipio = 'Envigado' 
WHERE nombre = 'Carlos Perez';

-- ============================
-- 5. ALTER TABLE (R3)
-- ============================
-- R3a (ya hecho arriba, pero por si acaso en el parcial piden):
-- ALTER TABLE clientes MODIFY COLUMN nombre VARCHAR(120) NOT NULL;

-- R3b: Check de peso (se obvia si los datos violan la regla, pero la sintaxis es:)
-- ALTER TABLE drones ADD CONSTRAINT chk_drones_carga CHECK (carga_max_kg >= 0.5 AND carga_max_kg <= 25);

-- R3c: FK del supervisor
-- ALTER TABLE pilotos ADD CONSTRAINT fk_pilotos_supervisor FOREIGN KEY (id_supervisor) REFERENCES pilotos(id_piloto);

-- ============================
-- 6. VISTA (R10)
-- ============================
CREATE OR REPLACE VIEW vw_resumen_entregas AS
SELECT e.codigo, c.nombre AS cliente, e.distancia_km, e.estado
FROM entregas e
INNER JOIN clientes c ON e.id_cliente = c.id_cliente;

-- ============================
-- 7. FUNCIÓN ALMACENADA (R11)
-- ============================
DELIMITER //
CREATE FUNCTION fn_valor_entrega(p_id_entrega INT) 
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_distancia DECIMAL(5,2);
    DECLARE v_prioridad VARCHAR(30);
    
    IF NOT EXISTS (SELECT 1 FROM entregas WHERE id_entrega = p_id_entrega) THEN
        RETURN NULL;
    END IF;

    SELECT distancia_km, prioridad INTO v_distancia, v_prioridad 
    FROM entregas WHERE id_entrega = p_id_entrega;

    SELECT IFNULL(SUM(ce.peso_kg * tc.tarifa_kg), 0) INTO v_total
    FROM carga_entrega ce
    INNER JOIN tipos_carga tc ON ce.id_tipo = tc.id_tipo
    WHERE ce.id_entrega = p_id_entrega;

    SET v_total = v_total + (v_distancia * 1200);

    IF v_prioridad = 'URGENTE' THEN
        SET v_total = v_total * 1.20;
    END IF;

    RETURN v_total;
END //
DELIMITER ;

-- ============================
-- 8. TRIGGER (R12)
-- ============================
DELIMITER //
CREATE TRIGGER trg_entregas_estado
BEFORE UPDATE ON entregas
FOR EACH ROW
BEGIN
    IF OLD.estado <> NEW.estado THEN
        IF NEW.estado = 'ENTREGADA' AND NEW.fecha_entrega IS NULL THEN
            SET NEW.fecha_entrega = NOW();
        END IF;
        
        INSERT INTO historical_entregas (id_entrega, estado_anterior, estado_nuevo, fecha_cambio)
        VALUES (OLD.id_entrega, OLD.estado, NEW.estado, NOW());
    END IF;
END //
DELIMITER ;

-- ============================
-- 9. PROCEDIMIENTO ALMACENADO (R13)
-- ============================
DELIMITER //
CREATE PROCEDURE sp_programar_entrega(
    IN p_codigo VARCHAR(30), IN p_id_cliente INT, IN p_id_dron INT, IN p_id_piloto INT,
    IN p_fecha DATETIME, IN p_municipio VARCHAR(30), IN p_distancia DECIMAL(5,2), IN p_prioridad VARCHAR(30)
)
BEGIN
    DECLARE v_estado_dron VARCHAR(20);
    DECLARE v_autonomia DECIMAL(6,1);
    DECLARE v_licencia VARCHAR(3);

    SELECT estado, autonomia_km INTO v_estado_dron, v_autonomia FROM drones WHERE id_dron = p_id_dron;
    
    IF v_estado_dron IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El dron no existe.';
    ELSEIF v_estado_dron <> 'ACTIVO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El dron no está ACTIVO.';
    END IF;

    IF p_distancia > v_autonomia THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La distancia supera la autonomía del dron.';
    END IF;

    SELECT licencia INTO v_licencia FROM pilotos WHERE id_piloto = p_id_piloto;
    IF (v_licencia = 'A' AND p_distancia > 20) OR (v_licencia = 'B' AND p_distancia > 40) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La licencia del piloto no permite esa distancia.';
    END IF;

    INSERT INTO entregas (codigo, id_cliente, id_dron, id_piloto, fecha_programada, municipio_destino, distancia_km, prioridad, estado)
    VALUES (p_codigo, p_id_cliente, p_id_dron, p_id_piloto, p_fecha, p_municipio, p_distancia, p_prioridad, 'PROGRAMADA');
    
    SELECT CONCAT('Entrega ', p_codigo, ' programada con éxito.') AS Mensaje;
END //
DELIMITER ;

-- ============================
-- 10. PRUEBAS (Opcional, para que veas que todo corre)
-- ============================
-- SELECT fn_valor_entrega(1);
-- CALL sp_programar_entrega('ENT-0021', 11, 3, 3, '2026-10-03 10:00:00', 'Marinilla', 16.0, 'URGENTE');
-- UPDATE entregas SET estado = 'ENTREGADA', calificacion = 5 WHERE codigo = 'ENT-0018';
-- SELECT * FROM historical_entregas;
