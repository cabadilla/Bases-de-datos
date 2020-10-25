declare @doc xml
set @doc='
	<Personas>
<Persona
	TipoDocuIdentidad="1"
	Nombre="Javith Aguero Hernandez"
	ValorDocumentoIdentidad="117370445"
	FechaNacimiento="1999-03-20"
	Email="aguerojavith@gmail.com"
	telefono1="85343403"
	telefono2="24197636"/>
<Persona
	TipoDocuIdentidad="1"
	Nombre="Osvaldo Aguero Hernandez"
	ValorDocumentoIdentidad="12738545"
	FechaNacimiento="1994-10-13"
	Email="osadage@gmail.com"
	telefono1="87541766"
	telefono2="24197545"/>
</Personas>
		'
insert into DBO.Persona(IdTipoDocumentoIdentidad,Nombre,ValorDocumentoIdentidad,FechaNacimiento,Email,telefono1,telefono2)
select 
	x.Rec.value('@TipoDocuIdentidad[1]','int'),
    x.Rec.value('@Nombre[1]','varchar(100)'),
    x.Rec.value('@ValorDocumentoIdentidad[1]','int'),
	x.Rec.value('@FechaNacimiento[1]','date'),
	x.Rec.value('@Email[1]','varchar(100)'),
	x.Rec.value('@telefono1[1]','int'),
	x.Rec.value('@telefono2[1]','int')
from @doc.nodes('/Personas/Persona') as x(Rec)

select * from Persona