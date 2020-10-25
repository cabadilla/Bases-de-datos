declare @doc xml
set @doc='
	<Estados_de_Cuenta>
<Estado_de_Cuenta
NumeroCuenta="11000001"
fechaInicio="2020-10-13"
fechafin="2020-11-12"
saldoinicial="1000000.00"
saldo_final="1250000.00" />
</Estados_de_Cuenta>
		'
insert into DBO.EstadoCuenta(IdCuentaAhorro,FechaInicio,FechaFinal,SaldoInicial,SaldoFinal)
select 
	x.Rec.value('@NumeroCuenta[1]','int'),
    x.Rec.value('@fechaInicio[1]','date'),
	x.Rec.value('@fechafin[1]','date'),
	x.Rec.value('@saldoinicial[1]','float'),
	x.Rec.value('@saldo_final[1]','float')
from @doc.nodes('/Estados_de_Cuenta/Estado_de_Cuenta') as x(Rec)

select * from EstadoCuenta