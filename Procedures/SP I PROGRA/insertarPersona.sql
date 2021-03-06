/****** Object:  StoredProcedure [dbo].[insertarPersona]    Script Date: 13/11/2020 19:55:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarPersona]
----SP PARA LA INSERCCION DE PERSONAS
    -- Parámetros del SP
	@IdTipoDocumentoIdentidad int,
    	@Nombre varchar(40),
	@ValorDocumentoIdentidad int,
	@FechaNacimiento date,
	@Email varchar(100),
	@Telefono1 int,
	@Telefono2 int



AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
	---SE DECLARA LA VARIABLE PARA REGISTRAR LA FECHA EN QUE SE INSERTO A LA PERSONA EN LA BASE DE DATOS
	----TAMBIEN SE REGISTRA EL MODO EN EL QUE SE INSERTO, SI FUE POR SCRIPT O SI FUE POR EL USUARIO
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
				   ,'usuario'
				   )

	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END