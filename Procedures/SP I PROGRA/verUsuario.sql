/****** Object:  StoredProcedure [dbo].[verUsuario]    Script Date: 10/12/2020 10:51:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verUsuario]
@contrasena nchar(100),
@nombre nchar(100)

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY

		SELECT [Usuario]
		,[Contrasena]
		,[EsAdministrador]
	FROM [dbo].[Usuario]
		WHERE (Usuario=@nombre) and (Contrasena=@contrasena) and (isActivo=1)

		UPDATE [dbo].[Usuario] 
		SET [inSesion] = 1
		WHERE (Usuario=@nombre) and (Contrasena=@contrasena) and (isActivo=1)

	END TRY
	BEGIN CATCH


	END CATCH

END