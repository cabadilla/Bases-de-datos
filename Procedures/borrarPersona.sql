/****** Object:  StoredProcedure [dbo].[borrarPersona]    Script Date: 4/11/2020 22:49:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarPersona]

@Id int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	UPDATE [dbo].[Persona]
	   SET [isActivo] = 0
      WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END