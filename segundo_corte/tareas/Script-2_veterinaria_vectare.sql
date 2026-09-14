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