/****** Object:  Database [Bases de datos]    Script Date: 22/12/2020 21:36:59 ******/
CREATE DATABASE [Bases de datos]  (EDITION = 'GeneralPurpose', SERVICE_OBJECTIVE = 'GP_S_Gen5_1', MAXSIZE = 10 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE [Bases de datos] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [Bases de datos] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Bases de datos] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Bases de datos] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Bases de datos] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Bases de datos] SET ARITHABORT OFF 
GO
ALTER DATABASE [Bases de datos] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Bases de datos] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Bases de datos] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Bases de datos] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Bases de datos] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Bases de datos] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Bases de datos] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Bases de datos] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Bases de datos] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [Bases de datos] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Bases de datos] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [Bases de datos] SET  MULTI_USER 
GO
ALTER DATABASE [Bases de datos] SET ENCRYPTION ON
GO
ALTER DATABASE [Bases de datos] SET QUERY_STORE = ON
GO
ALTER DATABASE [Bases de datos] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_diagramobjects]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE FUNCTION [dbo].[fn_diagramobjects]() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
GO
/****** Object:  Table [dbo].[Beneficiario]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Beneficiario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersona] [int] NULL,
	[IdCuentaAhorros] [int] NULL,
	[IdParentezco] [int] NULL,
	[Porcentaje] [int] NULL,
	[valorDocumentoIdentidad] [int] NULL,
	[isActivo] [int] NULL,
	[fechaInserccion] [date] NULL,
	[fechaDesactivacion] [date] NULL,
	[modoInserccion] [nchar](10) NULL,
 CONSTRAINT [PK_Beneficiario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaAhorros]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaAhorros](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NumeroCuenta] [int] NULL,
	[IdTipoCuentaAhorros] [int] NULL,
	[IdCliente] [int] NULL,
	[Saldo] [float] NULL,
	[FechaCreacion] [date] NULL,
	[modoInsercion] [nchar](100) NULL,
 CONSTRAINT [PK_CuentaAhorros] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaObjetivo]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaObjetivo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCuentaAhorro] [int] NULL,
	[FechaInicio] [date] NULL,
	[FechaFin] [date] NULL,
	[DiasRebajo] [int] NULL,
	[InteresesAcumulados] [float] NULL,
	[Saldo] [float] NULL,
	[TasaIntereses] [float] NULL,
	[Cuota] [float] NULL,
	[Objetivo] [nchar](100) NULL,
	[isActivo] [int] NULL,
	[depositos] [int] NULL,
	[depositosNoRealizados] [int] NULL,
	[CodigoCuenta] [int] NULL,
 CONSTRAINT [PK_CuentaObjetivo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatosXml]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatosXml](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nchar](100) NULL,
	[XML] [xml] NULL,
 CONSTRAINT [PK_DatosXml] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Errores]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Errores](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorID] [int] NULL,
	[userName] [varchar](500) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](500) NULL,
	[ErrorMessage] [varchar](500) NULL,
	[ErrorDataTime] [datetime] NULL,
 CONSTRAINT [PK_Errores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadoCuenta]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoCuenta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCuentaAhorro] [int] NULL,
	[FechaInicio] [date] NULL,
	[FechaFinal] [date] NULL,
	[SaldoInicial] [float] NULL,
	[SaldoFinal] [float] NULL,
	[SaldoMinimo] [float] NULL,
	[numRetirosAuto] [int] NULL,
	[numRetirosVentana] [int] NULL,
 CONSTRAINT [PK_EstadoCuenta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Eventos]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Eventos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idTipoEvento] [int] NULL,
	[idUser] [int] NULL,
	[IP] [int] NULL,
	[Fecha] [date] NULL,
	[XMLAntes] [xml] NULL,
	[XMLDespues] [xml] NULL,
	[insertAt] [varchar](50) NULL,
 CONSTRAINT [PK_Eventos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoCA]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoCA](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NULL,
	[Monto] [float] NULL,
	[NuevoSaldo] [float] NULL,
	[IdTipoMovimientoCA] [int] NULL,
	[IdCuentaAhorros] [int] NULL,
	[IdEstadoCuenta] [int] NULL,
	[Descripcion] [nchar](100) NULL,
 CONSTRAINT [PK_MovimientoCA] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoCO]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoCO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoMovimientoCo] [int] NULL,
	[IdCuentaObjetivo] [int] NULL,
	[Fecha] [date] NULL,
	[Monto] [float] NULL,
	[Descripcion] [varchar](100) NULL,
	[NuevoSaldo] [float] NULL,
 CONSTRAINT [PK_MovimientoCO] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[movimientosInteresCO]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[movimientosInteresCO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoMovimientoCoInte] [int] NULL,
	[IdCuentaObjetivo] [int] NULL,
	[Fecha] [date] NULL,
	[Monto] [float] NULL,
	[Descripcion] [varchar](100) NULL,
	[NuevoInteresesAcomulados] [float] NULL,
 CONSTRAINT [PK_MovimientoCOInte] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Parentezco]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parentezco](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
 CONSTRAINT [PK_Parentezco] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Persona]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persona](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nchar](100) NULL,
	[IdTipoDocumentoIdentidad] [int] NULL,
	[FechaNacimiento] [date] NULL,
	[Email] [nchar](100) NULL,
	[Telefono1] [int] NULL,
	[Telefono2] [int] NULL,
	[ValorDocumentoIdentidad] [int] NULL,
	[isActivo] [int] NULL,
	[FechaActivacion] [date] NULL,
	[MedioInsercion] [nchar](100) NULL,
 CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoCuentaAhorros]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoCuentaAhorros](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
	[IdTipoMoneda] [int] NULL,
	[SaldoMinimo] [float] NULL,
	[MultaSaldoMin] [float] NULL,
	[CargoAnual] [float] NULL,
	[NumRetirosHumano] [int] NULL,
	[NumRetirosAutomatico] [int] NULL,
	[ComisionHumano] [float] NULL,
	[ComisionAutomatico] [float] NULL,
	[Intereses] [float] NULL,
 CONSTRAINT [PK_TipoCuentaAhorros] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDocumentoIdentidad]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDocumentoIdentidad](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
 CONSTRAINT [PK_TipoDocumentoIdentidad] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoEvento]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoEvento](
	[id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
 CONSTRAINT [PK_TipoEvento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMoneda]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMoneda](
	[Id] [int] NOT NULL,
	[Tipo] [nchar](10) NULL,
	[Simbolo] [nchar](10) NULL,
 CONSTRAINT [PK_TipoMoneda] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoCA]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoCA](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
	[Tipo] [nchar](100) NULL,
 CONSTRAINT [PK_TipoMovimientoCA] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoCO]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoCO](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
 CONSTRAINT [PK_TipoMovimientoCO] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoCOInte]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoCOInte](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
 CONSTRAINT [PK_TipoMovimientoCOInte] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [varchar](100) NULL,
	[Contrasena] [nchar](100) NULL,
	[EsAdministrador] [int] NULL,
	[isActivo] [int] NULL,
	[inSesion] [int] NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario_Ver]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario_Ver](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [varchar](100) NULL,
	[NumeroCuenta] [int] NULL,
 CONSTRAINT [PK_Usuario_Ver] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Beneficiario]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiario_CuentaAhorros] FOREIGN KEY([IdCuentaAhorros])
REFERENCES [dbo].[CuentaAhorros] ([Id])
GO
ALTER TABLE [dbo].[Beneficiario] CHECK CONSTRAINT [FK_Beneficiario_CuentaAhorros]
GO
ALTER TABLE [dbo].[Beneficiario]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiario_Parentezco] FOREIGN KEY([IdParentezco])
REFERENCES [dbo].[Parentezco] ([Id])
GO
ALTER TABLE [dbo].[Beneficiario] CHECK CONSTRAINT [FK_Beneficiario_Parentezco]
GO
ALTER TABLE [dbo].[Beneficiario]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiario_Persona1] FOREIGN KEY([IdPersona])
REFERENCES [dbo].[Persona] ([Id])
GO
ALTER TABLE [dbo].[Beneficiario] CHECK CONSTRAINT [FK_Beneficiario_Persona1]
GO
ALTER TABLE [dbo].[CuentaAhorros]  WITH CHECK ADD  CONSTRAINT [FK_CuentaAhorros_Persona] FOREIGN KEY([IdCliente])
REFERENCES [dbo].[Persona] ([Id])
GO
ALTER TABLE [dbo].[CuentaAhorros] CHECK CONSTRAINT [FK_CuentaAhorros_Persona]
GO
ALTER TABLE [dbo].[CuentaAhorros]  WITH CHECK ADD  CONSTRAINT [FK_CuentaAhorros_TipoCuentaAhorros] FOREIGN KEY([IdTipoCuentaAhorros])
REFERENCES [dbo].[TipoCuentaAhorros] ([Id])
GO
ALTER TABLE [dbo].[CuentaAhorros] CHECK CONSTRAINT [FK_CuentaAhorros_TipoCuentaAhorros]
GO
ALTER TABLE [dbo].[CuentaObjetivo]  WITH CHECK ADD  CONSTRAINT [FK_CuentaObjetivo_CuentaAhorros] FOREIGN KEY([IdCuentaAhorro])
REFERENCES [dbo].[CuentaAhorros] ([Id])
GO
ALTER TABLE [dbo].[CuentaObjetivo] CHECK CONSTRAINT [FK_CuentaObjetivo_CuentaAhorros]
GO
ALTER TABLE [dbo].[EstadoCuenta]  WITH CHECK ADD  CONSTRAINT [FK_EstadoCuenta_CuentaAhorros] FOREIGN KEY([IdCuentaAhorro])
REFERENCES [dbo].[CuentaAhorros] ([Id])
GO
ALTER TABLE [dbo].[EstadoCuenta] CHECK CONSTRAINT [FK_EstadoCuenta_CuentaAhorros]
GO
ALTER TABLE [dbo].[Eventos]  WITH CHECK ADD  CONSTRAINT [FK_Eventos_TipoEvento] FOREIGN KEY([idTipoEvento])
REFERENCES [dbo].[TipoEvento] ([id])
GO
ALTER TABLE [dbo].[Eventos] CHECK CONSTRAINT [FK_Eventos_TipoEvento]
GO
ALTER TABLE [dbo].[Eventos]  WITH CHECK ADD  CONSTRAINT [FK_Eventos_Usuario] FOREIGN KEY([idUser])
REFERENCES [dbo].[Usuario] ([Id])
GO
ALTER TABLE [dbo].[Eventos] CHECK CONSTRAINT [FK_Eventos_Usuario]
GO
ALTER TABLE [dbo].[MovimientoCA]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCA_CuentaAhorros] FOREIGN KEY([IdCuentaAhorros])
REFERENCES [dbo].[CuentaAhorros] ([Id])
GO
ALTER TABLE [dbo].[MovimientoCA] CHECK CONSTRAINT [FK_MovimientoCA_CuentaAhorros]
GO
ALTER TABLE [dbo].[MovimientoCA]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCA_EstadoCuenta] FOREIGN KEY([IdEstadoCuenta])
REFERENCES [dbo].[EstadoCuenta] ([Id])
GO
ALTER TABLE [dbo].[MovimientoCA] CHECK CONSTRAINT [FK_MovimientoCA_EstadoCuenta]
GO
ALTER TABLE [dbo].[MovimientoCA]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCA_TipoMovimientoCA] FOREIGN KEY([IdTipoMovimientoCA])
REFERENCES [dbo].[TipoMovimientoCA] ([Id])
GO
ALTER TABLE [dbo].[MovimientoCA] CHECK CONSTRAINT [FK_MovimientoCA_TipoMovimientoCA]
GO
ALTER TABLE [dbo].[MovimientoCO]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCO_CuentaObjetivo] FOREIGN KEY([IdCuentaObjetivo])
REFERENCES [dbo].[CuentaObjetivo] ([Id])
GO
ALTER TABLE [dbo].[MovimientoCO] CHECK CONSTRAINT [FK_MovimientoCO_CuentaObjetivo]
GO
ALTER TABLE [dbo].[MovimientoCO]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCO_TipoMovimientoCO] FOREIGN KEY([IdTipoMovimientoCo])
REFERENCES [dbo].[TipoMovimientoCO] ([Id])
GO
ALTER TABLE [dbo].[MovimientoCO] CHECK CONSTRAINT [FK_MovimientoCO_TipoMovimientoCO]
GO
ALTER TABLE [dbo].[movimientosInteresCO]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCOInte_CuentaObjetivo] FOREIGN KEY([IdCuentaObjetivo])
REFERENCES [dbo].[CuentaObjetivo] ([Id])
GO
ALTER TABLE [dbo].[movimientosInteresCO] CHECK CONSTRAINT [FK_MovimientoCOInte_CuentaObjetivo]
GO
ALTER TABLE [dbo].[movimientosInteresCO]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCOInte_TipoMovimientoCOInte] FOREIGN KEY([IdTipoMovimientoCoInte])
REFERENCES [dbo].[TipoMovimientoCOInte] ([Id])
GO
ALTER TABLE [dbo].[movimientosInteresCO] CHECK CONSTRAINT [FK_MovimientoCOInte_TipoMovimientoCOInte]
GO
ALTER TABLE [dbo].[Persona]  WITH CHECK ADD  CONSTRAINT [FK_Persona_TipoDocumentoIdentidad] FOREIGN KEY([IdTipoDocumentoIdentidad])
REFERENCES [dbo].[TipoDocumentoIdentidad] ([Id])
GO
ALTER TABLE [dbo].[Persona] CHECK CONSTRAINT [FK_Persona_TipoDocumentoIdentidad]
GO
ALTER TABLE [dbo].[TipoCuentaAhorros]  WITH CHECK ADD  CONSTRAINT [FK_TipoCuentaAhorros_TipoMoneda] FOREIGN KEY([IdTipoMoneda])
REFERENCES [dbo].[TipoMoneda] ([Id])
GO
ALTER TABLE [dbo].[TipoCuentaAhorros] CHECK CONSTRAINT [FK_TipoCuentaAhorros_TipoMoneda]
GO
/****** Object:  StoredProcedure [dbo].[activarUsuario]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[activarUsuario]
@contrasena nchar(100),
@nombre nchar(100)

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		UPDATE Usuario
		SET inSesion = 0
		WHERE inSesion = 1

		UPDATE [Usuario]
		SET inSesion = 1
		WHERE  (Usuario=@nombre) and (Contrasena=@contrasena) and (isActivo=1)

		
	END TRY
	BEGIN CATCH


	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[borrarBeneficiario]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[borrarBeneficiario]

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
GO
/****** Object:  StoredProcedure [dbo].[borrarCuentaObjetivo]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[borrarCuentaObjetivo]

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
GO
/****** Object:  StoredProcedure [dbo].[buscarDescripcion]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[buscarDescripcion]
@valor nchar (100),
@numeroCuenta int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY

	DECLARE @idCuenta int
	SELECT @idCuenta= C.Id
	FROM CuentaAhorros C
	WHERE C.NumeroCuenta=@numeroCuenta

	DECLARE @idMov INT
	SELECT @idMov=M.IdTipoMovimientoCA
	FROM MovimientoCA M
	WHERE M.IdCuentaAhorros=@idCuenta

	DECLARE @movimiento nchar(100)
	SELECT @movimiento=T.Nombre
	FROM TipoMovimientoCA T
	WHERE T.Id=@idMov

	SELECT 
			[Fecha] ,
			Descripcion
			,[Monto] 
			,[NuevoSaldo]
			,@movimiento 
		FROM [dbo].[MovimientoCA] M
		WHERE M.Descripcion=@valor and M.IdCuentaAhorros=@idCuenta

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50007,
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

END
GO
/****** Object:  StoredProcedure [dbo].[calcularSaldoCuentaAhorro]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[calcularSaldoCuentaAhorro]

@idCuenta int,
@monto float,
@tipo int,
@nuevoSaldo float output


AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	DECLARE @saldoCuenta float
	DECLARE @tipoMov nchar(100)

	-----se ve si es un credito o debito
	SELECT @tipoMov=M.Tipo
	FROM TipoMovimientoCA M
	WHERE M.Id=@tipo

	SELECT @saldoCuenta=C.Saldo
	FROM CuentaAhorros C
	WHERE C.Id=@idCuenta
	
	IF @tipoMov='Debito'
		BEGIN
			SET @nuevoSaldo=@saldoCuenta-@monto
		END 
	ELSE
		BEGIN 
				
			SET @nuevoSaldo=@saldoCuenta+@monto
		END 

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50003,
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
GO
/****** Object:  StoredProcedure [dbo].[CargarTipoEventos]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargarTipoEventos]

AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
		--Primero se limpia la tabla
		DELETE dbo.TipoEvento
		--Se cargan los eventos de los beneficiarios
		EXEC dbo.insertarTipoEventos 1,"Insertar Beneficiarios"
		EXEC dbo.insertarTipoEventos 2,"Modificar Beneficiario"
		EXEC dbo.insertarTipoEventos 3,"Eliminar Beneficiario"
		--Se cargan los eventos de las cuenta objetivo
		EXEC dbo.insertarTipoEventos 4,"Insertar CO"
		EXEC dbo.insertarTipoEventos 5,"Modificar CO"
		EXEC dbo.insertarTipoEventos 6,"Eliminar CO"


	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[ConsultaBeneficiariosAdministrador]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConsultaBeneficiariosAdministrador]

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
GO
/****** Object:  StoredProcedure [dbo].[ConsultaCuentasMultadas]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConsultaCuentasMultadas]
	@dias INT
AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY
		DECLARE @idCuenta INT
		DECLARE @iteradorAux INT
		DECLARE @contadorAux INT
		DECLARE @fechaUltima DATE
		DECLARE @retirosPromedio INT
		DECLARE @longitudDatos INT
		DECLARE @doc xml
		DECLARE @cantRetiros INT
		DECLARE @consulta TABLE
			(cuenta INT,
			 promedio FLOAT,
			 fechaMayorCantRetiros DATE
			)
		SELECT @contadorAux = COUNT(Id) FROM CuentaAhorros 
		SET @iteradorAux=0
		SET @idCuenta=0

		--AQUI TOMA la ultima fecha
		SELECT @doc = DX.XML FROM DatosXml DX WHERE DX.Id = 6 

		SELECT @longitudDatos=COUNT(x.Rec.value('@Fecha','date'))
		FROM @doc.nodes('/Operaciones/FechaOperacion') AS x(Rec)

		SELECT @fechaUltima= x.Rec.value('@Fecha','date')
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@longitudDatos")]') AS x(Rec)
		
		--
		

		WHILE @iteradorAux<=@contadorAux
		BEGIN 
				--Toma una cuenta de la tabla de CuentaAhorro
				SELECT TOP 1 @idCuenta=CA.Id
				FROM DBO.CuentaAhorros CA
				WHERE CA.Id > @idCuenta

				--Cantidad de retiros para se multa
				SELECT @cantRetiros = tca.NumRetirosAutomatico 
				FROM dbo.TipoCuentaAhorros TCA 
				WHERE TCA.Id = (SELECT CA.IdTipoCuentaAhorros 
								FROM dbo.CuentaAhorros CA 
								WHERE CA.Id = @idCuenta)
				print (@cantRetiros)

				--si no ha sido procesada, tiene al menos una multa  y tiene mas de 5 retiros hace menos de @dias dias
				IF NOT EXISTS(SELECT CM.cuenta FROM @consulta CM WHERE CM.cuenta=@idCuenta) 
				AND (EXISTS (SELECT CA.NumeroCuenta  FROM dbo.CuentaAhorros CA INNER JOIN EstadoCuenta EC ON EC.IdCuentaAhorro=@idCuenta AND (EC.numRetirosAuto>4)))
				AND EXISTS(SELECT COUNT(M.ID) FROM dbo.MovimientoCA M WHERE M.Fecha > (SELECT DATEADD(DAY,@dias,@fechaUltima)) AND M.IdCuentaAhorros=@idCuenta)
				BEGIN
				
					--calculo el promedio de retiros por mes de esa cuenta
					SELECT @retirosPromedio=SUM(EC.numRetirosAuto) FROM dbo.EstadoCuenta EC WHERE EC.IdCuentaAhorro = @idCuenta
					SELECT @retirosPromedio = @retirosPromedio/(SELECT COUNT(EC.Id) FROM dbo.EstadoCuenta EC WHERE EC.IdCuentaAhorro = @idCuenta)
					

					--insertar datos en la varible tabla
					INSERT INTO @consulta(cuenta, promedio,fechaMayorCantRetiros)
					SELECT   (SELECT CA.NumeroCuenta FROM CuentaAhorros CA WHERE CA.Id = @idCuenta),
							 @retirosPromedio,
							(SELECT Top 1 EC.FechaInicio
							 FROM dbo.EstadoCuenta EC
							 WHERE EC.numRetirosAuto =  (SELECT MAX(EC.numRetirosAuto ) 
														FROM dbo.EstadoCuenta EC 
														WHERE EC.IdCuentaAhorro = @idCuenta))


				END
				SET @iteradorAux=@iteradorAux+1
		END
		SELECT C.cuenta,C.promedio,FORMAT(C.fechaMayorCantRetiros,'yyyy/MM') FROM @consulta C
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
GO
/****** Object:  StoredProcedure [dbo].[consultaCuentasObjetivo]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[consultaCuentasObjetivo]

AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

		SELECT C.CodigoCuenta,C.Id,C.Objetivo,C.depositos,C.depositos+C.depositosNoRealizados AS DepositosSiSeHubieranHecho  ,C.Saldo,C.Saldo+(C.depositosNoRealizados*C.Cuota) AS MontoSiSeHubieranHecho
		FROM DBO.CuentaObjetivo C
		WHERE C.depositosNoRealizados=0

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50021,
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

END
GO
/****** Object:  StoredProcedure [dbo].[ConsultarCantidadMovimientosEstado]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConsultarCantidadMovimientosEstado]
	
	@IdEstadoCuenta int,					
	@IdCuenta int

	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE @IddCuenta INT
		DECLARE @aux INT
		DECLARE @depositosATM INT
		DECLARE @depositosVentana INT 
		DECLARE @retirosATM INT
		DECLARE @retirosVentana INT
		DECLARE @montoInteres INT
		DECLARE @tipoCuenta INT
		DECLARE @table TABLE 
				(intereses INT,
				retirosATM INT,
				retirosVentana INT,
				depositosATM INT,
				depositosVentana INT
				)

		SELECT @IddCuenta = CA.Id
		FROM CuentaAhorros CA
		WHERE CA.NumeroCuenta=@IdCuenta

		SELECT @tipoCuenta=C.IdTipoCuentaAhorros
		FROM CuentaAhorros C
		WHERE C.Id=@iddCuenta

		SELECT @montoInteres=T.Intereses
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		SELECT @aux=T.SaldoMinimo
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		--SE SACA EL VALOR AL QUE CORRESPONDEN LOS INTERESES Y SE LE SUMA A LA CUENTA
		SET @aux=(@aux*@montoInteres)/100


		--Se calcula la cantidad de retiros
		SET @retirosATM = (SELECT COUNT(*) 
		FROM MovimientoCA MCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta and MCA.IdTipoMovimientoCA = 2
		)
		
		SET @retirosVentana = (SELECT COUNT(*) 
		FROM MovimientoCA MCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta and MCA.IdTipoMovimientoCA = 3
		)
		
		--Se calcula la cantidad de depositos
		
		SET @depositosATM = (SELECT  COUNT(*)
		FROM MovimientoCA MCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta 
			and MCA.IdTipoMovimientoCA = 4
		)
		SET @depositosVentana = (SELECT  COUNT(*)
		FROM MovimientoCA MCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta 
			and MCA.IdTipoMovimientoCA= 5 
		)
		
		INSERT INTO @table (intereses,retirosATM,retirosVentana,depositosATM,depositosVentana)
		SELECT @aux,@retirosATM,@retirosVentana,@depositosATM,@depositosVentana
		SELECT * FROM @table
		
	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50009,
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
GO
/****** Object:  StoredProcedure [dbo].[ConsultarEstadoCuenta]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConsultarEstadoCuenta]
	@Id int
	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		

		DECLARE @valor INT
		SELECT @valor = P.Id
		FROM dbo.CuentaAhorros P
		WHERE P.NumeroCuenta = @Id	--se toma el id de ese valor de documento

		SELECT TOP 8	ec.FechaInicio,
						ec.FechaFinal,
						ec.SaldoInicial, 
						ec.SaldoFinal,
						ec.Id
					
		FROM  [dbo].[EstadoCuenta] ec
		WHERE (ec.IdCuentaAhorro = @valor) 
		ORDER BY FechaInicio DESC --Se ordenan

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[hacerCierre]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hacerCierre]
    -- Parámetros del SP
@idEstado int,
@fecha date


AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
		DECLARE @idCuenta int
		DECLARE @montoInteres INT
		DECLARE @montoMultas int
		DECLARE @cantidadDeVeces int
		DECLARE @aux int
		DECLARE @saldoCuenta int
		DECLARE @tipoCuenta int
		DECLARE @saldoMinimo int
		-----SE SACA EL ID DE LA CUENTA DE AHORROS
		SELECT @idCuenta= C.IdCuentaAhorro
		FROM EstadoCuenta C
		WHERE C.Id=@idEstado

		----EN ESTA SECCION SE VAN A CALCULAR EL INTERES MENSUAL
		SELECT @tipoCuenta=C.IdTipoCuentaAhorros
		FROM CuentaAhorros C
		WHERE C.Id=@idCuenta

		SELECT @montoInteres=T.Intereses
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		SELECT @aux=T.SaldoMinimo
		FROM EstadoCuenta T
		WHERE T.Id=@idEstado
		----se saca el monto de los intereses y se le envia a aux
		SET @aux=((@aux*@montoInteres)/100)/12
		---se encuentra el nuevo monto de la cuenta de ahorro
		SELECT @saldoCuenta=C.Saldo
		FROM CuentaAhorros C
		WHERE C.Id=@idCuenta

		----SE LE CAMBIA EL VALOR AL SALDO
		SET @saldoCuenta=@aux+@saldoCuenta
		---se inserta crea el movimiento
		INSERT INTO [dbo].[MovimientoCA]
           ([Descripcion]
           ,[Fecha]
           ,[Monto]
           ,[NuevoSaldo]
           ,[IdTipoMovimientoCA]
           ,[IdCuentaAhorros]
           ,[IdEstadoCuenta])
     VALUES
           ('Interes',
           @fecha,
           @aux,
           @saldoCuenta,
           7,
           @idCuenta,
           @idEstado)


		----SE ACTUALIZA EL SALDO DE LA CUENTA

			UPDATE [dbo].[CuentaAhorros]
			SET
			  Saldo = @saldoCuenta
		 WHERE Id=@idCuenta


		-----FIN INTERES MENSUAL

		----SE CALCULAN LAS MULTAS POR CAJERO AUTOMATICO

		SELECT @cantidadDeVeces=E.numRetirosAuto
		FROM EstadoCuenta E
		WHERE E.Id=@idEstado

		SELECT @aux=T.NumRetirosAutomatico
		FROM TipoCuentaAhorros T
		WHERE T.Id=(SELECT C.IdTipoCuentaAhorros FROM CuentaAhorros C WHERE C.Id=@idCuenta)

		IF	@cantidadDeVeces>@aux
			BEGIN
				SELECT @montoMultas=T.ComisionAutomatico
				FROM TipoCuentaAhorros T
				WHERE T.Id=(SELECT C.IdTipoCuentaAhorros FROM CuentaAhorros C WHERE C.Id=@idCuenta)

				SET @montoMultas=(@cantidadDeVeces-@aux)*@montoMultas
				SET @saldoCuenta=@saldoCuenta-@montoMultas

				BEGIN TRAN
					INSERT INTO [dbo].[MovimientoCA]
						   ([Descripcion]
						   ,[Fecha]
						   ,[Monto]
						   ,[NuevoSaldo]
						   ,[IdTipoMovimientoCA]
						   ,[IdCuentaAhorros]
						   ,[IdEstadoCuenta])
					 VALUES
						   ('Multa por exeso de retiros en cajero automatico',
						   @fecha,
						   @montoMultas,
						   @saldoCuenta,
						   1,
						   @idCuenta,
						   @idEstado)
					----SE LE REBAJA A LA CUENTA EL VALOR CORRESPONDIENTE AL CARGO MENSUAL
						UPDATE [dbo].[CuentaAhorros]
							SET
							  Saldo = @saldoCuenta
						 WHERE Id=@idCuenta
				IF (@@Error<>0)
					ROLLBACK
				ELSE
					COMMIT TRAN

			END

		

		----FIN DE LAS MULTAS POR CAJERO
		----MULTAS POR VENTANILLA

		SELECT @cantidadDeVeces=E.numRetirosVentana
		FROM EstadoCuenta E
		WHERE Id=@idEstado

		SELECT @aux=T.NumRetirosHumano
		FROM TipoCuentaAhorros T
		WHERE T.Id=(SELECT C.IdTipoCuentaAhorros FROM CuentaAhorros C WHERE C.Id=@idCuenta)

		IF	@cantidadDeVeces>@aux
			BEGIN
				SELECT @montoMultas=T.ComisionHumano
				FROM TipoCuentaAhorros T
				WHERE T.Id=(SELECT C.IdTipoCuentaAhorros FROM CuentaAhorros C WHERE C.Id=@idCuenta)

				SET @montoMultas=(@cantidadDeVeces-@aux)*@montoMultas
				SET @saldoCuenta=@saldoCuenta-@montoMultas
				
				BEGIN TRAN 
					INSERT INTO [dbo].[MovimientoCA]
						   ([Descripcion]
						   ,[Fecha]
						   ,[Monto]
						   ,[NuevoSaldo]
						   ,[IdTipoMovimientoCA]
						   ,[IdCuentaAhorros]
						   ,[IdEstadoCuenta])
					 VALUES
						   ('Multa por exeso de retiros en ventanilla',
						   @fecha,
						   @montoMultas,
						   @saldoCuenta,
						   1,
						   @idCuenta,
						   @idEstado)
					----SE LE REBAJA A LA CUENTA EL VALOR CORRESPONDIENTE AL CARGO MENSUAL
						UPDATE [dbo].[CuentaAhorros]
							SET
							  Saldo = @saldoCuenta
						 WHERE Id=@idCuenta
				IF (@@Error<>0)
					ROLLBACK
				ELSE
					COMMIT TRAN
			END


		---FIN MULTAS POR VENTANILLA



		----SE REBAJA EL CARGO MENSUAL

		---SE ENCUENTRA EL VALOR DEL CARGO MENSUAL
		SELECT @aux=T.CargoAnual
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		---se le cambia el valor al saldo
		SET @saldoCuenta=@saldoCuenta-@aux

		----SE CREA EL MOVIMIENTO
		BEGIN TRAN 
			INSERT INTO [dbo].[MovimientoCA]
				   ([Descripcion]
				   ,[Fecha]
				   ,[Monto]
				   ,[NuevoSaldo]
				   ,[IdTipoMovimientoCA]
				   ,[IdCuentaAhorros]
				   ,[IdEstadoCuenta])
			 VALUES
				   ('Cargo mensual',
				   @fecha,
				   @aux,
				   @saldoCuenta,
				   1,
				   @idCuenta,
				   @idEstado)
			----SE LE REBAJA A LA CUENTA EL VALOR CORRESPONDIENTE AL CARGO MENSUAL
				UPDATE [dbo].[CuentaAhorros]
					SET
					  Saldo = @saldoCuenta
				 WHERE Id=@idCuenta
		IF (@@Error<>0)
			ROLLBACK
		ELSE
			COMMIT TRAN

	----SE  CALCULA LA MULTA POR SALDO MINIMO
	---SE VERIFICA EL SALDO MINIMO
	---se revisa el saldo minimo
	SELECT @saldoMinimo=E.SaldoMinimo FROM DBO.EstadoCuenta E WHERE E.Id=@idEstado
	IF @saldoMinimo>@saldoCuenta OR @saldoMinimo=0
		BEGIN
			UPDATE DBO.EstadoCuenta
			SET 
				[SaldoMinimo]=@saldoCuenta
			WHERE Id=@idEstado
		END


	---SE VE SI HAY MULTA
	SELECT @aux=T.SaldoMinimo
	FROM TipoCuentaAhorros T
	WHERE T.Id=@tipoCuenta

	SELECT @saldoMinimo=E.SaldoMinimo
	FROM dbo.EstadoCuenta E
	WHERE E.Id=@idEstado
	---DESPUES DE ENCONTRAR EL VALOR DEL SALDO MIN Y DEL SALDO DE LA CUENTA SE REALIZA UN IF PARA VERIFICAR SI SE LE DEBE DE REBAJAR
	IF @saldoCuenta<@aux
		BEGIN
			---se inserta el movimiento
			SELECT @aux= MultaSaldoMin 
			FROM TipoCuentaAhorros 
			WHERE Id=(SELECT IdTipoCuentaAhorros FROM CuentaAhorros WHERE Id=@idCuenta)

			SET @saldoCuenta=@saldoCuenta-@aux
			BEGIN TRAN 
				INSERT INTO [dbo].[MovimientoCA]
				   ([Descripcion]
				   ,[Fecha]
				   ,[Monto]
				   ,[NuevoSaldo]
				   ,[IdTipoMovimientoCA]
				   ,[IdCuentaAhorros]
				   ,[IdEstadoCuenta])
				 VALUES
					   ('saldo minimo',
					   @fecha,
					   @aux,
					   @saldoCuenta,
					   1,
					   @idCuenta,
					   @idEstado)


				UPDATE [dbo].[CuentaAhorros]
				SET
				  Saldo = @saldoCuenta
				WHERE Id=@idCuenta
			IF (@@Error<>0)
				ROLLBACK
			ELSE
				COMMIT TRAN
		END
		
		----SE GENERA EL NUEVO ESTADO DE CUENTA
	SELECT @aux= Saldo 
	FROM CuentaAhorros 
	WHERE Id=@idCuenta
	UPDATE [dbo].[EstadoCuenta]
		SET
		  [SaldoFinal] = @aux
	 WHERE Id=@idEstado
	 ---la nueva fecha de inicio va a ser la fecha final del anterior mas un dia
	DECLARE @fechaInicio date
	SELECT @fechaInicio=E.FechaFinal
	FROM EstadoCuenta E
	WHERE E.Id=@idEstado
	SET @fechaInicio=DATEADD(DAY, 1, @fechaInicio)

	----se calcula la fecha final
	DECLARE @fechaFinal DATETIME;
	SET @fechaFinal = DATEADD(MONTH, 1, @fechainicio);
	SET @fechaFinal = DATEADD(DAY, -1, @fechaFinal);

	--toma el saldoInicial de lo que acaba de insertar de la tabla inserted


	INSERT INTO EstadoCuenta(
				[IdCuentaAhorro],
				[FechaInicio],
				[FechaFinal],
				[SaldoInicial],
				[numRetirosAuto],
				[SaldoMinimo],
				[numRetirosVentana])
		VALUES (@idCuenta,@Fechainicio,@FechaFinal,@aux,0,@aux,0)

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50001,
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
GO
/****** Object:  StoredProcedure [dbo].[insertarBeneficiario]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarBeneficiario]

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
								   ,[modoInserccion]
								   ,[IdPersona])
								VALUES
								   (
									(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@IdCuentaAhorros ),
									@IdParentezco,
									@porcentaje,
									@valorDocumentoIdentidad,
									1,
									@Existingdate,
									'usuario',
									(SELECT Id FROM Persona WHERE ValorDocumentoIdentidad=@valorDocumentoIdentidad)
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
GO
/****** Object:  StoredProcedure [dbo].[insertarCatalogosSegundaProgra]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarCatalogosSegundaProgra]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
----Script de inserccion de catalogos, primero limpia las tablas y despues reinserta los catalogos desde el XML de datos ubicado en una tabla de la base de datos
	
	DELETE TipoMovimientoCA
	DELETE TipoCuentaAhorros
	DELETE TipoDocumentoIdentidad
	DELETE TipoMoneda
	DELETE Parentezco
	

		---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 1)
	--select * from DatosXml



	----INSERCCION DE CATALOGOS
	-------------------------------------------------------------------------------------------------------
	
	
	INSERT INTO DBO.Parentezco(Id,Nombre)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/Parentezcos/Parentezco') AS x(Rec)




-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoDocumentoIdentidad(Id,Nombre)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/Tipo_Doc/TipoDocuIdentidad') AS x(Rec)

-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoMoneda(Id,Tipo,Simbolo)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)'),
		x.Rec.value('@Simbolo[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/Tipo_Moneda/TipoMoneda') AS x(Rec)

-------------------------------------------------------------------------------------------------------

INSERT INTO DBO.TipoCuentaAhorros(Id,Nombre,IdTipoMoneda,SaldoMinimo,MultaSaldoMin,CargoAnual,NumRetirosHumano,NumRetirosAutomatico,ComisionHumano,ComisionAutomatico,Intereses)
	SELECT 
		x.Rec.value('@Id','int'),
		x.Rec.value('@Nombre','varchar(100)'),
		x.Rec.value('@IdTipoMoneda','int'),
		x.Rec.value('@SaldoMinimo','float'),
		x.Rec.value('@MultaSaldoMin','float'),
		x.Rec.value('@CargoMensual','float'),
		x.Rec.value('@NumRetiroHumano','int'),
		x.Rec.value('@NumRetirosAutomatico','int'),
		x.Rec.value('@ComisionHumano','float'),
		x.Rec.value('@ComisionAutomatico','float'),
		x.Rec.value('@Interes','float')
	FROM @doc.nodes('/Catalogos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro') AS x(Rec)

-------------------------------------------------------------------------------------------------------

INSERT INTO DBO.TipoMovimientoCA(Id,Nombre,Tipo)
	SELECT 
		x.Rec.value('@Id','int'),
		x.Rec.value('@Nombre','varchar(100)'),
		x.Rec.value('@Tipo','nchar(100)')
	FROM @doc.nodes('/Catalogos/Tipo_Movimientos/Tipo_Movimiento') AS x(Rec)


	
	END TRY
	BEGIN CATCH

		INSERT INTO [dbo].[Errores] VALUES(
		50004,
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

END
GO
/****** Object:  StoredProcedure [dbo].[insertarCatalogosTerceraProgra]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarCatalogosTerceraProgra]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
----Script de inserccion de catalogos, primero limpia las tablas y despues reinserta los catalogos desde el XML de datos ubicado en una tabla de la base de datos
	
	DELETE TipoMovimientoCA
	DELETE TipoCuentaAhorros
	DELETE TipoDocumentoIdentidad
	DELETE TipoMoneda
	DELETE Parentezco
	DELETE TipoMovimientoCO
	DELETE TipoEvento
	

		---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 5)
	--select * from DatosXml



	----INSERCCION DE CATALOGOS
	-------------------------------------------------------------------------------------------------------
	
	
	INSERT INTO DBO.Parentezco(Id,Nombre)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/Parentezcos/Parentezco') AS x(Rec)




-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoDocumentoIdentidad(Id,Nombre)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/TipoDoc/TipoDocuIdentidad') AS x(Rec)

-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoMoneda(Id,Tipo,Simbolo)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)'),
		x.Rec.value('@Simbolo[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/TipoMoneda/TipoMoneda') AS x(Rec)

-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoCuentaAhorros(Id,Nombre,IdTipoMoneda,SaldoMinimo,MultaSaldoMin,CargoAnual,NumRetirosHumano,NumRetirosAutomatico,ComisionHumano,ComisionAutomatico,Intereses)
		SELECT 
			x.Rec.value('@Id','int'),
			x.Rec.value('@Nombre','varchar(100)'),
			x.Rec.value('@IdTipoMoneda','int'),
			x.Rec.value('@SaldoMinimo','float'),
			x.Rec.value('@MultaSaldoMin','float'),
			x.Rec.value('@CargoMensual','float'),
			x.Rec.value('@NumRetiroHumano','int'),
			x.Rec.value('@NumRetirosAutomatico','int'),
			x.Rec.value('@ComisionHumano','float'),
			x.Rec.value('@ComisionAutomatico','float'),
			x.Rec.value('@Interes','float')
		FROM @doc.nodes('/Catalogos/Tipo_Cuenta_Ahorro/TipoCuentaAhorro') AS x(Rec)

-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoMovimientoCA(Id,Nombre,Tipo)
		SELECT 
			x.Rec.value('@Id','int'),
			x.Rec.value('@Nombre','varchar(100)'),
			x.Rec.value('@Tipo','nchar(100)')
		FROM @doc.nodes('/Catalogos/TipoMovimientos/TipoMovimiento') AS x(Rec)


------------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoMovimientoCO(Id,Nombre)
		SELECT 
			x.Rec.value('@Id','int'),
			x.Rec.value('@Nombre','varchar(100)')
		FROM @doc.nodes('/Catalogos/TiposMovimientoCuentaAhorro/Tipo_Movimiento') AS x(Rec)




----------------------------------------------------------------------------

	INSERT INTO DBO.TipoEvento(Id,Nombre)
		SELECT 
			x.Rec.value('@Id','int'),
			x.Rec.value('@Nombre','varchar(100)')
		FROM @doc.nodes('/Catalogos/TiposEvento/TipoEvento') AS x(Rec)

	
	END TRY
	BEGIN CATCH

		INSERT INTO [dbo].[Errores] VALUES(
		50004,
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

END
GO
/****** Object:  StoredProcedure [dbo].[insertarCuentaObjetivo]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarCuentaObjetivo]
    -- Parámetros del SP
    @CuentaAhorro int,
	@FechaFin date,
	@DiasRebajo int,
	@Cuota float,
	@Objetivo nchar(100)
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  

		--Se establece la fecha de inicio
		DECLARE @Existingdate DATETIME
		SET @Existingdate=GETDATE()
		SELECT CONVERT(VARCHAR,@Existingdate,3) as [DD/MM/YY]

		--Se establece el id del cuenta 
		DECLARE @IdCuentaAhorro int;
		-- Inicializacion
		 SELECT @IdCuentaAhorro=CA.Id
		 FROM dbo.CuentaAhorros CA
		 WHERE CA.[NumeroCuenta]=@CuentaAhorro

		INSERT INTO [dbo].[CuentaObjetivo]
				   ([IdCuentaAhorro]
				   ,[FechaInicio]
				   ,[FechaFin]
				   ,[DiasRebajo]
				   ,[Cuota]
				   ,[Objetivo]
				   ,[isActivo])
			 VALUES
				   (@IdCuentaAhorro
				   ,@Existingdate
				   ,@FechaFin
				   ,@DiasRebajo
				   ,@Cuota
				   ,@Objetivo
				   ,1)
   
	END TRY
	BEGIN CATCH
	END CATCH
SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[insertarPersona]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarPersona]
----SP PARA LA INSERCCION DE PERSONAS
    -- Parámetros del SP
	@IdTipoDocumentoIdentidad int,
    	@Nombre varchar(40),
	@ValorDocumentoIdentidad int,
	@FechaNacimiento date,
	@Email varchar(100),
	@Telefono1 int,
	@Telefono2 int



AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
	---SE DECLARA LA VARIABLE PARA REGISTRAR LA FECHA EN QUE SE INSERTO A LA PERSONA EN LA BASE DE DATOS
	----TAMBIEN SE REGISTRA EL MODO EN EL QUE SE INSERTO, SI FUE POR SCRIPT O SI FUE POR EL USUARIO
		DECLARE @Existingdate DATETIME
		SET @Existingdate=GETDATE()
		SELECT CONVERT(VARCHAR,@Existingdate,3) as [DD/MM/YY]

		INSERT INTO [dbo].[Persona]
				   (
				   [IdTipoDocumentoIdentidad]
				   ,[Nombre]
				   ,[ValorDocumentoIdentidad]
				   ,[FechaNacimiento]
				   ,[Email]
				   ,[Telefono1]
				   ,[Telefono2]
				   ,[isActivo]
				   ,[FechaActivacion]
				   ,[MedioInsercion])
			 VALUES
				   (@IdTipoDocumentoIdentidad
				   ,@Nombre
				   ,@ValorDocumentoIdentidad
				   ,@FechaNacimiento
				   ,@Email
				   ,@Telefono1
				   ,@Telefono2
				   ,1
				   ,@Existingdate
				   ,'usuario'
				   )

	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[insertarTipoEventos]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[insertarTipoEventos]
----SP PARA LA INSERCCION DE TipoEventos
    -- Parámetros del SP
	@Id INT,
	@Nombre NCHAR(100)



AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
		

		INSERT INTO [dbo].[TipoEvento]
				   (
				   [id],
				   [Nombre])
			 VALUES
				   (@Id
				   ,@Nombre
				   )

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50004,
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
GO
/****** Object:  StoredProcedure [dbo].[INSERTARXML]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[INSERTARXML]
@nombre nchar(100),
@datos xml

AS
BEGIN 
SET NOCOUNT ON 
	BEGIN TRY

		INSERT INTO [dbo].[DatosXml]
			   ([Nombre]
			   ,[XML])
		 VALUES
			   (@nombre
			   ,@datos)


	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[modificarBeneficiario]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[modificarBeneficiario]
	@NumCuenta int,
	@IdParentezco int,
	@valorDocumento int,
	@porcentaje int,
	@nombre nchar(100)

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY

			UPDATE [dbo].[Beneficiario]
			   SET [IdParentezco] = @IdParentezco
				  ,[valorDocumentoIdentidad] = @valorDocumento
				  ,[porcentaje]=@porcentaje
				WHERE (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@NumCuenta )) and (valorDocumentoIdentidad=@valorDocumento)

			UPDATE [dbo].[Persona]
			   SET [Nombre] = @nombre
				  
				WHERE (valorDocumentoIdentidad=@valorDocumento)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END
GO
/****** Object:  StoredProcedure [dbo].[modificarCuentaObjetivo]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[modificarCuentaObjetivo]

@ObjetivoNuevo nchar(100),
@ObjetivoViejo nchar(100),
@numeroCuenta int
AS
BEGIN    
	SET NOCOUNT ON;
	BEGIN TRY
		
		DECLARE @IdNumeroCuenta int 
		SELECT @IdNumeroCuenta = CA.Id
		FROM CuentaAhorros CA
		WHERE CA.NumeroCuenta=@numeroCuenta

		UPDATE [dbo].[CuentaObjetivo]
	    SET [Objetivo] = @ObjetivoNuevo
		WHERE Objetivo = @ObjetivoViejo and IdCuentaAhorro=@IdNumeroCuenta
		
	END TRY
	BEGIN CATCH

	END CATCH
    SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[procesarCO]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procesarCO]
----se procesan los intereses diarios
	@dia DATE
	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE @contadorAux int
		DECLARE @iteradorAux int
		DECLARE @idCuenta int
		DECLARE @cuota float
		DECLARE @idCuentaAhorro int
		DECLARE @saldo float
		DECLARE @montoIntereses float

		----en este segmento del codigo primero se va a sumar a la cuenta objetivo el monto mensual en caso de ser el dia correspondiente
		----mientras que a la cuenta de ahorros se le va a rebajar
		SELECT @contadorAux=COUNT(C.Id)
		FROM CuentaObjetivo C
		WHERE C.DiasRebajo=DAY(@dia)

		SET @iteradorAux=1
		SET @idCuenta=0
		WHILE @iteradorAux<=@contadorAux
			BEGIN 
				SELECT TOP 1 @idCuenta = C.Id
				FROM DBO.CuentaObjetivo C
				WHERE (C.Id > @idCuenta) AND (C.DiasRebajo=DAY(@dia))

				SELECT @saldo=C.Saldo,@cuota=V.Cuota
				FROM DBO.CuentaObjetivo V 
				INNER JOIN DBO.CuentaAhorros C ON C.Id=V.IdCuentaAhorro
				WHERE V.Id=@idCuenta

				IF(@saldo-@cuota)>=0
					BEGIN 
						SELECT @idCuentaAhorro=C.IdCuentaAhorro FROM DBO.CuentaObjetivo C WHERE C.Id=@idCuenta
						---primero se actualiza la cuenta de ahorros y se genera  el movimiento
						BEGIN TRY
							BEGIN TRAN
								UPDATE DBO.CuentaAhorros
								SET Saldo= Saldo-@cuota
								WHERE Id=@idCuentaAhorro

								INSERT INTO DBO.MovimientoCA(
									[Monto]
									,[Fecha]
									,[NuevoSaldo]
									,[IdTipoMovimientoCA]
									,[IdCuentaAhorros]
									,[IdEstadoCuenta]
									,[Descripcion]
									)
								VALUES(
									@cuota,
									@dia,
									(@saldo-@cuota),
									3,
									@idCuentaAhorro,
									(SELECT MAX(E.Id) FROM DBO.EstadoCuenta E WHERE E.IdCuentaAhorro=@idCuentaAhorro),
									'Debito por cuenta objetivo'
								)
							
						---Depues de actualizar la cuenta de ahorros, se le suma a la cuenta objetivo el monto que corresponde y se 
						---inserta el movimiento
								UPDATE DBO.CuentaObjetivo
								SET 
									Saldo=Saldo+@cuota,
									depositos=depositos+1
								WHERE Id=@idCuenta

								INSERT INTO DBO.MovimientoCO(
									IdTipoMovimientoCo,
									Fecha,
									Monto,
									Descripcion,
									IdCuentaObjetivo,
									NuevoSaldo)
								VALUES(
									1,
									@dia,
									@cuota,
									'Deposito mesual',
									@idCuenta,
									(SELECT C.Saldo FROM DBO.CuentaObjetivo C WHERE C.Id=@idCuenta)
									)
							COMMIT
						END TRY
						BEGIN CATCH 
							ROLLBACK
							INSERT INTO [dbo].[Errores] VALUES(
							50021,
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
					
					END
					ELSE
						BEGIN
							UPDATE DBO.CuentaObjetivo
							SET depositosNoRealizados=depositosNoRealizados+1
							WHERE Id=@idCuenta
						END 
			
				SET @iteradorAux=@iteradorAux+1
			END

		----en este segundo segmento se van a cerrar las cuentas las cuales se terminan en la fecha de proceso
		SELECT @contadorAux=COUNT(C.Id)
		FROM CuentaObjetivo C
		WHERE C.FechaFin=@dia

		SET @iteradorAux=1
		SET @idCuenta=0
		WHILE @iteradorAux<=@contadorAux
			BEGIN 
				SELECT TOP 1 @idCuenta = C.Id
				FROM DBO.CuentaObjetivo C
				WHERE (C.Id > @idCuenta) AND (C.FechaFin=@dia)
				
				SELECT @montoIntereses=V.InteresesAcumulados,@idCuentaAhorro=C.Id
				FROM DBO.CuentaObjetivo V 
				INNER JOIN DBO.CuentaAhorros C ON C.Id=V.IdCuentaAhorro
				WHERE V.Id=@idCuenta

				print(@idCuentaAhorro)

				BEGIN TRY
					BEGIN TRAN
					---En la primera parte de la transaccions e actualiza el saldo  de la cuenta objetivo y quedan los intereses acumulados en cero
						INSERT DBO.movimientosInteresCO(
							IdTipoMovimientoCoInte,
							IdCuentaObjetivo,
							Fecha,
							Monto,
							Descripcion,
							NuevoInteresesAcomulados)
						VALUES(
						1,
						@idCuenta,
						@dia,
						@montoIntereses,
						'Redencion de intereses',
						0)
						---despues de crear el movimiento de intereses, se procede a actualizar la cuenta objetivo
						UPDATE DBO.CuentaObjetivo
						SET 
							Saldo=Saldo+@montoIntereses,
							InteresesAcumulados=0
						WHERE Id=@idCuenta
					---se genera el movimiento
						INSERT MovimientoCO(
							IdTipoMovimientoCo,
							Fecha,
							Monto,
							Descripcion,
							IdCuentaObjetivo,
							NuevoSaldo)
						VALUES(
						2,
						@dia,
						@montoIntereses,
						'Redencion de intereses acumulados',
						@idCuenta,
						(SELECT C.Saldo FROM CuentaObjetivo C WHERE C.Id=@idCuenta))
						---en esta parte se redime el dinero de la cuenta objetivo a la cuenta de ahorro
						UPDATE DBO.CuentaAhorros
						SET 
							Saldo=Saldo+(SELECT C.Saldo FROM DBO.CuentaObjetivo C WHERE C.Id=@idCuenta)
						WHERE Id=@idCuentaAhorro

						INSERT INTO DBO.MovimientoCA(
									[Monto]
								   ,[Fecha]
								   ,[NuevoSaldo]
								   ,[IdTipoMovimientoCA]
								   ,[IdCuentaAhorros]
								   ,[IdEstadoCuenta]
								   ,[Descripcion]
								   )
								VALUES(
									(SELECT C.Saldo FROM DBO.CuentaObjetivo C WHERE C.Id=@idCuenta),
									@dia,
									(SELECT C.Saldo FROM DBO.CuentaAhorros C WHERE C.Id=@idCuentaAhorro),
									5,
									@idCuentaAhorro,
									(SELECT MAX(E.Id) FROM DBO.EstadoCuenta E WHERE E.IdCuentaAhorro=@idCuentaAhorro),
									'redencion CO')
					----se crea el movimiento de la cuenta objetico
						INSERT INTO MovimientoCO(
								IdTipoMovimientoCo,
								Fecha,
								Monto,
								Descripcion,
								IdCuentaObjetivo,
								NuevoSaldo)
							VALUES(
							3,
							@dia,
							(SELECT C.Saldo FROM CuentaObjetivo C WHERE C.Id=@idCuenta),
							'Redencion CO',
							@idCuenta,
							0)
						--- desactiva la cuenta objetivo y se pone el saldo en 0
						UPDATE DBO.CuentaObjetivo
						SET 
							Saldo=0,
							isActivo=0
						WHERE Id=@idCuenta
					COMMIT 
				END TRY
				BEGIN CATCH
					ROLLBACK
					INSERT INTO [dbo].[Errores] VALUES(
					50020,
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
				
				SET @iteradorAux=@iteradorAux+1
 
			END
		
	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50016,
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

GO
/****** Object:  StoredProcedure [dbo].[procesarInteresesDiarios]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procesarInteresesDiarios]
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
GO
/****** Object:  StoredProcedure [dbo].[scripInserccionDeDatos]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[scripInserccionDeDatos]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

	DELETE Beneficiario
	DELETE CuentaObjetivo
	DELETE MovimientoCA
	DELETE Usuario
	DELETE Usuario_Ver
	DELETE EstadoCuenta
	DELETE CuentaAhorros
	DELETE Persona

---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 2)
----Declaracion de variables necesarias dia es la fecha sobre la cual se esta insertando y longitudDatos es la cantidad de fechas que existen
	DECLARE  @dia date
	DECLARE @longitudDatos int
	DECLARE @iterador int

	
	
	DECLARE @idPersona int
	DECLARE @valorDoc int

	DECLARE @idCuenta int
	DECLARE @numeroCuenta int
	DECLARE @saldoMin int
	DECLARE @multaSaldo int
---contador e iterador que se van a usar
	DECLARE @contadorAux int
	DECLARE @iteradorAux int 


	DECLARE @idEstadoCuenta int
	DECLARE @saldo float
	DECLARE @monto float
	DECLARE @tipoMovimiento int



----Se le envia el valor a longitud
	SELECT @longitudDatos=COUNT(x.Rec.value('@Fecha','date'))
	FROM @doc.nodes('/Operaciones/FechaOperacion') AS x(Rec)
	SET @iterador=1

	WHILE @iterador<=@longitudDatos
	BEGIN
		SELECT @dia= x.Rec.value('@Fecha','date')
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]') AS x(Rec)
		
		-----Se revisa si se tiene que cerrar un estado de cuenta

		SELECT @contadorAux=COUNT(C.Id)
		FROM EstadoCuenta C
		WHERE C.FechaFinal=@dia

		SET @iteradorAux=1
		SET @idCuenta=0
		WHILE @iteradorAux<=@contadorAux
			BEGIN 
				SELECT TOP 1 @idCuenta = C.Id
				FROM EstadoCuenta C
				WHERE C.Id > @idCuenta AND C.FechaFinal=@dia
				 
				EXEC hacerCierre @idCuenta,@dia
				SET @iteradorAux=@iteradorAux+1
			END


		------inserccion de personas en ese dia

		INSERT INTO DBO.Persona(
		IdTipoDocumentoIdentidad,
		Nombre,
		ValorDocumentoIdentidad,
		FechaNacimiento,
		Email,
		telefono1,
		telefono2,
		isActivo,
		FechaActivacion,
		MedioInsercion)
		SELECT 
			x.Rec.value('@TipoDocuIdentidad','int'),
			x.Rec.value('@Nombre','varchar(40)'),
			x.Rec.value('@ValorDocumentoIdentidad','int'),
			x.Rec.value('@FechaNacimiento','date'),
			x.Rec.value('@Email','varchar(100)'),
			x.Rec.value('@Telefono1','int'),
			x.Rec.value('@Telefono2','int'),
			1,
			@dia,
			'Script'
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Persona') AS x(Rec)

		----fin de inserccion de personas

			----insercion cuentas


		SELECT @contadorAux=COUNT(x.Rec.value('@ValorDocumentoIdentidadDelCliente','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta') AS x(Rec)

		SET @iteradorAux=1

		WHILE @iteradorAux<=@contadorAux
		BEGIN
			---se obtiene el id del cliente

			Select @valorDoc =x.Rec.value('@ValorDocumentoIdentidadDelCliente','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

			Select @idPersona = P.Id
			FROM dbo.Persona P
			WHERE P.ValorDocumentoIdentidad = @valorDoc
			----comienza el insert


			INSERT INTO DBO.CuentaAhorros(
			NumeroCuenta,
			IdTipoCuentaAhorros,
			IdCliente,
			Saldo,
			FechaCreacion,
			modoInsercion)
			SELECT 
				x.Rec.value('@NumeroCuenta','int'),
				x.Rec.value('@TipoCuentaId','int'),
				@idPersona,
				0,
				@dia,
				'Script'
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1

		END
		----fin insercion cuentas


		-----insercion beneficiarios

		SET @iteradorAux=1
		SELECT @contadorAux= COUNT(x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario') AS x(Rec)

		WHILE @iteradorAux<=@contadorAux
		BEGIN
		
		----se consigue el valor de la llave de la persona que es el beneficiario
			SELECT @valorDoc =x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idPersona=P.Id 
			FROM Persona P
			WHERE P.ValorDocumentoIdentidad=@valorDoc

			----Se consige el id de la cuenta que se asocia al beneficiario
			SELECT @numeroCuenta = x.Rec.value('@NumeroCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta = C.Id
			FROM dbo.CuentaAhorros C
			WHERE C.NumeroCuenta = @numeroCuenta

			---------Se hace el insert

			INSERT INTO [dbo].[Beneficiario]
						   ([IdCuentaAhorros]
						   ,[IdParentezco]
						   ,[IdPersona]
						   ,[porcentaje]
						   ,[valorDocumentoIdentidad]
						   ,[isActivo]
						   ,fechaInserccion
						   ,modoInserccion)
			SELECT 
				@idCuenta,
				x.Rec.value('@ParentezcoId','int'),
				@idPersona,
				x.Rec.value('@Porcentaje','int'),
				@valorDoc,
				1,
				@dia,
				'script'
	
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1
		END
		----fin insercion beneficiarios

		-----insercion usuarios
		SET @iteradorAux=1
		SELECT @contadorAux= COUNT(x.Rec.value('@User','varchar(100)'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Usuario') AS x(Rec)

		WHILE @iteradorAux<=@contadorAux
		BEGIN

			INSERT INTO [dbo].[Usuario]
				(Usuario,
				Contrasena,
				isActivo,
				EsAdministrador,
				inSesion
				)
			SELECT 
				x.Rec.value('@User','varchar(100)'),
				x.Rec.value('@Pass','varchar(100)'),
				1,
				x.Rec.value('@EsAdministrador','int'),
				0
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Usuario[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1

		END



		----fin insercion usuarios

		----insercion usuariosVer

		SET @iteradorAux=1
		SELECT @contadorAux= COUNT(x.Rec.value('@User','varchar(100)'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/UsuarioPuedeVer') AS x(Rec)

			WHILE @iteradorAux<=@contadorAux
			BEGIN

			INSERT INTO [dbo].[Usuario_Ver]
				(Usuario,
				NumeroCuenta
				)
			SELECT 
				x.Rec.value('@User','varchar(100)'),
				x.Rec.value('@NumeroCuenta','int')
			
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/UsuarioPuedeVer[sql:variable("@iteradorAux")]') AS x(Rec)
			SET @iteradorAux=@iteradorAux+1

		END

		----fin insercion usuarios ver


		----insercion movimiento


		SELECT @contadorAux=COUNT(x.Rec.value('@CodigoCuenta','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos') AS x(Rec)

		SET @iteradorAux=1
		WHILE @iteradorAux<=@contadorAux
		BEGIN
		----Se consigue el id de la cuenta a la que se asocia

			SELECT @numeroCuenta = x.Rec.value('@CodigoCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta = C.Id
			FROM dbo.CuentaAhorros C
			WHERE C.NumeroCuenta = @numeroCuenta

		-----se consige el id del estado de cuenta correspondiente, va a conseguir el ultimo estado de cuenta al que se asocie el numero de cuenta

			SELECT @idEstadoCuenta = C.Id
			FROM dbo.EstadoCuenta C
			WHERE C.IdCuentaAhorro = @idCuenta


		---Se llama a un Sp que va a calcular el nuevo saldo
		
		SELECT @monto=x.Rec.value('@Monto','float')
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

		SELECT @tipoMovimiento=x.Rec.value('@Tipo','int')
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

		EXEC calcularSaldoCuentaAhorro @idCuenta, @monto, @tipoMovimiento,@nuevoSaldo=@saldo OUTPUT

		---Comienza la insercion

			INSERT INTO [dbo].[MovimientoCA]
			   ([Monto]
			   ,[Fecha]
			   ,[NuevoSaldo]
			   ,[IdTipoMovimientoCA]
			   ,[IdCuentaAhorros]
			   ,[IdEstadoCuenta]
			   ,[Descripcion])
			SELECT 
				@monto,
				@dia,
				@saldo,
				@tipoMovimiento,
				@idCuenta,
				@idEstadoCuenta,
				x.Rec.value('@Descripcion','nchar(100)')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			---UNA VEZ QUE EL MOVIMIENTO SE INSERTA CORRECTAMENTE, SE LE CAMBIA A LA CUENTA EL NUEVO SALDO
			UPDATE [dbo].[CuentaAhorros]
			   SET 
				  [Saldo] = @saldo
			 WHERE CuentaAhorros.Id=@idCuenta

			
			SET @iteradorAux=@iteradorAux+1
		END

		----fin insercion movimientos
		----En este punto se revisa si el saldo es menor al saldo minimo
		SELECT @saldoMin=T.SaldoMinimo
		FROM TipoCuentaAhorros T
		WHERE T.Id=(SELECT IdTipoCuentaAhorros FROM CuentaAhorros WHERE Id=@idCuenta)

		IF @saldo<@saldoMin
			BEGIN
				SELECT @multaSaldo=T.MultaSaldoMin 
				FROM TipoCuentaAhorros T
				WHERE T.Id=(SELECT IdTipoCuentaAhorros FROM CuentaAhorros WHERE Id=@idCuenta)
				IF @saldo-@multaSaldo>0
					BEGIN
						SET @saldo=@saldo-@multaSaldo
						
					END
					ELSE
						BEGIN
							SET @saldo=0
						END
					INSERT INTO [dbo].[MovimientoCA]
						   ([Descripcion]
						   ,[Fecha]
						   ,[Monto]
						   ,[NuevoSaldo]
						   ,[IdTipoMovimientoCA]
						   ,[IdCuentaAhorros]
						   ,[IdEstadoCuenta])
						 VALUES
							   ('saldo minimo',
							   @dia,
							   @multaSaldo,
							   @saldo,
							   1,
							   @idCuenta,
							   @idEstadoCuenta)


							UPDATE [dbo].[CuentaAhorros]
							SET
							  Saldo = @saldo
							WHERE Id=@idCuenta
				END

		SET @iterador=@iterador+1
	END


	END TRY
	BEGIN CATCH

		INSERT INTO [dbo].[Errores] VALUES(
		50005,
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

END
GO
/****** Object:  StoredProcedure [dbo].[scripInserccionDeDatosTerceraProgra]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[scripInserccionDeDatosTerceraProgra]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
	DELETE Eventos
	DELETE Beneficiario
	DELETE movimientosInteresCO
	DELETE MovimientoCO
	DELETE CuentaObjetivo
	DELETE MovimientoCA
	DELETE Usuario
	DELETE Usuario_Ver
	DELETE EstadoCuenta
	DELETE CuentaAhorros
	DELETE Persona
---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 6)
----Declaracion de variables necesarias dia es la fecha sobre la cual se esta insertando y longitudDatos es la cantidad de fechas que existen
	DECLARE  @dia varchar(100)
	DECLARE @longitudDatos int
	
	DECLARE @idPersona int
	DECLARE @valorDoc int

	DECLARE @idCuenta int
	DECLARE @numeroCuenta int
	DECLARE @saldoMin int
	DECLARE @multaSaldo int

	DECLARE @idEstadoCuenta int
	DECLARE @saldo float
	DECLARE @monto float
	DECLARE @tipoMovimiento int
	DECLARE @contadorAux int
	DECLARE @iteradorAux int
	DECLARE @dias date
	DECLARE @cantidadMeses int



----Se le envia el valor a longitud
	SELECT @longitudDatos=COUNT(x.Rec.value('@Fecha','date'))
	FROM @doc.nodes('/Operaciones/FechaOperacion') AS x(Rec)

	SELECT @dias= x.Rec.value('@Fecha','date')
	FROM @doc.nodes('/Operaciones/FechaOperacion[1]') AS x(Rec)
	

	WHILE @dias<=(SELECT x.Rec.value('@Fecha','date') FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@longitudDatos")]') AS x(Rec))
	BEGIN
		----lo primero que se hace es llamar a la funcion que calcula los intereses diarios de las cuentas objetivo
		EXEC procesarInteresesDiarios @dias
		---una vez que se calculan los nuevos intereses se procesan las cuentas objetivo y hace lo que se tenga que hacer en ese respectivo dia
		EXEC procesarCO @dias


		-----Se revisa si se tiene que cerrar un estado de cuenta
		SELECT @dia=CONVERT(varchar,@dias,110)
		SELECT @contadorAux=COUNT(C.Id)
		FROM EstadoCuenta C
		WHERE C.FechaFinal=@dia

		SET @iteradorAux=1
		SET @idCuenta=0
		WHILE @iteradorAux<=@contadorAux
			BEGIN 
				SELECT TOP 1 @idCuenta = C.Id
				FROM EstadoCuenta C
				WHERE C.Id > @idCuenta AND C.FechaFinal=@dia
				 
				EXEC hacerCierre @idCuenta,@dias
				SET @iteradorAux=@iteradorAux+1
			END


		------inserccion de personas en ese dia
		------inserccion de personas en ese dia

		INSERT INTO DBO.Persona(
		IdTipoDocumentoIdentidad,
		Nombre,
		ValorDocumentoIdentidad,
		FechaNacimiento,
		Email,
		telefono1,
		telefono2,
		isActivo,
		FechaActivacion,
		MedioInsercion)
		SELECT 
			x.Rec.value('@TipoDocuIdentidad','int'),
			x.Rec.value('@Nombre','varchar(40)'),
			x.Rec.value('@ValorDocumentoIdentidad','int'),
			x.Rec.value('@FechaNacimiento','date'),
			x.Rec.value('@Email','varchar(100)'),
			x.Rec.value('@Telefono1','int'),
			x.Rec.value('@Telefono2','int'),
			1,
			@dia,
			'Script'
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Persona') AS x(Rec)
		----fin de inserccion de personas
		
		----insercion de cuentas

		SELECT @contadorAux=COUNT(x.Rec.value('@ValorDocumentoIdentidadDelCliente','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Cuenta') AS x(Rec)

		SET @iteradorAux=1
		----este insert se hace iterando para que el trigger pueda funcionar  bien
		WHILE @iteradorAux<=@contadorAux
		BEGIN
			---se obtiene el id del cliente

			SELECT @valorDoc =x.Rec.value('@ValorDocumentoIdentidadDelCliente','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idPersona = P.Id
			FROM dbo.Persona P
			WHERE P.ValorDocumentoIdentidad = @valorDoc
			ORDER BY P.Id
			----comienza el insert


			INSERT INTO DBO.CuentaAhorros(
			NumeroCuenta,
			IdTipoCuentaAhorros,
			IdCliente,
			Saldo,
			FechaCreacion,
			modoInsercion)
			SELECT 
				x.Rec.value('@NumeroCuenta','int'),
				x.Rec.value('@TipoCuentaId','int'),
				@idPersona,
				0,
				@dia,
				'Script'
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1

		END


		---fin insercion cuentas
		---insercion beneficiarios

		SET @iteradorAux=1
		SELECT @contadorAux= COUNT(x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario') AS x(Rec)

		WHILE @iteradorAux<=@contadorAux
		BEGIN
		
		----se consigue el valor de la llave de la persona que es el beneficiario
			SELECT @valorDoc =x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idPersona=P.Id 
			FROM DBO.Persona P
			WHERE P.ValorDocumentoIdentidad=@valorDoc
			ORDER BY P.Id
			----Se consige el id de la cuenta que se asocia al beneficiario
			SELECT @numeroCuenta = x.Rec.value('@NumeroCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta = C.Id
			FROM DBO.CuentaAhorros C
			WHERE C.NumeroCuenta = @numeroCuenta
			ORDER BY C.Id
			---------Se hace el insert

			INSERT INTO [dbo].[Beneficiario]
						   ([IdCuentaAhorros]
						   ,[IdParentezco]
						   ,[IdPersona]
						   ,[porcentaje]
						   ,[valorDocumentoIdentidad]
						   ,[isActivo]
						   ,fechaInserccion
						   ,modoInserccion)
			SELECT 
				@idCuenta,
				x.Rec.value('@ParentezcoId','int'),
				@idPersona,
				x.Rec.value('@Porcentaje','int'),
				@valorDoc,
				1,
				@dia,
				'script'
	
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1
		END

		----fin insercion beneficiarios

		---INSERCION USUARIOS

		INSERT INTO DBO.Usuario
				(Usuario,
				Contrasena,
				isActivo,
				EsAdministrador,
				inSesion
				)
		SELECT 
			x.Rec.value('@User','varchar(100)'),
			x.Rec.value('@Pass','varchar(100)'),
			1,
			x.Rec.value('@EsAdministrador','int'),
			0
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Usuario') AS x(Rec)

		---FIN INSERCION USUARIOS

		----insercion usuariosVer

		INSERT INTO DBO.Usuario_Ver
			(Usuario,
			NumeroCuenta
			)
		SELECT 
			x.Rec.value('@User','varchar(100)'),
			x.Rec.value('@Cuenta','int')
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/UsuarioPuedeVer') AS x(Rec)

		----fin insercion usuarios ver
		----insercion de cuentas objetivo

		SELECT @contadorAux=COUNT(x.Rec.value('@NumeroCuentaPrimaria','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/CuentaAhorro') AS x(Rec)

		SET @iteradorAux=1
		WHILE @iteradorAux<=@contadorAux
		BEGIN
			SELECT @numeroCuenta = x.Rec.value('@NumeroCuentaPrimaria','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/CuentaAhorro[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta=C.Id 
			FROM CuentaAhorros C
			WHERE @numeroCuenta=C.NumeroCuenta
			ORDER BY C.Id

			---SE CALCULA A CUANTO CORRESPONDE LA TASA DE INTERESES
			SELECT @cantidadMeses=DATEDIFF(MONTH,@dias,x.Rec.value('@FechaFinal','date'))
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/CuentaAhorro[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @monto=(@cantidadMeses*0.5)/365
			
			---SE INSERTA LA CUENTA OBJETIVO
			INSERT INTO [dbo].[CuentaObjetivo]
			   ([IdCuentaAhorro]
			   ,[FechaInicio]
			   ,[FechaFin]
			   ,[DiasRebajo]
			   ,[InteresesAcumulados]
			   ,[Saldo]
			   ,[TasaIntereses]
			   ,[Cuota]
			   ,[Objetivo]
			   ,[isActivo]
			   ,[depositos]
			   ,[depositosNoRealizados]
			   ,[codigoCuenta])
			SELECT
			    @idCuenta
			   ,@dias
			   ,x.Rec.value('@FechaFinal','date')
			   ,x.Rec.value('@DiaAhorro','int')
			   ,0
			   ,0
			   ,@monto
			   ,x.Rec.value('@MontoAhorro','float')
			   ,x.Rec.value('@Descripcion','varchar(100)')
			   ,1
			   ,0
			   ,0
			   ,x.Rec.value('@NumeroCuentaAhorro','varchar(100)')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/CuentaAhorro[sql:variable("@iteradorAux")]') AS x(Rec)
			SET @iteradorAux=@iteradorAux+1
		END

		-----fin insercion
		


		----insercion movimiento


		SELECT @contadorAux=COUNT(x.Rec.value('@CodigoCuenta','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos') AS x(Rec)

		SET @iteradorAux=1
		WHILE @iteradorAux<=@contadorAux
		BEGIN
		----Se consigue el id de la cuenta a la que se asocia

			SELECT @numeroCuenta = x.Rec.value('@CodigoCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)


		-----se consige el id del estado de cuenta correspondiente, va a conseguir el ultimo estado de cuenta al que se asocie el numero de cuenta

			SELECT @idCuenta=C.Id, @idEstadoCuenta = E.Id
			FROM DBO.CuentaAhorros C
			INNER JOIN DBO.EstadoCuenta E ON E.IdCuentaAhorro=C.Id
			WHERE C.NumeroCuenta = @numeroCuenta
			ORDER BY C.Id



		---Se llama a un Sp que va a calcular el nuevo saldo
		
			SELECT @monto=x.Rec.value('@Monto','float')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @tipoMovimiento=x.Rec.value('@Tipo','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			EXEC calcularSaldoCuentaAhorro @idCuenta, @monto, @tipoMovimiento,@nuevoSaldo=@saldo OUTPUT

			---Comienza la insercion
			BEGIN TRAN 
				INSERT INTO DBO.MovimientoCA
				   ([Monto]
				   ,[Fecha]
				   ,[NuevoSaldo]
				   ,[IdTipoMovimientoCA]
				   ,[IdCuentaAhorros]
				   ,[IdEstadoCuenta]
				   ,[Descripcion])
				SELECT 
					@monto,
					@dia,
					@saldo,
					@tipoMovimiento,
					@idCuenta,
					@idEstadoCuenta,
					x.Rec.value('@Descripcion','nchar(100)')
				FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

				---UNA VEZ QUE EL MOVIMIENTO SE INSERTA CORRECTAMENTE, SE LE CAMBIA A LA CUENTA EL NUEVO SALDO
				UPDATE DBO.CuentaAhorros
				   SET 
					  [Saldo] = @saldo
				WHERE CuentaAhorros.Id=@idCuenta
			IF (@@Error<>0)
				ROLLBACK
			ELSE
				COMMIT TRAN

				------Se revisa si se le debe sumar al numero de retiros ventana o atm

				IF @tipoMovimiento=2
					BEGIN 
						BEGIN TRAN 
							UPDATE DBO.EstadoCuenta
								SET [numRetirosAuto]=numRetirosAuto+1
							WHERE Id=@idEstadoCuenta
						IF (@@Error<>0)
							ROLLBACK
						ELSE
							COMMIT TRAN

					END

				IF @tipoMovimiento=3
					BEGIN 
						BEGIN TRAN 
							UPDATE DBO.EstadoCuenta
								SET [numRetirosVentana]=numRetirosVentana+1
							WHERE Id=@idEstadoCuenta
						IF (@@Error<>0)
							ROLLBACK
						ELSE
							COMMIT TRAN

					END

				---se revisa el saldo minimo
			SELECT @saldoMin=E.SaldoMinimo FROM DBO.EstadoCuenta E WHERE E.Id=@idEstadoCuenta
			IF @saldoMin>@saldo OR @saldoMin=0
				BEGIN
					UPDATE DBO.EstadoCuenta
					SET 
						[SaldoMinimo]=@saldo
					WHERE Id=@idEstadoCuenta
				END


			SET @iteradorAux=@iteradorAux+1
		END


		----fin insercion movimientos

		SELECT @dias= DATEADD(DAY,1,@dias)
	END
		

	END TRY
	BEGIN CATCH

		INSERT INTO [dbo].[Errores] VALUES(
		50005,
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

END
GO
/****** Object:  StoredProcedure [dbo].[sp_alterdiagram]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_alterdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_creatediagram]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_creatediagram]
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdiagram]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_dropdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagramdefinition]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagramdefinition]
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagrams]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagrams]
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_renamediagram]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_renamediagram]
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_upgraddiagrams]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_upgraddiagrams]
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO
/****** Object:  StoredProcedure [dbo].[verBeneficiarioPersona]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verBeneficiarioPersona]
@cuenta int
----Script para ver los datos del beneficiario y los datos de la persona que está vinculada por el valor del documento al beneficiario
AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		DECLARE @idCuenta int
		SELECT @idCuenta= Id FROM CuentaAhorros WHERE NumeroCuenta=@cuenta

		SELECT b.valorDocumentoIdentidad, b.porcentaje,p.Nombre,pe.Nombre,pe.FechaNacimiento,doc.Nombre,pe.Email,pe.Telefono1,pe.Telefono2
		FROM [dbo].[Beneficiario] b, Parentezco p,Persona pe,TipoDocumentoIdentidad Doc
		WHERE (b.IdCuentaAhorros=@idCuenta) AND (p.Id=b.IdParentezco) AND (b.isActivo=1) AND (pe.ValorDocumentoIdentidad=b.valorDocumentoIdentidad) AND (doc.Id=pe.IdTipoDocumentoIdentidad)
	END TRY
	BEGIN CATCH
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[verCuentaObjetivo]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verCuentaObjetivo]
	@cuentaAhorros int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		DECLARE @IdCuentaAhorro int
		SELECT @IdCuentaAhorro = CA.Id
		FROM CuentaAhorros CA
		WHERE CA.NumeroCuenta=@cuentaAhorros

		SELECT CO.FechaInicio
		  ,CO.FechaFin
		  ,CO.DiasRebajo
		  ,CO.Cuota
		  ,CO.Objetivo
	  FROM [dbo].[CuentaObjetivo] CO
	  WHERE CO.IdCuentaAhorro=@IdCuentaAhorro and CO.isActivo=1
	

	END TRY
	BEGIN CATCH

	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[verEstadoCuenta]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verEstadoCuenta]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


	SELECT [Id]
			,[IdCuentaAhorro]
			,[FechaInicio] 
			,[FechaFinal]
			,[SaldoInicial] 
			,[SaldoFinal]
		FROM [dbo].[EstadoCuenta]
		WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[verMovimientosCAdeEstadoCuenta]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verMovimientosCAdeEstadoCuenta]
	@IdEstadoCuenta int
	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		

		SELECT 	MCA.Fecha,
				MCA.Descripcion,
				TMCA.Tipo,
				MCA.Monto, 
				MCA.NuevoSaldo
					
		FROM  [dbo].[MovimientoCA] MCA, [dbo].[TipoMovimientoCA] TMCA
		WHERE (MCA.IdEstadoCuenta = @IdEstadoCuenta) and TMCA.Id = MCA.IdTipoMovimientoCA
		ORDER BY Fecha DESC --Se ordenan
		

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50006,
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
GO
/****** Object:  StoredProcedure [dbo].[verPersona]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verPersona]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


	SELECT [Id]
      ,[Nombre]
      ,[IdTipoDocumentoIdentidad]
      ,[FechaNacimiento]
      ,[Email]
      ,[Telefono1]
      ,[Telefono2]
  FROM [dbo].[Persona]
  WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[verPorcentaje]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verPorcentaje]

	---Sp para ver la suma de porcentajes de beneficiarios en una cuenta
	@IdCuentaAhorros int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
			

			SELECT SUM(porcentaje)
			FROM Beneficiario 
			WHERE (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@IdCuentaAhorros )) and (isActivo=1)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END
GO
/****** Object:  StoredProcedure [dbo].[verPorcentajeSinContarBene]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verPorcentajeSinContarBene]

	
	@IdCuentaAhorros int,
	@valorDoc int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
			SELECT SUM(porcentaje)
			FROM Beneficiario 
			WHERE (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@IdCuentaAhorros )) and (isActivo=1) and (valorDocumentoIdentidad!=@valorDoc)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END
GO
/****** Object:  StoredProcedure [dbo].[verTipoDocumentoIdentidad]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verTipoDocumentoIdentidad]
    -- Parámetros del SP
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  


		SELECT * FROM TipoDocumentoIdentidad

	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[verUsuario]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verUsuario]
@contrasena nchar(100),
@nombre nchar(100)

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		


		SELECT [Usuario]
			,[Contrasena]
			,[EsAdministrador]
		FROM [dbo].[Usuario]
		WHERE (Usuario=@nombre) and (Contrasena=@contrasena) and (isActivo=1)
		
		
	END TRY
	BEGIN CATCH


	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[verUsuarioVer]    Script Date: 22/12/2020 21:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verUsuarioVer]
@usuario nchar(100)

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY

		SELECT [NumeroCuenta]
		FROM [dbo].[Usuario_Ver]
		WHERE Usuario=@usuario

	END TRY
	BEGIN CATCH


	END CATCH

END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tal vez CA es cuenta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MovimientoCA'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sysdiagrams'
GO
ALTER DATABASE [Bases de datos] SET  READ_WRITE 
GO
