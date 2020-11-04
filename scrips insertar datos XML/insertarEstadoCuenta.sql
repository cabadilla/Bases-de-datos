---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
declare @doc xml
set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 3)
--select * from DatosXml


insert into DBO.EstadoCuenta(IdCuentaAhorro,FechaInicio,FechaFinal,SaldoInicial,SaldoFinal)
select 
	x.Rec.value('@NumeroCuenta[1]','int'),
    x.Rec.value('@fechaInicio[1]','date'),
	x.Rec.value('@fechafin[1]','date'),
	x.Rec.value('@saldoinicial[1]','float'),
	x.Rec.value('@saldo_final[1]','float')
from @doc.nodes('/Estados_de_Cuenta/Estado_de_Cuenta') as x(Rec)

select * from EstadoCuenta