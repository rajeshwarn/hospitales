--***********************************************************
--UPDATE Stored Procedure for historia_clinica table
--***********************************************************
GO

USE hospital
GO

IF EXISTS (SELECT sys.objects.name FROM sys.objects INNER JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id WHERE sys.objects.name = 'historia_clinicaUpdate'    and sys.objects.type = 'P') 
DROP PROCEDURE [historia_clinicaUpdate]
GO

CREATE PROCEDURE [historia_clinicaUpdate] 
      @NewCedula nvarchar(50)
     ,@NewApellido nvarchar(50)
     ,@NewNombre nvarchar(50)
     ,@NewFecha_nacim date
     ,@NewNum_seguridad_social nvarchar(50)
     ,@Oldid_historia int
     ,@OldCedula nvarchar(50)
     ,@OldApellido nvarchar(50)
     ,@OldNombre nvarchar(50)
     ,@OldFecha_nacim date
     ,@OldNum_seguridad_social nvarchar(50)
     ,@ReturnValue int OUTPUT
AS
BEGIN

SET NOCOUNT ON

BEGIN TRANSACTION 

BEGIN TRY 

UPDATE [historia_clinica]
SET
      [Cedula] = @NewCedula
     ,[Apellido] = @NewApellido
     ,[Nombre] = @NewNombre
     ,[Fecha_nacim] = @NewFecha_nacim
     ,[Num_seguridad_social] = @NewNum_seguridad_social
WHERE
     [id_historia] = @Oldid_historia
AND ((@OldCedula IS NULL AND [Cedula] IS NULL) OR [Cedula] = @OldCedula)
AND ((@OldApellido IS NULL AND [Apellido] IS NULL) OR [Apellido] = @OldApellido)
AND ((@OldNombre IS NULL AND [Nombre] IS NULL) OR [Nombre] = @OldNombre)
AND ((@OldFecha_nacim IS NULL AND [Fecha_nacim] IS NULL) OR [Fecha_nacim] = @OldFecha_nacim)
AND ((@OldNum_seguridad_social IS NULL AND [Num_seguridad_social] IS NULL) OR [Num_seguridad_social] = @OldNum_seguridad_social)

IF @@ROWCOUNT = 0
BEGIN
     ROLLBACK TRANSACTION
     SET @ReturnValue = 0
     RETURN @ReturnValue
END
ELSE
BEGIN
     COMMIT TRANSACTION
     SET @ReturnValue = 1
     RETURN @ReturnValue
END

END TRY

BEGIN CATCH
     DECLARE @Error_Message varchar(150)
     SET @Error_Message = ERROR_NUMBER() + ' ' + ERROR_MESSAGE()
     ROLLBACK TRANSACTION
     RAISERROR(@Error_Message,16,1)
      SET @ReturnValue = -1
      RETURN @ReturnValue
END CATCH

END
GO

GRANT EXECUTE ON [historia_clinicaUpdate] TO [Public]
GO
 
