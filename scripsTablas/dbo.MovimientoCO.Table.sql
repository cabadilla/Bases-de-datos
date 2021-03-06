/****** Object:  Table [dbo].[MovimientoCO]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoCO](
	[Id] [int] NOT NULL,
	[IdTipoMovimientoCo] [int] NULL,
	[IdCuentaObjetivo] [int] NULL,
	[Fecha] [date] NULL,
	[Monto] [float] NULL,
 CONSTRAINT [PK_MovimientoCO] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
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
