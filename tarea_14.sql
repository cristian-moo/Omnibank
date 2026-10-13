Tarea 14: Extensión de Self JOIN, matriz de productos y anti JOIN

Select
  a.account_number,
  a.account_type,
  c.customer_name As titular
From core.accounts a
Inner Join core.customers c
  On a.customer_id = c.customer_id
Where a.is_active = true
And NOT EXISTS (
  Select 1
  From core.transaction t
  Where t.account_id = a.account_id
  And t.tx_type = 'Deposit'
)
Order By a.account_number;

Select
  a.account_number,
  a.account_type,
  c.customer_name As titular
From core.accounts a
Inner Join core.customers c
  On a.customer_id = c.customer_id
Where a.is_active = true
And Exists (
  Select 1
  From core.transactions t
  Where t.account_id = a.account_id
)
Order By a.account_number;


lo que aprendi:Desarrollé reportes operativos combinando uniones relacionales (INNER JOIN) con filtros existenciales (EXISTS / NOT EXISTS) para auditar cuentas con o sin depósitos por titular activo.


fix:


# Day 14 Answer Key — Extensión de Self JOIN, matriz de productos y anti JOIN

## Expected Result
Tres cuentas activas carecen de DEPOSIT: ACCT-1001, ACCT-2001 y ACCT-3002. Las dos primeras sí tienen otros movimientos.

## Reference Solution
```sql
SELECT a.account_number, a.account_type
FROM core.accounts a
LEFT JOIN core.transactions t ON t.account_id = a.account_id AND t.tx_type = 'DEPOSIT'
WHERE a.is_active AND t.transaction_id IS NULL
ORDER BY a.account_number;