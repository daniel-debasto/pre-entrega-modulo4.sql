-- ----------------------------------------------------------------------------
-- CONSULTA 1: Rentabilidad por categoría
-- Problema de negocio: El equipo financiero y comercial necesita evaluar la 
-- demanda de las categorías líderes. Esta consulta realiza un JOIN de 3 tablas 
-- (ventas, productos, categorias) para consolidar unidades vendidas e ingresos. 
-- Filtra mediante HAVING aquellas categorías con más de 100 unidades comercializadas.
-- ----------------------------------------------------------------------------

SELECT 
    cat.nombre AS categoria_nombre,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * p.precio) AS ingreso_total
FROM ventas v
INNER JOIN productos p ON v.producto_id = p.id
INNER JOIN categorias cat ON p.categoria_id = cat.id
GROUP BY cat.nombre
HAVING SUM(v.cantidad) > 100
ORDER BY ingreso_total DESC;

-- ==========================================
-- RESULTADO DE LA CONSULTA EXECUTADA:
-- categoria_nombre | unidades_vendidas | ingreso_total
-- Electrónica      | 150               | 76.400
-- Indumentaria     | 120               | 3.000
-- ==========================================


