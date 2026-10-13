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


lo que aprendi:Modularicé la lógica de negocio y clasificación de actividad (baja, media, alta) utilizando Expresiones de Tabla Comunes (CTEs con WITH).


fix:

# Day 13 Answer Key — CTE y pipeline de métricas por cuenta

## Expected Result

La salida incluye cuatro cuentas activas; ACCT-3002 aparece con cero eventos. El volumen total de la semilla es 800, distribuido sin multiplicar movimientos.

## Reference Solution

```
WITH movement AS (
  SELECT account_id,
         COUNT(*) AS tx_count,
         SUM(amount) AS gross_volume
  FROM core.transactions
  GROUP BY account_id
),
account_metrics AS (
  SELECT a.account_id,
         a.account_number,
         a.currency,
         a.customer_id,
         COALESCE(m.tx_count, 0) AS tx_count,
         COALESCE(m.gross_volume, 0) AS gross_volume
  FROM core.accounts a
  LEFT JOIN movement m USING (account_id)
  WHERE a.is_active
)
SELECT c.first_name,
       c.last_name,
       am.account_number,
       am.currency,
       am.tx_count,
       am.gross_volume,
       CASE 
         WHEN am.tx_count = 0 THEN 'SIN MOVIMIENTOS'
         ELSE 'CON MOVIMIENTOS'
       END AS activity_band
FROM account_metrics am
JOIN core.customers c USING (customer_id)
ORDER BY am.account_number;

SELECT (SELECT COUNT(*) FROM core.accounts WHERE is_active) AS active_accounts,
       (SELECT COALESCE(SUM(amount), 0) FROM core.transactions) AS direct_gross_volume;

```

**Lectura de la solución:** El tablero de productos necesita una medida de actividad por cuenta que otras consultas puedan reutilizar. El equipo no quiere repetir una agregación cada vez que agrega datos del titular o de la moneda. Un pipeline de CTE permite nombrar las etapas y declarar si cada una tiene una fila por movimiento, por cuenta o por moneda.

## Common Valid Variations

Se puede usar una subconsulta derivada por etapa si el grano y las filas conservadas son equivalentes; los nombres de las CTE no son parte del resultado.

## Common Mistakes

Agregar después de una unión que multiplica eventos o usar `INNER JOIN` antes de conservar cuentas vacías altera tanto el total como el denominador del promedio.

## Grading Rubric

* **35%:** Parte de `transactions` y construye una CTE con una fila por `account_id`: cuenta eventos y suma sus importes positivos como volumen bruto. No nombres saldo a esa suma.

* **30%:** En una segunda CTE conserva todas las cuentas activas con `LEFT JOIN` hacia la primera. Sustituye solo los agregados ausentes por cero y conserva `account_id` para controlar el grano.

* **20%:** Comprueba el resultado con datos reproducibles: La salida incluye cuatro cuentas activas; ACCT-3002 aparece con cero eventos. El volumen total de la semilla es 800, distribuido sin multiplicar movimientos.

* **15%:** Reconoce y evita este error: Agregar después de una unión que multiplica eventos o usar `INNER JOIN` antes de conservar cuentas vacías altera tanto el total como el denominador del promedio.