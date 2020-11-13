/****** Object:  StoredProcedure [dbo].[INSERTARXML]    Script Date: 3/11/2020 21:49:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[INSERTARXML]
@nombre nchar(100),
@datos xml

AS
BEGIN 
SET NOCOUNT ON 
	BEGIN TRY

		INSERT INTO [dbo].[DatosXml]
			   ([Nombre]
			   ,[XML])
		 VALUES
			   (@nombre
			   ,@datos)


	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END
