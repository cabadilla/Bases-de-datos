/****** Object:  Trigger [dbo].[TR_insert_CuentaAhorro]    Script Date: 29/11/2020 12:03:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER  [dbo].[TR_insert_CuentaAhorro] 
   ON  [dbo].[CuentaAhorros]
   AFTER INSERT
AS 

	SET NOCOUNT ON;

	--toma el Id de lo que acaba de insertar de la tabla inserted
	DECLARE @IdCuenta int SELECT @IdCuenta = NumeroCuenta FROM inserted

	--Toma la fecha inicio para la fecha  del estado
	DECLARE @Fechainicio DATETIME
	SET @Fechainicio=GETDATE()
	SELECT CONVERT(VARCHAR,@Fechainicio,3) AS [DD/MM/YY]

	DECLARE @FechaFinal DATETIME;
	SET @FechaFinal = DATEADD(MONTH, 1, @Fechainicio);

	--toma el saldoInicial de lo que acaba de insertar de la tabla inserted
	DECLARE @saldoInicial int
	SELECT @saldoInicial = Saldo
	FROM inserted

	--Toma el modo de insercion
	DECLARE @modoInsercion int
	SELECT @modoInsercion = modoInsercion
	FROM inserted

	INSERT INTO EstadoCuenta(
				[IdCuentaAhorro],
				[FechaInicio],
				[FechaFinal],
				[SaldoInicial])
		VALUES (@IdCuenta,@Fechainicio,@FechaFinal,@saldoInicial)


