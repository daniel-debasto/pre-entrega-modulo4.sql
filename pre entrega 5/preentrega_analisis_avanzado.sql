-- ==============================================================================
-- ACTIIVIDAD PRE-ENTREGA: SCRIPT DE ANÁLISIS AVANZADO CON WINDOW FUNCTIONS
-- Archivo: preentrega_analisis_avanzado.sql
-- ==============================================================================

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

-- CTE 2: Cálculo de métricas avanzadas (Ranking y Running Total) con Window Functions
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
),

-- CTE 3: Cálculo del promedio histórico mensual de ventas por cada categoría
promedios_historicos AS (
    SELECT 
        categoria,
        AVG(venta_total) AS promedio_historico
    FROM ventas_mensuales
    GROUP BY categoria
)

-- SELECT PRINCIPAL: Consolidación del reporte final y aplicación de la lógica condicional
SELECT 
    m.mes,
    m.categoria,
    m.venta_total,
    m.ranking_mes,
    m.acumulado_historico,
    -- Mensaje condicional comparando el mes actual contra el promedio histórico de la categoría
    CASE 
        WHEN m.venta_total > p.promedio_historico THEN 'Exitoso'
        ELSE 'Bajo el promedio'
    END AS comparativa_promedio
FROM metricas_ventana m
INNER JOIN promedios_historicos p ON m.categoria = p.categoria
ORDER BY m.mes ASC, m.ranking_mes ASC;

-- =======================================================================================================
-- RESULTADO DE LA CONSULTA EJECUTADA:
-- mes                 | categoria    | venta_total | ranking_mes | acumulado_historico | comparativa_promedio
-- 2026-10-01 00:00:00 | Electrónica  | 76.400      | 1           | 76.400              | Exitoso
-- 2026-10-01 00:00:00 | Indumentaria | 3.000       | 2           | 3.000               | Exitoso
-- 2026-10-01 00:00:00 | Hogar        | 675         | 3           | 675                 | Bajo el promedio
-- 2026-11-01 00:00:00 | Electrónica  | 8.500       | 1           | 84.900              | Bajo el promedio
-- 2026-11-01 00:00:00 | Indumentaria | 1.250       | 2           | 4.250               | Bajo el promedio
-- 2026-12-01 00:00:00 | Electrónica  | 12.750      | 1           | 97.650              | Bajo el promedio
-- 2026-12-01 00:00:00 | Hogar        | 1.350       | 2           | 2.025               | Exitoso
-- =======================================================================================================

