PROCEDURE SUMPR
lPARAMETERS aRes,lcFiltro
	SELECT;
		SUM(costo) as Costo,;
		SUM(Iva) AS Iva,;
		SUM(RetencionIva) AS RetencionIva,;
		SUM(Monto) AS Monto;		
	FROM ;
		PR ;
		&lcFiltro;
	INTO CURSOR;
		sPR1

	IF RECCOUNT("sPR1")>0
		aRes(1)=sPR1.Costo
		aRes(2)=sPR1.Iva
		aRes(3)=sPR1.RetencionIva
		aRes(5)=sPR1.Monto
		SELECT sPR1
		USE 
	ELSE 
		aRes(1)=0.00
		aRes(2)=0.00
		aRes(3)=0.00
		aRes(5)=0.00
	ENDIF

ENDPROC 
