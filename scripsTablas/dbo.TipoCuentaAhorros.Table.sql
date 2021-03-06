/****** Object:  Table [dbo].[TipoCuentaAhorros]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoCuentaAhorros](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
	[TasaIntereses] [float] NULL,
	[Multa] [float] NULL,
	[IdTipoMoneda] [int] NULL,
	[SaldoMinimo] [float] NULL,
	[MultaSaldoMin] [float] NULL,
	[CargoAnual] [float] NULL,
	[NumRetirosAnual] [int] NULL,
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
ALTER TABLE [dbo].[TipoCuentaAhorros]  WITH CHECK ADD  CONSTRAINT [FK_TipoCuentaAhorros_TipoMoneda] FOREIGN KEY([IdTipoMoneda])
REFERENCES [dbo].[TipoMoneda] ([Id])
GO
ALTER TABLE [dbo].[TipoCuentaAhorros] CHECK CONSTRAINT [FK_TipoCuentaAhorros_TipoMoneda]
GO
