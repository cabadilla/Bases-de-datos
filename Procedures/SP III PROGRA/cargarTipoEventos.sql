CREATE PROCEDURE [dbo].[CargarTipoEventos]

AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
		--Primero se limpia la tabla
		DELETE dbo.TipoEvento
		--Se cargan los eventos de los beneficiarios
		EXEC dbo.insertarTipoEventos 1,"Insertar Beneficiarios"
		EXEC dbo.insertarTipoEventos 2,"Modificar Beneficiario"
		EXEC dbo.insertarTipoEventos 3,"Eliminar Beneficiario"
		--Se cargan los eventos de las cuenta objetivo
		EXEC dbo.insertarTipoEventos 4,"Insertar CO"
		EXEC dbo.insertarTipoEventos 5,"Modificar CO"
		EXEC dbo.insertarTipoEventos 6,"Eliminar CO"


	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END