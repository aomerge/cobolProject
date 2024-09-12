#include <stdio.h>
#include <sql.h>
#include <sqlext.h>
#include <string.h>

int dbConection() {
    SQLHENV henv;
    SQLHDBC hdbc;
    SQLRETURN ret; 

    SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &henv);
    SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, (void *) SQL_OV_ODBC3, 0);
    SQLAllocHandle(SQL_HANDLE_DBC, henv, &hdbc);

    SQLCHAR connectionString[] = "Driver={ODBC Driver 17 for SQL Server};"
                                 "Server=localhost,1433;"
                                 "Database=master;"
                                 "UID=sa;"
                                 "PWD=StrongP@ssw0rd!;";
    SQLCHAR outstr[1024];
    SQLSMALLINT outstrlen;

    ret = SQLDriverConnect(hdbc, NULL, connectionString, SQL_NTS, 
                           outstr, sizeof(outstr), &outstrlen, SQL_DRIVER_COMPLETE);

    if (SQL_SUCCEEDED(ret)) {
        printf("Connected to the database successfully!\n");
        return 0;
    } else {
        printf("Failed to connect to the database.\n");
        return -1;
    }

    SQLDisconnect(hdbc);
    SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
    SQLFreeHandle(SQL_HANDLE_ENV, henv);
}

#define MAX_COLUMNS 2  // Ajusta según el número de columnas que necesitas.
#define MAX_BUFFER_SIZE 256

typedef struct {
    char col1[MAX_BUFFER_SIZE];
    char col2[MAX_BUFFER_SIZE];
} QueryResult;

int executeQuery(const char *query, QueryResult *result) {
    SQLHENV henv;
    SQLHDBC hdbc;
    SQLHSTMT hstmt;
    SQLRETURN ret;
    
    SQLCHAR connectionString[] = "Driver={ODBC Driver 17 for SQL Server};"
                                 "Server=localhost,1433;"
                                 "Database=master;"  // Asegúrate de que la base de datos sea correcta
                                 "UID=sa;"
                                 "PWD=StrongP@ssw0rd!;";
    SQLCHAR outstr[1024];
    SQLSMALLINT outstrlen;

    // Allocate environment handle
    SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &henv);
    SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, (void *) SQL_OV_ODBC3, 0);

    // Allocate connection handle
    SQLAllocHandle(SQL_HANDLE_DBC, henv, &hdbc);

    // Connect to the database
    ret = SQLDriverConnect(hdbc, NULL, connectionString, SQL_NTS, 
                           outstr, sizeof(outstr), &outstrlen, SQL_DRIVER_COMPLETE);

    if (SQL_SUCCEEDED(ret)) {
        printf("Connected to the database successfully!\n");

        // Allocate statement handle
        SQLAllocHandle(SQL_HANDLE_STMT, hdbc, &hstmt);

        // Execute the query
        ret = SQLExecDirect(hstmt, (SQLCHAR*)query, SQL_NTS);

        if (SQL_SUCCEEDED(ret)) {
            int rowCount = 0;

            // Bind columns
            SQLBindCol(hstmt, 1, SQL_C_CHAR, result->col1, MAX_BUFFER_SIZE, NULL);
            SQLBindCol(hstmt, 2, SQL_C_CHAR, result->col2, MAX_BUFFER_SIZE, NULL);

            // Fetch and print results
            while (SQLFetch(hstmt) == SQL_SUCCESS) {
                printf("Row %d: col1 = %s, col2 = %s\n", ++rowCount, result->col1, result->col2);
            }

            if (rowCount == 0) {
                printf("No rows returned.\n");
            }

            SQLFreeHandle(SQL_HANDLE_STMT, hstmt);
            SQLDisconnect(hdbc);
            SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
            SQLFreeHandle(SQL_HANDLE_ENV, henv);
            return 0;
        } else {
            printf("Failed to execute the query.\n");
            SQLFreeHandle(SQL_HANDLE_STMT, hstmt);
            SQLDisconnect(hdbc);
            SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
            SQLFreeHandle(SQL_HANDLE_ENV, henv);
            return -1;
        }
    } else {
        printf("Failed to connect to the database.\n");
        SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
        SQLFreeHandle(SQL_HANDLE_ENV, henv);
        return -1;
    }
}
