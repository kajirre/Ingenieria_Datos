## Metadatos de las Operaciones (¿Qué significan esos campos?)

### 1. `acknowledged`

- **¿Qué es?** Un valor booleano (`true` o `false`) que indica si la operación de escritura fue **reconocida** (confirmada) por el servidor de MongoDB .[](https://mongodb.ac.cn/docs/php-library/current/reference/method/MongoDBDeleteResult-isAcknowledged/#return-values)[](https://www.mongodb.com/pt-br/docs/php-library/current/reference/method/mongodbupdateresult-isacknowledged/)
    
- **¿En qué se usa?** Aparece en **todas** las operaciones (insert, update, delete).
    
- **Ejemplo práctico:** Si tu conexión a internet falla justo cuando envías un `insertOne`, el servidor no recibe nada y el resultado podría ser `acknowledged: false`. Si todo va bien, verás `acknowledged: true`.
    
- **Código:**
```
	//Al insertar, si sale acknowledged: true, el dato está a salvo.
  
    db.restaurantes.insertOne({ nombre: "Nuevo Restaurante", ciudad: "Cali" })
    
    // Resultado típico: { acknowledged: true, insertedId: ObjectId("...") }
    
```

### 2. `insertedId` (o `insertedIds`)

- **¿Qué es?** El identificador único (`_id`) que MongoDB le asignó al documento que acabas de insertar .[](https://www.mongodb.com/community/forums/t/linking-objects-v-s-embedded-objects/154962/5)[](https://mongodb.ac.cn/docs/drivers/go/current/fundamentals/crud/write-operations/insert/)
    
- **¿En qué se usa?** Solo en operaciones de **inserción** (`insertOne` e `insertMany`).
    
- **Ejemplo práctico:** Si insertas un producto sin darle un `_id` manualmente, MongoDB inventa uno (usualmente un `ObjectId`) y te lo devuelve en este campo. Así sabes cuál es la "cédula" de tu nuevo dato.
    
- **Código:**
```
    // insertedId te dice qué ID se generó
    db.productos.insertOne({ nombre: "Nuevo Producto", precio: 5000 })
    // Resultado: { acknowledged: true, insertedId: ObjectId("65f...") }
```

### 3. `matchedCount` (o `n`)

- **¿Qué es?** El número de documentos que **coincidieron** con el filtro de búsqueda que usaste en una actualización .[](https://pkg.go.dev/go.mongodb.org/mongo-driver/mongo#UpdateResult)[](https://pub.dev/documentation/mongo_go/4.6.1/mongo_go/UpdateResult-class.html)
    
- **¿En qué se usa?** Solo en operaciones de **actualización** (`updateOne`, `updateMany`).
    
- **Ejemplo práctico:** Si intentas actualizar el precio de un producto, `matchedCount` te dice cuántos productos encontró con ese filtro. Si es `0`, significa que no encontró nada y no actualizó nada.
    
- **Código:**
```
    // Si matchedCount es 1, encontró el producto. Si es 0, no existe.
    db.productos.updateOne({ _id: "P26" }, { $set: { precio: 9500 } })
    // Resultado: { acknowledged: true, matchedCount: 1, modifiedCount: 1, ... }
```

### 4. `modifiedCount`

- **¿Qué es?** El número de documentos que **realmente cambiaron** de valor .[](https://pkg.go.dev/go.mongodb.org/mongo-driver/mongo#UpdateResult)[](https://pub.dev/documentation/mongo_go/4.6.1/mongo_go/UpdateResult-class.html)
    
- **¿En qué se usa?** Solo en operaciones de **actualización** (`updateOne`, `updateMany`).
    
- **Ejemplo práctico:** Es posible que `matchedCount` sea `1` (encontró el documento) pero `modifiedCount` sea `0`. Esto pasa si intentas actualizar un campo con el mismo valor que ya tenía. MongoDB es inteligente y no reescribe el dato si no hay cambios reales.
    
- **Código:**
```
// Si el producto P26 ya costaba 9500, modifiedCount será 0 (no hubo cambio real)
db.productos.updateOne({ _id: "P26" }, { $set: { precio: 9500 } })
// Resultado: { matchedCount: 1, modifiedCount: 0, ... }
```

### 5. `upsertedCount` (y `upsertedId`)

- **¿Qué es?** El número de documentos que se **insertaron** como consecuencia de una operación de actualización con la opción `upsert: true` .[](https://pkg.go.dev/go.mongodb.org/mongo-driver/mongo#UpdateResult)[](https://pub.dev/documentation/mongo_go/4.6.1/mongo_go/UpdateResult-class.html)
    
- **¿En qué se usa?** Solo en operaciones de **actualización** cuando usas `{ upsert: true }`.
    
- **Ejemplo práctico:** El "upsert" es un híbrido entre "update" e "insert". Le dices a MongoDB: _"Si encuentras el documento, actualízalo; si NO lo encuentras, créalo"_. Si lo creó, `upsertedCount` será 1 y te dará su nuevo `_id` en `upsertedId`.
    
- **Código:**
```
// Busca un restaurante R99. Como no existe, lo crea.
    db.restaurantes.updateOne(
      { _id: "R99" },
      { $set: { nombre: "Restaurante Upsert" } },
      { upsert: true }
    )
// Resultado: { acknowledged: true, matchedCount: 0, modifiedCount: 0, upsertedCount: 1, upsertedId: "R99" }
```
    

### 6. `deletedCount`

- **¿Qué es?** El número de documentos que fueron **eliminados** por la operación .[](https://www.mongodb.com/ja-jp/docs/drivers/node/v6.x/crud/delete/)[](https://www.mongodb.com/es/docs/drivers/node/current/crud/delete/)
    
- **¿En qué se usa?** Solo en operaciones de **eliminación** (`deleteOne`, `deleteMany`).
    
- **Ejemplo práctico:** Si ejecutas `deleteMany` con un filtro y te devuelve `deletedCount: 5`, significa que borró 5 documentos. Si te devuelve `0`, no encontró nada que borrar (quizás ya los habías eliminado antes).
    
- **Código:**
```
    // Borra los productos con stock 0
    db.productos.deleteMany({ stock: 0 })
    // Resultado: { acknowledged: true, deletedCount: 3 }
```


siempre hacer un borrador logico son $set


db.clientes.updateOne({})
busca el documento y si no exite lo inserta

indice unico. agregacion por medio de parlayns de agregacion


mirar los peidos que estan en estado entregdo 

```
db.pedidos.find({ estado : "entregado"}, { restaurante : { nombre : 1},  total : 1, _id : 0 }).sort({total : -1})
```

