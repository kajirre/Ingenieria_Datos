# Tipos de Datos en Bases de Datos

En los sistemas de gestión de bases de datos (DBMS), el tipo de datos especifica el tipo de valor que una columna puede almacenar. Elegir el tipo de datos correcto garantiza la integridad de la información, optimiza el almacenamiento en disco y mejora el rendimiento de las consultas.

---

## 1. Tipos de Datos Numéricos

Se utilizan para almacenar valores numéricos, ya sean enteros o con punto flotante.

* **Enteros (Integer):** Almacenan números sin parte decimal.
* `TINYINT`: Almacena enteros en un rango pequeño (generalmente 1 byte, de -128 a 127).
* `INT` / `INTEGER`: Tipo estándar para enteros (generalmente 4 bytes, de -2,147,483,648 a 2,147,483,647).
* `BIGINT`: Para valores numéricos muy grandes (8 bytes).


* **Decimales de Precisión Exacta (Decimal / Numeric):**
* `DECIMAL(P, D)` / `NUMERIC(P, D)`: Almacena números con precisión exacta, donde `P` representa el número total de dígitos (precisión) y `D` el número de dígitos a la derecha del punto decimal (escala). Es ideal para datos financieros.


* **Punto Flotante (Floating-Point):**
* `FLOAT`: Almacena números de precisión simple con decimales.
* `DOUBLE` / `REAL`: Almacena números de precisión doble. Se utilizan cuando se requiere un amplio rango numérico y la precisión exacta al centavo no es crítica.



---

## 2. Tipos de Datos de Cadena y Texto

Se emplean para guardar texto, caracteres alfanuméricos y combinaciones de símbolos.

* **Cadena de Longitud Fija (CHAR):** 
* `CHAR(N)`: Reserva un espacio fijo de `N` caracteres. Si el texto insertado es más corto, el motor rellena el resto con espacios.


* **Cadena de Longitud Variable (VARCHAR / VARCHAR2):**
* `VARCHAR(N)`: Almacena cadenas de caracteres de hasta una longitud máxima de `N`. Solo consume el espacio del texto realmente ingresado más el encabezado de control.


* **Texto de Gran Tamaño (TEXT / CLOB):**
* `TEXT` / `CLOB` (Character Large Object): Diseñados para almacenar grandes volúmenes de texto, como artículos, descripciones largas o documentos JSON almacenados en formato de texto.



---

## 3. Tipos de Datos de Fecha y Hora

Permiten almacenar instancias temporales para registro de auditoría, programación o fechas de eventos.

* **DATE:** Almacena únicamente la fecha en formato de año, mes y día (`AAAA-MM-DD`).
* **TIME:** Almacena únicamente la hora (`HH:MM:SS`).
* **DATETIME / TIMESTAMP:** Almacena tanto la fecha como la hora.
* `DATETIME`: Guarda el valor tal como se ingresa, independientemente de la zona horaria del servidor.
* `TIMESTAMP`: Convierte el valor ingresado a formato UTC para almacenamiento y lo convierte de nuevo a la zona horaria local al recuperarlo.



---

## 4. Tipos de Datos Booleanos

* **BOOLEAN / BOOL:** Representa valores de lógica binaria. Acepta únicamente dos estados: `TRUE` (Verdadero) o `FALSE` (Falso). En algunos motores como MySQL, se implementa internamente como `TINYINT(1)` donde `1` es `TRUE` y `0` es `FALSE`.

---

## 5. Tipos de Datos Binarios

Diseñados para almacenar datos en formato de bytes sin procesar.

* **BINARY / VARBINARY:** Similares a `CHAR` y `VARCHAR`, pero almacenan bytes en lugar de caracteres.
* **BLOB (Binary Large Object):** Utilizado para almacenar objetos binarios de gran tamaño, como imágenes, archivos de audio, documentos PDF o ejecutables.

---

## 6. Tipos de Datos Estructurados y Avanzados

Motores modernos de bases de datos relacionales (como PostgreSQL o MySQL) incluyen soporte para formatos de datos complejos.

* **JSON / JSONB:** Almacena documentos con estructura JSON. `JSONB` (disponible en PostgreSQL) almacena la información en formato binario descompuesto, permitiendo la creación de índices sobre llaves específicas.
* **ENUM:** Define una lista de valores permitidos previamente declarada. La columna solo puede aceptar uno de los valores definidos en la lista.
* **UUID (Universally Unique Identifier):** Almacena identificadores únicos globales de 128 bits, comúnmente utilizados como llaves primarias en sistemas distribuidos.
* **ARRAY:** Permite almacenar listas o colecciones de elementos dentro de una sola celda (soportado nativamente por PostgreSQL).
