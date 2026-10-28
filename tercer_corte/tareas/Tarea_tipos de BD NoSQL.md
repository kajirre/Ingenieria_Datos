|Tipo|Modelo de datos|Tecnología más representativa|Otras tecnologías mencionadas|
|---|---|---|---|
|**Clave-valor**|Pares clave → valor (hash table)|**Redis**|Amazon DynamoDB, Memcached, Riak|
|**Documental**|Documentos JSON/BSON con esquema flexible|**MongoDB**|CouchDB, Couchbase, Amazon DocumentDB|
|**Columnas (wide-column)**|Tablas con familias de columnas, filas dispersas|**Apache Cassandra**|HBase, Google Bigtable|
|**Grafos**|Nodos y aristas con propiedades|**Neo4j**|Amazon Neptune, FlockDB|
### BD clave-valor
almacenamineto mas simple, cada item es un par: clave-valor
```
Clave          →   Valor
"usuario:1001" →   {"nombre":"Luis", "edad":30}
"sesion:abc"   →   "token_xyz_123"
"contador:visitas" → 15234
```
### BD documental 
los datos se guardan como documentos (JSON o BSON), cada documento contiene pares clase-valor es sin esquema fijo
```
Colección: "productos"
┌─────────────────────────────────────┐
│ { "_id": "p001",                    │
│   "nombre": "Laptop",               │
│   "precio": 1200,                   │
│   "especificaciones": {             │
│     "ram": "16GB",                  │
│     "almacenamiento": "512GB SSD"   │
│   },                                │
│   "etiquetas": ["tecnología", "work"]│
│ }                                   │
├─────────────────────────────────────┤
│ { "_id": "p002",                    │
│   "nombre": "Mouse",                │
│   "precio": 25,                     │
│   "color": "negro"                  │
│ }                                   │
└─────────────────────────────────────┘
```
lo mas utilizado en MongoDB el formatos es BSON que es el biniario de JSON

### BD columnas
