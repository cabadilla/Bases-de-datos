set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 6)
select * from DatosXml
insert into DBO.TipoCuentaAhorros(Id,Nombre,IdTipoMoneda,SaldoMinimo,MultaSaldoMin,CargoAnual,NumRetirosHumano,NumRetirosAutomatico,ComisionHumano,ComisionAutomatico,Intereses)
select 
	x.Rec.value('@Id[1]','int'),
    x.Rec.value('@Nombre[1]','varchar(100)'),
	x.Rec.value('@IdTipoMoneda[1]','int'),
	x.Rec.value('@SaldoMinimo[1]','float'),
    x.Rec.value('@MultaSaldoMin[1]','float'),
	x.Rec.value('@CargoAnual[1]','float'),
    x.Rec.value('@NumRetirosHumano[1]','int'),
	x.Rec.value('@NumRetirosAutomatico[1]','int'),
    x.Rec.value('@comisionHumano[1]','float'),
	x.Rec.value('@comisionAutomatico[1]','float'),
	x.Rec.value('@interes[1]','float')
from @doc.nodes('/Tipo_Cuenta_Ahorros/TipoCuentaAhorro') as x(Rec)


