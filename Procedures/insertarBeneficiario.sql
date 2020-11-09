/****** Object:  StoredProcedure [dbo].[insertarBeneficiario]    Script Date: 8/11/2020 18:17:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarBeneficiario]

	
	@porcentaje float,
	@IdCuentaAhorros int,
	@IdParentezco int,
	@valorDocumentoIdentidad int,
	@resultado int output

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
			DECLARE @cantidad int
			SELECT @cantidad= COUNT(*)
			FROM Beneficiario WHERE (IdCuentaAhorros=@IdCuentaAhorros) and (isActivo=1)

			SELECT SUM(porcentaje)
			FROM Beneficiario WHERE (IdCuentaAhorros=@IdCuentaAhorros) and (isActivo=1)
		
			IF (@cantidad<3)
				BEGIN
					INSERT INTO [dbo].[Beneficiario]
					   ([IdCuentaAhorros]
					   ,[IdParentezco]
					   ,[porcentaje]
					   ,[valorDocumentoIdentidad]
					   ,[isActivo])
					VALUES
					   (
						@IdCuentaAhorros,
						@IdParentezco,
						@porcentaje,
						@valorDocumentoIdentidad,
						1
					   )
					   SET @resultado=1
				END
			ELSE
				BEGIN
					SET @resultado=0
				END
			SELECT @resultado
		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END

	SELECT * FROM Beneficiario

	exec insertarBeneficiario 3,11000001,1,34,0