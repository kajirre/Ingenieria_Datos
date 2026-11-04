
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

```

```
### B7
### B8


