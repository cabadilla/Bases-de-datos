ALTER PROCEDURE modificarPersona
@Id int
,@Nombre varchar(100)
,@IdTipoDcumentoIdentidad int
,@FechaNacimiento date
,@Email nchar(100)
,@Telefono1 int
,@Telefono2 int


AS
BEGIN    
	SET NOCOUNT ON;
	BEGIN TRY

		UPDATE [dbo].[Persona]
		SET	   [Nombre] =@Nombre
			  ,[IdTipoDcumentoIdentidad] = @IdTipoDcumentoIdentidad
			  ,[FechaNacimiento] = @FechaNacimiento
			  ,[Email] = @Email
			  ,[Telefono1] = @Telefono1
			  ,[Telefono2] = @Telefono2

		WHERE Id=@Id
		
	END TRY
	BEGIN CATCH

	END CATCH
    SET NOCOUNT OFF;
END

