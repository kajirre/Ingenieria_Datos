
## Bloque 1 la base la (ddl)

Acá esta el modelo relacional -> [[reto1_mapa_finca.png]]
la reflexion esta en el final 


   #### 1. Tabla: `fincas`

| **Columna**              | **Tipo de Dato** | **Obligatorio** | **Regla de Negocio / Descripción**                                         |
| ------------------------ | ---------------- | --------------- | -------------------------------------------------------------------------- |
| `id_finca`               | `INT`            | **Sí**          | Clave primaria autoincremental.                                            |
| `nombre_finca`           | `VARCHAR(30)`    | **Sí**          | Nombre comercial de la finca.                                              |
| `caficultor_responsable` | `VARCHAR(30)`    | **Sí**          | Nombre del caficultor a cargo.                                             |
| `departamento`           | `VARCHAR(30)`    | **Sí**          | Departamento de ubicación de la finca.                                     |
| `municipio`              | `VARCHAR(30)`    | **Sí**          | Municipio cafetero real.                                                   |
| `altitud`                | `INT`            | **Sí**          | Restricción: Altitud en msnm. Debe estar entre 800 y 2.500.                |
| `activo`                 | `BOOLEAN`        | **Sí**          | Valor por defecto `TRUE`. Permite la baja lógica para no borrar historial. |

#### 2. Tabla: `lotes`

|**Columna**|**Tipo de Dato**|**Obligatorio**|**Regla de Negocio / Descripción**|
|---|---|---|---|
|`id_lote`|`INT`|**Sí**|Clave primaria autoincremental.|
|`id_finca`|`INT`|**Sí**|Clave foránea que referencia a `fincas(id_finca)`.|
|`codigo_lote`|`VARCHAR(20)`|**Sí**|Restricción: Único (`UNIQUE`), ej. HUI-2026-014.|
|`variedad`|`VARCHAR(30)`|**Sí**|Variedad del café (Castillo, Caturra, Geisha, Bourbon, etc.).|
|`proceso`|`VARCHAR(30)`|**Sí**|Restricción: Proceso del café ('lavado', 'honey' o 'natural').|
|`fecha_cosecha`|`DATE`|**Sí**|Fecha en que se cosechó el lote.|
|`kilo_lote`|`DECIMAL(10,2)`|**Sí**|Cantidad total de kilos cosechados del lote.|

#### 3. Tabla: `catadores`

|**Columna**|**Tipo de Dato**|**Obligatorio**|**Regla de Negocio / Descripción**|
|---|---|---|---|
|`id_catador`|`INT`|**Sí**|Clave primaria autoincremental.|
|`nombre_catador`|`VARCHAR(50)`|**Sí**|Nombre completo del catador profesional.|

#### 4. Tabla: `cataciones`

|**Columna**|**Tipo de Dato**|**Obligatorio**|**Regla de Negocio / Descripción**|
|---|---|---|---|
|`id_catacion`|`INT`|**Sí**|Clave primaria autoincremental.|
|`id_catador`|`INT`|**Sí**|Clave foránea que referencia a `catadores(id_catador)`.|
|`id_lote`|`INT`|**Sí**|Clave foránea que referencia a `lotes(id_lote)`.|
|`puntaje`|`DECIMAL(5,2)`|**Sí**|Restricción: Puntaje SCA entre 0.00 y 100.00.|

#### 5. Tabla: `tostiones`

|**Columna**|**Tipo de Dato**|**Obligatorio**|**Regla de Negocio / Descripción**|
|---|---|---|---|
|`id_tostion`|`INT`|**Sí**|Clave primaria autoincremental.|
|`id_lote`|`INT`|**Sí**|Clave foránea que referencia a `lotes(id_lote)`.|
|`fecha_tostion`|`DATE`|**Sí**|Fecha en la que se realizó el tostado.|
|`kilos_entrada`|`DECIMAL(10,2)`|**Sí**|Cantidad de kilos de café verde que entraron.|
|`kilos_salida`|`DECIMAL(10,2)`|**Sí**|Restricción: Kilos tostados obtenidos. Debe ser menor o igual a `kilos_entrada`.|
|`perfil`|`VARCHAR(20)`|**Sí**|Restricción: Perfil de tostión ('claro', 'medio' u 'oscuro').|

#### 6. Tabla: `clientes`

|**Columna**|**Tipo de Dato**|**Obligatorio**|**Regla de Negocio / Descripción**|
|---|---|---|---|
|`id_cliente`|`INT`|**Sí**|Clave primaria autoincremental.|
|`num_cliente`|`INT`|**Sí**|Número identificador/código de cliente.|
|`nombre`|`VARCHAR(20)`|**Sí**|Nombre o razón social del cliente.|
|`telefono`|`VARCHAR(20)`|**No**|Teléfono de contacto del cliente.|
|`correo`|`VARCHAR(30)`|**Sí**|Correo electrónico de contacto del cliente.|

#### 7. Tabla: `pedidos`

|**Columna**|**Tipo de Dato**|**Obligatorio**|**Regla de Negocio / Descripción**|
|---|---|---|---|
|`id_pedido`|`INT`|**Sí**|Clave primaria autoincremental.|
|`id_cliente`|`INT`|**Sí**|Clave foránea que referencia a `clientes(id_cliente)`.|
|`fecha_pedido`|`DATE`|**Sí**|Fecha en la que se realizó el pedido.|
|`estado`|`VARCHAR(20)`|**Sí**|Restricción: Valor por defecto `'pendiente'`.|

#### 8. Tabla: `detalle_pedido` (Líneas de Pedido)

|**Columna**|**Tipo de Dato**|**Obligatorio**|**Regla de Negocio / Descripción**|
|---|---|---|---|
|`id_detalle_pedido`|`INT`|**Sí**|Clave primaria autoincremental.|
|`id_pedido`|`INT`|**Sí**|Clave foránea que referencia a `pedidos(id_pedido)`.|
|`id_tostion`|`INT`|**Sí**|Clave foránea que referencia a `tostiones(id_tostion)`.|
|`kilos`|`DECIMAL(10,2)`|**Sí**|Cantidad de kilos solicitados de esa tostión.|
|`precio`|`DECIMAL(10,2)`|**Sí**|Precio negociado por kilo para esa línea.|

## Reflexion 
 en la tabla de la finca se dejo una viriable bool para indicar si esta activa o no, con eso el flujo sigue normal dentro de la base datos solo que la finca puede estar activa o no