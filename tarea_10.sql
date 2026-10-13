Tarea 10: Promedios con NULL y reporte de actividad de crédito

Select
  count (*) AS total_cuentas_activas
From core.accounts
Where is_active = true;

Select
  count (Distinct a.account_id) As cuentas_activas_con_depositos
From core.accounts a
Where a.is_active = true
And exists (
  Select 1
  From core.transaction t
  Where t.account_id = a.account_id
  And t.tx_type = 'Deposit'
);

Select
  count (*) As total_movimientos,
  sum (amount) As volumen_bruto
From core.transaction;

Select
  a.account_number,
  count (t.transaction_id) As recuento_eventos,
  COALESCE (Sum (t.amount), 0) As volumen_bruto
From core.accounts a
Left Join core.transactions t
  On a.account_number = 'ACCT-3602'
Group By a.account_number;