/****** Object:  StoredProcedure [dbo].[insertarBeneficiario]    Script Date: 11/11/2020 19:05:45 ******/
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
			DECLARE @cantidad INT
			SELECT @cantidad= COUNT(*)
			FROM Beneficiario WHERE (IdCuentaAhorros=@IdCuentaAhorros) and (isActivo=1)
			IF (@cantidad<3)
				BEGIN

				DECLARE @existe int
				SELECT @existe=COUNT(*)
				FROM Beneficiario WHERE (valorDocumentoIdentidad=@valorDocumentoIdentidad) and (IdCuentaAhorros=@IdCuentaAhorros)
				

				IF(@existe>0)
					BEGIN
						UPDATE Beneficiario
						SET isActivo=1,
						porcentaje=@porcentaje,
						IdParentezco=@IdParentezco
						WHERE valorDocumentoIdentidad=@valorDocumentoIdentidad
						SET @resultado=1
					END
				ELSE
					BEGIN

						DECLARE @isPersona int
						SELECT @isPersona=COUNT(*)
						FROM Persona WHERE valorDocumentoIdentidad=@valorDocumentoIdentidad

						IF (@isPersona>0)
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
								SET @resultado=2
							END
					END
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