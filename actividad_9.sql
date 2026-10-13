Actividad 9: reportes relacionales para operaciones de OmniBank

Punto de control de la semilla:
Clientes: 4, Cuentas: 5, Transacciones: 4

Recorrido de cada movimiento:
Se parte de core.Transaction y se relaciona con core.accounts mediante account_id. Despues, las cuentas se relacionan con core.customers mediante customer_id.
Se obtiene el ID del movimiento, nombre, apellido, numero de cuenta, tipo de transaccion e importe.
Hay una fila por movimiento porque la tabla principal es core.transactions, donde cada registro representa una transaccion, un cliente puede aparecer varias veces si tiene varios movimientos.

Cuentas sin movimientos:
Se parte de core.accounts y se utiliza un Left join con core.transactions. Las cuentas sin movimientos se identifican cuando transaction_id es NULL.
Las cuentas encontradas son:
* ACCT-1002: desactivada y sin movimiento
* ACCT-3002: Activa y sin movimiento

INSERT INTO core.Transaction
(id, from_account_id, to_account_id, amount, transaction_type, status)
Values
(gen_random_uuid(), 'aaaaaa-9999-9999-9999-999999999999', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 150, 'transfer', 'COMPLETED'),
(gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccc-cccc-cccc-cccc-cccccccccccc', 300, 'TRANSFER', 'COMPLETEDED'),
(gen_random_uuid(), 'aaaaaa-9999-9999-9999-999999999999', NULL, 50, 'FEE', 'COMPLETED');

UPDATE core.accounts
SET balance = balance - 50
WHERE account_number = 'Acct-1601'
Returning account_number, balance;
Commit;


lo que aprendi:Establecí puntos de control de semillas, identifiqué cuentas sin movimientos mediante LEFT JOIN y realicé operaciones de actualización atómica (UPDATE ... RETURNING).


fix:

# Day 09 Answer Key — Relaciones Reales y Ausencia de Movimientos

## Expected Result

El checkpoint aporta cuatro clientes, cinco cuentas y cuatro movimientos. El recorrido de eventos devuelve cuatro filas; la consulta de ausencia devuelve ACCT-1002 desactivada y ACCT-3002 activa. El reporte de titulares con balance > 0 conserva a los cuatro clientes, con columnas de cuenta nulas para Alice y Humberto. La variante con el filtro en `WHERE` pierde esas dos personas.

## Reference Solution

```sql
SELECT (SELECT COUNT(*) FROM core.customers) AS customers,
       (SELECT COUNT(*) FROM core.accounts) AS accounts,
       (SELECT COUNT(*) FROM core.transactions) AS movements;

SELECT t.transaction_id, c.first_name, c.last_name, a.account_number, t.tx_type, t.amount
FROM core.transactions t
JOIN core.accounts a ON a.account_id = t.account_id
JOIN core.customers c ON c.customer_id = a.customer_id
ORDER BY t.tx_timestamp, t.transaction_id;

SELECT a.account_number, a.is_active,
       CASE WHEN a.is_active THEN 'ACTIVA SIN MOVIMIENTOS'
            ELSE 'DESACTIVADA SIN MOVIMIENTOS' END AS estado
FROM core.accounts a
LEFT JOIN core.transactions t ON t.account_id = a.account_id
WHERE t.transaction_id IS NULL
ORDER BY a.account_number;

SELECT c.email, a.account_number, a.balance
FROM core.customers c
LEFT JOIN core.accounts a
  ON a.customer_id = c.customer_id AND a.balance > 0
ORDER BY c.email, a.account_number;

-- Comparación diagnóstica: WHERE elimina las filas externas sin pareja elegible.
SELECT c.email, a.account_number, a.balance
FROM core.customers c
LEFT JOIN core.accounts a ON a.customer_id = c.customer_id
WHERE a.balance > 0
ORDER BY c.email, a.account_number;
```

La última consulta devuelve solo John y Jane; si se requiere preservar a los titulares, el predicado de cuenta elegible pertenece a `ON`. `is_active` y ausencia de movimiento son atributos diferentes y no deben codificarse en el enum `tx_type`.

## Common Valid Variations

* Se aceptan alias distintos, una etiqueta textual equivalente y un `RIGHT JOIN` reorientado que preserve las mismas cuentas. 
* Una solución con `NOT EXISTS` para la ausencia también es válida si está claramente explicada, aunque no se exige antes del día 12.

## Common Mistakes

* **Unir movimiento con cliente por un campo descriptivo**: Hacerlo en vez de recorrer las claves foráneas crea asociaciones falsas.
* **Filtrar `transactions` en `WHERE` después de un `LEFT JOIN`**: Puede ocultar cuentas sin eventos inadvertidamente.
* **Usar un `INNER JOIN` entre clientes y cuentas**: Elimina a Humberto del reporte.
* **Filtrar `balance` en `WHERE`**: Elimina también a Alice del reporte.

## Grading Rubric

* **25%**: Recuentos de control y uso de claves reales (`account_id` y `customer_id`).
* **25%**: Recorrido de cuatro movimientos, una fila por evento y orden estable.
* **25%**: Ausencia de dos cuentas con `is_active` separado de la existencia de eventos.
* **25%**: Cuatro titulares preservados, comparación entre predicados en `ON` vs `WHERE` y explicación del grano.