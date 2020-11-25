/****** Object:  StoredProcedure [dbo].[borrarCuentaObjetivo]    Script Date: 25/11/2020 00:07:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarCuentaObjetivo]

@IdCuentaAhorro int,
@Objetivo nchar(100)

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY
	declare @Existingdate datetime
	Set @Existingdate=GETDATE()
	Select CONVERT(varchar,@Existingdate,3) as [DD/MM/YY]


	UPDATE [dbo].[CuentaObjetivo]

	   SET  [FechaFin]=@Existingdate,
			[isActivo] = 0
	   WHERE (IdCuentaAhorro=@IdCuentaAhorro) and (Objetivo=@Objetivo)
      
	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END