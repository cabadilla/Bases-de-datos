set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 7)
select * from DatosXml

insert into DBO.TipoDocumentoIdentidad(Id,Nombre)
select 
	x.Rec.value('@Id[1]','int'),
    x.Rec.value('@Nombre[1]','varchar(100)')
from @doc.nodes('/Tipo_Doc/TipoDocuIdentidad') as x(Rec)

select * from TipoDocumentoIdentidad
