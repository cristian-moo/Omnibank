Actividad 12: Subconsultas correlacionadas y cuentas sin movimientos

1. SELECT
  t.transaction_id,
  t.account_id,
  t.amount,
  (
    SELECT AVG(t2.amount)
    FROM transaction t2
    WHERE t2.account_id = t.account_id
  ) AS promedio_cuenta
FROM transactions t
WHERE t.amount > (
  SELECT AVG(t2.amount)
  FROM transactions t2
  WHERE t2.account_id = t.account_id
)
ORDER BY t.account_id, t.amount DESC;

2. SELECT
  account_id,
  AVG(amount) AS promedio_cuenta
FROM transactions
GROUP BY account_id
ORDER BY account_id;

3. SELECT
  a.account_number,
  a.is_active
FROM accounts a
WHERE NOT EXISTS (
  SELECT 1
  FROM transactions t
  WHERE t.account_id = a.account_id
)
ORDER BY a.account_number;