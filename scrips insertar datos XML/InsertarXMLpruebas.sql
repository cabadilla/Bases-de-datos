
----insert de primer tipo xml
declare @doc xml
set @doc='
<nombres>
	<nom>
		<Nombre>juab</Nombre>
		<descripcion>kbsdhf</descripcion>
	</nom>
	<nom>
		<Nombre>hbkc</Nombre>
		<descripcion>hfsd</descripcion>
	</nom>
	
</nombres>
'

insert into TablaPruebaXML(Nombre,Descripcion)
select
    c.query('./Nombre').value('.','varchar(100)'),
    c.query('./descripcion').value('.','varchar(100)')
from @doc.nodes('/nombres/nom') as ref(c)

select * from TablaPruebaXML 


----insert segundo tipo----
declare @doc1 xml
set @doc1='
		<nombres>
			<nom Nombre="Colones" Descripcion="₡"/>
			<nom Nombre="Dolares" Descripcion="$"/>
			<nom Nombre="Euros" Descripcion="€"/>
		</nombres>
		'
insert into TablaPruebaXML(Nombre,Descripcion)
select 
	x.Rec.value('@Nombre[1]','varchar(100)'),
    x.Rec.value('@Descripcion[1]','varchar(100)')
from @doc1.nodes('/nombres/nom') as x(Rec)


select * from TablaPruebaXML 