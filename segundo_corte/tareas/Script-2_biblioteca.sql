CREATE DATABASE tienda_tecno
WITH ENCODING = 'UTF8'
TEMPLATE = template0;

/* Crear tabla clientes */
CREATE TABLE clientes (
    idcliente SERIAL PRIMARY KEY,
    nombrecliente VARCHAR(50) NOT NULL,
    correoCliente VARCHAR(150) NOT NULL UNIQUE, 
    fechaRegistro DATE NOT NULL DEFAULT CURRENT_DATE
);

/* Crear tabla productos */
CREATE TABLE productos (
    idproducto SERIAL PRIMARY KEY,
    nombreProducto VARCHAR(100) NOT NULL,
    precioProducto NUMERIC(10,2) NOT NULL CHECK (precioProducto > 0),
    stock INTEGER NOT NULL DEFAULT 0
);

/* Crear tabla pedido */
CREATE TABLE pedido (
    idpedido SERIAL PRIMARY KEY,
    idClienteFK INTEGER NOT NULL REFERENCES clientes(idcliente) ON DELETE CASCADE, /* Corregido: idcliente */
    fechaPedido TIMESTAMP NOT NULL DEFAULT NOW(),
    estadoPedido VARCHAR(20) NOT NULL DEFAULT 'Pendiente'
);

/* Crear tabla detallePedido */
CREATE TABLE detallePedido (
    idpedidoFK INTEGER NOT NULL REFERENCES pedido(idpedido) ON DELETE CASCADE,
    idproductoFK INTEGER NOT NULL REFERENCES productos(idproducto) ON DELETE CASCADE,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (idpedidoFK, idproductoFK)
);


/* --- MODIFICACIONES ALTER TABLE --- */

/* 1. Tabla cliente -> agregar columna telefono */
ALTER TABLE clientes 
ADD COLUMN telefono NUMERIC(10);

/* 2. Tabla productos -> cambiar tipo de columna nombreProducto a varchar(150) */
ALTER TABLE productos 
ALTER COLUMN nombreProducto TYPE VARCHAR(150);

/* 3. Renombrar la columna estadoPedido a estado */
ALTER TABLE pedido 
RENAME COLUMN estadoPedido TO estado;

/* 4. Agregar restriccion a stock para que no sea negativo (>= 0) */
ALTER TABLE productos 
ADD CONSTRAINT check_stock_no_negativo CHECK (stock >= 0);




