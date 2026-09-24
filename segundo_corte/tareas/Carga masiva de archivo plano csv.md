Suponga  --> clientes.csv

id,nombre_cliente,email_cliente,ciudad,fecha_registro
1,Juan Perez,juan@mail.com,Bogota,2023-01-15
2,Ana Gomez,ana@mail.com,Medellin,2023-02-20

### A. Carga en MariaDB / MySQL

En MariaDB usaremos la sentencia `LOAD DATA INFILE`.
#### Paso 1: Crear la tabla destino

SQL

```
CREATE DATABASE IF NOT EXISTS tienda_kaggle;
USE tienda_kaggle;

CREATE TABLE clientes_staging (
    id INT,
    nombre_cliente VARCHAR(100),
    email_cliente VARCHAR(150),
    ciudad VARCHAR(80),
    fecha_registro DATE
);
```

#### Paso 2: Permitir la carga de archivos locales (Solo si te da error de permisos)

Ejecuta esto antes de cargar:

SQL

```
SET GLOBAL local_infile = 1;
```

#### Paso 3: Ejecutar el comando de inserción masiva

SQL

```
LOAD DATA LOCAL INFILE '/ruta/a/tu/archivo/clientes.csv'
INTO TABLE clientes_staging
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- Salta la primera fila de encabezados
```

### B. Carga en PostgreSQL

En PostgreSQL el método nativo es `COPY`.

#### Paso 1: Crear la tabla destino

SQL

```
CREATE TABLE clientes_staging (
    id INT,
    nombre_cliente VARCHAR(100),
    email_cliente VARCHAR(150),
    ciudad VARCHAR(80),
    fecha_registro DATE
);
```

#### Paso 2: Ejecutar el comando de carga

- **Desde la terminal con DBeaver / `psql` (Recomendado):**
    
    SQL
    
    ```
    \copy clientes_staging FROM '/ruta/a/tu/archivo/clientes.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
    ```
    
- **Desde un script de servidor (Requiere permisos de superusuario):**
    
    SQL
    
    ```
    COPY clientes_staging 
    FROM '/var/lib/postgresql/data/clientes.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');
    ```
    

