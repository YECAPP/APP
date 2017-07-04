
*DO costopromv2 WITH DATE(),"04200103"
*MESSAGEBOX(costopromv2(CTOD("01/02/2012"),"04030126"))
*DO costopromv2Update WITH "040301"

PROCEDURE costopromv2Update
	LPARAMETERS tcCodigo2Update,tbSilenceMode
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
		
		IF !tbSilenceMode
			MESSAGEBOX(lcMsg ,48,"Resultados")		
		ENDIF 
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
**13/03/2013 se agrego campo precioref a cursor costos para no tener que volver a consultarlo mas abajo 
CREATE CURSOR periodos(periodo c(6),codigo c(15),nombre c(60),entrada n(10,4),entrada2 n(10,4),salida n(10,4),saldo n(10,4),calc n(10,4),costo  n(10,4) NULL ,costo2 n(10,4) NULL ,cambio l,tpcosto c(30),costo3  n(10,4) NULL,costoref n(10,4))
CREATE CURSOR costos(periodo c(6), codigo c(15),nombre c(60),entrada n(10,4),costos n(10,4), calc N(10,4))
CREATE CURSOR movs(periodo c(6), codigo c(15),nombre c(60),entrada n(10,4),salida n(10,4),saldo n(10,4),costo n(10,4),precioref n(10,4))
SELECT movs
INDEX ON CODIGO+periodo TAG CODIGO
SELECT periodos 
INDEX ON CODIGO+periodo TAG CODIGO
*************************************************************************************************************************************************************

*Insertando ingresos ********************************************************************************************************************************************

**29 de sep 2014 se agrego el manejo de aplicadefault a falso, 
**asi solo se mostraran e el inventario las ordenes que cumplan  los siguiente criterios:
**enviarautoriza=.t.
**fechaautoriza=alguna fecha 
lcFiltroOc=""
lcFiltroRa=""
IF !VARTYPE(gcAplicaDefault)="U"
	IF gcAplicaDefault="SI"
		lcFiltroOc="AND ORDENCOMPRA.ENVIARAUTORIZA=.T."
		lcFiltroRa="AND REQUISICIONES.ENVIARAUTORIZA=.T."
	ENDIF 
ENDIF 
**FIN 29 de sep 2014 se agrego el manejo de aplicadefault a falso, 


INSERT INTO movs(periodo,codigo,nombre,entrada,costo,precioref) ;
	SELECT ;
		CAST(TRANSFORM(year(fecha))+PADL(TRANSFORM(month(fecha)),2,"0") as c(6))  ,;
		detalleorden.codigo ,;
		NVL(inventario.nombre,"SCodigo"),;
		cantidad,;
		detalleorden.costo,;
		NVL(inventario.precioref,0000.0000);		
	FROM ;
		detalleorden INNER JOIN ordencompra ON detalleorden.norden==ordencompra.norden;
					LEFT JOIN inventario on detalleorden.codigo==inventario.codigo;
	WHERE ;
		detalleorden.codigo=lcCod AND ;
		detalleorden.cantidad>0 &lcFiltroOc
		

*Insertando egresos********************************************************************************************************************************************		
INSERT INTO movs(periodo,codigo,nombre,salida,precioref) ;		
	SELECT ;
		CAST(TRANSFORM(year(fecha))+PADL(TRANSFORM(month(fecha)),2,"0") as c(6)) ,;
		detallerequisicion.codigo ,;
		NVL(inventario.nombre,"SCodigo"),;
		cantidad  ,;
		NVL(inventario.precioref,0000.0000);				
	FROM ;
		detallerequisicion 	INNER JOIN requisiciones ON detallerequisicion.nrequisicion==requisiciones.nrequisicion;
							LEFT JOIN inventario on detallerequisicion.codigo==inventario.codigo;		
	WHERE ;
		detallerequisicion.codigo=lcCod &lcFiltroRa

INSERT INTO movs(periodo,codigo,nombre,salida,precioref) ;		
	SELECT ;
		CAST(TRANSFORM(year(fecha))+PADL(TRANSFORM(month(fecha)),2,"0") as c(6))  ,;
		detalleorden.codigo ,;
		NVL(inventario.nombre,"SCodigo"),;
		cantidad*-1,;
		NVL(inventario.precioref,0000.0000);				
	FROM ;
		detalleorden INNER JOIN ordencompra ON detalleorden.norden==ordencompra.norden;
					LEFT JOIN inventario on detalleorden.codigo==inventario.codigo;
	WHERE ;
		detalleorden.codigo=lcCod AND; 
		detalleorden.cantidad<0 &lcFiltroOc
	

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
INSERT INTO costos(periodo,codigo,entrada,CALC) ;
	SELECT ;
		CAST(TRANSFORM(year(fecha))+PADL(TRANSFORM(month(fecha)),2,"0") as c(6))  ,;
		detalleorden.codigo,;
		SUM(cantidad),;
		SUM(ROUND(cantidad*costo,4));
	FROM ;
		detalleorden INNER JOIN ordencompra ON detalleorden.norden==ordencompra.norden;
					LEFT JOIN inventario on detalleorden.codigo==inventario.codigo;
	WHERE ;
		detalleorden.codigo=lcCod AND ;
		detalleorden.costo>0 &lcFiltroOc;
	GROUP BY ;
		1,2		
SELECT costos 


SCAN 
	IF entrada<=0
		replace costos WITH 0.0000
	ELSE
		replace costos WITH calc/entrada
	ENDIF 

	
ENDSCAN

*Insertando periodos********************************************************************************************************************************************
INSERT INTO periodos(periodo, codigo,nombre ,entrada ,entrada2,salida ,costo ,costoref);
	SELECT ;
		MOVS.periodo as periodo,;
		MOVS.codigo as codigo,;
		MOVS.nombre as nombre,;
		SUM(MOVS.entrada) as entrada,;
		NVL(costos.entrada,0.00) as entrada2,;
		SUM(MOVS.salida) as salida,;		
		MAX(NVL(costos.costos,0.00)) as costo,;		
		MOVS.precioref as costoref;
	FROM ;
		MOVS LEFT JOIN COSTOS ON MOVS.PERIODO==COSTOS.PERIODO;
	WHERE ;
		MOVS.codigo=lcCod;
	GROUP BY ;
		1,2,3,5,8

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

lnEntrada=0
lnSalida=0
lnSaldo=0
lnSaldoAnt=0
lnCosto=0
lnCosto2=0
lnCostoAnt=0

lcTpcosto=""
lnPrecioRef=0.0000
SCAN
	lcCodigo=periodos.codigo
	lcLastDay=getLastDay(periodos.periodo)
	ldFecha=CTOD(lcLastDay+"/"+SUBSTR(periodo,5,2)+"/"+SUBSTR(periodo,1,4))

	lnEntrada=periodos.entrada2
	lnSalida=periodos.Salida
	lnSaldo=periodos.saldo
	lnCosto=periodos.costo
	lcPeriodo=periodos.periodo
	lnSaldoDivisor=0
	lnCalc=0
	
	IF SUBSTR(lcPeriodo,1,4)>"2011"
	**********************************************************
	*mostrar operadores para verificar 
	xlcPeriodo="201212"
	xlbMostrar=.f.
	**********************************************************
	
	
	
	**el costo al final del mese se conforma de:
	**a) Entradas -estas suman-
	**	a.1)la contribucion del la existencia del mes anterior 
		lnCalc=lnSaldoAnt*lnCostoAnt

	IF xlbMostrar  &&solo para mostrar y verificar el calculo de costo 
	IF lcperiodo="201212"
		MESSAGEBOX("a.1: "+TRANSFORM(lnSaldoAnt*lnCostoAnt))
	ENDIF 
	ENDIF 
		
	**	a.2)la contribucion de las compras de este mes 
		lnCalc=lnCalc+lnEntrada*lncosto

	IF xlbMostrar  &&solo para mostrar y verificar el calculo de costo 
	IF lcperiodo="201212"
		MESSAGEBOX("a.2: "+TRANSFORM(lnEntrada*lncosto))
	ENDIF 
	ENDIF 		

	**b) Salidas -estas restan-
	**	b.1)la inhibicion de las salidas que corresponden al saldo 
		lnCalc=lnCalc-IIF((lnSaldoAnt-lnSalida)<=0,lnSaldoAnt,lnSalida)*lnCostoAnt

	IF xlbMostrar  &&solo para mostrar y verificar el calculo de costo 
	IF lcperiodo="201212"
		MESSAGEBOX("b.1: "+TRANSFORM(-IIF((lnSaldoAnt-lnSalida)<=0,lnSaldoAnt,lnSalida)*lnCostoAnt))
	ENDIF 
	ENDIF 
		
	**  b.2)la inhibicion de las salidas que corresponden al mes actual 
		lnCalc=lnCalc-IIF((lnSaldoAnt-lnSalida)<=0,lnSalida-lnSaldoAnt,0)*lnCosto

	IF xlbMostrar  &&solo para mostrar y verificar el calculo de costo 
	IF lcperiodo="201212"
		MESSAGEBOX("b.2: "+TRANSFORM(-IIF((lnSaldoAnt-lnSalida)<=0,lnSalida-lnSaldoAnt,0)*lnCosto))
	ENDIF 
	endif
		
		
	***una vez calculados tantos las contribuciones como las inhibiciones hay que dividirlo entre la existencia que queden
	*puede suceder dos cosas 
	*a) que las la suma de las contribuciones e inhibiciones sea cero o menor a cero 
		lnCalc=IIF(lnCalc<=0,lnCostoAnt,lnCalc)
		&&en ese caso solo se trasladara el costo anterior 
	*b)	que el saldo de las existencias sea cero 
		lnSaldoDivisor=IIF(lnSaldo<=0,1,lnSaldo)
		*lnSaldo=IIF(lnSaldo<=0,1,lnSaldo) cambiado 15 mar 2013 yec 
		&&en ese caso solo se pondra divisor 1 para que el costo pueda ser transferido 
	**calculado estos parametro ya se puede calcular el promedio 
	
	
	lnCostoProm=ROUND(lnCalc/lnSaldoDivisor,4)

	IF xlbMostrar  &&solo para mostrar y verificar el calculo de costo 
	IF lcperiodo="201212"
		MESSAGEBOX("lnCostoProm"+TRANSFORM(lnCostoProm))
	ENDIF 
	ENDIF 
	**para que este calculo pueda ser realizado deben cumplirse dos condiciones 
	*a)lnSaldo no puede ser menor que cero es decir no pueden existir saldos negativos
	*b)Toda entrada debe tener precio asi sea de ajuste de inventario, orden de ajuste,orden de compra o devolucion 
		**Nota: en caso de no tener el precio disponible usar el precio de referencia 
		
		lcTpcosto="Promedio2"
		lnCostoProm3=costoprom(ldFecha,lcCodigo)
		SELECT periodos
	ELSE
		
		lnCostoProm=costoprom(ldFecha,lcCodigo)
		lnCostoProm3=lnCostoProm
		SELECT periodos
		lcTpcosto="Promedio"
	ENDIF

	replace costo2 WITH lnCostoProm,;
			tpcosto WITH lcTpcosto,;
			costo3 WITH lnCostoProm3
			
	lnSaldoAnt=lnSaldo
	lnCostoAnt=lnCostoProm
	
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


PROCEDURE pruebacosto
LPARAMETERS tccodigo,tdfecha
	CREATE CURSOR base(;
		fecha d,;
		doc c(10),;
		codigo c(15),;
		entrada n(12,4),;
		salida n(12,4),;
		costo n(12,4))
		
		lnCero=000.0000
		
	INSERT INTO base ;
		SELECT ;
			m.fecha,d.norden,ALLTRIM(d.codigo),d.cantidad,lnCero,d.costo ;
		FROM ;
			detalleorden D inner join ordencompra M on D.norden=M.norden ;
		WHERE ;
			alltrim(UPPER(codigo))==UPPER(tccodigo) AND M.fecha<=tdfecha
		
	INSERT INTO base ;
		SELECT;
			m.fecha,d.nrequisicion,ALLTRIM(d.codigo),lncero,d.cantidad,lncero ;
		FROM ;
			detallerequisicion D inner join requisiciones M on D.nrequisicion=M.nrequisicion;
		WHERE;
			ALLTRIM(UPPER(codigo))==UPPER(tccodigo) AND M.fecha<=tdfecha
		
	INSERT INTO base ;
		SELECT ;
			m.fecha,d.idventa,ALLTRIM(d.referencia),lncero,d.cantidad,lncero ;
		FROM ;
			facturaslines D inner join facturas M on  D.idventa=M.idventa;
		WHERE ;
			tp=1 AND ALLTRIM(UPPER(referencia))==UPPER(tccodigo) AND M.fecha<=tdfecha
			
	**calculando el valor para los que estan a cero 
	SELECT precioref FROM inventario WHERE ALLTRIM(codigo)==UPPER(tccodigo) INTO ARRAY laCostoRef
	
	IF !VARTYPE(laCostoRef)="X"
		lnCostoRef=laCostoRef
	ELSE 
		lnCostoRef=0.00
	ENDIF 
	**calculando el valor para los que estan a cero 
	
	SELECT base 

	SELECT SUM(entrada*IIF(costo=0,lnCostoRef,costo))/SUM(entrada) FROM base INTO ARRAY laCostoEntrada

**PASAR A EXCEL 
	SELECT ;
		fecha,;
		doc,;
		CODIGO,;
		entrada,;
		SALIDA,;
		IIF(costo=0,lnCostoRef,costo);
	FROM ;
		base ;
	INTO CURSOR PARAPRUEBA 
	SELECT PARAPRUEBA 
	GO TOP 
	_VFP.DataToClip(,,3)
**PASAR A EXCEL 	 

	IF !VARTYPE(laCostoEntrada)="X"
		SELECT SUM(entrada*IIF(costo=0,lnCostoRef,costo)-salida*laCostoEntrada)/SUM(entrada-salida) FROM base 
	ENDIF 

	
ENDPROC 
