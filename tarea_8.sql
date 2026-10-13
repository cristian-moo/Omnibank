Tarea 8: Auditoría Antifraude y Detección de Operaciones Sospechosas (AML) en OmniBank

Select transaction_id, amount, tx_type, tx_timestamp,
COALESCE(description, 'EXCLUSION OPORTUNAMENTE Detectada - Sin Motivo de paso')
As description_Monitoreado
From core.transactions
Where (amount >= 1000.00
And tx_type In ('TRANSFER', 'WITHDRAWAL')
Or (Coalesce(Trim(description), '') is NULL
And tx_type != 'DEPOSIT')
Or description Like '%crypto%'
Or description Like '%Offshore%'
Or description Like '%Shell%'
Or description Like '%casino%'
)
Order By amount Desc;