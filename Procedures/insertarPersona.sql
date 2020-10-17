/****** Object:  StoredProcedure [dbo].[insertarPersona]    Script Date: 17/10/2020 14:20:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarPersona]
    -- Parámetros del SP
    @Nombre varchar(100),
	@IdTipoDocumentoIdentidad int,
	@FechaNacimiento date,
	@Email varchar(100),
	@Telefono1 int,
	@Telefono2 int
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY  


INSERT INTO [dbo].[Persona]
           ([Nombre]
           ,[IdTipoDcumentoIdentidad]
           ,[FechaNacimiento]
           ,[Email]
           ,[Telefono1]
           ,[Telefono2])
     VALUES
           (@Nombre
		   ,@IdTipoDocumentoIdentidad
		   ,@FechaNacimiento
		   ,@Email
		   ,@Telefono1
		   ,@Telefono2
		   )
   
END TRY
BEGIN CATCH
END CATCH
SET NOCOUNT OFF
END
