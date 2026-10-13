Actividad 10: tablero de saldos y actividad registrada de OmniBank

1. Tablero de productos: una fila por tipo de cuenta activo
Grano: una fila por tipo de cuenta activo

SELECT
  account_type,
  count(*) AS cantidad_cuentas,
  SUM(balance) AS saldo_total,
  MIN(balance) AS saldo_minimo,
  MAX(balance) AS saldo_maximo,
  AVG(balance) AS saldo_promedio
FROM core.accounts
WHERE is_active = True
GROUP BY account_type
ORDER BY saldo_total DESC, account_type;

2. Segmentacion de titulares:
SELECT c.customer_id,
  c.name,
  c.email,
  count(t.transaction_id) AS cantidad_movimientos,
  COALESCE(SUM(t.amount), 0) AS volumen_bruto
FROM core.customer c
LEFT JOIN core.accounts a ON c.customer_id = a.customer_id
LEFT JOIN core.transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name, c.email
HAVING count(t.transaction_id) >= 2
   AND COALESCE(SUM(t.amount), 0) > 100
ORDER BY volumen_bruto DESC, c.email;

3. Control independiente:
SELECT account_id,
  count(transaction_id) AS movimientos,
  Sum(amount) AS volumen_bruto
FROM core.transactions
GROUP BY account_id;

SELECT count(transaction_id) AS total_movimientos,
  Sum(amount) AS volumen_total
FROM core.transactions;