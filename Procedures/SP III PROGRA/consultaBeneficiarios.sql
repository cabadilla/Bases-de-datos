	DECLARE @idBene int
	DECLARE @iteradorAux INT
	DECLARE @contadorAux INT
	DECLARE @monto float
	DECLARE @idPersona int
	DECLARE @cuenta int
	DECLARE @mayorCuenta int
	DECLARE @tablaMontos TABLE 				(idPersona int,				idBeneficiario int,				monto float,				idCuenta int				)
	DECLARE @tablaCuenta TABLE
			(idPersona int,
			idBeneficiario int,
			numeroCuenta int
			)

	DECLARE @tablaSaldos TABLE 
		(idPersona int,
		numeroCuenta int,
		monto float
		)

	SELECT @contadorAux=COUNT(Id) FROM Beneficiario WHERE isActivo=1
	SET @iteradorAux=0
	SET @idBene=0

	WHILE @iteradorAux<=@contadorAux
			BEGIN 
				SELECT TOP 1 @idBene=B.Id
				FROM DBO.Beneficiario B
				WHERE (B.Id > @idBene) AND (B.isActivo=1)

				SELECT @idPersona=B.IdPersona,@cuenta=B.IdCuentaAhorros FROM Beneficiario B WHERE B.Id=@idBene

				IF NOT EXISTS(SELECT T.idPersona FROM @tablaMontos T WHERE T.idPersona=@idPersona)
					BEGIN
						SELECT @monto=SUM((C.Saldo*B.Porcentaje)/100)
						FROM Beneficiario B INNER JOIN CuentaAhorros C ON B.IdCuentaAhorros=C.Id
						WHERE B.Id=@idBene

						INSERT INTO @tablaMontos(idPersona,idBeneficiario,monto,idCuenta)
						SELECT 
							@idPersona,
							@idBene,
							@monto,
							@cuenta
					END

				INSERT INTO @tablaSaldos(idPersona,numeroCuenta,monto)
				SELECT B.IdPersona,C.NumeroCuenta,((C.Saldo*B.Porcentaje)/100)
				FROM Beneficiario B INNER JOIN DBO.CuentaAhorros C ON C.Id=B.IdCuentaAhorros 
				WHERE B.Id=@idBene

				IF NOT EXISTS(SELECT T.idPersona FROM @tablaCuenta T WHERE T.idPersona=@idPersona)
					BEGIN
						
						SELECT @mayorCuenta=T.numeroCuenta 
						FROM @tablaSaldos T
						WHERE T.monto=(SELECT MAX(monto) FROM @tablaSaldos T WHERE idPersona=@idPersona)

						INSERT INTO @tablaCuenta(idPersona,idBeneficiario,numeroCuenta)
						SELECT 
							@idPersona,
							@idBene,
							@mayorCuenta
							
					END

				SET @iteradorAux=@iteradorAux+1
				
			END


	SELECT * FROM @tablaCuenta
	SELECT * FROM @tablaMontos
	SELECT * FROM @tablaSaldos

