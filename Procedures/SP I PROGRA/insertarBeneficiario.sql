/****** Object:  StoredProcedure [dbo].[insertarBeneficiario]    Script Date: 7/12/2020 15:10:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarBeneficiario]

----SP DE INSERCCION DE BENEFICIARIO
----VALORES DE ENTRADA NECESARIOS PARA LA INSERCCION
	@porcentaje float,
	@IdCuentaAhorros int,
	@IdParentezco int,
	@valorDocumentoIdentidad int,
	@resultado int output
	----LOS VALORES DE RESULTADO LE VAN A INDICAR AL BACKEND QUE MOSTRAR EN PANTALLA, SE HIZO CON NUMERO Y QUE EL BACKEND TUVIERA LAS LETRAS PARA NO SATURAR EL SCRIP DE 
	----INSERTADO DE DATOS EN EL SQL SERVER
	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
		-----SE VERIFICA SI DENTRO DE UNA CUENTA YA HAY MAS DE 3 BENEFICIARIOS ASOCIADOS
			DECLARE @cantidad INT
			SELECT @cantidad= COUNT(*)
			FROM Beneficiario WHERE (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@IdCuentaAhorros )) and (isActivo=1)
			IF (@cantidad<3)
				BEGIN
				DECLARE @existe int
				SELECT @existe=COUNT(*)
				FROM Beneficiario 
				WHERE (valorDocumentoIdentidad=@valorDocumentoIdentidad) and (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@IdCuentaAhorros ))
				
				---UNA VEZ SE VERIFICA QUE HAY MENOS DE 3, SE VERIFICA SI YA EL BENEFICIARIO EXISTE Y ESTA ACTIVO, EN CASO DE SER ASI SOLO SE CAMBIA EL VALOR DE ISACTIVO
				----Y SE CAMBIAN A LOS NUEVOS VALORES QUE SE DIGITEN
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
					----EN CASO DE QUE EL BENEFICIARIO NO EXISTA PRIMERO SE VERIFICA SI ES UNA PERSONA 
						DECLARE @isPersona int
						SELECT @isPersona=COUNT(*)
						FROM Persona WHERE valorDocumentoIdentidad=@valorDocumentoIdentidad
						-----EN CASO DE QUE SEA UNA PERSNA SE INSERTA DE UN SOLO Y POR EL VALOR DE DOCUMENTO DE IDENTIDAD QUEDA ASOCIADO A ESA PERSONA
						----EN CASO DE QUE NO LO SEA SE LE MANDA AL BACKEND  UN VALOR DE SALIDA EL CUAL INDICA QUE DEBE DE INSERTAR PRIMERO A LA PERSONA
						-----UNA VEZ SE INSERTE A LA PERSONA YA SE PODRA INSERTAR AL BENEFICIARIO
						IF (@isPersona>0)
							BEGIN
								DECLARE @Existingdate DATETIME
								SET @Existingdate=GETDATE()
								SELECT CONVERT(VARCHAR,@Existingdate,3) as [DD/MM/YY]

								INSERT INTO [dbo].[Beneficiario]
								   ([IdCuentaAhorros]
								   ,[IdParentezco]
								   ,[porcentaje]
								   ,[valorDocumentoIdentidad]
								   ,[isActivo]
								   ,[fechaInserccion]
								   ,[modoInserccion])
								VALUES
								   (
									(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@IdCuentaAhorros ),
									@IdParentezco,
									@porcentaje,
									@valorDocumentoIdentidad,
									1,
									@Existingdate,
									'usuario'
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

