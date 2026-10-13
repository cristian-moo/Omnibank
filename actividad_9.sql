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