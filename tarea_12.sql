Tarea 12: Exclusión segura con NOT EXISTS y NULL

1: SELECT
  a.account_number,
  a.is_active
From core.accounts a
Where a.is_active = true
And NOT Exists (
  Select 1
  From core.transaction t
  Where t.account_id = a.account_id
)
ORDER BY a.account_number;

2: Select
  a.account_number,
  a.is_active
From core.account a
Where not exists (
  Select 1
  From core.transaction t
  Where t.account_id = a.account_id
  And t.transaction_type = 'Deposit'
)
ORDER BY a.account_number;

3: Select
  (
    Select count (*)
    From core.accounts a
    Where a.is_active = true
    And NOT Exists (
      Select 1
      From core.transaction t
      Where t.account_id = a.account_id
    )
  );