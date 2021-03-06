/****** Object:  Table [dbo].[EstadoCuenta]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoCuenta](
	[Id] [int] NOT NULL,
	[IdCuentaAhorro] [int] NULL,
	[FechaInicio] [date] NULL,
	[FechaFinal] [date] NULL,
	[SaldoInicial] [float] NULL,
	[SaldoFinal] [float] NULL,
 CONSTRAINT [PK_EstadoCuenta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoCuenta]  WITH CHECK ADD  CONSTRAINT [FK_EstadoCuenta_CuentaAhorros] FOREIGN KEY([IdCuentaAhorro])
REFERENCES [dbo].[CuentaAhorros] ([Id])
GO
ALTER TABLE [dbo].[EstadoCuenta] CHECK CONSTRAINT [FK_EstadoCuenta_CuentaAhorros]
GO
