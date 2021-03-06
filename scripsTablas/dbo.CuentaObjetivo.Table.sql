/****** Object:  Table [dbo].[CuentaObjetivo]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaObjetivo](
	[Id] [int] NOT NULL,
	[IdCuentaAhorro] [int] NULL,
	[FechaInicio] [date] NULL,
	[FechaFin] [date] NULL,
	[DiasRebajo] [date] NULL,
	[Cuota] [float] NULL,
	[Objetivo] [nchar](100) NULL,
 CONSTRAINT [PK_CuentaObjetivo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CuentaObjetivo]  WITH CHECK ADD  CONSTRAINT [FK_CuentaObjetivo_CuentaAhorros] FOREIGN KEY([IdCuentaAhorro])
REFERENCES [dbo].[CuentaAhorros] ([Id])
GO
ALTER TABLE [dbo].[CuentaObjetivo] CHECK CONSTRAINT [FK_CuentaObjetivo_CuentaAhorros]
GO
