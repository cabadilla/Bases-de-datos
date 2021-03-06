/****** Object:  Table [dbo].[Persona]    Script Date: 14/10/2020 22:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persona](
	[Id] [int] NOT NULL,
	[Nombre] [nchar](100) NULL,
	[IdTipoDcumentoIdentidad] [int] NULL,
	[FechaNacimiento] [date] NULL,
	[Email] [nchar](100) NULL,
	[Telefono1] [int] NULL,
	[Telefono2] [int] NULL,
 CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
