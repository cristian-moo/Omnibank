Actividad 14: Self JOIN, matriz de productos y anti JOIN

1: SELECT
  t1.account_id,
  t1.trasaction_id AS evento_1,
  t1.amount AS importe_1,
  t1.transaction_id AS fecha_1,
  t2.transaction_id AS evento_2,
  t2.amount AS importe_2,
  t2.transaction_date AS fecha_2
FROM core.transactions t1
INNER JOIN core.transaction t2
  ON t1.account_id = t2.account_id
  AND t1.transaction_id <> t2.transaction_id
  AND t2.transaction_date >= t1.transaction_date
  AND t2.transaction_date <= t1.transaction_date + INTERVAL '48 hours'
ORDER BY t1.account_id, t1.transaction_id;

2: SELECT
  unnest(Enum_range(NULL::core.tipo_cuenta))
AS tipo_cuenta;

3: WITH tipo AS (
  SELECT
    unnest(Enum_range(NULL::core.tipo_cuenta))
  AS tipo_cuenta
),
matriz_posibilidades AS (
  SELECT
    c.customer_id,
    C.Customer_name AS titular,
    to.tipo_cuenta
  FROM core.customers C
  CROSS JOIN tipo to
)
SELECT
  m.customer_id,
  m.titular,
  m.tipo_cuenta
FROM matriz_posibilidades m
WHERE NOT EXISTS (
  SELECT 1
  FROM core.accounts a
  WHERE a.customer_id = m.customer_id
    AND a.account_type = m.tipo_cuenta
)
ORDER BY m.titular, m.tipo_cuenta;

4: SELECT
  t.transaction_id,
  a.account_number,
  t.amount,
  t.transaction_date
FROM core.transactions t
INNER JOIN core.accounts a
  ON t.account_id = a.account_id
WHERE a.account_number = 'ACCT-1001'
ORDER BY t.transaction_date;

SELECT
  C.customer_name,
  - tipo de cuenta por verificar ! AS tipo_cuenta
FROM core.customers C
WHERE C.customer_name = 'Humberto';


lo que aprendi:: Construí cruces analíticos temporales de 48 horas entre eventos de transacciones y generé matrices de posibilidades mediante la expansión de tipos unnest(enum_range).


fix:

# Day 14 Answer Key — Self JOIN, matriz de productos y anti JOIN

## Expected Result
John ofrece un par de movimientos iniciales en la misma cuenta. La matriz muestra posibilidades faltantes sin inventar sucursales ni relaciones por moneda.

## Reference Solution
```sql
SELECT t1.account_id, t1.transaction_id AS earlier_id, t2.transaction_id AS later_id
FROM core.transactions t1 JOIN core.transactions t2
 ON t1.account_id = t2.account_id
 AND (t1.tx_timestamp,t1.transaction_id) < (t2.tx_timestamp,t2.transaction_id)
 AND t2.tx_timestamp <= t1.tx_timestamp + INTERVAL '48 hours'
ORDER BY t1.account_id, t1.tx_timestamp;

WITH types AS (
 SELECT unnest(enum_range(NULL::core.tipo_cuenta)) AS account_type
)
SELECT c.customer_id, c.email, ty.account_type
FROM core.customers c CROSS JOIN types ty
LEFT JOIN core.accounts a ON a.customer_id = c.customer_id AND a.account_type = ty.account_type
WHERE a.account_id IS NULL 
ORDER BY c.email, ty.account_type;