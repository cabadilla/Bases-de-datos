
CREATE PROCEDURE [dbo].[insertarTipoEventos]
----SP PARA LA INSERCCION DE TipoEventos
    -- Parámetros del SP
	@Id INT,
	@Nombre NCHAR(100)



AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
		

		INSERT INTO [dbo].[TipoEvento]
				   (
				   [id],
				   [Nombre])
			 VALUES
				   (@Id
				   ,@Nombre
				   )

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50004,
		SUSER_SNAME(),
		ERROR_NUMBER(),
		ERROR_STATE(),
		ERROR_SEVERITY(),
		ERROR_LINE(),
		ERROR_PROCEDURE(),
		ERROR_MESSAGE(),
		GETDATE()
		);
	END CATCH
SET NOCOUNT OFF
END