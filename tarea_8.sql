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


lo que aprendi:Diseñé consultas de monitoreo financiero complejas con exclusiones y condiciones múltiples sobre descripciones de riesgo (crypto, offshore, shell, casino) ordenadas por monto.


fix:

# Day 08 Answer Key — Candidatos de Revisión

## Expected Result

Tres movimientos de revisión didáctica, sin atribuir fraude ni destinatario.

## Reference Solution

```sql
SELECT 
    transaction_id,
    account_id,
    tx_type,
    amount,
    COALESCE(NULLIF(TRIM(description), ''), 'SIN DESCRIPCIÓN') AS visible_description
FROM core.transactions
WHERE (tx_type IN ('TRANSFER', 'WITHDRAWAL') AND amount >= 100)
   OR (tx_type = 'WITHDRAWAL' AND NULLIF(TRIM(description), '') IS NULL)
ORDER BY amount DESC, transaction_id;
```

Los dos `TRANSFER` superan el umbral didáctico. El retiro de 50 entra por descripción faltante. El depósito no cumple ninguno de los dos bloques. Una alerta exploratoria requiere revisión adicional y no constituye una acusación ni un reporte legal.

## Common Valid Variations

* Se acepta `btrim` y una CTE que calcule la descripción normalizada antes de filtrar.

## Common Mistakes

* **Omitir paréntesis**: Cambia la precedencia de los operadores lógicos y altera los resultados esperados.
* **Tratar `description IS NULL` como prueba de fraude**: Confunde una observación incompleta o un dato faltante con una conclusión delictiva.