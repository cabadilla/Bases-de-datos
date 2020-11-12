/****** Object:  StoredProcedure [dbo].[insertarPersona]    Script Date: 11/11/2020 19:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verTipoDocumentoIdentidad]
    -- Parámetros del SP
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  


		SELECT * FROM TipoDocumentoIdentidad

	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END