declare @doc xml
set @doc='
	<Parentezcos>
		<Parentezco Id="1" Nombre="Padre"/>
		<Parentezco Id="2" Nombre="Madre"/>
		<Parentezco Id="3" Nombre="Hijo"/>
		<Parentezco Id="4" Nombre="Hija"/>
		<Parentezco Id="5" Nombre="Hermano"/>
		<Parentezco Id="6" Nombre="Hermana"/>
		<Parentezco Id="7" Nombre="amigo"/>
		<Parentezco Id="8" Nombre="amiga"/>
</Parentezcos>
		'
insert into DBO.Parentezco(Id,Nombre)
select 
	x.Rec.value('@Id[1]','int'),
    x.Rec.value('@Nombre[1]','varchar(100)')
from @doc.nodes('/Parentezcos/Parentezco') as x(Rec)

select * from Parentezco