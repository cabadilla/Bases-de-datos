/****** Object:  StoredProcedure [dbo].[procesarInteresesDiarios]    Script Date: 21/12/2020 21:10:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[procesarInteresesDiarios]
----se procesan los intereses diarios
	@dia DATE
	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRAN 

		---primero se actualiza la cuenta objetivo, es decir se suman los nuevos intereses, esto se le hace a todas las cuentas activas
			UPDATE DBO.CuentaObjetivo
			SET InteresesAcumulados=InteresesAcumulados+(TasaIntereses*Saldo)/100
			WHERE isActivo=1
		---una vez que se actualizo se procede a insertar el mmovimiento de intereses, en caso de que algo salga mal se hace un rollback
			INSERT INTO DBO.movimientosInteresCO(
				IdTipoMovimientoCoInte,
				IdCuentaObjetivo,
				Fecha,
				Monto,
				Descripcion,
				NuevoInteresesAcomulados)
			SELECT 
				1,
				C.Id,
				@dia,
				(C.TasaIntereses*C.Saldo)/100,
				'intereses nuevos',
				C.InteresesAcumulados 
			FROM DBO.CuentaObjetivo C
			WHERE isActivo=1
		IF (@@Error<>0)
			ROLLBACK
		ELSE
			COMMIT TRAN
		
	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50015,
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