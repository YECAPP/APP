PROCEDURE COSTOPROM
LPARAMETERS tdFecha,tcCodigo
	********************************************************************************************************************************************
	&&DECLARACION DE VARIABLES 																													
	&&variables 																																
	ldFecha=tdFecha  	&&Fecha para el calculo  
	lcCodigo=tcCodigo	&&Codigo para el calculo 

	********************************************************************************************************************************************
	lnCosMes=0					&&Costo para almacenar costo temporal 	
	ldFechaT={^2010/05/31}		&&Fecha temporal  						
	lnLastDayDate=0				&&Ultimo dia para el calculo completo 	
	lnNiter=0
	
	&&DETERMINAR PERIODOS QUE EXISTEN ANTES DE LA FECHA SOLICITADA Y PARA EL CODIGO SOLICITADO 
		SELECT ;
			YEAR(fecha),;
			MONTH(fecha) ;
		FROM ;
			DETALLEORDEN INNER JOIN ORDENCOMPRA ON DETALLEORDEN.NORDEN=ORDENCOMPRA.NORDEN ;
		WHERE;
			ORDENCOMPRA.fecha<=ldFecha AND  ;
			DETALLEORDEN.CODIGO=lcCodigo AND ;
			DETALLEORDEN.COSTO>0 ;
		GROUP BY;
			1,2 ;
		INTO ARRAY ;
			arrayan
		
		***
		*SELECT *;
		FROM ;
			DETALLEORDEN INNER JOIN ORDENCOMPRA ON DETALLEORDEN.NORDEN=ORDENCOMPRA.NORDEN ;
		WHERE;
			ORDENCOMPRA.fecha<=ldFecha AND  ;
			DETALLEORDEN.CODIGO=lcCodigo AND ;
			DETALLEORDEN.COSTO>0 
		****
		
		
		
	IF !VARTYPE(arrayan)="U"
		lnNiter=ALEN(arrayan,1)
		FOR n=1 TO lnNiter  

			IF !USED("COSTOBASE")
				SELECT;
					SUM(detalleorden.cantidad) as entrada,;
					ROUND(SUM(detalleorden.cantidad*detalleorden.costo)/SUM(detalleorden.cantidad),2) AS PRECIOPROM ;
				FROM;
					DETALLEORDEN INNER JOIN ORDENCOMPRA ON DETALLEORDEN.NORDEN=ORDENCOMPRA.NORDEN ;
				WHERE ;
					CODIGO=lcCodigo AND ;
					DETALLEORDEN.COSTO>0 AND ; 
					year(FECHA)=Arrayan(n,1) AND ;
					MONTH(FECHA)=Arrayan(n,2) AND ;
					DETALLEORDEN.cantidad>0;
				INTO CURSOR ;
					COSTObase READWRITE 
				
				lnCosMes=COSTOBASE.PRECIOPROM 
			ELSE 
				INSERT INTO COSTOBASE (ENTRADA,PRECIOPROM) ;
					SELECT;
						NVL(SUM(detalleorden.cantidad),0.00) as entrada,;
						ROUND(NVL(SUM(detalleorden.cantidad*detalleorden.costo)/SUM(detalleorden.cantidad),0.00),2) AS PRECIOPROM ;
					FROM ;
						DETALLEORDEN INNER JOIN ORDENCOMPRA ON DETALLEORDEN.NORDEN=ORDENCOMPRA.NORDEN ;
					WHERE ;
						CODIGO=lcCodigo AND ;
						DETALLEORDEN.COSTO>0 AND ;  
						year(FECHA)=Arrayan(n,1) AND ;
						MONTH(FECHA)=Arrayan(n,2) AND ;
						DETALLEORDEN.cantidad>0

					*SELECT;
						NVL(SUM(detalleorden.cantidad),0.00) as entrada,;
						NVL(SUM(detalleorden.cantidad*detalleorden.costo)/SUM(detalleorden.cantidad),0.00) AS PRECIOPROM ;
					FROM ;
						DETALLEORDEN INNER JOIN ORDENCOMPRA ON DETALLEORDEN.NORDEN=ORDENCOMPRA.NORDEN ;
					WHERE ;
						CODIGO=lcCodigo AND ;
						DETALLEORDEN.COSTO>0 AND ;  
						year(FECHA)=Arrayan(n,1) AND ;
						MONTH(FECHA)=Arrayan(n,2)	


				SELECT ;
					SUM(ENTRADA) AS ENTRADA,;
					CAST(ROUND(SUM(ENTRADA*PRECIOPROM)/SUM(ENTRADA),2) AS N(10,2)) AS PRECIOPROM ;
				FROM ;
					COSTOBASE ;
				INTO CURSOR ;
					COSTOBASE
					
				*SELECT ;
					SUM(ENTRADA) AS ENTRADA,;
					SUM(ENTRADA),;
					CAST(ROUND(SUM(ENTRADA*PRECIOPROM)/SUM(ENTRADA),2) AS N(10,2)) AS PRECIOPROM ;
				FROM ;
					COSTOBASE 
			ENDIF 
			
			ldFEchaT=DATE(Arrayan(N,1),Arrayan(N,2),1)
			lnLastDayDate=GOMONTH(ldFechaT,1)-DAY(ldFechaT)
			
			SELECT;
				SUM(detalleorden.cantidad) as entrada,;
				COSTObase.PRECIOPROM AS PRECIOPROM ;
			FROM ;
				DETALLEORDEN INNER JOIN ORDENCOMPRA ON DETALLEORDEN.NORDEN=ORDENCOMPRA.NORDEN,COSTObase;
			WHERE ;
			CODIGO=lcCodigo AND FECHA<=lnLastDayDate GROUP BY 2 INTO CURSOR COSTOBASE READWRITE 

		
		
		ENDFOR 
		SELECT costobase
		lnCosMes=ROUND(costobase.PRECIOPROM,2)
		USE 
	ELSE 
		lnCosMes=0.00
	ENDIF 
	
	RETURN CAST(lnCosMes AS NUMERIC(10,8) )
ENDPROC

