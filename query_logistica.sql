-- =====================================================================
-- PROYECTO: Análisis de Logística y Rendimiento de Envíos (E-commerce)
-- MOTOR: Google BigQuery
-- =====================================================================

-- 1. Resumen mensual de volumen, facturación y cumplimiento OTD
SELECT 
    FORMAT_DATE('%Y-%m', Fecha) AS Anio_Mes,
    COUNT(ID_Transaccion) AS Total_Envios,
    SUM(Monto_Total_ARS) AS Facturacion_Total_ARS,
    AVG(Monto_Total_ARS) AS Ticket_Promedio_ARS,
    -- Porcentaje aproximado de entregas a tiempo (On-Time Delivery)
    SAFE_DIVIDE(
        COUNT(CASE WHEN Estado_Envio = 'Entregado a tiempo' THEN 1 END),
        COUNT(ID_Transaccion)
    ) * 100 AS Porcentaje_OTD
FROM 
    `tu_proyecto.mercadolibre_analytics.fact_ventas_logistica`
GROUP BY 
    Anio_Mes
ORDER BY 
    Anio_Mes DESC;

-- 2. Análisis de desvíos en tiempos de entrega por provincia de destino
SELECT 
    Provincia_Destino,
    COUNT(ID_Transaccion) AS Total_Envios,
    ROUND(AVG(Dias_Entrega_Real), 2) AS Promedio_Dias_Real,
    ROUND(AVG(Dias_Entrega_Prometido), 2) AS Promedio_Dias_Prometido,
    ROUND(AVG(Dias_Entrega_Real) - AVG(Dias_Entrega_Prometido), 2) AS Desvio_Promedio_Dias
FROM 
    `tu_proyecto.mercadolibre_analytics.fact_ventas_logistica`
GROUP BY 
    Provincia_Destino
ORDER BY 
    Desvio_Promedio_Dias DESC;
    