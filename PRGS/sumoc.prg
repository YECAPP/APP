PROCEDURE SUMOc
lPARAMETERS aRes,lcFiltro
	SELECT;
		SUM(costo) as Costo,;
		SUM(Iva) AS Iva,;
		SUM(RetencionIva) AS RetencionIva,;
		SUM(Renta) AS Renta,;
		SUM(Monto) AS Monto;		
	FROM ;
		OC ;
		&lcFiltro;
	INTO CURSOR;
		sOC1

	IF RECCOUNT("sOC1")>0
		aRes(1)=sOC1.Costo
		aRes(2)=sOC1.Iva
		aRes(3)=sOC1.RetencionIva
		aRes(4)=sOC1.Renta
		aRes(5)=sOC1.Monto
		SELECT soc1
		USE 
	ELSE 
		aRes(1)=0.00
		aRes(2)=0.00
		aRes(3)=0.00
		aRes(4)=0.00
		aRes(5)=0.00
	ENDIF

ENDPROC 
