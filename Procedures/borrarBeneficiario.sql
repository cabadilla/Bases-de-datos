/****** Object:  StoredProcedure [dbo].[borrarBeneficiario]    Script Date: 4/11/2020 22:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarBeneficiario]

@Id int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	UPDATE [dbo].[Beneficiario]
	   SET [isActivo] = 0
      WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END


