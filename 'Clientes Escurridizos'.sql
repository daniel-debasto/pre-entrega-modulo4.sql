-- ----------------------------------------------------------------------------
-- CONSULTA 2: Clientes sin compras (Clientes Escurridizos)
-- Problema de negocio: El área de marketing busca detectar usuarios que se 
-- registraron pero no completaron el embudo de conversión (compras). Se aplica 
-- un LEFT JOIN desde clientes hacia ventas, aislando con HAVING a aquellos cuyo 
-- conteo es 0. Se usa COALESCE para formatear estéticamente los nulos como 0.
-- ----------------------------------------------------------------------------

SELECT 
    c.id AS cliente_id,
    c.nombre AS cliente_nombre,
    COALESCE(COUNT(v.id), 0) AS total_compras
FROM clientes c
LEFT JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.id, c.nombre
HAVING COUNT(v.id) = 0
ORDER BY c.nombre ASC;

-- ==========================================
-- RESULTADO DE LA CONSULTA EJECUTADA:
-- cliente_id | cliente_nombre | total_compras
-- 4          | Ana Martínez   | 0
-- ==========================================
