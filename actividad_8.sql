Actividad 8: Extracción de Reportes Gerenciales en OmniBank y Detección de Vacíos

SELECT
  Numero_cuenta,
  Tipo_cuenta,
  balance
FROM core.accounts
WHERE between 1000.00 and 10000
  and Account_type IN ('Savings')
ORDER BY balance DESC
LIMIT 2;

SELECT first_name, last_name, email
FROM core.customers
WHERE email ILIKE 'Texto%';

SELECT transaction_id, transaction_type, amount,
  COALESCE(to_account_id::text, 'Cobro institucional o Comision - Sin Receptor') AS cuenta_receptora_visible
FROM core.transactions
WHERE to_account_id IS NULL
  AND transaction_type = 'Fee';

Restriccion de unicidad:
El tax ID de cada cliente debe ser unico, por lo que no puede existir mas de un cliente con el mismo tax ID.
El correo tambien debe ser unico.

Esqueleto de las tablas:
- Cliente: Nombre, electronico, telefono, fecha de Nacimiento, tax
- Cuentas: Numero de cuenta, Moneda, tipo de cuenta, saldo y limite de credito
- Transacciones: Cuenta origen, cuenta destino, monto, tipo de Transaccion y fecha de realizacion.