PROCEDURE fixinv 
LPARAMETERS  tnMes, tnaño
	lnMes=tnMes
	lnAño=tnaño

	**ordenes de compra sin costo 
	*SELECT fecha,detalleorden.* ;
	FROM detalleorden INNER JOIN ordencompra ON detalleorden.norden=ordencompra.norden ;
	WHERE EMPTY(costo)

	**requisiciones sin costo 
	*SELECT fecha, detallerequisicion.* ;
	FROM detallerequisicion INNER JOIN requisiciones ON detallerequisicion.nrequisicion=requisiciones.nrequisicion ;
	WHERE EMPTY(costo)
	lbHayMas=.t.
	DO WHILE lbHayMas
		SET SAFETY off
		DO costopromv2Update WITH "",.t.
		RELEASE laPendientes,laOCs
		SET SAFETY ON 
		
		*seleccionar los que tienen precio de esta fecha y ponerle precio 
		*luego las requisiciones 

	*	SELECT line,fecha,*;
		FROM detalleorden INNER JOIN ordencompra ON detalleorden.norden=ordencompra.norden ;
		WHERE EMPTY(costo) AND YEAR(fecha)=lnAño AND MONTH(fecha)=lnMes 
		
		SELECT;
			line,fecha,codigo; 
		FROM ;
			detalleorden INNER JOIN ordencompra ON detalleorden.norden=ordencompra.norden ;
		WHERE ;
			EMPTY(costo) AND YEAR(fecha)=lnAño AND MONTH(fecha)=lnMes;
		INTO ARRAY ;
			laOCs
			
		IF !VARTYPE(laOCs)="U"
			FOR lnOc=1 TO ALEN(laOCs,1)
				lnLine=laOCs(lnOc,1)
				ldFecha=laOCs(lnOc,2)
				lcCodigo=laOCs(lnOc,3)
				lnCostoPromVer2=costopromv2(ldFecha,lcCodigo)
				UPDATE detalleorden SET costo=lnCostoPromVer2, descripcion=ALLTRIM(descripcion)+"(c)" WHERE line=lnLine 
			ENDFOR 
		ENDIF 	
		
		
		IF lnmes=12 
			lnmes = 1
			lnAño = lnAño + 1 
		ELSE
			lnMes = lnMes + 1 
		ENDIF 

		SELECT COUNT(*) FROM detalleorden WHERE norden in ;
			(SELECT norden FROM ordencompra WHERE MONTH(fecha)=>lnMes AND YEAR(fecha)>=lnAño);
		INTO ARRAY laPendientes
		
		IF laPendientes(1)=0
			lbHayMas=.f.
		ELSE 
			lbHayMas=.t.
		ENDIF 
			
	ENDDO 
ENDPROC 
