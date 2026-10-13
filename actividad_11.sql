Actividad 11: Transformaciones escalares y fechas de OmniBank

1. Reporte de cuentas con etiquetas:
SELECT
  a.account_id,
  a.account_number,
  upper(concat_ws(' ', c.first_name, c.last_name)),
  RIGHT(a.account_number, 4) AS etiqueta,
  c.email,
  a.is_active,
  CASE
    WHEN a.is_active = false THEN 'Desactivada'
    ELSE 'Activa'
  END AS estado
FROM core.account AS a
INNER JOIN core.customers AS c
  ON c.customers_id = c.customer_id
ORDER BY a.account_id ASC;

2. Reporte de los 4:
SELECT
  t.transaction_id,
  t.account_id,
  EXTRACT(year FROM t.tx_timestamp)::integer AS tx_year,
  EXTRACT(month FROM t.tx_timestamp)::integer AS tx_month,
  TO_CHAR(t.amount, 'FM999,999,999,990.00') AS amount_display,
  t.tx_timestamp AS original_timestamp,
  t.tx_timestamp + INTERVAL '15 days' AS review_timestamp,
  TIMESTAMP WITH TIME ZONE '2026-10-12 00:00+00' - t.tx_timestamp AS age_at_cutoff
FROM core.transaction AS t
WHERE t.tx_timestamp < TIMESTAMP '2026-09-10 00:00+00'
ORDER BY t.transaction_id;

3. Orden y comparacion:
SELECT count(*) AS source_account_count
FROM core_accounts;

SELECT count(*) AS source_event_count
FROM core.transactions
WHERE tx_timestamp < Timestamp '2026-09-10 00:00+00';