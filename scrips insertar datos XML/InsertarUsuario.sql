
declare @doc xml
set @doc='
	<Usuarios>
	<Usuario User="jaguero" Pass="LaFacil" EsAdministrador="0" />
	<Usuario User="fquiros" Pass="MyPass123*" EsAdministrador="1" />
</Usuarios>
		'
insert into DBO.Usuario(Usuario,Contrasena,EsAdministrador)
select 
	x.Rec.value('@User[1]','varchar(100)'),
    x.Rec.value('@Pass[1]','varchar(100)'),
	x.Rec.value('@EsAdministrador[1]','int')
from @doc.nodes('/Usuarios/Usuario') as x(Rec)

select * from Usuario