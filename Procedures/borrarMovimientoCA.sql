/****** Object:  StoredProcedure [dbo].[borrarMovimientoCA]    Script Date: 23/10/2020 18:42:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarMovimientoCA]

@Id int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	DELETE FROM [dbo].[MovimientoCA]
      WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END