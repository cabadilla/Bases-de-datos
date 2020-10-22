declare @doc xml
set @doc='
<Tipo_Doc>
	<TipoDocuIdentidad Id="1" Nombre="Cedula Nacional"/>
	<TipoDocuIdentidad Id="2" Nombre="Cedula Residente"/>
	<TipoDocuIdentidad Id="3" Nombre="Pasaporte"/>
	<TipoDocuIdentidad Id="4" Nombre="Cedula Juridica"/>
	<TipoDocuIdentidad Id="5" Nombre="Permiso de Trabajo"/>
	<TipoDocuIdentidad Id="6" Nombre="Cedula Extranjera"/>
</Tipo_Doc>
		'
insert into DBO.TipoDocumentoIdentidad(Id,Nombre)
select 
	x.Rec.value('@Id[1]','int'),
    x.Rec.value('@Nombre[1]','varchar(100)')
from @doc.nodes('/Tipo_Doc/TipoDocuIdentidad') as x(Rec)

select * from TipoDocumentoIdentidad
