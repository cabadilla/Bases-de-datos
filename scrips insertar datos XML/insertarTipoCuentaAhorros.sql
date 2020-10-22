declare @doc xml
set @doc='
		<Tipo_Cuenta_Ahorros>
<TipoCuentaAhorro
		Id="1"
		Nombre="Proletario"
		IdTipoMoneda="1"
		SaldoMinimo="25000.00"
		MultaSaldoMin="3000.00"
		CargoAnual = "5000"
		NumRetirosHumano="5"
		NumRetirosAutomatico ="8"
		comisionHumano="300"
		comisionAutomatico="300"
		interes ="10" />
		<TipoCuentaAhorro
		Id="2"
		Nombre="Profesional"
		IdTipoMoneda="1"
		SaldoMinimo="50000.00"
		MultaSaldoMin="3000.00"
		CargoAnual = "15000"
		NumRetirosHumano="5"
		NumRetirosAutomatico ="8"
		comisionHumano="500"
		comisionAutomatico="500"
		interes ="15" />
		<TipoCuentaAhorro
		Id="3"
		Nombre="Exclusivo"
		IdTipoMoneda="1"
		SaldoMinimo="100000.00"
		MultaSaldoMin="3000.00"
		CargoAnual = "30000"
		NumRetirosHumano="5"
		NumRetirosAutomatico ="8"
		comisionHumano="1000"
		comisionAutomatico="1000"
		interes ="20" />
</Tipo_Cuenta_Ahorros>
		'
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


