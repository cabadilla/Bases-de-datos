/****** Object:  Table [dbo].[Parentezco]    Script Date: 14/10/2020 22:22:27 ******/
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
