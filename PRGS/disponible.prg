PROCEDURE Disponible 
PARAMETERS lsCodigo,ldFecha
IF EMPTY(lsCodigo)
	RETURN 0.00
ELSE 
	SELECT;
		SUM(CANTIDAD);
	FROM ;
		DETALLEORDEN ;
	WHERE ;
		CODIGO=lsCodigo; 
	INTO ARRAY ;
		lnEntradas
	lnEntradas(1)=IIF(VARTYPE(lnEntradas)="X",0.00,lnEntradas(1))

	SELECT;
		SUM(CANTIDAD);
	FROM ;
		DETALLEREQUISICION ;
	WHERE ;
		CODIGO=lsCodigo; 
	INTO ARRAY ;
		lnSalidas
	lnSalidas(1)=IIF(VARTYPE(lnSalidas)="X",0.00,lnSalidas(1))

		RETURN lnEntradas-LnSalidas
ENDIF 
ENDPROC 
