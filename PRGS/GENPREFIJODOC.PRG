PROCEDURE genPrefijoDoc
PARAMETERS lcIdDoc

*!*	IF !USED("DOCUMENTOS")
*!*		USE DOCUMENTOS IN 0
*!*	ENDIF 
*MESSAGEBOX("prefijodoc:"+TRANSFORM(lcIdDoc))
*RETURN IIF(SEEK(lcIdDoc,"DOCUMENTOS","IDDOC"),ALLTRIM(DOCUMENTOS.PREFIJO),.NULL.)
SELECT prefijo FROM documentos WHERE iddoc=lcIdDoc INTO ARRAY laGenPreFijoDoc

IF !VARTYPE(laGenPreFijoDoc)="U"
	lcReturn=ALLTRIM(laGenPreFijoDoc)
ELSE
	lcReturn=.null. 
ENDIF 

RETURN lcReturn
ENDPROC 