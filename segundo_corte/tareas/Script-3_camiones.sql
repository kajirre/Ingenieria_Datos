CREATE TABLE TipoUsuario (
    idTUsuario SERIAL PRIMARY KEY,
    nomTUsuario VARCHAR(20),
    EstadoTU VARCHAR(20)
);

CREATE TABLE TipoDoc (
    idTD SERIAL PRIMARY KEY,
    nomTD VARCHAR(20),
    EstadoTD VARCHAR(20)
);

CREATE TABLE Usuarios (
    idUsuario SERIAL PRIMARY KEY,
    idTDFK INT REFERENCES TipoDoc(idTD),
    numdocUsuario INT,
    nomUsuario VARCHAR(15),
    apellidoUsuario VARCHAR(30),
    telefonoUsuario INT,
    correoUsuario VARCHAR(40),
    direccionUsuario VARCHAR(40),
    fechanacUsuario TIMESTAMP,
    CiudadNac VARCHAR(40),
    idTUsuarioFK INT REFERENCES TipoUsuario(idTUsuario),
    numcelularUsuario INT,
    Passwordusuario VARCHAR(20),
    EstadoUsuario VARCHAR(20)
);

CREATE TABLE Recorrido (
    idRecorrido SERIAL PRIMARY KEY,
    nomRecorrido VARCHAR(50),
    localidad VARCHAR(30),
    EstadoRuta VARCHAR(20)
);

CREATE TABLE AsigRecorridoUsuario (
    idasigVehiculo SERIAL PRIMARY KEY,
    idUsuarioFK INT REFERENCES Usuarios(idUsuario),
    idRecorridoFK INT REFERENCES Recorrido(idRecorrido)
);

CREATE TABLE Marca (
    idmarcaVehiculo SERIAL PRIMARY KEY,
    nommarcaVehiculo VARCHAR(30),
    EstadoMarca VARCHAR(20)
);

CREATE TABLE Vehiculo (
    idvehiculo SERIAL PRIMARY KEY,
    idmarcaVehiculoFK INT REFERENCES Marca(idmarcaVehiculo),
    modeloVehiculo VARCHAR(20),
    fechaMatricula TIMESTAMP,
    EstadoVehiculo VARCHAR(20)
);

CREATE TABLE AsigVehiculoRecorrido (
    idasigVehiculo SERIAL PRIMARY KEY,
    idVehiculoFK INT REFERENCES Vehiculo(idvehiculo),
    idRecorridoFK INT REFERENCES Recorrido(idRecorrido)
);

CREATE TABLE DocVehiculo (
    idDocVehi SERIAL PRIMARY KEY,
    nomDocVehi VARCHAR(50),
    EstadoDoc VARCHAR(20)
);

CREATE TABLE CargueDoc (
    idCargueDoc SERIAL PRIMARY KEY,
    idDocVehiFK INT REFERENCES DocVehiculo(idDocVehi),
    idVehiculoFK INT REFERENCES Vehiculo(idvehiculo),
    fechaCargue TIMESTAMP,
    archivo BYTEA
);

CREATE TABLE Curso (
    idCurso SERIAL PRIMARY KEY,
    nomCurso VARCHAR(30),
    EstadoCurso VARCHAR(20)
);

CREATE TABLE AsigUsuarioCurso (
    idAsiguc SERIAL PRIMARY KEY,
    idUsuarioFK INT REFERENCES Usuarios(idUsuario),
    idCursoFK INT REFERENCES Curso(idCurso)
);

/* Pago */
CREATE TABLE Pago (
    idPago SERIAL PRIMARY KEY,
    fechaPago TIMESTAMP,
    idUsuarioFK INT REFERENCES Usuarios(idUsuario),
    totalPago INT,
    EstadoPago VARCHAR(20)
);

/*  Servicio */
CREATE TABLE Servicio (
    idServicio SERIAL PRIMARY KEY,
    nomServicio VARCHAR(40),
    valorServicio INT,
    EstadoServicio VARCHAR(20)
);

/* se puede crear DetallePago porque Pago y Servicio ya existen */
CREATE TABLE DetallePago (
    idDetalleServicio SERIAL PRIMARY KEY,
    idPagoFK INT REFERENCES Pago(idPago),
    idServicioFK INT REFERENCES Servicio(idServicio),
    descripcion VARCHAR(50),
    subTotal INT
);