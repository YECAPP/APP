SET DELETED ON 
SET EXCLUSIVE OFF


SELECT TOP 1  EJECUTABLE  FROM LAUNCHER ORDER BY LINE DESC INTO ARRAY LALAUNCHER 
*SELECT TOP 1  EJECUTABLE  FROM LAUNCHER ORDER BY LINE DESC 
IF !VARTYPE(LALAUNCHER)="U"
	LCEXEC=LALAUNCHER

	*MESSAGEBOX(LALAUNCHER)
ELSE
	LCEXEC="ERROR.EXE"
	*MESSAGEBOX("SGAA")
ENDIF 

SELECT LAUNCHER 
USE 

IF FILE(LCEXEC)
	RUN /N &LCEXEC
ELSE 
	MESSAGEBOX("No se pudo encontrar el archivo de inicio",16,"Error")
ENDIF 