/****** Object:  Table [dbo].[MovimientoCOInte]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoCOInte](
	[Id] [int] NOT NULL,
	[IdTipoMovimientoCoInte] [int] NULL,
	[IdCuentaObjetivo] [int] NULL,
	[Fecha] [date] NULL,
	[Monto] [float] NULL,
 CONSTRAINT [PK_MovimientoCOInte] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MovimientoCOInte]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCOInte_CuentaObjetivo] FOREIGN KEY([IdCuentaObjetivo])
REFERENCES [dbo].[CuentaObjetivo] ([Id])
GO
ALTER TABLE [dbo].[MovimientoCOInte] CHECK CONSTRAINT [FK_MovimientoCOInte_CuentaObjetivo]
GO
ALTER TABLE [dbo].[MovimientoCOInte]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCOInte_TipoMovimientoCOInte] FOREIGN KEY([IdTipoMovimientoCoInte])
REFERENCES [dbo].[TipoMovimientoCOInte] ([Id])
GO
ALTER TABLE [dbo].[MovimientoCOInte] CHECK CONSTRAINT [FK_MovimientoCOInte_TipoMovimientoCOInte]
GO
