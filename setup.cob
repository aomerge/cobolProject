       IDENTIFICATION DIVISION.
       PROGRAM-ID. CobolODBC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 action PIC 9(2).
           01 result PIC S9(9) BINARY.
 
           01 tabla-option.
               06 texto-elemento OCCURS 6 TIMES PIC X(30) VALUE SPACES.
           01 i pic 9 value 1.   

           01  WS-QUERY-RESULT.
               05  WS-COL1   PIC X(256).
               05  WS-COL2   PIC X(256).

           01  WS-QUERY-READ PIC X(100) VALUE "SELECT * FROM productos".           

           01  WS-ID         PIC 9(5).
           01  WS-NOMBRE     PIC X(50).
           01  WS-ID-TEXT    PIC X(5).
           01  WS-NOMBRE-CORTADO PIC X(50). 
           01  WS-QUERY-STRING PIC X(256).
           01  WS-STATUS       PIC S9(4) COMP-5 VALUE 0.

       PROCEDURE DIVISION.           
           CALL "dbConection" RETURNING result.
           IF result = 0 THEN
               DISPLAY "Conexión exitosa a la base de datos."               
               perform PRINTMENU

           ELSE
               DISPLAY "Error al conectar a la base de datossss."
           END-IF.
           STOP RUN.
           
           display "MENU".
           perform PRINTMENU.     

           stop run. 

       execute_query_select.
           display "ejecutando query productos..."                   

           CALL "executeQuery" USING BY REFERENCE WS-QUERY-READ
                                  BY REFERENCE WS-QUERY-RESULT
                                  RETURNING WS-STATUS.

              IF WS-STATUS = 0 THEN
                   DISPLAY "Consulta ejecutada con éxito."
                   DISPLAY "Resultado de la consulta:"
                   DISPLAY "Columna 1: " WS-COL1
                   DISPLAY "Columna 2: " WS-COL2
                ELSE
                   DISPLAY "Error al ejecutar query."
                END-IF.

       execute_query_create.           
           DISPLAY "Introduce el nombre del producto: "
           ACCEPT WS-NOMBRE.              

           INSPECT WS-NOMBRE TALLYING WS-STATUS FOR LEADING SPACES.
               MOVE FUNCTION TRIM(WS-NOMBRE) TO WS-NOMBRE-CORTADO.     

            STRING "INSERT INTO productos (nombre) VALUES ( '" WS-NOMBRE-CORTADO "')"
               DELIMITED BY SIZE
               INTO WS-QUERY-STRING.

           DISPLAY "Query: " WS-QUERY-STRING.
           
           CALL "executeQuery" USING BY REFERENCE WS-QUERY-STRING
                                   RETURNING WS-STATUS.
           IF WS-STATUS = 0 THEN
               DISPLAY "INSERT ejecutado con éxito."
           ELSE
               DISPLAY "Falló la ejecución del INSERT."
           END-IF.

       
       execute_query_update.
           DISPLAY "Introduce el ID del producto a actualizar: "
           ACCEPT WS-ID.
           DISPLAY "Introduce el nuevo nombre del producto: "
           ACCEPT WS-NOMBRE.              

           INSPECT WS-NOMBRE TALLYING WS-STATUS FOR LEADING SPACES.
               MOVE FUNCTION TRIM(WS-NOMBRE) TO WS-NOMBRE-CORTADO.     

            STRING "UPDATE productos SET nombre = '" WS-NOMBRE-CORTADO "' WHERE id = " WS-ID
               DELIMITED BY SIZE
               INTO WS-QUERY-STRING.           
           
           CALL "executeQuery" USING BY REFERENCE WS-QUERY-STRING
                                   RETURNING WS-STATUS.
           IF WS-STATUS = 0 THEN
               DISPLAY "UPDATE ejecutado con éxito."
           ELSE
               DISPLAY "Falló la ejecución del UPDATE."
           END-IF.

       execute_query_delete.
              DISPLAY "Introduce el ID del producto a eliminar: "
              ACCEPT WS-ID.           
    
                STRING "DELETE FROM productos WHERE id = " WS-ID
                DELIMITED BY SIZE
                INTO WS-QUERY-STRING.    
                                                    
              CALL "executeQuery" USING BY REFERENCE WS-QUERY-STRING
                                      RETURNING WS-STATUS.
              IF WS-STATUS = 0 THEN
                DISPLAY "DELETE ejecutado con éxito."
              ELSE
                DISPLAY "Falló la ejecución del DELETE."
              END-IF.

       PRINTMENU.
           move "1. Mostrar datos" to texto-elemento(1).
           move "2. Insertar datos" to texto-elemento(2).
           move "3. Actualizar datos" to texto-elemento(3).
           move "4. Eliminar datos" to texto-elemento(4).
           move "5. Comprobar conección" to texto-elemento(5).
           move "6. Salir" to texto-elemento(6).

           PERFORM UNTIL i > 6
               DISPLAY texto-elemento(i)
               ADD 1 TO i
           END-PERFORM.           
           
           display "Introduce un número: ".
           accept action.                  
           PERFORM actions.                                    
           
       actions.
           EVALUATE action
               WHEN 1
                   PERFORM execute_query_select   
                   perform PRINTMENU                 
               WHEN 2
                     PERFORM execute_query_create
                     perform PRINTMENU
               WHEN 3
                        PERFORM execute_query_update
                        perform PRINTMENU                   
               WHEN 4
                        PERFORM execute_query_delete
                        perform PRINTMENU                   
               WHEN 5
                     perform connection     
                     perform PRINTMENU                    
               WHEN 6
                     DISPLAY "Has seleccionado la opción 6."
               WHEN OTHER
                   DISPLAY "Opción no válida."
                   perform PRINTMENU  
             END-EVALUATE.   

             
       connection.
           CALL "dbConection" RETURNING result.
           IF result = 0 THEN
               DISPLAY "Conexión exitosa a la base de datos."
               perform PRINTMENU
           ELSE
               DISPLAY "Error al conectar a la base de datos."
           END-IF.
           STOP RUN.
       
            
    
           
      