## ¿ Que es el formato JSON ?
formato ligero de intercambio de datos, cualquier lenguaje puede leerlo y escribirlo
### Estructura fundamental 
 
| Estructura | descripcion                                 | sintaxis          |
| ---------- | ------------------------------------------- | ----------------- |
| objeto     | colección desordenada de pares nombre/valor | {"clave": valor } |
| arreglo    | lista ordenada de valores                   | [valor1, valor2]  |
|            |                                             |                   |
estas estructuras se pueden anidar ed un objeto puede contener arreglos y un arreglo puede contener objetos.

### Tipos de valores permitidos
tambien conocidos como tipos primitivos de datos solo son 6

| Tipo            | Ejemplo                 | Restricción                                                                                       |
| --------------- | ----------------------- | ------------------------------------------------------------------------------------------------- |
| Cadena (string) | `"Hola mundo"`          | Comillas dobles, soporta Unicode y secuencias de escape                                           |
| Número          | `42`, `-3.14`, `1.5e10` | Sin formato octal ni hexadecimal; no admite `Infinity` ni `NaN`<br>int, long, double, date, array |
| Booleano        | `true`, `false`         | Siempre en minúsculas                                                                             |
| Nulo            | `null`                  | Representa ausencia de valor                                                                      |
| Objeto          | `{ "a": 1 }`            | Anidable  -> object                                                                               |
| Arreglo         | `[1, 2, 3]`             | Anidable                                                                                          |
### Ejemplo visual 
```
{
  "estudiante": 
  {
    "nombre": "Ana Pérez",
    "edad": 21,
    "carrera": "Ingeniería de Datos",
    "cursos": ["NoSQL", "Big Data", "Machine Learning"],
    "activo": true,
    "promedio": 4.2
  }
}
```

Estructura
```
{ (objeto raíz)
  └── "estudiante" : { (objeto anidado)
        ├── "nombre"   : "Ana Pérez"     (string)
        ├── "edad"     : 21              (número)
        ├── "carrera"  : "Ingeniería..." (string)
        ├── "cursos"   : [ ... ]         (arreglo de strings)
        ├── "activo"   : true            (booleano)
        └── "promedio" : 4.2             (número)
      }
}
```

| Regla                        | Correcto                      | Incorrecto        |
| ---------------------------- | ----------------------------- | ----------------- |
| Claves entre comillas dobles | `"nombre": "Ana"`             | `nombre: "Ana"`   |
| Sin comas finales            | `{"a":1, "b":2}`              | `{"a":1, "b":2,}` |
| Sin comentarios              | —                             | `// comentario`   |
| Codificación UTF-8           | Caracteres Unicode permitidos | —                 |
**JSON no deja hacer comentarios** 



