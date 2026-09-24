### A. Funciones de Carácter (Texto)

|**Función**|**Descripción**|**MariaDB**|**PostgreSQL**|**Ejemplo de Uso**|
|---|---|---|---|---|
|**Mayúsculas**|Convierte texto a mayúsculas|`UPPER(str)`|`UPPER(str)`|`SELECT UPPER(nombre) FROM cliente;`|
|**Minúsculas**|Convierte texto a minúsculas|`LOWER(str)`|`LOWER(str)`|`SELECT LOWER(correo) FROM cliente;`|
|**Longitud**|Cuenta número de caracteres|`CHAR_LENGTH(str)`|`LENGTH(str)` / `CHAR_LENGTH(str)`|`SELECT CHAR_LENGTH(num_documento) FROM cliente;`|
|**Concatenación**|Une dos o más textos|`CONCAT(s1, s2)`|`CONCAT(s1, s2)` o `s1 \| s2`|`SELECT CONCAT(nombre, ' ', apellido) FROM cliente;`|
|**Subcadena**|Extrae una parte del texto|`SUBSTRING(str, pos, len)`|`SUBSTRING(str FROM pos FOR len)`|`SELECT SUBSTRING(telefono, 1, 3) FROM cliente;`|
|**Limpieza espacios**|Elimina espacios a los lados|`TRIM(str)`|`TRIM(str)`|`SELECT TRIM(nombre) FROM sede;`|
|**Reemplazo**|Reemplaza texto por otro|`REPLACE(str, busq, reemp)`|`REPLACE(str, busq, reemp)`|`SELECT REPLACE(especie, 'Perro', 'Canino') FROM mascota;`|
|**Buscar posición**|Posición donde inicia subtexto|`POSITION(sub IN str)`|`POSITION(sub IN str)`|`SELECT POSITION('@' IN correo) FROM cliente;`|
|**Primeros N chars**|Corta N caracteres por la izquierda|`LEFT(str, n)`|`LEFT(str, n)`|`SELECT LEFT(num_documento, 3) FROM cliente;`|
|**Últimos N chars**|Corta N caracteres por la derecha|`RIGHT(str, n)`|`RIGHT(str, n)`|`SELECT RIGHT(tarjeta_prof, 3) FROM veterinario;`|
|**Relleno Izquierda**|Padea texto a la izquierda|`LPAD(str, len, pad)`|`LPAD(str::text, len, pad)`|`SELECT LPAD(id::text, 5, '0') FROM cliente;`|
|**Formato Título**|Primera letra en mayúscula|No nativo (`CONCAT+UPPER`)|`INITCAP(str)`|`SELECT INITCAP('clinica vetcare');`|
|**Dividir Texto**|Parte por delimitador y toma N|No nativo (`SUBSTRING_INDEX`)|`SPLIT_PART(str, delim, n)`|`SELECT SPLIT_PART(correo, '@', 2) FROM cliente;`|

### B. Funciones Numéricas (Enteros y Decimales)

| **Función**        | **Descripción**               | **MariaDB**              | **PostgreSQL**           | **Ejemplo de Uso**                       |
| ------------------ | ----------------------------- | ------------------------ | ------------------------ | ---------------------------------------- |
| **Valor Absoluto** | Devuelve el valor positivo    | `ABS(x)`                 | `ABS(x)`                 | `SELECT ABS(-150);`                      |
| **Redondeo**       | Redondea a N decimales        | `ROUND(x, d)`            | `ROUND(x, d)`            | `SELECT ROUND(total, 2) FROM factura;`   |
| **Techo**          | Redondea hacia arriba         | `CEIL(x)` / `CEILING(x)` | `CEIL(x)` / `CEILING(x)` | `SELECT CEIL(peso) FROM mascota;`        |
| **Piso**           | Redondea hacia abajo          | `FLOOR(x)`               | `FLOOR(x)`               | `SELECT FLOOR(peso) FROM mascota;`       |
| **Truncar**        | Corta decimales sin redondear | `TRUNCATE(x, d)`         | `TRUNC(x, d)`            | `SELECT TRUNC(precio, 1) FROM producto;` |
| **Módulo**         | Resto de la división entera   | `MOD(x, y)`              | `MOD(x, y)` o `x % y`    | `SELECT MOD(stock, 2) FROM inventario;`  |
| **Potencia**       | Eleva X a la potencia Y       | `POWER(x, y)`            | `POWER(x, y)`            | `SELECT POWER(2, 3);`                    |
| **Raíz Cuadrada**  | Raíz cuadrada de X            | `SQRT(x)`                | `SQRT(x)`                | `SELECT SQRT(64);`                       |
| **Signo**          | Retorna 1, -1 o 0 según signo | `SIGN(x)`                | `SIGN(x)`                | `SELECT SIGN(stock) FROM inventario;`    |
| **Aleatorio**      | Número aleatorio entre 0 y 1  | `RAND()`                 | `RANDOM()`               | `SELECT RANDOM();`                       |
| **Mayor de lista** | Devuelve el valor mayor       | `GREATEST(x, y, ...)`    | `GREATEST(x, y, ...)`    | `SELECT GREATEST(5, 12, 20);`            |
| **Menor de lista** | Devuelve el valor menor       | `LEAST(x, y, ...)`       | `LEAST(x, y, ...)`       | `SELECT LEAST(precio, subtotal);`        |