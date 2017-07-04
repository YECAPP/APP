PROCEDURE SKIPPER
PARAMETERS lnBarmenu,tcUsuario
**4 SEP 2016 
**EL PERMISO CERO DA ACCESO A CUALQUIER USUARIO 

*****************************************************
*menus 0
	IF VARTYPE(lnBarmenu)="N"
		IF lnBarmenu=0
			RETURN .F.
		ENDIF  
	ENDIF 
*****************************************************

*****************************************************
	LOCAL lcStatus as Character 
	LOCAL lcActualAlias
	LOCAL llFound
	lcActualAlias=ALIAS()
	IF VARTYPE(_SCREEN.oApp)="O"
		IF !EMPTY(_SCREEN.oApp.oSec.cStatus)
			lcStatus=_SCREEN.oApp.oSec.cStatus
			
		ELSE 
			lcStatus="A-01"
		ENDIF
		
	ELSE 
		lcStatus="A-01"
	ENDIF
	
*****************************************************
	IF ALEN(_screen.yoapp1.lamenus,1)=1
*!*		IF !USED("MENUS")
*!*			USE MENUS IN 0
*!*		ENDIF 

		SELECT ;
			alltrim(codigo);
		FROM ;
			menus ;
		WHERE ;
			UPPER(ALLTRIM(IDCARGO))==UPPER(ALLTRIM(lcStatus));
		INTO ARRAY ;
			_screen.yoapp1.lamenus
		
		SELECT MENUS
		USE 
	ENDIF 
*****************************************************
	
	IF VARTYPE(lnBarmenu)="N"
		
		lnBarmenu=TRANSFORM(lnBarmenu)

*!*			SELECT;
*!*				codigo;
*!*			FROM ;
*!*				MENUS ;
*!*			WHERE ;
*!*				UPPER(ALLTRIM(IDCARGO))==UPPER(ALLTRIM(lcStatus)) AND ;
*!*				UPPER(ALLTRIM(CODIGO))==TRANSFORM(lNBarMenu);
*!*			INTO ARRAY ;
*!*				laMenu
		*LOCATE FOR UPPER(ALLTRIM(IDCARGO))=UPPER(ALLTRIM(lcStatus)) AND UPPER(ALLTRIM(CODIGO))=ALLTRIM(STR(lNBarMenu))
		*llFound=!FOUND()
		*IF !EMPTY(lcActualAlias)
		*	SELECT (lcActualAlias)
		*ENDIF 
	ELSE 
	
*!*			SELECT;
*!*				codigo;
*!*			FROM ;
*!*				MENUS ;
*!*			WHERE ;
*!*				UPPER(ALLTRIM(IDCARGO))==UPPER(ALLTRIM(lcStatus)) AND ;
*!*				UPPER(ALLTRIM(CODIGO))==ALLTRIM(UPPER(lNBarMenu));
*!*			INTO ARRAY ;
*!*				laMenu

	ENDIF 
	
	

	lnResult=ASCAN(_screen.yoapp1.lamenus,lnBarmenu,1,ALEN(_screen.yoapp1.lamenus),1,6)

	
*!*		IF !VARTYPE(laMenu)="U"
*!*			llFound=.F.
*!*		ELSE
*!*			llFound=.T.
*!*		ENDIF 
	
	IF lnResult<>0
		llFound=.F.
	ELSE
		llFound=.T.
	ENDIF 
	
	RETURN llFound

ENDPROC 