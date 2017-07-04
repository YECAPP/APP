
* PROGRAMA PRINCIPAL
*
**ESTABLECIENDO PATHS VALIDOS 
**03/01/2013 4:59 am agregar clase general para manejo de la aplicacion 
SET PATH TO 

*CD c:\users\yec\documents\fox\app

PUBLIC errMain as Exception 
TRY 
	*SET CLASSLIB TO lib1.0\yoapp.vcx ADDITIVE

	IF !VARTYPE(_screen.yoapp1)="O"
		_screen.NewObject("yoapp1","yoapp","lib1.0\yoapp.vcx")
	ENDIF 
	
	lcFullpath=FULLPATH("")
	DO CASE
	CASE lcFullpath="C:\USERS\YEC\DOCUMENTS\FOX\"
		lcFullpath="C:\USERS\YEC\DOCUMENTS\FOX\APP\"
	OTHERWISE

	ENDCASE

	
	_screen.yoapp1.setEspecialKeys()
	_screen.yoapp1.setpath(lcFullpath)
	_screen.yoapp1.setStatus()
	_screen.yoapp1.setMenu()
	_screen.yoapp1.setToolbar()
	_screen.yoapp1.selApp
*	READ EVENTS
	
CATCH TO errMain
	lcErrorMessage=	"Error No: "+TRANSFORM(errMain.ErrorNo)+CHR(13)+;
					" Detalle: "+TRANSFORM(errMain.details)+CHR(13)+;
					" Procedimiento: "+TRANSFORM(errMain.Procedure)+CHR(13)+;
					" Llamado de pila: "+TRANSFORM(errMain.StackLevel)+CHR(13)+;
					" Mensaje: "+TRANSFORM(errMain.Message)+CHR(13)+;
					" No Linea: "+TRANSFORM(errMain.LineNo)+CHR(13)+;
					" Contenido de Linea: "+TRANSFORM(errMain.LineContents)

	
	MESSAGEBOX(lcErrorMessage)
	_Screen.RemoveObject("yoapp1")
	RELEASE ALL 
	CLEAR EVENTS 
	SET SYSMENU TO DEFAULT 
	
	
FINALLY

ENDTRY


**02/01/2013 CAMBIOS CRITICOS 
PROCEDURE CHANGECRITICOS
	**VERIFICAR QUE EXISTA DIRECTORIO DATA Y PASAR ARCHIVOS A DATA 
	IF DIRECTORY("DATA")
	
	ELSE
		MD "DATA"
	ENDIF 
	
	DIMENSION LAFILES2COPY(13)
	LAFILES2COPY(1)="C1.DBF"
	LAFILES2COPY(2)="C1.FPT"
	LAFILES2COPY(3)="C1.CDX"
	LAFILES2COPY(4)="C2.DBF"
	LAFILES2COPY(5)="C2.CDX"
	LAFILES2COPY(6)="INFOAPP.DBF"
	LAFILES2COPY(7)="NOMBRE.DBF"	
	LAFILES2COPY(8)="NSC.DBF"
	LAFILES2COPY(9)="NSC.FPT"		
	LAFILES2COPY(10)="NSC.CDX"
	LAFILES2COPY(11)="TBDTUP.DBF"				
	LAFILES2COPY(12)="C2TEMP.DBF"
	LAFILES2COPY(13)="C2TMP.DBF"	
	FOR N=1 TO ALEN(LAFILES2COPY,1)	
		LCFILE=LAFILES2COPY(N)
		
		IF FILE("DATA\"+LCFILE)=.F.
			IF FILE(LCFILE)
				COPY FILE (LCFILE) TO "DATA\"+LCFILE
				DELETE FILE  (LCFILE) RECYCLE 
			ENDIF 
		ELSE &&si el archivo ya existe en data 
		ENDIF &&FILE("DATA\"+LCFILE)=.F.
	ENDFOR &&	FOR N=1 TO ALEN(LAFILES2COPY,1)	
	
	**verificar si existe tabla para manejo de versiones sino crearla 
	CLOSE TABLES ALL 
	IF FILE("DATA\tbsrcdtup.dbf")=.F.
		DO addtbDataUpdates  IN altertable2 WITH .t. 
		SELECT tbsrcdtup
		USE 
	ENDIF 
	
	IF FILE("tbdtup.dbf")=.F.
		DO addtbDataUpdates  IN altertable2 WITH .t. 
		SELECT tbdtup
		USE 
	ENDIF 
ENDPROC 


