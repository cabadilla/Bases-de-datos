declare @doc xml
set @doc='
		<Tipo_Moneda>
			<TipoMoneda Id="1" Nombre="Colones" Simbolo="₡"/>
			<TipoMoneda Id="2" Nombre="Dolares" Simbolo="$"/>
			<TipoMoneda Id="3" Nombre="Euros" Simbolo="€"/>
</Tipo_Moneda>
		'
insert into DBO.TipoMoneda(Id,Tipo,Simbolo)
select 
	x.Rec.value('@Id[1]','int'),
    x.Rec.value('@Nombre[1]','varchar(100)'),
	x.Rec.value('@Simbolo[1]','varchar(100)')
from @doc.nodes('/Tipo_Moneda/TipoMoneda') as x(Rec)


