set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 8)
select * from DatosXml

insert into DBO.TipoMoneda(Id,Tipo,Simbolo)
select 
	x.Rec.value('@Id[1]','int'),
    x.Rec.value('@Nombre[1]','varchar(100)'),
	x.Rec.value('@Simbolo[1]','varchar(100)')
from @doc.nodes('/Tipo_Moneda/TipoMoneda') as x(Rec)


