ALTER PROCEDURE [dbo].[ConsultaBeneficiariosAdministrador]

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY
		DECLARE @idBene INT
		DECLARE @iteradorAux INT
		DECLARE @contadorAux INT
		DECLARE @monto FLOAT
		DECLARE @idPersona INT
		DECLARE @cuenta INT
		DECLARE @mayorCuenta INT
		DECLARE @tablaMontos TABLE 					(idPersona INT,					idBeneficiario INT,					monto FLOAT,					idCuenta INT					)
			DECLARE @tablaSaldos TABLE 
			(idPersona INT,
			numeroCuenta INT,
			monto FLOAT
			)
		DECLARE @tablaDatosBeneficiario TABLE 
			(idPersona INT,
			numeroCuentaMayorBeneficio INT,
			cantCuentas INT,
			montoTotal FLOAT
			)

		SELECT @contadorAux=COUNT(Id) FROM Beneficiario WHERE isActivo=1
		SET @iteradorAux=0
		SET @idBene=0

		WHILE @iteradorAux<=@contadorAux
				BEGIN 
					--Toma un beneficiario de la tabla Beneficiario
					SELECT TOP 1 @idBene=B.Id
					FROM DBO.Beneficiario B
					WHERE (B.Id > @idBene) AND (B.isActivo=1)

					--Toma el id de la persona y el id de la Cuenta de Ahorros
					SELECT @idPersona=B.IdPersona,@cuenta=B.IdCuentaAhorros FROM Beneficiario B WHERE B.Id=@idBene

					--Si ese beneficiario no ha sido procesado antes, no esta en @tablaMontos
					IF NOT EXISTS(SELECT T.idPersona FROM @tablaMontos T WHERE T.idPersona=@idPersona)
						BEGIN
							--Monto que va recibir por las cuentas
							SELECT @monto=SUM((C.Saldo*B.Porcentaje)/100)
							FROM Beneficiario B INNER JOIN CuentaAhorros C ON B.IdCuentaAhorros=C.Id
							WHERE B.Id=@idBene

							--Inserta el dato en la variable tabla
							INSERT INTO @tablaMontos(idPersona,idBeneficiario,monto,idCuenta)
							SELECT 
								@idPersona,
								@idBene,
								@monto,
								@cuenta
						END

					--Se llena @tablaSaldos con todos los numeros de cuenta y el monto que cada una le va a generar
					INSERT INTO @tablaSaldos(idPersona,numeroCuenta,monto)
					SELECT B.IdPersona,C.NumeroCuenta,((C.Saldo*B.Porcentaje)/100)
					FROM Beneficiario B INNER JOIN DBO.CuentaAhorros C ON C.Id=B.IdCuentaAhorros 
					WHERE B.Id=@idBene

					--Si ese beneficiario no ha sido procesado antes, no esta en @tablaCuenta
					IF NOT EXISTS(SELECT T.idPersona FROM @tablaDatosBeneficiario T WHERE T.idPersona=@idPersona)
						BEGIN
							--Toma el numero de cuenta de la cuenta que le genera mayor beneficio usando los valores de la @tablaSaldos
							SELECT @mayorCuenta=T.numeroCuenta 
							FROM @tablaSaldos T
							WHERE T.monto=(SELECT MAX(monto) FROM @tablaSaldos T WHERE idPersona=@idPersona)

							INSERT INTO @tablaDatosBeneficiario(idPersona,numeroCuentaMayorBeneficio,cantCuentas,montoTotal)
							SELECT 
								(SELECT P.ValorDocumentoIdentidad FROM Persona P WHERE P.Id=@idPersona),
								@mayorCuenta,
								(SELECT COUNT(B.IdCuentaAhorros) FROM Beneficiario B WHERE idPersona=@idPersona),
								(SELECT monto FROM @tablaMontos WHERE idPersona = @idPersona)
							
						END
					
					SET @iteradorAux=@iteradorAux+1
				
				END
	SELECT * FROM @tablaDatosBeneficiario ORDER BY montoTotal DESC

	

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50010,
		SUSER_SNAME(),
		ERROR_NUMBER(),
		ERROR_STATE(),
		ERROR_SEVERITY(),
		ERROR_LINE(),
		ERROR_PROCEDURE(),
		ERROR_MESSAGE(),
		GETDATE()
		);

	END CATCH

SET NOCOUNT OFF
END
