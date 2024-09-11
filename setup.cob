       IDENTIFICATION DIVISION.
       PROGRAM-ID. CobolODBC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
          01 result PIC S9(9) BINARY.
       
       PROCEDURE DIVISION.
           CALL "dbConection" RETURNING result.
           IF result = 0 THEN
               DISPLAY "Conexión exitosa a la base de datos."
           ELSE
               DISPLAY "Error al conectar a la base de datos."
           END-IF.
           STOP RUN.
       