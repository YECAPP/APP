
*DO costopromv2 WITH DATE(),"04200103"
*MESSAGEBOX(costopromv2(CTOD("01/02/2012"),"04030126"))
*DO costopromv2Update WITH "040301"

PROCEDURE costopromv2Update
	LPARAMETERS tcCodigo2Update
	CLOSE TABLES ALL 
	LOCAL lbMsgsInternos as Boolean 
	lnCountSup=0
	lnCountSupVacios=0
	lnCountSupSinMov=0
	lnCountSupPend=0
	lnTotal=0
	lnDivisorSup=3
	lbMsgsInternos=.f.
	**borrando calculos anteriores 
	USE tbCOSTOS exclusive 
	ZAP IN tbCOSTOS 
	USE IN TBCOSTOS 
	**fin 
	SELECT codigo FROM inventario WHERE codigo=tcCodigo2Update INTO ARRAY laIventarioCods
	IF !VARTYPE(laIventarioCods)="U"
		lnTotal=ALEN(laIventarioCods)
		FOR n2Update=1 TO ALEN(laIventarioCods)
			IF INLIST(INKEY(),99,67)
				IF MESSAGEBOX("¿Desea Cancelar la generacion de tabla de costos?",36,"¿Cancelar?")=6
					EXIT 
					lnCountSupPend=lnTotal-lnCountsup
				ENDIF 
			ENDIF 
			lcCodigo2Update=laIventarioCods(n2Update)
			IF !EMPTY(lcCodigo2Update)
				DO genListMonth WITH lcCodigo2Update
				IF USED("PERIODOS")
					INSERT INTO tbCOSTOS;
						SELECT * FROM periodos 
					USE IN periodos 
					IF MOD(lnCountsup,lndivisorsup)=0
						WAIT TRANSFORM(lnCountsup )+" Generando Tabla de Costos para codigo: "+lcCodigo2Update+",Faltan :"+TRANSFORM(lnTotal-lnCountsup) WINDOW NOWAIT 
					ENDIF 
					lnCountsup = lnCountsup + 1 
					lnCountSupPend=lnTotal-lnCountsup
				ELSE
					lnCountSupSinMov = lnCountSupSinMov + 1 
				ENDIF
			ELSE
				lnCountSupVacios = lnCountSupVacios + 1 
			ENDIF 			
		ENDFOR
		lcMsg="Tabla de Costos Actualizada "
		lcMsg = lcMsg + IIF(lnCountsup >0,CHR(13)+TRANSFORM(lnCountsup )+" Codigos generados satisfactoriamente de un total de "+TRANSFORM(lnTotal),"")
		lcMsg = lcMsg + IIF(lnCountSupSinMov>0,CHR(13)+TRANSFORM(lnCountSupSinMov)+" Codigos sin movimiento","")
		lcMsg = lcMsg + IIF(lnCountSupVacios >0,CHR(13)+TRANSFORM(lnCountSupVacios )+" Codigos vacios","")
		lcMsg = lcMsg + IIF(lnCountSupPend>0,CHR(13)+TRANSFORM(lnCountSupPend)+" Codigos quedaron pendientes de generar","")		
		
		
		MESSAGEBOX(lcMsg ,48,"Resultados")		
	ELSE
		MESSAGEBOX("No se encontro codigo(s) solicitado(s)",48,"Resultados")
	ENDIF 
	CLOSE TABLES ALL 
ENDPROC

*PROCEDURE Calcular 
*	SELECT codigo FROM inventario INTO ARRAY laCods
*	FOR n=1 TO ALEN(laCods)
*		DO genListMonth(laCods)
*	ENDFOR 
*ENDPROC 
 
PROCEDURE genListMonth
PARAMETERS lcCod
lnDivisor=3
*Creando cursores********************************************************************************************************************************************
CREATE CURSOR periodos(periodo c(6),codigo c(15),nombre c(60),entrada n(10,4),entrada2 n(10,4),salida n(10,4),saldo n(10,4),calc n(10,4),costo  n(10,4) NULL ,costo2 n(10,4) NULL ,cambio l,tpcosto c(30),costo3  n(10,4) NULL,costoref n(10,4))
CREATE CURSOR costos(periodo c(6), codigo c(15),nombre c(60),entrada n(10,4),costos n(10,4),calc n(10,4))
CREATE CURSOR movs(periodo c(6), codigo c(15),nombre c(60),entrada n(10,4),salida n(10,4),saldo n(10,4),costo n(10,4))
SELECT movs
INDEX ON CODIGO+periodo TAG CODIGO
SELECT periodos 
INDEX ON CODIGO+periodo TAG CODIGO
*************************************************************************************************************************************************************

*Insertando ingresos ********************************************************************************************************************************************


INSERT INTO movs(periodo,codigo,nombre,entrada,costo) ;
	SELECT ;
		CAST(TRANSFORM(year(fecha))+PADL(TRANSFORM(month(fecha)),2,"0") as c(6))  ,;
		detalleorden.codigo ,;
		NVL(inventario.nombre,"SCodigo"),;
		cantidad,;
		detalleorden.costo;
	FROM ;
		detalleorden INNER JOIN ordencompra ON detalleorden.norden==ordencompra.norden;
					LEFT JOIN inventario on detalleorden.codigo==inventario.codigo;
	WHERE ;
		detalleorden.codigo=lcCod AND ;
		detalleorden.cantidad>0
		

*Insertando egresos********************************************************************************************************************************************		
INSERT INTO movs(periodo,codigo,nombre,salida) ;		
	SELECT ;
		CAST(TRANSFORM(year(fecha))+PADL(TRANSFORM(month(fecha)),2,"0") as c(6)) ,;
		detallerequisicion.codigo ,;
		NVL(inventario.nombre,"SCodigo"),;
		cantidad  ;
	FROM ;
		detallerequisicion 	INNER JOIN requisiciones ON detallerequisicion.nrequisicion==requisiciones.nrequisicion;
							LEFT JOIN inventario on detallerequisicion.codigo==inventario.codigo;		
	WHERE ;
		detallerequisicion.codigo=lcCod

INSERT INTO movs(periodo,codigo,nombre,salida) ;		
	SELECT ;
		CAST(TRANSFORM(year(fecha))+PADL(TRANSFORM(month(fecha)),2,"0") as c(6))  ,;
		detalleorden.codigo ,;
		NVL(inventario.nombre,"SCodigo"),;
		cantidad*-1;
	FROM ;
		detalleorden INNER JOIN ordencompra ON detalleorden.norden==ordencompra.norden;
					LEFT JOIN inventario on detalleorden.codigo==inventario.codigo;
	WHERE ;
		detalleorden.codigo=lcCod AND; 
		detalleorden.cantidad<0
	

	SET ORDER TO codigo 

*poner los saldos  ********************************************************************************************************************************************
SELECT movs
lcCodigo=""
lnSaldo=0.00

SCAN
	IF lcCodigo=movs.codigo
		lnSaldo = lnSaldo + movs.entrada-movs.salida
	ELSE
		lnSaldo=movs.entrada-movs.salida
		lcCodigo=movs.codigo
	ENDIF
	replace saldo WITH lnSaldo 
	
ENDSCAN

*Crear costos ********************************************************************************************************************************************
INSERT INTO costos(periodo,codigo,nombre,entrada,calc) ;
	SELECT ;
		CAST(TRANSFORM(year(fecha))+PADL(TRANSFORM(month(fecha)),2,"0") as c(6))  ,;
		detalleorden.codigo,;
		NVL(inventario.nombre,"SCodigo"),;
		SUM(cantidad),;
		SUM(ROUND(cantidad*costo,4));
	FROM ;
		detalleorden INNER JOIN ordencompra ON detalleorden.norden==ordencompra.norden;
					LEFT JOIN inventario on detalleorden.codigo==inventario.codigo;
	WHERE ;
		detalleorden.codigo=lcCod AND ;
		detalleorden.costo>0;
	GROUP BY ;
		1,2,3		
SELECT costos 


SCAN 
	IF entrada<=0
		replace costos WITH 0.0000
	ELSE
		replace costos WITH calc/entrada
	ENDIF 

	
ENDSCAN

*Insertando periodos********************************************************************************************************************************************
INSERT INTO periodos(periodo, codigo,nombre ,entrada ,entrada2,salida ,saldo,calc ,costo ,cambio );
	SELECT ;
		MOVS.periodo,;
		MOVS.codigo,;
		MOVS.nombre,;
		SUM(MOVS.entrada),;
		NVL(costos.entrada,0.00),;
		SUM(MOVS.salida),;		
		VAL("0.00"),;
		NVL(costos.calc,0.00),;
		MAX(NVL(costos.costos,0.00)),;		
		.f.;
	FROM ;
		MOVS LEFT JOIN COSTOS ON MOVS.PERIODO==COSTOS.PERIODO;
	WHERE ;
		MOVS.codigo=lcCod;
	GROUP BY ;
		1,2,3,5,7,8,10

SELECT periodos
SET ORDER TO codigo 		

lcCodigo=""
lnSaldo=0.00
SCAN
	IF lcCodigo=periodos.codigo
		lnSaldo = lnSaldo + periodos.entrada-periodos.salida
	ELSE
		lnSaldo=periodos.entrada-periodos.salida
		lcCodigo=periodos.codigo
	ENDIF
	replace saldo WITH lnSaldo 
	
	
ENDSCAN

lnSaldo=0
lnCosto=0
lcTpcosto=""
lnPrecioRef=0.0000
SCAN
	lcCodigo=periodos.codigo
	lcLastDay=getLastDay(periodos.periodo)
	ldFecha=CTOD(lcLastDay+"/"+SUBSTR(periodo,5,2)+"/"+SUBSTR(periodo,1,4))
	lnEntrada2=periodos.entrada2
	lnCalc=periodos.calc
	lcPeriodo=periodos.periodo
	IF SUBSTR(lcPeriodo,1,4)>"2011"
		IF lnSaldo>0 AND lnEntrada2>0
			IF lnSaldo>0
				lnCostoProm=ROUND((lnSaldo*lnCosto+lnCalc)/(lnSaldo+lnEntrada2),4)
			ELSE
				lnCostoProm=ROUND((lnCalc)/(lnEntrada2),4) &&Solo el del mes
			ENDIF 
		ELSE
			IF lnEntrada2>0
				lnCostoProm=ROUND((lnCalc)/(lnEntrada2),4)
			ELSE
				lnCostoProm=0.00
			ENDIF 
		ENDIF 
		lcTpcosto="Promedio2"
		lnCostoProm3=costoprom(ldFecha,lcCodigo)
		SELECT periodos
	ELSE
		lnCostoProm=costoprom(ldFecha,lcCodigo)
		lnCostoProm3=costoprom(ldFecha,lcCodigo)
		SELECT periodos
		lcTpcosto="Promedio"
	ENDIF
	**PONIENDO PRECIO REF
	SELECT precioref FROM INVENTARIO WHERE CODIGO==lcCodigo INTO ARRAY laPrecioRef 
	IF !VARTYPE(laPrecioRef )="U"
		lnPrecioRef=laPrecioRef
	ELSE
		lnPrecioRef=0.0000
	ENDIF 
	**FIN PONIENDO PRECIO REF 
	
	**YEC corrigiendo calculo de costo 
	IF lnCostoProm=0
		lnCosto=periodos.costo
		lnCostoProm=lnCosto
	ENDIF 
	**YEC corrigiendo calculo de costo 
	
	replace costo2 WITH lnCostoProm,;
			tpcosto WITH lcTpcosto,;
			costo3 WITH lnCostoProm3,;
			costoref WITH lnPrecioRef
			
	lnSaldo=periodos.saldo
	lnCosto=periodos.costo2
	
	
	
ENDSCAN
ENDPROC 

PROCEDURE getLastDay
LPARAMETERS tcPer
	DO CASE
	CASE INLIST(SUBSTR(tcPer,5,2),"01","03","05","07","08","10","12")
		lcReturn="31"	
	CASE SUBSTR(tcPer,5,2)="02"
		lcReturn="28"	
	OTHERWISE
		lcReturn="30"	
	ENDCASE

RETURN lcReturn
	
ENDPROC 

