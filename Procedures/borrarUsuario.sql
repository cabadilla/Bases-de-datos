/****** Object:  StoredProcedure [dbo].[borrarUsuario]    Script Date: 4/11/2020 22:50:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarUsuario]

@Id int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	UPDATE [dbo].[Usuario]
	   SET [isActivo] = 0
      WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END


