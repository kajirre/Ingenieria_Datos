/* SISTEMA VETCARE - CLINICA VETERINARIA */

-- 1. TABLAS INDEPENDIENTES (Sin FK)

CREATE TABLE Sede (
    id_sede SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    num_documento VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(100)
);

CREATE TABLE Veterinario (
    id_veterinario SERIAL PRIMARY KEY,
    num_documento VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    tarjeta_profesional VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE Especialidad (
    id_especialidad SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('Medicamento', 'Vacuna')),
    descripcion VARCHAR(200)
);

CREATE TABLE DocVehiculo ( -- Reutilizable si manejan transportes de la clínica
    idDocVehi SERIAL PRIMARY KEY,
    nomDocVehi VARCHAR(50),
    EstadoDoc VARCHAR(20)
);


-- 2. TABLAS DE PRIMER NIVEL DE DEPENDENCIA

CREATE TABLE Mascota (
    id_mascota SERIAL PRIMARY KEY,
    id_cliente_fk INT NOT NULL REFERENCES Cliente(id_cliente) ON DELETE CASCADE,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    raza VARCHAR(30),
    fecha_nacimiento DATE,
    sexo VARCHAR(10) CHECK (sexo IN ('Macho', 'Hembra')),
    peso NUMERIC(5,2),
    num_microchip VARCHAR(50) UNIQUE
);

CREATE TABLE Veterinario_Especialidad (
    id_veterinario_fk INT REFERENCES Veterinario(id_veterinario) ON DELETE CASCADE,
    id_especialidad_fk INT REFERENCES Especialidad(id_especialidad) ON DELETE CASCADE,
    PRIMARY KEY (id_veterinario_fk, id_especialidad_fk)
);

CREATE TABLE Horario_Veterinario (
    id_horario SERIAL PRIMARY KEY,
    id_veterinario_fk INT NOT NULL REFERENCES Veterinario(id_veterinario) ON DELETE CASCADE,
    id_sede_fk INT NOT NULL REFERENCES Sede(id_sede) ON DELETE CASCADE,
    dia_semana VARCHAR(15) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL
);

CREATE TABLE Jaula (
    id_jaula SERIAL PRIMARY KEY,
    id_sede_fk INT NOT NULL REFERENCES Sede(id_sede) ON DELETE CASCADE,
    codigo_jaula VARCHAR(20) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Disponible' CHECK (estado IN ('Disponible', 'Ocupada'))
);

CREATE TABLE Lote_Inventario (
    id_lote SERIAL PRIMARY KEY,
    id_producto_fk INT NOT NULL REFERENCES Producto(id_producto) ON DELETE CASCADE,
    id_sede_fk INT NOT NULL REFERENCES Sede(id_sede) ON DELETE CASCADE,
    num_lote VARCHAR(50) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    stock_actual INT NOT NULL CHECK (stock_actual >= 0)
);


-- 3. CITAS Y ATENCION MEDICA

CREATE TABLE Cita (
    id_cita SERIAL PRIMARY KEY,
    id_mascota_fk INT NOT NULL REFERENCES Mascota(id_mascota) ON DELETE CASCADE,
    id_sede_fk INT NOT NULL REFERENCES Sede(id_sede) ON DELETE CASCADE,
    id_veterinario_fk INT NOT NULL REFERENCES Veterinario(id_veterinario) ON DELETE CASCADE,
    fecha_hora TIMESTAMP NOT NULL,
    motivo VARCHAR(200),
    estado VARCHAR(20) DEFAULT 'Agendada' CHECK (estado IN ('Agendada', 'Reprogramada', 'Cancelada', 'Atendida'))
);

CREATE TABLE Consulta (
    id_consulta SERIAL PRIMARY KEY,
    id_cita_fk INT UNIQUE NOT NULL REFERENCES Cita(id_cita) ON DELETE CASCADE,
    sintomas TEXT NOT NULL,
    diagnostico TEXT NOT NULL,
    indicaciones TEXT
);

CREATE TABLE Examen_Laboratorio (
    id_examen SERIAL PRIMARY KEY,
    id_consulta_fk INT NOT NULL REFERENCES Consulta(id_consulta) ON DELETE CASCADE,
    nombre_examen VARCHAR(100) NOT NULL,
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_resultado TIMESTAMP,
    resultado TEXT,
    archivo_adjunto BYTEA
);

CREATE TABLE Receta_Medicamento (
    id_receta SERIAL PRIMARY KEY,
    id_consulta_fk INT NOT NULL REFERENCES Consulta(id_consulta) ON DELETE CASCADE,
    id_lote_fk INT NOT NULL REFERENCES Lote_Inventario(id_lote),
    dosis VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    duracion VARCHAR(50) NOT NULL,
    cantidad_descontada INT NOT NULL CHECK (cantidad_descontada > 0)
);

CREATE TABLE Aplicacion_Vacuna (
    id_vacunacion SERIAL PRIMARY KEY,
    id_consulta_fk INT NOT NULL REFERENCES Consulta(id_consulta) ON DELETE CASCADE,
    id_lote_fk INT NOT NULL REFERENCES Lote_Inventario(id_lote),
    fecha_aplicacion DATE DEFAULT CURRENT_DATE,
    fecha_siguiente_dosis DATE
);


-- 4. HOSPITALIZACION

CREATE TABLE Hospitalizacion (
    id_hospitalizacion SERIAL PRIMARY KEY,
    id_mascota_fk INT NOT NULL REFERENCES Mascota(id_mascota) ON DELETE CASCADE,
    id_jaula_fk INT NOT NULL REFERENCES Jaula(id_jaula),
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_salida TIMESTAMP
);

CREATE TABLE Nota_Evolucion (
    id_nota SERIAL PRIMARY KEY,
    id_hospitalizacion_fk INT NOT NULL REFERENCES Hospitalizacion(id_hospitalizacion) ON DELETE CASCADE,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nota TEXT NOT NULL
);


-- 5. FACTURACION Y PAGOS

CREATE TABLE Factura (
    id_factura SERIAL PRIMARY KEY,
    id_cliente_fk INT NOT NULL REFERENCES Cliente(id_cliente) ON DELETE CASCADE,
    id_consulta_fk INT REFERENCES Consulta(id_consulta) ON DELETE SET NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_factura NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    estado_pago VARCHAR(20) DEFAULT 'Pendiente' CHECK (estado_pago IN ('Pendiente', 'Parcial', 'Pagado'))
);

CREATE TABLE Detalle_Factura (
    id_detalle SERIAL PRIMARY KEY,
    id_factura_fk INT NOT NULL REFERENCES Factura(id_factura) ON DELETE CASCADE,
    concepto VARCHAR(100) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal NUMERIC(10,2) NOT NULL CHECK (subtotal >= 0)
);

CREATE TABLE Pago (
    id_pago SERIAL PRIMARY KEY,
    id_factura_fk INT NOT NULL REFERENCES Factura(id_factura) ON DELETE CASCADE,
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    monto NUMERIC(10,2) NOT NULL CHECK (monto > 0),
    forma_pago VARCHAR(20) NOT NULL CHECK (forma_pago IN ('Efectivo', 'Tarjeta', 'Transferencia'))
);


-- vamos hacer los 10 registros por tabla


-- 1. SEDE
INSERT INTO Sede (nombre, direccion, telefono) VALUES
('Sede Norte', 'Calle 127 #19-45', '6015551001'),
('Sede Sur', 'Carrera 27 #45-12', '6015551002'),
('Sede Occidente', 'Av. El Dorado #85-10', '6015551003'),
('Sede Centro', 'Calle 19 #4-88', '6015551004'),
('Sede Chapinero', 'Carrera 7 #58-21', '6015551005'),
('Sede Suba', 'Av. Suba #115-30', '6015551006'),
('Sede Usaquén', 'Carrera 9 #119-10', '6015551007'),
('Sede Poblado', 'Calle 10 #43-12', '6015551008'),
('Sede Fontibón', 'Calle 17 #98-05', '6015551009'),
('Sede Engativá', 'Carrera 70 #80-15', '6015551010');

-- 2. CLIENTE
INSERT INTO Cliente (num_documento, nombre, apellido, telefono, correo, direccion) VALUES
('10101', 'Carlos', 'Gómez', '3001112233', 'carlos@mail.com', 'Calle 10 #2-3'),
('10102', 'Ana', 'Martínez', '3002223344', 'ana@mail.com', 'Carrera 15 #45-12'),
('10103', 'Luis', 'Rodríguez', '3003334455', 'luis@mail.com', 'Calle 80 #11-25'),
('10104', 'Sofía', 'López', '3004445566', 'sofia@mail.com', 'Av. 68 #33-10'),
('10105', 'Fernando', 'Pérez', '3005556677', 'fernando@mail.com', 'Carrera 50 #12-00'),
('10106', 'Laura', 'García', '3006667788', 'laura@mail.com', 'Calle 170 #15-40'),
('10107', 'Diego', 'Hernández', '3007778899', 'diego@mail.com', 'Carrera 9 #80-12'),
('10108', 'María', 'Torres', '3008889900', 'maria@mail.com', 'Calle 53 #22-05'),
('10109', 'Jorge', 'Ramírez', '3009990011', 'jorge@mail.com', 'Carrera 100 #26-15'),
('10110', 'Paula', 'Sánchez', '3101234567', 'paula@mail.com', 'Calle 134 #9-50');

-- 3. VETERINARIO
INSERT INTO Veterinario (num_documento, nombre, apellido, tarjeta_profesional) VALUES
('20201', 'Roberto', 'Mendoza', 'TP-001'),
('20202', 'Elena', 'Vargas', 'TP-002'),
('20203', 'Gabriel', 'Castro', 'TP-003'),
('20204', 'Patricia', 'Morales', 'TP-004'),
('20205', 'Santiago', 'Ríos', 'TP-005'),
('20206', 'Camila', 'Suárez', 'TP-006'),
('20207', 'Andrés', 'Navarro', 'TP-007'),
('20208', 'Valeria', 'Ortega', 'TP-008'),
('20209', 'Felipe', 'Maldonado', 'TP-009'),
('20210', 'Daniela', 'Rojas', 'TP-010');

-- 4. ESPECIALIDAD
INSERT INTO Especialidad (nombre) VALUES
('Medicina General'),
('Cirugía Veterinaria'),
('Dermatología'),
('Oftalmología'),
('Cardiología'),
('Odontología'),
('Ortopedia'),
('Neurología'),
('Oncología'),
('Nutrición Animal');

-- 5. PRODUCTO
INSERT INTO Producto (nombre, tipo, descripcion) VALUES
('Amoxicilina 250mg', 'Medicamento', 'Antibiótico de amplio espectro'),
('Meloxicam 2.5mg', 'Medicamento', 'Antiinflamatorio no esteroideo'),
('Vacuna Antirrábica', 'Vacuna', 'Vacuna contra el virus de la rabia'),
('Vacuna DHPPL (Penta)', 'Vacuna', 'Vacuna múltiple canina'),
('Vacuna Triple Felina', 'Vacuna', 'Protección contra rinotraqueitis, calicivirus y panleucopenia'),
('Desparasitante Interno', 'Medicamento', 'Tratamiento contra parásitos intestinales'),
('Omeprazol 10mg', 'Medicamento', 'Protector gástrico'),
('Tramadol 20mg', 'Medicamento', 'Analgésico para dolor moderado a severo'),
('Vacuna Tos de las Kennels', 'Vacuna', 'Prevención de Traqueobronquitis canina'),
('Shampoo Medicado Clorhexidina', 'Medicamento', 'Tratamiento para afecciones dermatológicas');

-- 6. MASCOTA
INSERT INTO Mascota (id_cliente_fk, nombre, especie, raza, fecha_nacimiento, sexo, peso, num_microchip) VALUES
(1, 'Firulais', 'Perro', 'Labrador', '2020-05-10', 'Macho', 25.5, 'CHIP-001'),
(1, 'Michi', 'Gato', 'Siames', '2021-02-14', 'Macho', 4.2, 'CHIP-002'),
(2, 'Luna', 'Perro', 'Poodle', '2019-11-20', 'Hembra', 8.0, 'CHIP-003'),
(3, 'Thor', 'Perro', 'Bulldog', '2022-01-05', 'Macho', 18.3, 'CHIP-004'),
(4, 'Pelusa', 'Gato', 'Persa', '2020-08-30', 'Hembra', 3.8, 'CHIP-005'),
(5, 'Max', 'Perro', 'Golden Retriever', '2018-03-15', 'Macho', 30.1, 'CHIP-006'),
(6, 'Simba', 'Gato', 'Angora', '2021-06-12', 'Macho', 4.5, 'CHIP-007'),
(7, 'Rocky', 'Perro', 'Boxer', '2020-12-01', 'Macho', 22.0, 'CHIP-008'),
(8, 'Mia', 'Gato', 'Mestizo', '2022-04-18', 'Hembra', 3.2, 'CHIP-009'),
(9, 'Toby', 'Perro', 'Beagle', '2019-07-22', 'Macho', 12.4, 'CHIP-010');

-- 7. VETERINARIO_ESPECIALIDAD
INSERT INTO Veterinario_Especialidad (id_veterinario_fk, id_especialidad_fk) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- 8. HORARIO_VETERINARIO
INSERT INTO Horario_Veterinario (id_veterinario_fk, id_sede_fk, dia_semana, hora_inicio, hora_fin) VALUES
(1, 1, 'Lunes', '08:00:00', '16:00:00'),
(2, 1, 'Martes', '08:00:00', '16:00:00'),
(3, 2, 'Miércoles', '09:00:00', '17:00:00'),
(4, 2, 'Jueves', '09:00:00', '17:00:00'),
(5, 3, 'Viernes', '08:00:00', '16:00:00'),
(6, 3, 'Sábado', '08:00:00', '14:00:00'),
(7, 4, 'Lunes', '10:00:00', '18:00:00'),
(8, 5, 'Martes', '10:00:00', '18:00:00'),
(9, 6, 'Miércoles', '08:00:00', '16:00:00'),
(10, 7, 'Jueves', '08:00:00', '16:00:00');

-- 9. JAULA
INSERT INTO Jaula (id_sede_fk, codigo_jaula, estado) VALUES
(1, 'J-Norte-01', 'Ocupada'), (1, 'J-Norte-02', 'Disponible'),
(2, 'J-Sur-01', 'Ocupada'), (2, 'J-Sur-02', 'Disponible'),
(3, 'J-Occ-01', 'Disponible'), (3, 'J-Occ-02', 'Disponible'),
(4, 'J-Cen-01', 'Disponible'), (5, 'J-Cha-01', 'Disponible'),
(6, 'J-Sub-01', 'Disponible'), (7, 'J-Usa-01', 'Disponible');

-- 10. LOTE_INVENTARIO
INSERT INTO Lote_Inventario (id_producto_fk, id_sede_fk, num_lote, fecha_vencimiento, stock_actual) VALUES
(1, 1, 'LOTE-101', '2027-05-01', 50),
(2, 1, 'LOTE-102', '2026-12-01', 30),
(3, 2, 'LOTE-103', '2028-01-15', 100),
(4, 2, 'LOTE-104', '2027-08-20', 80),
(5, 3, 'LOTE-105', '2027-10-10', 40),
(6, 3, 'LOTE-106', '2026-11-30', 60),
(7, 4, 'LOTE-107', '2028-03-01', 25),
(8, 5, 'LOTE-108', '2027-02-18', 45),
(9, 6, 'LOTE-109', '2027-09-05', 70),
(10, 7, 'LOTE-110', '2028-06-12', 90);

-- 11. CITA
INSERT INTO Cita (id_mascota_fk, id_sede_fk, id_veterinario_fk, fecha_hora, motivo, estado) VALUES
(1, 1, 1, '2026-09-10 09:00:00', 'Chequeo general', 'Atendida'),
(2, 1, 2, '2026-09-10 10:00:00', 'Vacunación', 'Atendida'),
(3, 2, 3, '2026-09-11 11:00:00', 'Infección en piel', 'Atendida'),
(4, 2, 4, '2026-09-11 14:00:00', 'Revision de ojos', 'Atendida'),
(5, 3, 5, '2026-09-12 08:30:00', 'Evaluación cardíaca', 'Atendida'),
(6, 3, 6, '2026-09-12 10:00:00', 'Limpieza dental', 'Agendada'),
(7, 4, 7, '2026-09-13 15:00:00', 'Cojera pata trasera', 'Agendada'),
(8, 5, 8, '2026-09-14 09:30:00', 'Comportamiento anormal', 'Agendada'),
(9, 6, 9, '2026-09-15 11:30:00', 'Masa sospechosa', 'Agendada'),
(10, 7, 10, '2026-09-16 13:00:00', 'Control de peso', 'Agendada');

-- 12. CONSULTA
INSERT INTO Consulta (id_cita_fk, sintomas, diagnostico, indicaciones) VALUES
(1, 'Fiebre leve y decaimiento', 'Infección bacteriana leve', 'Reposo y tomar amoxicilina por 7 días'),
(2, 'Ninguno (Control)', 'Sano apto para vacuna', 'Aplicación de vacuna antirrábica'),
(3, 'Rascado excesivo y enrojecimiento', 'Dermatitis alérgica', 'Uso de shampoo medicado'),
(4, 'Secreción ocular izquierda', 'Conjuntivitis leve', 'Limpieza ocular diaria'),
(5, 'Fatiga al caminar', 'Soplo cardíaco grado I', 'Monitoreo de actividad física');

-- 13. EXAMEN_LABORATORIO
INSERT INTO Examen_Laboratorio (id_consulta_fk, nombre_examen, resultado) VALUES
(1, 'Hemograma Completo', 'Leucocitos ligeramente elevados'),
(3, 'Raspado de Piel', 'Negativo para ácaros, positivo para bacterias superficiales'),
(5, 'Ecocardiograma', 'Engrosamiento leve de válvula mitral'),
(1, 'Uroanálisis', 'Parámetros normales'),
(3, 'Cultivo Hongos', 'Negativo');

-- 14. RECETA_MEDICAMENTO
INSERT INTO Receta_Medicamento (id_consulta_fk, id_lote_fk, dosis, frecuencia, duracion, cantidad_descontada) VALUES
(1, 1, '1 pastilla 250mg', 'Cada 12 horas', '7 días', 14),
(3, 10, '1 baño', 'Cada 3 días', '2 semanas', 1),
(5, 2, '0.5 pastilla 2.5mg', 'Cada 24 horas', '5 días', 3);

-- 15. APLICACION_VACUNA
INSERT INTO Aplicacion_Vacuna (id_consulta_fk, id_lote_fk, fecha_aplicacion, fecha_siguiente_dosis) VALUES
(2, 3, '2026-09-10', '2027-09-10');

-- 16. HOSPITALIZACION
INSERT INTO Hospitalizacion (id_mascota_fk, id_jaula_fk, fecha_ingreso) VALUES
(1, 1, '2026-09-10 10:30:00'),
(3, 3, '2026-09-11 12:00:00');

-- 17. NOTA_EVOLUCION
INSERT INTO Nota_Evolucion (id_hospitalizacion_fk, nota) VALUES
(1, 'Paciente come bien, temperatura normalizada'),
(1, 'Paciente alerta, responde bien a tratamiento'),
(2, 'Se aplica compresa fría en área afectada');

-- 18. FACTURA
INSERT INTO Factura (id_cliente_fk, id_consulta_fk, total_factura, estado_pago) VALUES
(1, 1, 85000.00, 'Pagado'),
(1, 2, 45000.00, 'Pagado'),
(2, 3, 120000.00, 'Parcial'),
(3, 4, 60000.00, 'Pendiente'),
(4, 5, 150000.00, 'Pagado');

-- 19. DETALLE_FACTURA
INSERT INTO Detalle_Factura (id_factura_fk, concepto, cantidad, precio_unitario, subtotal) VALUES
(1, 'Consulta Médica General', 1, 50000.00, 50000.00),
(1, 'Amoxicilina 250mg', 1, 35000.00, 35000.00),
(2, 'Vacuna Antirrábica', 1, 45000.00, 45000.00),
(3, 'Consulta Especializada Dermatología', 1, 70000.00, 70000.00),
(3, 'Shampoo Medicado', 1, 50000.00, 50000.00);

-- 20. PAGO
INSERT INTO Pago (id_factura_fk, monto, forma_pago) VALUES
(1, 85000.00, 'Efectivo'),
(2, 45000.00, 'Tarjeta'),
(3, 60000.00, 'Transferencia'),
(5, 150000.00, 'Efectivo');













-- vamos a crear los indices

-- create index idxProductoCategoria on productos(categoriaId);


