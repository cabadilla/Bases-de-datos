/****** Object:  StoredProcedure [dbo].[verUsuario]    Script Date: 22/12/2020 20:29:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[activarUsuario]
@contrasena nchar(100),
@nombre nchar(100)

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		UPDATE Usuario
		SET inSesion = 0
		WHERE inSesion = 1

		UPDATE [Usuario]
		SET inSesion = 1
		WHERE  (Usuario=@nombre) and (Contrasena=@contrasena) and (isActivo=1)

		
	END TRY
	BEGIN CATCH


	END CATCH

END