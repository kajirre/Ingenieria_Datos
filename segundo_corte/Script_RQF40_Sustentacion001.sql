

use liwi_flor_eterna;
-- el "Concepto de compra" esta como "ConceptoGasto"
SELECT  * FROM ConceptoGasto cg ;

SELECT * FROM Producto p ;

SELECT c.nombreConcepto, p.nombreProducto 
FROM ConceptoGasto c 
JOIN Producto p 
USING (idProducto) ORDER BY 1;


