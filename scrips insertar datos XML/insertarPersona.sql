declare @doc xml
set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 5)
select * from DatosXml

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
