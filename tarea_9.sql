Tarea 9: diagnóstico de combinaciones sin relación en OmniBank

Cuantifica la matriz sin relacion:
La semilla contiene: customers : 4 registros, accounts : 5 registros, transaction : 4 registros.
4 x 5 x 4 = 80 combinaciones
Cada combinacion representa un cliente, cuenta y transaction.

Repara el Reporte de movimiento:
Se establecen 2 relaciones:
- transaction.account_id = accounts.account_id
- accounts.customer_id = customers.customer_id

Se aplican filtros:
- El titular debe ser activo
- El importe debe ser mayor o igual a 100

El reporte muestra:
- correo
- numero de cuenta
- tipo de transaccion
- importe
- fecha

Se ordena por fecha y por identificador de la transaccion.

Having:
Count (t.transaction_id) >= 0
OR SUM (t.amount) >= 300.00;

Diferencias:
El resultado cartesiano tiene 80 combinaciones porque combina todos los registros entre las tres tablas sin relacionarlos.
La consulta corregida devuelve solamente los movimientos que realmente corresponden a una cuenta y a su titular.
Las condiciones que faltaban son:
- Transaction -> cuenta : transactions.account_id = accounts.account_id
- Cuenta -> titular : accounts.customer_id = customers.customer_id
La reduccion primero se produce porque las uniones eliminan combinaciones que no tienen una relacion valida. Despues, el Where reduce todavia mas el resultado al conservar unicamente titulares activos y movimientos de importe >= 100.