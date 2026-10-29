
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
db.restaurantes.insertOne({ _id: "R11", nombre: "Nombre del Restaurante 11", ciudad: "Bogota", calificacion: 4.5 })

{
  acknowledged: true,
  insertedId: 'R11'
}

```

### A4
yo c
```
db.restaurantes.insertOne({_id: "R12", nombre: "Café Arriero",categoria: "Cafetería",ciudad: "Medellín",barrio: "Laureles",calificacion: 4.5,domicilio: true,ubicacion: {type: "Point",coordinates: [-75.5925, 6.2442]},etiquetas: ["café", "postres"]})
```