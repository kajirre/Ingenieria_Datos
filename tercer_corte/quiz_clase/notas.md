


db.productos.find({ "precio" : {$lt: 10000}},{ "nombre":1, "precio" : 1, "_id":0 })


db.restaurante.find({  "calificacion" : {$gte : 4.5} }).sort({ calificaciones : -1 })


db.pedidos.countDocuments({ estado : "cancelado" })


db.clientes.find({ ciudad :{$in : ["Bogotá" , "Medellín"] } })


para los updates 
que operadores ecxisten (son 5) haga un efecto y un ejemplo


db.productos.updateOne({ _id : "P01" }, {$inc : {precio : 500 }} )

eliminar el campo horarios dentro de un documento


db.restaurante.updateOne({ _id : "R02"}, { $unset : { horario : ""} } )