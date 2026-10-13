Tarea 13: Extensión de CTE y pipeline de métricas por cuenta

WITH agregado_movimientos AS (
  SELECT
    account_id,
    Count(*) AS recuento_eventos,
    SUM(amount) AS volumen_bruto
  FROM core.transaction
  GROUP BY account_id
),
cuentas_activas AS (
  SELECT
    a.account_id,
    a.account_number,
    a.currency,
    COALESCE(am.recuento_eventos, 0) AS recuento_eventos,
    COALESCE(am.volumen_bruto, 0) AS volumen_bruto
  FROM core.accounts a
  LEFT JOIN agregado_movimientos am
    ON a.account_id = am.account_id
  WHERE a.is_active = true
),
Resumen_monedas AS (
  SELECT
    currency,
    COUNT(*) AS Numero_cuentas,
    SUM(volumen_bruto) AS volumen_bruto_total,
    ROUND(AVG(volumen_bruto), 2) AS promedio_volumen_por_cuenta
  FROM cuentas_activas
  GROUP BY currency
)
SELECT * FROM Resumen_monedas;