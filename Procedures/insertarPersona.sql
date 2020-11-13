/****** Object:  StoredProcedure [dbo].[insertarPersona]    Script Date: 12/11/2020 23:06:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarPersona]
    -- Parámetros del SP
	@IdTipoDocumentoIdentidad int,
    @Nombre varchar(40),
	@ValorDocumentoIdentidad int,
	@FechaNacimiento date,
	@Email varchar(100),
	@Telefono1 int,
	@Telefono2 int,
	@ModoInsercion nChar(10)




AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
		DECLARE @Existingdate DATETIME
		SET @Existingdate=GETDATE()
		SELECT CONVERT(VARCHAR,@Existingdate,3) as [DD/MM/YY]

		INSERT INTO [dbo].[Persona]
				   (
				   [IdTipoDocumentoIdentidad]
				   ,[Nombre]
				   ,[ValorDocumentoIdentidad]
				   ,[FechaNacimiento]
				   ,[Email]
				   ,[Telefono1]
				   ,[Telefono2]
				   ,[isActivo]
				   ,[FechaActivacion]
				   ,[MedioInsercion])
			 VALUES
				   (@IdTipoDocumentoIdentidad
				   ,@Nombre
				   ,@ValorDocumentoIdentidad
				   ,@FechaNacimiento
				   ,@Email
				   ,@Telefono1
				   ,@Telefono2
				   ,1
				   ,@Existingdate
				   ,@ModoInsercion
				   )

	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END