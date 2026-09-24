
Cuando la tabla tiene un campo autoincrementable (`AUTO_INCREMENT` o `SERIAL`), la regla de oro es **omitir la columna en la lista del `INSERT`** o pasarle un valor nulo/por defecto para no romper la secuencia.

### A. En MariaDB (`AUTO_INCREMENT`)

SQL

```
-- Tabla
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

-- Forma 1: Omitiendo la columna autoincrementable (RECOMENDADA)
INSERT INTO producto (nombre, precio) VALUES ('Teclado', 150000.00);

-- Forma 2: Pasando NULL o DEFAULT
INSERT INTO producto VALUES (NULL, 'Mouse', 80000.00);

-- Recuperar el último ID generado en la sesión
SELECT LAST_INSERT_ID();
```

### B. En PostgreSQL (`SERIAL` / `IDENTITY`)

SQL

```
-- Tabla
CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

-- Forma 1: Omitiendo la columna (RECOMENDADA)
INSERT INTO producto (nombre, precio) VALUES ('Teclado', 150000.00);

-- Forma 2: Usando la palabra clave DEFAULT
INSERT INTO producto VALUES (DEFAULT, 'Mouse', 80000.00);

-- Recuperar el ID generado en el mismo instante (RETURNING)
INSERT INTO producto (nombre, precio) 
VALUES ('Monitor', 900000.00) 
RETURNING id_producto;
```