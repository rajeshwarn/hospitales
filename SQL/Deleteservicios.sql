--***********************************************************
--DELETE Stored Procedure for servicios table
--***********************************************************
GO

USE hospital
GO

IF EXISTS (SELECT sys.objects.name FROM sys.objects INNER JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id WHERE sys.objects.name = 'serviciosDelete'    and sys.objects.type = 'P') 
DROP PROCEDURE [serviciosDelete] 
GO

CREATE PROCEDURE [serviciosDelete]
      @OldId_servicio int
     ,@OldNombre_servicio nvarchar(50)
     ,@ReturnValue int OUTPUT
AS
BEGIN

SET NOCOUNT ON

BEGIN TRANSACTION 

BEGIN TRY 

DELETE FROM [servicios]
WHERE
     [Id_servicio] = @OldId_servicio
AND ((@OldNombre_servicio IS NULL AND [Nombre_servicio] IS NULL) OR [Nombre_servicio] = @OldNombre_servicio)

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

GRANT EXECUTE ON [serviciosDelete] TO [Public]
GO
 
