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