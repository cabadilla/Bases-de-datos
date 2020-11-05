/****** Object:  StoredProcedure [dbo].[insertarUsuario]    Script Date: 4/11/2020 22:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarUsuario]
    -- Parámetros del SP
    @Usuario nchar(100),
	@Contrasena nchar(100),
	@EsAdministrador int
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  

		INSERT INTO [dbo].[Usuario]
           ([Usuario]
           ,[Contrasena]
           ,[EsAdministrador]
		   ,[isActivo])
     VALUES
           (@Usuario
           ,@Contrasena
           ,@EsAdministrador
		   ,1)

	END TRY
	BEGIN CATCH
	END CATCH
SET NOCOUNT OFF
END