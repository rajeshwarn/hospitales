--***********************************************************
--DELETE Stored Procedure for ingresos table
--***********************************************************
GO

USE hospital
GO

IF EXISTS (SELECT sys.objects.name FROM sys.objects INNER JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id WHERE sys.objects.name = 'ingresosDelete'    and sys.objects.type = 'P') 
DROP PROCEDURE [ingresosDelete] 
GO

CREATE PROCEDURE [ingresosDelete]
      @OldNum_habitacion int
     ,@OldComentario nvarchar(50)
     ,@OldFecha_ingreso date
     ,@OldFecha_salida date
     ,@Oldid_cama int
     ,@Oldid_historia int
     ,@ReturnValue int OUTPUT
AS
BEGIN

SET NOCOUNT ON

BEGIN TRANSACTION 

BEGIN TRY 

DELETE FROM [ingresos]
WHERE
     [Num_habitacion] = @OldNum_habitacion
AND ((@OldComentario IS NULL AND [Comentario] IS NULL) OR [Comentario] = @OldComentario)
AND ((@OldFecha_ingreso IS NULL AND [Fecha_ingreso] IS NULL) OR [Fecha_ingreso] = @OldFecha_ingreso)
AND ((@OldFecha_salida IS NULL AND [Fecha_salida] IS NULL) OR [Fecha_salida] = @OldFecha_salida)
AND ((@Oldid_cama IS NULL AND [id_cama] IS NULL) OR [id_cama] = @Oldid_cama)
AND ((@Oldid_historia IS NULL AND [id_historia] IS NULL) OR [id_historia] = @Oldid_historia)

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

GRANT EXECUTE ON [ingresosDelete] TO [Public]
GO
 
