/****** Object:  StoredProcedure [dbo].[verUsuario]    Script Date: 9/11/2020 21:34:50 ******/
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
		WHERE (Usuario=@nombre) and (Contrasena=@contrasena) AND (isActivo=1)

	END TRY
	BEGIN CATCH


	END CATCH

END