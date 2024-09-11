#include <stdio.h>
#include <sql.h>
#include <sqlext.h>

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
