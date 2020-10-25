declare @doc xml
set @doc='
	<Cuentas>
<Cuenta ValorDocumentoIdentidadDelCliente="117370445"
	TipoCuentaId="1"
	NumeroCuenta="11000001"
	FechaCreacion="2020-10-13"
	Saldo="1000000.00"/>
</Cuentas>
		'
insert into DBO.CuentaAhorros(NumeroCuenta,IdTipoCuentaAhorros,IdCliente,Saldo,FechaCreacion)
select 
	x.Rec.value('@NumeroCuenta[1]','int'),
    x.Rec.value('@TipoCuentaId[1]','int'),
    x.Rec.value('@ValorDocumentoIdentidadDelCliente[1]','int'),
	x.Rec.value('@Saldo[1]','float'),
	x.Rec.value('@FechaCreacion[1]','date')
from @doc.nodes('/Cuentas/Cuenta') as x(Rec)

select * from CuentaAhorros