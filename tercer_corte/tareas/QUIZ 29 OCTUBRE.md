
#### 1. consultar restaurantes con calificacion mayor a 4.5 en la ciudad de Bogota
```
// consultar restaurantes con calificacion mayor a 4.5 en la ciudad de Bogota

db.restaurante.find({ calificacion : {$gt : 4.5}}, {nombre: 1, categoria:1, ciudad : "Bogota" , calificacion:1}  )

{

_id: 'R01',

nombre: 'Arepas',

calificacion: 4.6,

ciudad: 'Bogota'

}

```

#### 2 consultar las preferencias de clientes en la medellin


```
// consultar las preferencias de clientes en la medellin

db.clientes.find({ ciudad : "Medellín"}, { _id : 1 ,nombre : 1, ciudad : 1 , preferencias:1}  )

{

_id: 'C04',

nombre: 'Camilo Torres',

ciudad: 'Medellín',

preferencias: [

'colombiana',

'mexicana'

]

}

```