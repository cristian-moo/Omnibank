Tarea 11: Porcentaje de cuentas desactivadas y ventana de revisión temporal

Select
  count (*) AS total_cuentas,
  count (*) Filter (WHERE is_active = False) As cuentas_desactivadas,
  (
    count (*) Filter (Where is_active = False) :: numeric
    / count (*) :: numeric
  ) * 100 As porcentaje_desactivadas
From core.accounts;

SELECT
  transaction_id As evento_id,
  tx_timestamp,
  TIMESTAMPTZ '2026-01-01 00:00 +00' As fecha_revision,
  AGE (
    TIMESTAMPTZ '2026-10-01 00:00 +00',
    tx_timestamp
  ) As antiguedad
From core.transactions
ORDER BY tx_timestamp ASC, transaction_id ASC
Limit 4;

SELECT
  1 :: numeric / 5 :: numeric * 100 As verificacion_porcentaje;