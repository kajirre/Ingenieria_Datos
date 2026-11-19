
# Parte A - entorno y primero documentos
### A1
comprobar que estamos en la base de datos sabor ya
```
db.getName()
```
### A2
contar los documentos de las cuatro coleciones
```
print("Restaurantes: " + db.restaurantes.countDocuments()) 

Restaurantes: 11

print("Clientes: " + db.clientes.countDocuments()) 

Clientes: 8

print("Productos: " + db.productos.countDocuments()) 

Productos: 24

print("Pedidos: " + db.pedidos.countDocuments())   

Pedidos: 20

```

### A3
yo cree r12 porque ya antes en la bd habia creado r11
```
db.restaurante.insertOne({_id: "R12", nombre: "Café Arriero",categoria: "Cafetería",ciudad: "Medellín",barrio: "Laureles",calificacion: 4.5,domicilio: true,ubicacion: {type: "Point",coordinates: [-75.5925, 6.2442]},etiquetas: ["café", "postres"]})
```
me toco eliminar r11 anterior 
### A4
![[Pasted image 20261029145819.png]]

```
db.productos.insertMany([{ _id: "P25", restaurante_id: "R11", nombre: "Tinto campesino", tipo: "bebida", precio: 3500, stock: 100, disponible: true, volumen_ml: 200 },{ _id: "P26", restaurante_id: "R11", nombre: "Torta de zanahoria", tipo: "postre", precio: 9000, stock: 20, disponible: true }])
```

### A5
```
db.restaurante.find({ ciudad: "Medellín" })

{

_id: 'R06',

nombre: 'Verde Vivo',

categoria: 'Vegetariana',

ciudad: 'Medellín',

barrio: 'El Poblado',

calificacion: 4.4,

domicilio: false,

ubicacion: {

type: 'Point',

coordinates: [

-75.5664,

6.2088

]

},

etiquetas: [

'vegano',

'saludable'

],

menu_vegano: true

}
```

```
db.productos.countDocuments({ restaurante_id: "R11" })

```

type es pa saber el tipo de dato
### B1
```
// comprobar que las fechas son tipo date

db.pedidos.find({ fecha: { $type: "date" } })

// comprobar que ningun precio es texto 

db.productos.find({ precio: { $type: "string" } })

```

buscar datos de tipo double o numerico 
db.productos.find({ precio: { $type: "double" } }).count()
db.productos.find({ precio: { $type: "number" } }).count()
### B2

se puede crear una colecion propia llamada "reseñas" y ahí pogon el _ id de cliente y el nombre del cliente para mostralo en la seccion de reseñas
### B3
```
db.createCollection("resenas", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["restaurante_id", "cliente", "calificacion", "texto", "fecha"],
      properties: {
        restaurante_id: {
          bsonType: "string",
          description: "Debe ser un texto con el ID del restaurante"
        },
        cliente: {
          bsonType: "object",
          required: ["id", "nombre"],
          description: "Objeto con los datos del cliente",
          properties: {
            id: {
              bsonType: "string",
              description: "ID del cliente"
            },
            nombre: {
              bsonType: "string",
              description: "Nombre del cliente"
            }
          }
        },
        calificacion: {
          bsonType: "int",
          minimum: 1,
          maximum: 5,
          description: "Debe ser un entero entre 1 y 5"
        },
        texto: {
          bsonType: "string",
          minLength: 5,
          description: "El texto debe tener al menos 5 caracteres"
        },
        fecha: {
          bsonType: "date",
          description: "Debe ser una fecha válida (tipo Date)"
        },
        fotos: {
          bsonType: "array",
          maxItems: 4,
          items: {
            bsonType: "string"
          },
          description: "Opcional: arreglo de hasta 4 URLs de fotos en texto"
        }
      }
    }
  }
})
```
### B4
En una sola operación, inserta cuatro reseñas válidas (ver la tabla de datos debajo).
```
db.resenas.insertMany([
  {
    restaurante_id: "R02",
    cliente: { id: "C01", nombre: "Laura Gómez" },
    calificacion: 5,
    texto: "El ramen llegó caliente y bien empacado",
    fecha: new Date("2026-10-15T20:10:00-05:00")
  },
  {
    restaurante_id: "R02",
    cliente: { id: "C08", nombre: "Julián Castro" },
    calificacion: 4,
    texto: "Buen sushi, pero tardó 50 minutos",
    fecha: new Date("2026-10-16T21:30:00-05:00")
  },
  {
    restaurante_id: "R10",
    cliente: { id: "C07", nombre: "Daniela Martínez" },
    calificacion: 5,
    texto: "La cazuela es abundante",
    fecha: new Date("2026-10-17T13:45:00-05:00"),
    fotos: ["https://cdn.saborya.co/r/301.jpg", "https://cdn.saborya.co/r/302.jpg"]
  },
  {
    restaurante_id: "R04",
    cliente: { id: "C03", nombre: "Valentina Ríos" },
    calificacion: 2,
    texto: "Las papas llegaron frías",
    fecha: new Date("2026-10-18T19:05:00-05:00")
  }
])


// resultado 
 
{
	acknowledged: true,
	insertedIds: 
	{
	    '0': ObjectId('6aeb4e0f22ad597e32d39c8e'),
	    '1': ObjectId('6aeb4e0f22ad597e32d39c8f'),
	    '2': ObjectId('6aeb4e0f22ad597e32d39c90'),
	    '3': ObjectId('6aeb4e0f22ad597e32d39c91')
	}
}
```
### B5
Intenta insertar una reseña con calificación 6 para el R01. Explica en un comentario el error y qué parte de la regla lo produjo.

```
db.resenas.insertOne({
  restaurante_id: "R01",
  cliente: { id: "C05", nombre: "Prueba Error" },
  calificacion: 6, 
  texto: "Esta reseña tiene calificación inválida",
  fecha: new Date()
})

```

esto arroja el error: [MongoServerError:](#) Document failed validation
arroja error porque en la creacion de reseñas esta prohibido que sea menos a 1 y mayor a 5.
entonces bloqueo la insercion del dato, basicamente es un error e validacion 
### B6
|Muestra las reseñas escritas por Laura Gómez (C01) y las reseñas que tienen al menos una foto.|
|---|
```
db.resenas.find( { "cliente.id" : "C01" } )

// resultado

{
  _id: ObjectId('6aeb4e0f22ad597e32d39c8e'),
  restaurante_id: 'R02',
  cliente: {
    id: 'C01',
    nombre: 'Laura Gómez'
  },
  calificacion: 5,
  texto: 'El ramen llegó caliente y bien empacado',
  fecha: 2026-10-16T01:10:00.000Z
}

```
### B7

Aplica denormalización controlada: guarda en el restaurante R02 un subdocumento resumen_resenas con su promedio y su total de reseñas. Calcula los valores a partir de los datos de B4.

la verdad no se como hacer eso 
```

```
### B8
Obtén la lista de restaurantes distintos que tienen reseñas.
```
db.resenas.distinct("restaurante_id")

// resultado
[ 'R02', 'R04', 'R10' ]

```
El método `.distinct("campo")` en MongoDB devuelve un arreglo con los valores únicos que existen para ese campo en la colección.
### C1
Platos disponibles con stock menor a 20 unidades. Muestra nombre y stock, sin _id, del menor al mayor stock.

```
db.productos.find(
  { 
    $and: [ 
      { disponible: true }, 
      { stock: { $lt: 20 } } 
    ] 
  },
  { nombre: 1, stock: 1, _id: 0 }
).sort({ stock: 1 })

// Respuesta 
{
  nombre: 'Cazuela de mariscos',
  stock: 10
}
{
  nombre: 'Picada para dos',
  stock: 12
}
{
  nombre: 'Arroz con coco y pescado',
  stock: 14
}

```


### C2
|Pedidos con total entre 50.000 y 80.000 (inclusive) pagados en efectivo o con nequi. Muestra el total y el método de pago.|
|---|

```
db.pedidos.find(
  { 
    total: { $gte: 50000, $lte: 80000 }, 
    metodo_pago: { $in: ["efectivo", "nequi"] } 
  },
  { total: 1, metodo_pago: 1, _id: 0 }
)


// Respuesta



{
  metodo_pago: 'efectivo',
  total: 64000
}
{
  metodo_pago: 'nequi',
  total: 67000
}
{
  metodo_pago: 'efectivo',
  total: 78000
}

```


### C3

Los 3 restaurantes de Bogotá con mejor calificación. Muestra nombre y calificación.

```
//Los 3 restaurantes de Bogotá con mejor calificación. Muestra nombre y calificación.

db.restaurantes.find(
  { ciudad : "Bogotá" },
  { nombre : 1, calificacion : 1, _id : 0 }  
).sort({ calificacion : -1 }).limit(3)


// Resultado

{
  nombre: 'Sushi Nikko',
  calificacion: 4.8
}

{
  nombre: 'Arepas La 19',
  calificacion: 4.6
}

{
  nombre: 'Ajiaco & Co',
  calificacion: 4.5
}

```


### C4

Los 3 restaurantes de Bogotá con mejor calificación. Muestra nombre y calificación.

| Clientes de Bogotá con más de 100 puntos. |
| ----------------------------------------- |

dice 

```

db.clientes.find(
	{ ciudad : "Bogotá", puntos: { $gt : 100}},
	{ nombre : 1, ciudad : 1, puntos : 1, _id : 0}
)


// Respuesta


{
  nombre: 'Laura Gómez',
  ciudad: 'Bogotá',
  puntos: 120
}
{
  nombre: 'Andrés Rojas',
  ciudad: 'Bogotá',
  puntos: 340
}
{
  nombre: 'Julián Castro',
  ciudad: 'Bogotá',
  puntos: 600
}

```


### C5

|Pedidos hechos entre el 12 y el 14 de octubre de 2026 (hora de Colombia, ambos días incluidos) que no estén entregados.|
|---|
esto tiene dos filtros, el primero de la fecha:
- **Inicio:** `new Date("2026-10-12T00:00:00-05:00")`
- **Fin (exclusivo):** `new Date("2026-10-15T00:00:00-05:00")`
- `{ fecha: { $gte: new Date("2026-10-12T00:00:00-05:00"), $lt: new Date("2026-10-15T00:00:00-05:00") } }`
- mayor que new Date, menor que new Date
- el otro de la condicion del estado(entregado: no entregado -> `$ne` (not equal) )
- `{ estado: { $ne: "entregado" } }`
- Proyecta solo los campos necesarios, muestra los campos que sirvan para verificar: `_id` del pedido, `fecha` y `estado`.

```
db.pedidos.find(
  {
    fecha: { 
      $gte: new Date("2026-10-12T00:00:00-05:00"), 
      $lt: new Date("2026-10-15T00:00:00-05:00") 
    },
    estado: { $ne: "entregado" }
  },
  { _id: 1, fecha: 1, estado: 1 }
)


// respuesta 

{
  _id: 'PD015',
  fecha: 2026-10-12T23:30:00.000Z,
  estado: 'en_camino'
}
{
  _id: 'PD016',
  fecha: 2026-10-12T18:00:00.000Z,
  estado: 'pendiente'
}
{
  _id: 'PD017',
  fecha: 2026-10-14T01:20:00.000Z,
  estado: 'en_camino'
}
{
  _id: 'PD018',
  fecha: 2026-10-14T02:00:00.000Z,
  estado: 'pendiente'
}
{
  _id: 'PD020',
  fecha: 2026-10-15T00:10:00.000Z,
  estado: 'cancelado'
}
```



### C6

|Pedidos con algún ítem de precio menor a 10.000 y cantidad de 2 o más en ese mismo ítem. Luego ejecuta la versión sin $elemMatch. Explica en un comentario por qué el resultado cambia.|
|---|

```

db.pedidos.find(
  { 
    "items.precio": { $lt: 10000 }, 
    "items.cantidad": { $gte: 2 } 
  }
)

```

### C7
| Catálogo de productos del más caro al más barato, con 6 productos por página. Muestra la página 2 de forma que la paginación sea estable cuando haya precios repetidos. |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
	El ordenamiento (Sort)
Primero por precio, del más caro al más barato: `{ precio: -1 }`
Luego por `_id` (para desempatar): `{ _id: 1 }`
    

Juntos: `.sort({ precio: -1, _id: 1 })`
3. La paginación (Skip y Limit)

- Página 1: productos del 1 al 6 → `.skip(0).limit(6)`
    
- **Página 2:** productos del 7 al 12 → `.skip(6).limit(6)`
    

La fórmula es: `skip = (número_de_página - 1) * productos_por_página`

```

db.productos.find(
  {},
  { nombre: 1, precio: 1, _id: 1 }
).sort({ precio: -1, _id: 1 }).skip(6).limit(6)

```

### C8
| Restaurantes que tienen el campo horario o el campo menu_vegano. |
| ---------------------------------------------------------------- |

En MongoDB, para saber si un campo existe (sin importar su valor), usamos el operador `$exists: true`.

- Si existe el campo `horario`: `{ horario: { $exists: true } }`
    
- Si existe el campo `menu_vegano`: `{ menu_vegano: { $exists: true } }`
    

2. El operador `$or`

Como el enunciado dice **"o"**, no necesitamos que se cumplan las dos condiciones, sino al menos una. Para eso usamos `$or`, que recibe un arreglo de condiciones:

{ 
  $or: [ 
    { horario: { $exists: true } }, 
    { menu_vegano: { $exists: true } } 
  ] 
}

```
db.restaurantes.find(
  { 
    $or: [ 
      { horario: { $exists: true } }, 
      { menu_vegano: { $exists: true } } 
    ] 
  },
  { nombre: 1, horario: 1, menu_vegano: 1, _id: 0 }
)


```


- **D5 (Eliminar campo):** Es un `updateOne` con `$unset`. Rápido.
    
    db.productos.updateOne({ _id: "P06" }, { $unset: { volumen_ml: "" } })
    
- **D6 y D7 (Borrados):** recordar **contar antes** (Regla 4). Usa `countDocuments` con el mismo filtro, luego `deleteMany`.
    
    // D6
    db.resenas.countDocuments({ calificacion: { $lt: 3 } })
    db.resenas.deleteMany({ calificacion: { $lt: 3 } })
    
- **D8 (Conteo final):** Es solo `countDocuments()` en las 5 colecciones. Toma 1 minuto y son 4 puntos.

- **D4 (Upsert):** `upsert`. Es un `updateOne` con `{ upsert: true }` buscando por email.
    
    db.clientes.updateOne(
      { email: "natalia.suarez@example.com" },
      { $setOnInsert: { _id: "C09", nombre: "Natalia Suárez", ciudad: "Medellín", puntos: 0, direcciones: [] } },
      { upsert: true }
    )