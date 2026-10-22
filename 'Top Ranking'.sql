-- ----------------------------------------------------------------------------
-- CONSULTA 3: Top de compras por cliente (Top 3 del Ranking)
-- Problema de negocio: Identifica a los 3 clientes líderes junto con el producto 
-- que compraron con mayor frecuencia y la fecha de su última transacción. 
-- Esto permite reconocer y premiar a los consumidores más valiosos del negocio.
-- ----------------------------------------------------------------------------

SELECT 
    c.nombre AS cliente_nombre,
    p.nombre AS producto_preferido,
    SUM(v.cantidad) AS cantidad_compras, 
    MAX(v.fecha) AS fecha_ultima_transaccion
FROM ventas v
INNER JOIN clientes c ON v.cliente_id = c.id
INNER JOIN productos p ON v.producto_id = p.id
GROUP BY c.nombre, p.nombre
ORDER BY cantidad_compras DESC, fecha_ultima_transaccion DESC
LIMIT 3;


