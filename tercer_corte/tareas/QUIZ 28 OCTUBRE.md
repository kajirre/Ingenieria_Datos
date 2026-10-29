
#### inserccion de un solo dato

```
 db.restaurantes.insert({
  _id: "R01", 
  nombre: "Arepas", 
  ciudad: "Bogota", 
  barrio: "chapinero", 
  calificacion: 4.6, 
  domicilio: true, 
  ubicacion: {type: "Point", coordinates : [-74.0636, 4.6486]},
  etiquetas: ["arepas", "desayunos", "economico"]
})
```

#### inserccion de  10 datos
```
db.restaurantes.insertMany([
  { _id: "R00", nombre: "Arepas La 19", categoria: "Comida colombiana", ciudad: "Bogotá", barrio: "Chapinero", calificacion: 4.6, domicilio: true, ubicacion: { type: "Point", coordinates: [-74.0636, 4.6486] }, etiquetas: ["arepas", "desayunos", "económico"] },
  { _id: "R02", nombre: "Sushi Nikko", categoria: "Japonesa", ciudad: "Bogotá", barrio: "Usaquén", calificacion: 4.8, domicilio: true, ubicacion: { type: "Point", coordinates: [-74.0305, 4.695] }, etiquetas: ["sushi", "ramen"], horario: { apertura: "12:00", cierre: "22:00" } },
  { _id: "R03", nombre: "Pizzería Napoli", categoria: "Italiana", ciudad: "Bogotá", barrio: "Chicó", calificacion: 4.3, domicilio: true, ubicacion: { type: "Point", coordinates: [-74.048, 4.676] }, etiquetas: ["pizza", "pasta"] },
  { _id: "R04", nombre: "Burger Norte", categoria: "Hamburguesas", ciudad: "Bogotá", barrio: "Cedritos", calificacion: 3.9, domicilio: true, ubicacion: { type: "Point", coordinates: [-74.04, 4.724] }, etiquetas: ["hamburguesas", "económico"] },
  { _id: "R05", nombre: "Ajiaco & Co", categoria: "Comida colombiana", ciudad: "Bogotá", barrio: "La Candelaria", calificacion: 4.5, domicilio: false, ubicacion: { type: "Point", coordinates: [-74.0726, 4.5964] }, etiquetas: ["ajiaco", "almuerzos"] },
  { _id: "R06", nombre: "Verde Vivo", categoria: "Vegetariana", ciudad: "Medellín", barrio: "El Poblado", calificacion: 4.4, domicilio: false, ubicacion: { type: "Point", coordinates: [-75.5664, 6.2088] }, etiquetas: ["vegano", "saludable"], menu_vegano: true },
  { _id: "R07", nombre: "Bandeja Paisa Doña Rosa", categoria: "Comida colombiana", ciudad: "Medellín", barrio: "Laureles", calificacion: 4.7, domicilio: true, ubicacion: { type: "Point", coordinates: [-75.59, 6.245] }, etiquetas: ["bandeja paisa", "almuerzos"] },
  { _id: "R08", nombre: "Taco Loco", categoria: "Mexicana", ciudad: "Medellín", barrio: "Envigado", calificacion: 4.1, domicilio: true, ubicacion: { type: "Point", coordinates: [-75.588, 6.171] }, etiquetas: ["tacos", "picante"] },
  { _id: "R09", nombre: "Brasa Caribe", categoria: "Asados", ciudad: "Barranquilla", barrio: "El Prado", calificacion: 4.2, domicilio: true, ubicacion: { type: "Point", coordinates: [-74.7964, 10.9878] }, etiquetas: ["asados", "parrilla"] },
  { _id: "R10", nombre: "Mar y Coco", categoria: "Mariscos", ciudad: "Barranquilla", barrio: "Riomar", calificacion: 4.6, domicilio: true, ubicacion: { type: "Point", coordinates: [-74.812, 11.015] }, etiquetas: ["mariscos", "pescado"] }
])
```

### QUIZ
#### 12 restaurante
[[Pasted image 20261028223828.png]]
![[Pasted image 20261028223856.png]]

#### 9 clientes
[[Pasted image 20261028223856.png]]
![[Pasted image 20261028223828.png]]



como consultar, modificacion y eliminacion 
