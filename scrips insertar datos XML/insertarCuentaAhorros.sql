---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
declare @doc xml
set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 1)
--select * from DatosXml


insert into DBO.CuentaAhorros(NumeroCuenta,IdTipoCuentaAhorros,IdCliente,Saldo,FechaCreacion)
select 
	x.Rec.value('@NumeroCuenta[1]','int'),
    x.Rec.value('@TipoCuentaId[1]','int'),
    x.Rec.value('@ValorDocumentoIdentidadDelCliente[1]','int'),
	x.Rec.value('@Saldo[1]','float'),
	x.Rec.value('@FechaCreacion[1]','date')
from @doc.nodes('/Cuentas/Cuenta') as x(Rec)

select * from CuentaAhorros