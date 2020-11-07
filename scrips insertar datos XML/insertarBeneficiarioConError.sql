---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
declare @doc xml
set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 13)
--select * from DatosXml

INSERT INTO [dbo].[Beneficiario]
			   ([IdCuentaAhorros]
			   ,[IdParentezco]
			   ,[porcentaje]
			   ,[valorDocumentoIdentidad]
			   ,[isActivo])
select 
	x.Rec.value('@NumeroCuenta[1]','int'),
    x.Rec.value('@ParentezcoId[1]','int'),
    x.Rec.value('@Porcentaje[1]','int'),
	x.Rec.value('@ValorDocumentoIdentidadBeneficiario[1]','int'),
	1
	
from @doc.nodes('/Beneficiarios/Beneficiario') as x(Rec)

select * from Persona

declare @datos xml
set @datos='<Beneficiarios>
    <Beneficiario NumeroCuenta="117370445" ValorDocumentoIdentidadBeneficiario="117370445" ParentezcoId="5" Porcentaje="25" />
    <Beneficiario NumeroCuenta="12738545" ValorDocumentoIdentidadBeneficiario="105711321" ParentezcoId="7" Porcentaje="87"/>

  </Beneficiarios>'

  declare @nombre nchar(100)
  set @nombre='beneficiarios 2.0'

  exec INSERTARXML @nombre, @datos