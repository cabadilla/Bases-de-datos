/****** Object:  StoredProcedure [dbo].[verUsuarioVer]    Script Date: 9/11/2020 21:38:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verUsuarioVer]
@usuario nchar(100)

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY

		SELECT [NumeroCuenta]
		FROM [dbo].[Usuario_Ver]
		WHERE Usuario=@usuario

	END TRY
	BEGIN CATCH


	END CATCH

END

select * from Usuario_Ver