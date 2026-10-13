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

lo que aprendi:Desarrollé consultas con subconsultas correlacionadas y NOT EXISTS para identificar cuentas activas que nunca han registrado transacciones o depósitos.


fix:

# Day 12 Answer Key — Subconsultas correlacionadas

## Expected Result

Un movimiento supera el promedio de su cuenta. ACCT-1002 y ACCT-3002 carecen de movimientos, aunque solo una está activa.

## Reference Solution

```
SELECT t_ext.transaction_id,
       t_ext.account_id,
       t_ext.amount,
       (SELECT ROUND(AVG(t_int.amount), 2)
        FROM core.transactions t_int
        WHERE t_int.account_id = t_ext.account_id) AS account_average
FROM core.transactions t_ext
WHERE t_ext.amount > (
  SELECT AVG(t_int.amount)
  FROM core.transactions t_int
  WHERE t_int.account_id = t_ext.account_id
)
ORDER BY t_ext.amount DESC;

SELECT account_id, ROUND(AVG(amount), 2) AS account_average
FROM core.transactions 
GROUP BY account_id 
ORDER BY account_id;

SELECT a.account_number, a.is_active, a.balance
FROM core.accounts a
WHERE NOT EXISTS (
  SELECT 1 FROM core.transactions t WHERE t.account_id = a.account_id
)
ORDER BY a.account_number;

```

**Lectura de la solución:** El equipo de revisión busca movimientos superiores al comportamiento habitual de su propia cuenta y cuentas que nunca han registrado eventos. Comparar un movimiento de John con el promedio global de todas las cuentas respondería otra pregunta. La ausencia de eventos también debe distinguirse del estado `is_active` para no emitir una alerta administrativa falsa.

## Common Valid Variations

Una CTE con promedio por `account_id` puede sustituir la subconsulta correlacionada si conserva la misma comparación y el tratamiento de cuentas sin eventos.

## Common Mistakes

Olvidar la correlación por `account_id` convierte una excepción local en una comparación global; `NOT IN` con `NULL` puede eliminar resultados esperados.

## Grading Rubric

* **35%:** Calcula para cada movimiento el promedio de `amount` de los eventos que comparten su `account_id`. Usa una subconsulta correlacionada o una estrategia equivalente y conserva el identificador de la fila externa.

* **30%:** Filtra únicamente movimientos cuyo importe supera ese promedio. Comprueba el resultado contra un promedio agrupado independiente antes de interpretar el evento.

* **20%:** Comprueba el resultado con datos reproducibles: Un movimiento supera el promedio de su cuenta. ACCT-1002 y ACCT-3002 carecen de movimientos, aunque solo una está activa.

* **15%:** Reconoce y evita este error: Olvidar la correlación por `account_id` convierte una excepción local en una comparación global; `NOT IN` con `NULL` puede eliminar resultados esperados.