PROCEDURE  UsuarioActivo 

IF !varTYPE(_SCREEN.oApp)="U"
	lnUserActivo=_SCREEN.oApp.oSec.cCurrentUserID
ELSE
	lnUserActivo="YEC"
ENDIF 
RETURN lnUserActivo
ENDPROC 