PROCEDURE GENCURVAL
LPARAMETERS lbRecrear,lcTpDoc
	DO VerVars
	
	&&algoritmo medular 
	IF !USED("OC")
		DO GENCURBASEOGS
		DO GENCURBASEOCS
		DO GENCURBASE
		DO SUMCUROC
			DO ADDNULO
			DO SUMCC
			DO SUMQD
		DO CERRCURSTEMP
	ELSE
		IF lbRecrear 
			DO GENCURBASEOGS
			DO GENCURBASEOCS
			DO GENCURBASE
			DO REFSUMCUROC
				DO ADDNULO
				DO SUMCC
				DO SUMQD
			DO CERRCURSTEMP
		ENDIF
	ENDIF
	SELECT OC  
ENDPROC 

PROCEDURE GENCURBASEOGS

	SELECT;
		NOGASTO,;
		SUM(CANTIDAD*COSTO) AS BASERIVA;
	FROM;
		DETALLEGASTO ;
	WHERE ;
		DETALLEGASTO.CRIVA=.T.;
	GROUP BY ;
		1;
	INTO CURSOR;
		BASERIVACURVAL
	
	SELECT;
		DETALLEGASTO.NOGASTO,;
		BASERIVA,;
		CRIVA,;
		CIVA,;
		CRENTA,;
		SUM(cantidad*costo) as COSTO;
	FROM ;
		DETALLEGASTO LEFT  JOIN BASERIVACURVAL ON  DETALLEGASTO.nogasto=BASERIVACURVAL.nogasto;
	GROUP BY ;
		1,2,3,4,5;
	INTO CURSOR ;
		STDETALLEGASTO
		
ENDPROC 

PROCEDURE GENCURBASEOCS
	SELECT;
		NORDEN,;
		SUM(cantidad*costo) as COSTO;
	FROM ;
		DETALLEORDEN ;
	GROUP BY ;
		1;
	INTO CURSOR ;
		stdetalleorden
ENDPROC 







PROCEDURE GENCURBASE
	&&Cursor OC1 base para validar ordenes 
	&&este cursor solo contiene el costo=cantidad*costo del detalle de ordenes de compra y ordenes de gasto
	SELECT;
		OrdenCompra.Norden,;
		OrdenCompra.Proveedor,;
		OrdenCompra.Proyecto,;
		ORDENCOMPRA.SNETO   as Costo,;
		ORDENCOMPRA.SRIVA 	as RetencionIva,;
		ORDENCOMPRA.SIVA 	as Iva,;
		VAL("0.00")		as Renta,;
		ORDENCOMPRA.STOTAL	 as Monto,;
		ORDENCOMPRA.CCF AS CCF,;
		ORDENCOMPRA.REGISTRO AS REGISTRO,;
		ORDENCOMPRA.OBSERVACIONES AS OBSERVACIONES,;
		ORDENCOMPRA.FECHA AS FECHA ;
	FROM ;
		Ordencompra ;
	union ALL ;	
	SELECT  ;
		ordenesdegastos.nogasto,;
		ordenesdegastos.Proveedor,;
		ordenesdegastos.Proyecto,;
		ordenesdegastos.SNETO	as costo,;
		ordenesdegastos.SRIVA	as RetencionIva,;
		ordenesdegastos.SIVA 	as Iva ,;		
		ordenesdegastos.SRENTA	as Renta ,;
		ordenesdegastos.STOTAL	as Monto,;
		ordenesdegastos.CCF  AS CCF,;
		ordenesdegastos.REGISTRO  AS REGISTRO,;
		ordenesdegastos.OBSERVACIONES  AS OBSERVACIONES,;
		ordenesdegastos.FECHA AS FECHA ;
	FROM ;
		ordenesdegastos ;
	INTO CURSOR ;
		OC1
ENDPROC 



PROCEDURE SUMCUROC

	&&cursor OC sumarizado del cursor base ya con los totales de retencioniva, iva y renta 
	&&La funcion Retiva evalua el proveedor para calcular una retencion de iva distinta segun el proveedor
	SELECT;
		CAST(Norden AS CHAR(10)) 			AS NORDEN ,;
		CAST(Proveedor AS CHAR(10)) 		AS PROVEEDOR,;
		CAST(Proyecto AS CHAR(10)) 			AS PROYECTO,;
		CAST(SUM(Costo) AS NUMERIC(10,2) NULL) 	AS costo ,;
		CAST(SUM(RetencionIva) AS NUMERIC(10,2) NULL) 	as RetencionIva,;
		CAST(SUM(Iva) AS NUMERIC(10,2) NULL)		AS Iva,;
		CAST(SUM(Renta) AS NUMERIC(10,2) NULL) 	AS Renta,;
		CAST(SUM(Monto) AS NUMERIC(10,2) NULL)	AS Monto,;	
		CAST(CCF AS CHAR(25)) 		AS CCF,;
		CAST(REGISTRO AS CHAR(10)) 		AS REGISTRO,;
		CAST(OBSERVACIONES AS CHAR(50)) 		AS OBSERVACIONES,;
		CAST(FECHA AS D) 		AS FECHA ;
	FROM ;
		OC1;
	GROUP BY ;
		1,2,3,9,10,11,12;
	INTO CURSOR OC READWRITE 
	&&Indexando el cursor para que los seek's del grid funcionen 
	SELECT OC
	INDEX ON Norden TAG norden 
	INDEX ON proveedor TAG proveedor 
	INDEX ON Proyecto TAG proyecto
	INDEX ON CCF TAG CCF
	INDEX ON REGISTRO TAG REGISTRO

	SELECT OC
ENDPROC 

PROCEDURE REFSUMCUROC

	SELECT;
		CAST(Norden AS CHAR(10)) 			AS NORDEN ,;
		CAST(Proveedor AS CHAR(10)) 		AS PROVEEDOR,;
		CAST(Proyecto AS CHAR(10)) 			AS PROYECTO,;
		CAST(SUM(Costo) AS NUMERIC(10,2) NULL) 	AS costo ,;
		CAST(SUM(RetencionIva) AS NUMERIC(10,2) NULL) 	as RetencionIva,;
		CAST(SUM(Iva) AS NUMERIC(10,2) NULL)		AS Iva,;
		CAST(SUM(Renta) AS NUMERIC(10,2) NULL) 	AS Renta,;
		CAST(SUM(Monto) AS NUMERIC(10,2) NULL)	AS Monto,;	
		CAST(CCF AS CHAR(25)) 		AS CCF,;
		CAST(REGISTRO AS CHAR(10)) 		AS REGISTRO,;
		CAST(OBSERVACIONES AS CHAR(50)) 		AS OBSERVACIONES,;
		CAST(FECHA AS D) 		AS FECHA ;		
	FROM ;
		OC1;
	GROUP BY ;
		1,2,3,9,10,11,12;
	INTO CURSOR tempOC 
	&&refilando el cursor OC co TempOc 
	SET SAFETY OFF
	ZAP IN OC 
	SET SAFETY ON 
	SELECT OC 
	APPEND FROM DBF('tempOC') 
ENDPROC 

PROCEDURE ADDNULO
	&&Agregando linea de Anulado 
	INSERT INTO OC (norden,costo,retencioniva,iva,renta,monto);
	VALUES ("ANULADO",0,0,0,0,0)
ENDPROC 

PROCEDURE SUMCC
	&&Agregando Cajas chicas 
	SELECT;
		CAST(detallecc.idcc AS CHAR(10))			as norden,;
		CAST(DTOC(cc.fecha) AS CHAR(8)) 			as proveedor,;
		CAST(cc.solicitante AS CHAR(10))			as proyecto,;
		CAST(SUM(costo) AS NUMERIC(10,2))			as costo ,;
		CAST(SUM(retencioniva) AS NUMERIC(10,2)) 	as retencioniva,;
		CAST(SUM(iva) 	AS NUMERIC(10,2)) 	as iva,;
		CAST(SUM(renta) AS NUMERIC(10,2))			as renta,;
		CAST(SUM(monto) AS NUMERIC(10,2))			as monto;
	FROM ;
		detallecc inner JOIN cc ON detallecc.idcc=cc.idcc;
		LEFT JOIN OC ON DETALLECC.REFERENCIA=OC.NORDEN;
	GROUP BY;
	1,2,3;
	INTO CURSOR;
		TEMPCC
	SELECT OC
	APPEND FROM DBF('tempCC' )
ENDPROC 

PROCEDURE SUMQD
	&&Agregando Quedans 
	SELECT;
		detalledocprov.iddocprov	as norden,;
		DTOC(docprov.fecha) 		as proveedor,;
		docprov.solicitante 		as proyecto,;
		SUM(costo) 					as costo ,;
		SUM(retencioniva) 			as retencioniva,;
		SUM(iva) 					as iva,;
		SUM(renta)					as renta,;
		SUM(monto) 					as monto;
	FROM ;
		detalledocprov INNER JOIN DOCPROV ON detalleDOCPROV.idDOCPROV=DOCPROV.idDOCPROV;
		LEFT JOIN OC ON DETALLEDOCPROV.REFERENCIA=OC.NORDEN;
	GROUP BY;
		1,2,3;
	INTO CURSOR TEMPQD  READWRITE
	SELECT TEMPQD 
	SELECT OC
	
	APPEND FROM DBF('tempQD' )	 
ENDPROC 


PROCEDURE CERRCURSTEMP
	SELECT OC1 
	USE
	SELECT TEMPQD 
	USE 
	SELECT TEMPCC
	USE 
ENDPROC 

PROCEDURE VerVars
	llVarType=VARTYPE(gRETIVA)="U" OR VARTYPE(gIVA)="U" OR VARTYPE(gRENTA)="U" OR VARTYPE(gRETIVA13)="U"
	IF llVarType
		DO CONFIGAPP 
	ENDIF 
ENDPROC


