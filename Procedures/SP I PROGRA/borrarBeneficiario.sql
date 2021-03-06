/****** Object:  StoredProcedure [dbo].[borrarBeneficiario]    Script Date: 15/12/2020 21:44:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarBeneficiario]

@cuenta INT,
@valorDoc INT

AS
BEGIN 
SET NOCOUNT ON 
	BEGIN TRY
	DECLARE @Existingdate DATETIME
	SET @Existingdate=GETDATE()
	SELECT CONVERT(VARCHAR,@Existingdate,3) AS [DD/MM/YY]

	DECLARE @xml xml select @xml = '<Beneficiario />';

	BEGIN TRANSACTION borrarBene

		UPDATE [dbo].[Beneficiario]
		   SET [fechaDesactivacion] =@Existingdate,
			   [isActivo] = 0
		   WHERE (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@cuenta)) and (valorDocumentoIdentidad=@valorDoc)
		
		--Registrar Evento
		INSERT INTO [dbo].[Eventos](
					[idTipoEvento],
					[idUser],
					[IP],
					[Fecha],
					[XMLAntes],
					[XMLDespues])
		VALUES  (6,
				(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
				(SELECT ABS(CHECKSUM(NEWID()))),
				@Existingdate,
				(SELECT BE.IdCuentaAhorros,BE.IdPersona,BE.IdParentezco,BE.Porcentaje,BE.valorDocumentoIdentidad,BE.fechaInserccion,BE.fechaDesactivacion,BE.modoInserccion
				FROM Beneficiario BE WHERE (BE.IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@cuenta)) and (isActivo=0)and (valorDocumentoIdentidad=@valorDoc)
				FOR XML AUTO),
				@xml)
	
	COMMIT TRANSACTION borrarBene;
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION borrarBene;

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