/****** Object:  StoredProcedure [dbo].[modificarCuentaObjetivo]    Script Date: 24/11/2020 22:48:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[modificarCuentaObjetivo]

@ObjetivoNuevo nchar(100),
@ObjetivoViejo nchar(100)
AS
BEGIN    
	SET NOCOUNT ON;
	BEGIN TRY

		UPDATE [dbo].[CuentaObjetivo]
	   SET [Objetivo] = @ObjetivoNuevo
		WHERE Objetivo=@ObjetivoViejo
		
	END TRY
	BEGIN CATCH

	END CATCH
    SET NOCOUNT OFF;
END