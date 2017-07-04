**calculo de costo promedio, metodo uno -costoprom1- (costoprom.prg), este metodo se utilizaba antes de crear costopromv2(o su similar costopromv2Update.prg) 
**sin embargo para no causar diferencias en los calculos ya hechos y declarado a hacienda 
**se dejo que antes de 2011 se siguiera usando costoprom1 (costoprom.prg) aun y cuando se calculara usando costoprom2(o su similar costopromv2Update.prg) 
**por lo tanto costoprom2(o su similar costopromv2Update.prg) devolvera el mismo valor que costoprom1 (costoprom.prg) si se solicta una fecha menor o igual al año 2011 
**04/03/2013: 	se simplifico grandemente el algoritmo que calcula el costoprom haciendolo por medio de un array y eliminando todos los cursores innecesarios que creaba 
**				se dejo un backup en costoprom2 que era mas viejo y otro de mar que es costopromBCKMAR2013  


PROCEDURE COSTOPROM
LPARAMETERS tdFecha,tcCodigo
	********************************************************************************************************************************************
	&&DECLARACION DE VARIABLES 																													
	&&variables 																																
	ldFecha=tdFecha  	&&Fecha para el calculo  
	lcCodigo=tcCodigo	&&Codigo para el calculo 

	********************************************************************************************************************************************
*	LOCAL lnCosMes as Double					&&Costo para almacenar costo temporal 	


	
	RELEASE LACOSTOPROPROC
*	SELECT;
		SUM(detalleorden.cantidad) as entrada,;
		ROUND(SUM(detalleorden.cantidad*detalleorden.costo),2) AS CALC ;
	FROM ;
		DETALLEORDEN INNER JOIN ORDENCOMPRA ON DETALLEORDEN.NORDEN=ORDENCOMPRA.NORDEN  ;
	WHERE ;
		ORDENCOMPRA.fecha<=ldFecha &&AND  ;
		ALLTRIM(CODIGO)==ALLTRIM(lcCodigo) AND ;
		DETALLEORDEN.COSTO>0 AND ;  
		DETALLEORDEN.cantidad>0
		
		
	SELECT;
		SUM(detalleorden.cantidad) as entrada,;
		ROUND(SUM(detalleorden.cantidad*detalleorden.costo),2) AS CALC ;
	FROM ;
		DETALLEORDEN INNER JOIN ORDENCOMPRA ON DETALLEORDEN.NORDEN=ORDENCOMPRA.NORDEN ;
	WHERE ;
		ORDENCOMPRA.fecha<=ldFecha AND  ;
		CODIGO=lcCodigo AND ;
		DETALLEORDEN.COSTO>0 AND ;  
		DETALLEORDEN.cantidad>0;
	INTO ARRAY ;
		LACOSTOPROPROC
		


	IF !VARTYPE(LACOSTOPROPROC)="X"
		lnCalc=LACOSTOPROPROC(2)
		lnEntradas=LACOSTOPROPROC(1)
		IF lnEntradas>0
			lnCosMes=ROUND(lnCalc/lnEntradas,2)
		ELSE
			lnCosMes=0.00		
		ENDIF 	
	ELSE
		lnCosMes=0.00
	ENDIF 
	
	RETURN lnCosMes 
ENDPROC

