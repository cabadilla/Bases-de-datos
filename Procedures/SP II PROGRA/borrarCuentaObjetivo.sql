/****** Object:  StoredProcedure [dbo].[borrarCuentaObjetivo]    Script Date: 22/12/2020 19:33:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarCuentaObjetivo]

@CuentaAhorro int,
@Objetivo nchar(100)

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY
	--Se toma el Id al que corresponde esa cuenta ahorro
	DECLARE @IdCuentaAhorro int
	SELECT @IdCuentaAhorro = CA.Id
	FROM DBO.CuentaAhorros CA
	WHERE CA.NumeroCuenta = @CuentaAhorro

	--Se toma la fecha actual en la que se genero el evento
	DECLARE @Existingdate datetime
	SET @Existingdate=GETDATE()
	Select CONVERT(varchar,@Existingdate,3)
	SET NOCOUNT ON;
	DECLARE @xml xml select @xml = '<CuentaObjetivo />';
	

	BEGIN TRANSACTION borrarCO
		--Actualizar la cuenta
		UPDATE [dbo].[CuentaObjetivo]
		   SET  [isActivo] = 0
		   WHERE (IdCuentaAhorro=@IdCuentaAhorro) and (Objetivo=@Objetivo)

		--Registrar Evento
		INSERT INTO [dbo].[Eventos](
					[idTipoEvento],
					[idUser],
					[IP],
					[Fecha],
					[XMLAntes],
					[XMLDespues],
					[insertAt])
		VALUES  (6,
				(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
				(SELECT ABS(CHECKSUM(NEWID()))),
				@Existingdate,
				(SELECT CO.IdCuentaAhorro,CO.DiasRebajo,CO.Cuota,CO.FechaInicio,CO.FechaFin,CO.isActivo,CO.Objetivo
				FROM CuentaObjetivo CO WHERE (IdCuentaAhorro=@IdCuentaAhorro) and (Objetivo=@Objetivo) and (isActivo=0)
				FOR XML AUTO),
				@xml,
				'Pagina web')
	COMMIT TRANSACTION borrarCO;

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION borrarCO;

		--Error de borrado
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