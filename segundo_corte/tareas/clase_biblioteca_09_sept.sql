/* SENTENCIAS DDL: Definicion de datos estructura */

/* Usar la base de datos */
use biblioteca;

/* Tabla libro */
create table libro(
    idLibro varchar(20) primary key,
    tituloLibro varchar(50) not null,
    identificacionAutorFK varchar(50),
    anoPublicacion year not null,
    estadoLibro bool
);

/* Tabla autor */
create table autor(
    indentificacionAutor varchar(50) primary key,
    nombreAutor varchar(20) not null,
    fechaNacimiento date
);

/* Relacion entre libro y autor */
alter table libro
add constraint autorlibro
foreign key (identificacionAutorFK)
references autor (indentificacionAutor);

/* Tabla miembro */
create table miembro(
    identificacionMiembro int auto_increment primary key,
    documentoMiembro int not null,
    nombreMiembro varchar(20) not null,
    direccionMiembro varchar(50) null,
    fechaInscripcion date not null,
    estadoMiembro bool
);

/* Tabla prestamo */
create table prestamo(
    idPrestamo int auto_increment primary key,
    fechaPrestamo date not null,
    fechaDevolucion date not null,
    estadoPrestamo bool,
    identificacionMiembroFK int,
    idLibroFK varchar(20),
    constraint fkprestamomiembro
        foreign key (identificacionMiembroFK)
        references miembro(identificacionMiembro)
        on delete cascade,
    constraint fkprestamolibro
        foreign key (idLibroFK)
        references libro(idLibro)
        on delete cascade
);

/* Ver la estructura de la tabla prestamo */
describe prestamo;

/*  En la tabla préstamo vamos a agregar un campo que se 
 *  llame descripción varchar de un tamaño de 100.  */


/* Alterar tabla [nombre] -> Agregar [columna] [tipo_de_dato]:*/
ALTER TABLE prestamo 
ADD descripcion VARCHAR(100);
/* ADD le indica a MariaDB que añada una nueva columna 
 * al final de la estructura de la tabla prestamo*/


/* En la taba libro vamos a cambiar año publicacion por varchar*/
ALTER TABLE libro 
MODIFY anoPublicacion VARCHAR(4) NOT NULL;


/* Eliminar una columna DROP COLUM 
 * DROP borra definitivamente la columna documentoMiembro.
 * (Si la tabla tuviera datos guardados en esa columna, esos datos se borrarían con ella*/
ALTER TABLE miembro  
DROP COLUMN documentoMiembro;

/* Renombrar una tabla 
 * en la tabla miembro vamos a cambiar el nombre de la tabla por socio
 * La tabla dejará de llamarse miembro y pasará a llamarse socio. 
 * Todas las relaciones (claves foráneas) asociadas se actualizan automáticamente.*/
ALTER TABLE miembro 
RENAME TO socio;




