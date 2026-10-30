-- CTE 1: Agrupación de ventas a nivel mes/categoría
WITH ventas_mensuales AS (
    SELECT 
        DATE_TRUNC('month', v.fecha) AS mes,
        cat.nombre AS categoria,
        SUM(v.cantidad * p.precio) AS venta_total
    FROM ventas v
    INNER JOIN productos p ON v.producto_id = p.id
    INNER JOIN categorias cat ON p.categoria_id = cat.id
    GROUP BY DATE_TRUNC('month', v.fecha), cat.nombre
),

-- CTE 2: Cálculo de Ranking y Running Total (Acumulado)
metricas_ventana AS (
    SELECT 
        mes,
        categoria,
        venta_total,
        -- El ranking de las categorías más vendidas por cada mes
        RANK() OVER(PARTITION BY mes ORDER BY venta_total DESC) AS ranking_mes,
        -- El total acumulado de ventas por categoría a través del tiempo
        SUM(venta_total) OVER(PARTITION BY categoria ORDER BY mes) AS acumulado_historico
    FROM ventas_mensuales
)

-- SELECT DE PRUEBA: Mostramos el resultado de la ventana
SELECT * 
FROM metricas_ventana
ORDER BY mes ASC, ranking_mes ASC;

-- ==============================================================================
-- RESULTADO DE LA CONSULTA EJECUTADA:
-- mes                 | categoria    | venta_total | ranking_mes | acumulado_historico
-- 2026-10-01 00:00:00 | Electrónica  | 76.400      | 1           | 76.400
-- 2026-10-01 00:00:00 | Indumentaria | 3.000       | 2           | 3.000
-- 2026-10-01 00:00:00 | Hogar        | 675         | 3           | 675
-- 2026-11-01 00:00:00 | Electrónica  | 8.500       | 1           | 84.900
-- 2026-11-01 00:00:00 | Indumentaria | 1.250       | 2           | 4.250
-- 2026-12-01 00:00:00 | Electrónica  | 12.750      | 1           | 97.650
-- 2026-12-01 00:00:00 | Hogar        | 1.350       | 2           | 2.025
-- ==============================================================================

