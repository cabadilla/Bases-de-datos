declare @doc xml
set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 9)
select * from DatosXml

insert into DBO.Usuario(Usuario,Contrasena,EsAdministrador)
select 
	x.Rec.value('@User[1]','varchar(100)'),
    x.Rec.value('@Pass[1]','varchar(100)'),
	x.Rec.value('@EsAdministrador[1]','int')
from @doc.nodes('/Usuarios/Usuario') as x(Rec)

select * from Usuario
