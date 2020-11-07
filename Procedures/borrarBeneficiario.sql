/****** Object:  StoredProcedure [dbo].[borrarBeneficiario]    Script Date: 7/11/2020 00:29:42 ******/
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
	declare @Existingdate datetime
	Set @Existingdate=GETDATE()
	Select CONVERT(varchar,@Existingdate,3) as [DD/MM/YY]

	UPDATE [dbo].[Beneficiario]
	   SET [fechaDesactivacion] =@Existingdate,
		   [isActivo] = 0
	   WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END