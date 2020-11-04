declare @doc xml
set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 4)
		'
insert into DBO.Parentezco(Id,Nombre)
select 
	x.Rec.value('@Id[1]','int'),
    x.Rec.value('@Nombre[1]','varchar(100)')
from @doc.nodes('/Parentezcos/Parentezco') as x(Rec)

select * from Parentezco