/****** Object:  Trigger [dbo].[TR_insert_CuentaAhorro]    Script Date: 13/12/2020 16:16:28 ******/
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
	DECLARE @IdCuenta int SELECT @IdCuenta = Id FROM inserted

	--Toma la fecha inicio para la fecha  del estado
	DECLARE @Fechainicio DATETIME
	SELECT @Fechainicio = FechaCreacion
	FROM inserted

	DECLARE @FechaFinal DATETIME;
	SET @FechaFinal = DATEADD(MONTH, 1, @Fechainicio);
	SET @FechaFinal = DATEADD(DAY, -1, @FechaFinal);

	--toma el saldoInicial de lo que acaba de insertar de la tabla inserted
	DECLARE @saldoInicial int
	SELECT @saldoInicial = Saldo
	FROM inserted

	--Toma el modo de insercion
	DECLARE @modoInsercion VARCHAR
	SELECT @modoInsercion = modoInsercion
	FROM inserted

	INSERT INTO EstadoCuenta(
				[IdCuentaAhorro],
				[FechaInicio],
				[FechaFinal],
				[SaldoInicial],
				[numRetirosAuto],
				[numRetirosVentana],
				[SaldoMinimo])
		VALUES (@IdCuenta,@Fechainicio,@FechaFinal,@saldoInicial,0,0,0)
