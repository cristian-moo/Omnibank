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


lo que aprendi: Diseñé resúmenes financieros agregados por moneda empleando múltiples CTEs secuenciales (agregado_movimientos, cuentas_activas, Resumen_monedas) con promedios redondeados.


fix:

# Day 13 Answer Key — Extensión de CTE y pipeline de métricas por cuenta

## Expected Result
La semilla inicial produce una fila USD, cuatro cuentas activas, volumen bruto 800 y promedio de 200 por cuenta.

## Reference Solution
```sql
WITH movement AS (
 SELECT account_id, SUM(amount) AS gross_volume
 FROM core.transactions GROUP BY account_id
), account_metrics AS (
 SELECT a.account_id, a.currency, COALESCE(m.gross_volume,0) AS gross_volume
 FROM core.accounts a LEFT JOIN movement m USING (account_id)
 WHERE a.is_active
), by_currency AS (
 SELECT currency, COUNT(*) AS account_count, SUM(gross_volume) AS gross_volume
 FROM account_metrics GROUP BY currency
)
SELECT currency, account_count, gross_volume,
       ROUND(gross_volume / account_count,2) AS average_per_account
FROM by_currency ORDER BY currency;

SELECT (SELECT COUNT(*) FROM core.accounts WHERE is_active) AS active_accounts,
       (SELECT COALESCE(SUM(amount),0) FROM core.transactions) AS direct_gross_volume,
       (SELECT COUNT(*) FROM core.transactions t JOIN core.accounts a USING (account_id)
        WHERE a.account_number='ACCT-3002') AS empty_account_events;