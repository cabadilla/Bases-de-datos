/****** Object:  Table [dbo].[Beneficiario]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Beneficiario](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
	[IdCliente] [int] NULL,
	[IdCuentaAhorros] [int] NULL,
	[IdParentezco] [int] NULL,
	[FechaNacimiento] [date] NULL,
	[IdTipoDocumento] [int] NULL,
 CONSTRAINT [PK_Beneficiario] PRIMARY KEY CLUSTERED 
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
ALTER TABLE [dbo].[Beneficiario]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiario_Persona] FOREIGN KEY([IdCliente])
REFERENCES [dbo].[Persona] ([Id])
GO
ALTER TABLE [dbo].[Beneficiario] CHECK CONSTRAINT [FK_Beneficiario_Persona]
GO
ALTER TABLE [dbo].[Beneficiario]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiario_TipoDocumentoIdentidad] FOREIGN KEY([IdTipoDocumento])
REFERENCES [dbo].[TipoDocumentoIdentidad] ([Id])
GO
ALTER TABLE [dbo].[Beneficiario] CHECK CONSTRAINT [FK_Beneficiario_TipoDocumentoIdentidad]
GO
