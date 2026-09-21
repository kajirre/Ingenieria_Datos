-- lenguaje de modelacion de datos (DML)

-- CREAMOS LAS PRIMERAS TABLAS
 
-- DEPARTAMENTOS
create table Departamento(
    id_Departamento serial primary key,
    nombre_Departamento varchar(50) not null 
);

-- EMPLEADOS
create table Empleado(
	id_Empleado serial primary key, -- aumenta de 1 en 1
	nombre_Empleado varchar(50) not null,
	edad int not null,
	salario decimal(10, 2) not null,
	fecha_Contratacion date not null,
	id_Departamento_FK int, -- tipo int (no SERIAL), porque recibe el ID que ya existe
	foreign key (id_Departamento_FK)  references Departamento(id_Departamento)
);

/*  DATOS DE PRUEBA */


-- datos de departamento
insert into Departamento (nombre_Departamento) values 
	('Ventas'),
	('It'),
	('Recursos Humanos'),
	('Finanzas');

-- datos de empleado
-- la verdad el restro de registros los hizo la IA pero yo le indique como los tenia que crear :v
-- Poblado masivo de datos para la tabla Empleado (100 registros)
INSERT INTO Empleado (nombre_Empleado, edad, salario, fecha_Contratacion, id_Departamento_FK) VALUES
	('Carlos Ruiz', 35, 3800000.00, '2019-06-10', 2),
	('Andrés López', 32, 5100000.00, '2022-01-20', 1),
	('Camila Torres', 42, 4500000.00, '2018-11-05', 3),
	('David Pérez', 29, 1350000.00, '2020-08-12', 2),
	('Sofia Mendoza', 31, 4800000.00, '2023-02-01', 4),
	('Cristian Silva', 38, 1900000.00, '2017-04-18', 1),
	('Laura Morales', 26, 4100000.00, '2021-09-30', 2),
	('Alejandro Gómez', 45, 6200000.00, '2015-05-12', 4),
	('Carolina Herrera', 24, 1250000.00, '2023-06-15', 1),
	('Adrian Castro', 33, 3400000.00, '2020-01-10', 3),
	('Beatriz Pinzón', 29, 2800000.00, '2021-11-01', 2),
	('Camilo Vargas', 39, 4900000.00, '2018-03-22', 1),
	('Daniela Ortiz', 27, 1600000.00, '2022-08-14', 3),
	('Esteban Quito', 30, 2300000.00, '2019-12-05', 2),
	('Felipe Restrepo', 41, 5500000.00, '2016-07-19', 4),
	('Gloria Trevi', 36, 3100000.00, '2020-04-30', 1),
	('Hector Lavoe', 44, 5800000.00, '2014-02-11', 2),
	('Isabel Pantoja', 25, 1400000.00, '2023-01-15', 3),
	('Javier Sotomayor', 34, 3700000.00, '2021-05-20', 4),
	('Karen Abudinen', 28, 2100000.00, '2022-03-10', 1),
	('Luis Miguel', 50, 8500000.00, '2010-09-01', 4),
	('Marta Sánchez', 37, 4300000.00, '2018-08-25', 2),
	('Nicolas Arrieta', 31, 2900000.00, '2020-10-12', 3),
	('Olga Tañón', 43, 4700000.00, '2017-01-30', 1),
	('Pablo Escobar', 40, 6000000.00, '2016-11-15', 2),
	('Alvaro Uribe', 48, 7200000.00, '2012-04-10', 4),
	('Claudia López', 35, 3900000.00, '2019-09-05', 3),
	('Gustavo Petro', 46, 6800000.00, '2013-06-20', 1),
	('Rodolfo Hernández', 52, 7500000.00, '2011-03-18', 4),
	('Francia Márquez', 33, 3600000.00, '2021-07-12', 3),
	('Angelica Lozano', 29, 2500000.00, '2022-02-28', 2),
	('Cesar Gaviria', 47, 6400000.00, '2014-10-08', 4),
	('Arturo Calle', 55, 9000000.00, '2008-01-15', 1),
	('Mario Hernández', 53, 8800000.00, '2009-05-22', 2),
	('Shakira Mebarak', 38, 7900000.00, '2015-12-01', 3),
	('Juanes Aristizabal', 41, 5600000.00, '2017-08-14', 1),
	('Carlos Vives', 49, 6700000.00, '2013-02-19', 4),
	('Silvestre Dangond', 34, 4200000.00, '2019-11-30', 2),
	('Karol G', 28, 5000000.00, '2021-04-18', 3),
	('J Balvin', 36, 6100000.00, '2016-03-25', 1),
	('Maluma Londoño', 27, 4800000.00, '2020-07-07', 2),
	('Aida Merlano', 30, 1800000.00, '2022-09-12', 3),
	('Aurelio Cheveroni', 23, 1200000.00, '2024-01-10', 1),
	('Clementina Suarez', 32, 2700000.00, '2021-06-18', 4),
	('Alvaro Lemmon', 45, 3100000.00, '2018-02-20', 2),
	('Cristhian Daes', 42, 7000000.00, '2014-05-11', 1),
	('Amparo Grisales', 60, 9500000.00, '2005-08-30', 3),
	('Cesar Escola', 51, 6300000.00, '2012-11-04', 4),
	('Andrea Serna', 39, 5200000.00, '2017-09-15', 2),
	('Carolina Cruz', 37, 4600000.00, '2019-01-22', 1),
	('Ana Karina Soto', 35, 3300000.00, '2020-05-18', 3),
	('Alberto Gamero', 50, 5900000.00, '2013-07-01', 4),
	('Ariel Osorio', 33, 2400000.00, '2022-04-10', 2),
	('Alfonso Lizarazo', 58, 4000000.00, '2007-03-12', 1),
	('Celeste Cid', 26, 1750000.00, '2023-03-20', 3),
	('Cristina Hurtado', 31, 3500000.00, '2021-08-05', 2),
	('Alejandro Estrada', 34, 2850000.00, '2020-02-14', 4),
	('Camilo Cifuentes', 40, 4400000.00, '2018-10-28', 1),
	('Aida Victoria', 24, 1950000.00, '2023-07-01', 3),
	('Cintia Cossio', 28, 2200000.00, '2022-11-19', 2),
	('Yeferson Cossio', 29, 5300000.00, '2021-12-08', 1),
	('Alexander Ospina', 36, 3750000.00, '2019-04-17', 4),
	('Abelardo De La Espriella', 44, 8200000.00, '2013-09-23', 2),
	('Claudia Gurisatti', 46, 6100000.00, '2015-01-14', 3),
	('Anibal Gaviria', 48, 5700000.00, '2014-06-30', 1),
	('Carlos Mattos', 54, 7800000.00, '2010-12-05', 4),
	('Alex Char', 43, 6900000.00, '2016-08-18', 2),
	('Camilo Romero', 37, 3950000.00, '2018-05-09', 3),
	('Andres Pastrana', 56, 4500000.00, '2009-02-17', 1),
	('Belisario Betancur', 62, 3200000.00, '2004-10-10', 4),
	('Cesar Turbay', 59, 3600000.00, '2006-11-25', 2),
	('Antanas Mockus', 57, 5100000.00, '2008-07-04', 3),
	('Angelino Garzon', 61, 2900000.00, '2005-01-20', 1),
	('Alejandro Gaviria', 45, 5400000.00, '2016-02-28', 4),
	('Cecilia Alvarez', 49, 4800000.00, '2013-04-15', 2),
	('Clara Lopez', 53, 4200000.00, '2011-09-09', 3),
	('Armando Benedetti', 42, 3800000.00, '2017-06-12', 1),
	('Roy Barreras', 47, 4900000.00, '2015-10-03', 4),
	('Arturo Char', 41, 5300000.00, '2018-01-29', 2),
	('Alexander Vega', 38, 4100000.00, '2019-07-21', 3),
	('Carlos Holmes', 52, 4600000.00, '2012-03-14', 1),
	('Alicia Arango', 50, 3700000.00, '2014-11-08', 4),
	('Angela Maria Orozco', 44, 4300000.00, '2016-09-17', 2),
	('Carmen Ligia', 41, 3900000.00, '2018-12-02', 3),
	('Alberto Carrasquilla', 48, 6500000.00, '2013-08-11', 1),
	('Ariadna Gutierrez', 27, 2600000.00, '2022-05-19', 4),
	('Paulina Vega', 28, 3100000.00, '2021-10-24', 2),
	('Gabriela Tafur', 26, 2800000.00, '2023-02-14', 3),
	('Laura Olascuaga', 25, 1500000.00, '2023-09-01', 1),
	('Valeria Ayos', 26, 1850000.00, '2022-12-10', 4),
	('Maria Fernanda Aristizabal', 24, 1300000.00, '2024-02-01', 2),
	('Camila Escribens', 25, 1450000.00, '2023-11-15', 3),
	('Amanda Dudamel', 23, 1220000.00, '2024-03-01', 1),
	('Alessia Rovegno', 24, 1280000.00, '2023-10-20', 4),
	('Andreina Fargas', 25, 1390000.00, '2023-08-05', 2),
	('Celeste Viel', 23, 1210000.00, '2024-01-18', 3),
	('Athenea Perez', 26, 1650000.00, '2023-04-12', 1),
	('Anntonia Porsild', 27, 2100000.00, '2022-07-22', 4),
	('Sheynnis Palacios', 23, 1200000.00, '2024-02-20', 2);


/*  CONSULTAS  */

select * from departamento
select * from empleado 

/* 1 */
/* obtener nombre, edad, salario de la tabla empleado */
select e.nombre_empleado, e.edad, e.salario   from empleado e ;

/* 2 */
/* Empleados cons salarios superiores a 4 Millones */
select * from empleado where salario  > 4000000;

/* 3 */
/* Empleados que trabajan en el departamento de ventas */
select * from empleado where id_departamento_fk = 1; -- 1 es ventas 

/* 4 */
/* Empleados que tienen entre 30 y 40 */
select * from empleado where edad >= 30 and edad <= 40;
select * from empleado e where edad between 30 and 40;


/* 5 */
/* Contratados después del año 2020 */
select * from empleado where fecha_contratacion > '2020-12-31';
select * from empleado where extract(year from fecha_contratacion) > 2020;

/* 6 */
/* Cuantos empleados en cada departamento
 
  COUNT(): Una función de agregación que cuenta la cantidad de filas.
  GROUP BY: Agrupa los registros por una columna 
  (en este caso, por el nombre del departamento). 						*/

/* OTRA FORMA DE HACERLO */
SELECT 
    id_departamento_fk, 
    COUNT(*) AS total_empleados
FROM empleado
GROUP BY id_departamento_fk;

/* 7 */
/* ANALISIS SALARIAL */
-- avg toma los valores de la columna salario suma y divide 
-- as es el apodo que le ponemos a esa opereacion
select avg(salario) as salario_promedio from empleado e;

-- puede tener redondeo porque tiene dos decimales asi que 
select round(avg(salario), 0) as salario_promedio from empleado e;


/* 8 */
/* NOMBRES SELECTIVOS */
select * from empleado where nombre_empleado ilike 'A%' or nombre_empleado ilike 'C%';
-- Con el operador ~* (ignora mayúsculas y minúsculas)
-- El ^ indica que el nombre DEBE empezar por esa letra
select * from empleado  where nombre_empleado ~* '^(A|C)';


/* 9 */
/* EMPLEADOS QUE NO ESTAN EN TI */
select * from empleado where id_departamento_fk != 2;
select * from empleado e where e.id_departamento_fk not in (2);



/* 9 */
/* EMPLEADOS QUE GANA MAS */
select * from empleado e order by e.salario desc limit 1;







