/****** Object:  Table [dbo].[MovimientoCA]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoCA](
	[Id] [int] NOT NULL,
	[Fecha] [date] NULL,
	[Monto] [float] NULL,
	[NuevoSaldo] [float] NULL,
	[IdTipoMovimientoCA] [int] NULL,
	[IdCuentaAhorros] [int] NULL,
	[IdEstadoCuenta] [int] NULL,
 CONSTRAINT [PK_MovimientoCA] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tal vez CA es cuenta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MovimientoCA'
GO
