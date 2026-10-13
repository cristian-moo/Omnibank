Actividad 13: CTE y pipeline de métricas por cuenta

1: WITH agregado_movimientos AS (
  SELECT
    account_id,
    Count(*) AS recuento_eventos,
    SUM(amount) AS volumen_bruto
  FROM transactions
  GROUP BY account_id
),
cuentas_activas AS (
  SELECT
    a.account_id,
    a.account_number,
    a.customer_id,
    a.currency,
    COALESCE(am.recuento_eventos, 0) AS recuento_eventos,
    COALESCE(am.volumen_bruto, 0) AS volumen_bruto
  FROM accounts a
  LEFT JOIN agregado_movimientos am
    ON a.account_id = am.account_id
  WHERE a.is_active = TRUE
),
reporte_por_cuenta AS (
  SELECT
    ca.account_id,
    ca.account_number,
    c.customer_name AS Titular,
    ca.recuento_eventos,
    ca.volumen_bruto,
    CASE
      WHEN ca.recuento_eventos = 0 THEN 'Sin actividad'
      WHEN ca.volumen_bruto < 100 THEN 'Actividad BAJA'
      WHEN ca.volumen_bruto < 500 THEN 'Actividad media'
      ELSE 'Actividad alta'
    END AS banda_actividad
  FROM cuentas_activas ca
  INNER JOIN customers c
    ON ca.customer_id = c.customer_id
)
SELECT
  account_number,
  Titular,
  moneda,
  recuento_eventos,
  volumen_bruto,
  banda_actividad
FROM reporte_por_cuenta
ORDER BY account_number;

2: SELECT count(*) AS total_cuentas_activas
FROM accounts
WHERE is_active = TRUE;

3: SELECT SUM(amount) AS volumen_bruto_total
FROM transactions;

4: SELECT
  account_id,
  Count(*) AS Recuento_Eventos,
  SUM(amount) AS volumen_bruto
FROM Transactions
GROUP BY account_id
ORDER BY account_id;