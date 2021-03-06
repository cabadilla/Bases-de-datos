/****** Object:  Table [dbo].[Usuario_Ver]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario_Ver](
	[Id] [int] NOT NULL,
	[IdUsuario] [int] NULL,
	[NumeroCuenta] [int] NULL,
 CONSTRAINT [PK_Usuario_Ver] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Usuario_Ver]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Ver_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([Id])
GO
ALTER TABLE [dbo].[Usuario_Ver] CHECK CONSTRAINT [FK_Usuario_Ver_Usuario]
GO
