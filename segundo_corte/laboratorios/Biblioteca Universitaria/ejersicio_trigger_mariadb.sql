CREATE DATABASE IF NOT EXISTS biblioteca_ejersicio CHARACTER SET utf8mb4;
USE biblioteca_ejersicio;

CREATE TABLE IF NOT EXISTS socios(
  idSocio     INT AUTO_INCREMENT PRIMARY KEY,
  nombreSocio VARCHAR(100) NOT NULL,
  email       VARCHAR(100) NOT NULL UNIQUE,
  activo      BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS libros(
  idLibro                INT AUTO_INCREMENT PRIMARY KEY,
  tituloLibro            VARCHAR(150) NOT NULL,
  autorLibro             VARCHAR(100) NOT NULL,
  ejemplares_totales     INT NOT NULL CHECK (ejemplares_totales >= 0),
  ejemplares_disponibles INT NOT NULL CHECK (ejemplares_disponibles >= 0)
);

CREATE TABLE IF NOT EXISTS prestamos(
  idPrestamo       INT AUTO_INCREMENT PRIMARY KEY,
  socio_id         INT  NOT NULL,
  libro_id         INT  NOT NULL,
  fecha_prestamo   DATE NOT NULL,
  fecha_limite     DATE NOT NULL,
  fecha_devolucion DATE NULL,
  CONSTRAINT fk_prestamos_socio FOREIGN KEY (socio_id) REFERENCES socios(idSocio),
  CONSTRAINT fk_prestamos_libro FOREIGN KEY (libro_id) REFERENCES libros(idLibro)
);

CREATE TABLE IF NOT EXISTS historial_prestamos (
  idHistorial INT AUTO_INCREMENT PRIMARY KEY,
  prestamo_id INT          NOT NULL,
  accion      VARCHAR(20)  NOT NULL,
  detalle     VARCHAR(255),
  usuario     VARCHAR(100) NOT NULL,
  fecha       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_historial_prestamo FOREIGN KEY (prestamo_id) REFERENCES prestamos(idPrestamo)
);

INSERT INTO socios(idSocio, nombreSocio, email, activo) VALUES
  (1, 'Camila Rojas',   'camila@correo.com',    TRUE),
  (2, 'Andrés Díaz',    'andres@correo.com',    TRUE),
  (3, 'Valentina Ríos', 'valentina@correo.com', FALSE),
  (4, 'Mateo Castro',   'mateo@correo.com',     TRUE);

INSERT INTO libros (idLibro, tituloLibro, autorLibro, ejemplares_totales, ejemplares_disponibles) VALUES
  (1, 'Cien años de soledad',          'Gabriel García Márquez',   3, 2),
  (2, 'Clean Code',                    'Robert C. Martin',         2, 0),
  (3, 'Fundamentos de bases de datos', 'Abraham Silberschatz',     4, 3),
  (4, 'El principito',                 'Antoine de Saint-Exupéry', 2, 2);

INSERT INTO prestamos (idPrestamo, socio_id, libro_id, fecha_prestamo, fecha_limite, fecha_devolucion) VALUES
  (1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 40 DAY), DATE_SUB(CURDATE(), INTERVAL 26 DAY), DATE_SUB(CURDATE(), INTERVAL 27 DAY)),
  (2, 2, 2, DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY),  NULL),
  (3, 4, 2, DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY),  NULL),
  (4, 4, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY),  DATE_ADD(CURDATE(), INTERVAL 9 DAY),  NULL),
  (5, 4, 3, DATE_SUB(CURDATE(), INTERVAL 2 DAY),  DATE_ADD(CURDATE(), INTERVAL 12 DAY), NULL);

-- reto 1
CREATE OR REPLACE VIEW v_prestamos_vencidos AS
SELECT 
    p.idPrestamo,
    s.nombreSocio,
    s.email,
    l.tituloLibro,
    p.fecha_limite,
    DATEDIFF(CURDATE(), p.fecha_limite) AS dias_retraso
FROM prestamos p
INNER JOIN socios s ON p.socio_id = s.idSocio
INNER JOIN libros l ON p.libro_id = l.idLibro
WHERE p.fecha_devolucion IS NULL 
  AND p.fecha_limite < CURDATE();

-- reto 2
DROP PROCEDURE IF EXISTS sp_prestar_libro;

DELIMITER //

CREATE PROCEDURE sp_prestar_libro(
    IN p_socio_id INT,
    IN p_libro_id INT,
    IN p_dias INT,
    OUT p_prestamo_id INT
)
BEGIN
    DECLARE v_socio_existe INT DEFAULT 0;
    DECLARE v_socio_activo BOOLEAN DEFAULT FALSE;
    DECLARE v_libro_existe INT DEFAULT 0;
    DECLARE v_ejemplares INT DEFAULT 0;
    DECLARE v_prestamos_vencidos INT DEFAULT 0;
    DECLARE v_prestamos_activos INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*), COALESCE(MAX(activo), FALSE)
    INTO v_socio_existe, v_socio_activo
    FROM socios WHERE idSocio = p_socio_id;

    IF v_socio_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio no existe.';
    END IF;

    IF v_socio_activo = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: socio inactivo';
    END IF;

    SELECT COUNT(*) INTO v_prestamos_vencidos
    FROM prestamos
    WHERE socio_id = p_socio_id
      AND fecha_devolucion IS NULL
      AND fecha_limite < CURDATE();

    IF v_prestamos_vencidos > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio tiene prestamos vencidos sin devolver.';
    END IF;

    SELECT COUNT(*) INTO v_prestamos_activos
    FROM prestamos
    WHERE socio_id = p_socio_id
      AND fecha_devolucion IS NULL;

    IF v_prestamos_activos >= 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio ya tiene 3 prestamos activos.';
    END IF;

    SELECT COUNT(*), COALESCE(MAX(ejemplares_disponibles), 0)
    INTO v_libro_existe, v_ejemplares
    FROM libros WHERE idLibro = p_libro_id;

    IF v_libro_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El libro no existe.';
    END IF;

    IF v_ejemplares <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No hay ejemplares disponibles.';
    END IF;

    IF p_dias <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Los dias deben ser mayor a 0.';
    END IF;

    INSERT INTO prestamos (socio_id, libro_id, fecha_prestamo, fecha_limite, fecha_devolucion)
    VALUES (p_socio_id, p_libro_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL p_dias DAY), NULL);

    SET p_prestamo_id = LAST_INSERT_ID();

    UPDATE libros
    SET ejemplares_disponibles = ejemplares_disponibles - 1
    WHERE idLibro = p_libro_id;

    INSERT INTO historial_prestamos (prestamo_id, accion, detalle, usuario, fecha)
    VALUES (p_prestamo_id, 'PRESTAMO',
            CONCAT('Prestamo por ', p_dias, ' dias.'),
            CURRENT_USER(), NOW());

    COMMIT;
END //

DELIMITER ;

-- reto 3
DROP TRIGGER IF EXISTS tr_prestamo_devuelto;
DROP TRIGGER IF EXISTS tr_validar_fecha_devolucion;

DELIMITER //

CREATE TRIGGER tr_prestamo_devuelto
AFTER UPDATE ON prestamos
FOR EACH ROW
BEGIN
    IF OLD.fecha_devolucion IS NULL AND NEW.fecha_devolucion IS NOT NULL THEN
        UPDATE libros
        SET ejemplares_disponibles = ejemplares_disponibles + 1
        WHERE idLibro = NEW.libro_id;

        INSERT INTO historial_prestamos (prestamo_id, accion, detalle, usuario, fecha)
        VALUES (
            NEW.idPrestamo,
            'DEVOLUCION',
            CONCAT('Devuelto con ',
                   GREATEST(DATEDIFF(NEW.fecha_devolucion, NEW.fecha_limite), 0),
                   ' dias de retraso.'),
            CURRENT_USER(),
            NOW()
        );
    END IF;
END //

CREATE TRIGGER tr_validar_fecha_devolucion
BEFORE UPDATE ON prestamos
FOR EACH ROW
BEGIN
    IF NEW.fecha_devolucion IS NOT NULL
       AND NEW.fecha_devolucion < NEW.fecha_prestamo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La fecha de devolucion no puede ser anterior a la de prestamo.';
    END IF;
END //

DELIMITER ;

-- pruebas
-- 1
SELECT * FROM v_prestamos_vencidos;

-- 2
CALL sp_prestar_libro(1, 4, 14, @id);
SELECT @id;
SELECT idLibro, tituloLibro, ejemplares_disponibles FROM libros WHERE idLibro = 4;

-- 3
CALL sp_prestar_libro(3, 1, 7, @id);

-- 4
CALL sp_prestar_libro(1, 2, 7, @id);

-- paso 5
CALL sp_prestar_libro(4, 1, 7, @id);

-- paso 6
CALL sp_prestar_libro(1, 4, 0, @id);

-- paso 7
UPDATE prestamos SET fecha_devolucion = CURDATE() WHERE idPrestamo = 2;
SELECT idLibro, tituloLibro, ejemplares_disponibles FROM libros WHERE idLibro = 2;
SELECT * FROM historial_prestamos WHERE prestamo_id = 2;

-- paso 8
SELECT * FROM v_prestamos_vencidos;

-- paso 9
UPDATE prestamos SET fecha_devolucion = CURDATE() WHERE idPrestamo = 2;
SELECT idLibro, ejemplares_disponibles FROM libros WHERE idLibro = 2;
SELECT COUNT(*) FROM historial_prestamos WHERE prestamo_id = 2;





