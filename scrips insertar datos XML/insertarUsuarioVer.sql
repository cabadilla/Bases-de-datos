declare @doc xml
set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 10)
select * from DatosXml

INSERT INTO [dbo].[Usuario_Ver]
           ([Usuario]
           ,[NumeroCuenta])
select 
	x.Rec.value('@User[1]','nchar(100)'),
    x.Rec.value('@NumeroCuenta[1]','int')
from @doc.nodes('/Usuarios_Ver/UsuarioPuedeVer') as x(Rec)

select * from Usuario
