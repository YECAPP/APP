PROCEDURE NumeroRequisicion
	SELECT NVL(MAX(Nrequisicion),"0") AS Num  FROM Requisiciones INTO CURSOR mex
	*MESSAGEBOX(PADL(ALLTRIM(STR(VAL(mex.num)+1)),10,"0"))
	RETURN PADL(ALLTRIM(STR(VAL(mex.num)+1)),10,"0")  
	*NumeroOrden=VAL(norden)
	*RETURN PADL(ALLTRIM(STR(NumeroOrden+1)),10,"0")
ENDPROC 