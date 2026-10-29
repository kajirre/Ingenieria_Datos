
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

