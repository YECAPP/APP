
PROCEDURE gencataconfig
LPARAMETERS tcProc2Execute
**11 may 2017 se agregó que se pudiera actualizar a voluntad solo una parte o varias
**13 enero 2014 procedimiento para cagar las cuentas mas comunes del archivo cataconfig y los parametros locales 
**Este procedimiento se encarga de generar un cursor temporal que permita establecer las cuentas de contabilidad 
**en la tabla cataconfig, de esta manera se garantiza que no se olvide alguna cuenta a configurar

**Creando el cursor temporal
CREATE CURSOR CataConfigTemp(;
	con1 c(25),;
	desc_doc c(80),;
	con2 c(25),;
	con3 c(25),;
	DESC_SIS c(80),;
	con4 c(25),;
	con5 c(25),;	
	desc_conta c(80),;
	resultado c(25),;
	precedencia c(25);
	)

IF VARTYPE(tcProc2Execute)="L"
	DO genCataConfigComplete
ELSE 
	LOCAL ARRAY taProc2Execute(1) 
	ArrayFromList(@taProc2Execute,tcProc2Execute)
	FOR lnProc2Execute=1 TO ALEN(taProc2Execute,1)
		lcProc2Execute=taProc2Execute(lnProc2Execute)
		DO &lcProc2Execute
	ENDFOR 
ENDIF 



DO PUTDESCRIPTION 
GO TOP 
MESSAGEBOX("mostrando cataconfigtemp")
BROWSE 

DO UPDATECATACONFIG  

SELECT cataconfig 
MESSAGEBOX("mostrando cataconfig")
BROWSE 

ENDPROC 

PROCEDURE genCataConfigComplete
	DO bancos 
	DO inventario 
	DO impuestos
	DO quedans
	DO FACTURAS 
	DO cajas 
	DO RETACEOS 
	DO PLANILLAS
ENDPROC 

PROCEDURE BANCOS
	**BANCOS 
	****CARGOS	
	**Todas las cuentas bancarias disponibles 
	**10 MAY 2017 SE AGREGÓ QUE SE ORDENARA POR CUENTA PARA FACILITAR LA  PUESTA DEL CODIGO CONTABLE
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT;
		 "04",;
		 "Cargos Banco",;
		 c.idbanco,;
		 c.idcuenta,;
		 ALLTRIM(b.descripcion)+ALLTRIM(c.numero),;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		bancos  as b INNER JOIN cuentasbancarias as c ON b.idbanco=c.idbanco ;
	UNION ALL ;&&INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia)
	SELECT;
		 "03",;
		 "Cheques ",;
		 c.idbanco,;
		 c.idcuenta,;
		 ALLTRIM(b.descripcion)+ALLTRIM(c.numero),;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		bancos  as b INNER JOIN cuentasbancarias as c ON b.idbanco=c.idbanco ;
	UNION ALL ;&&INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia)
	SELECT;
		 "05",;
		 "Notas de Cargo",;
		 c.idbanco,;
		 c.idcuenta,;
		 ALLTRIM(b.descripcion)+ALLTRIM(c.numero),;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		bancos  as b INNER JOIN cuentasbancarias as c ON b.idbanco=c.idbanco ;
	UNION ALL ;&&****ABONOS&&INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia)
	SELECT;
		 "16",;
		 "Abonos Banco",;
		 c.idbanco,;
		 c.idcuenta,;
		 ALLTRIM(b.descripcion)+ALLTRIM(c.numero),;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		bancos  as b INNER JOIN cuentasbancarias as c ON b.idbanco=c.idbanco ;
	UNION ALL ;&&INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia)
	SELECT;
		 "17",;
		 "Abonos Banco",;
		 c.idbanco,;
		 c.idcuenta,;
		 ALLTRIM(b.descripcion)+ALLTRIM(c.numero),;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		bancos  as b INNER JOIN cuentasbancarias as c ON b.idbanco=c.idbanco ;
	UNION ALL ;&&INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia)
	SELECT;
		 "18",;
		 "Abonos Banco",;
		 c.idbanco,;
		 c.idcuenta,;
		 ALLTRIM(b.descripcion)+ALLTRIM(c.numero),;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		bancos  as b INNER JOIN cuentasbancarias as c ON b.idbanco=c.idbanco ;
	order by 4

ENDPROC 

PROCEDURE inventario 
	**inventario 
	**SOLO ES UNA CUENTA
	**SE PODRIA HACER QUE CAMBIE LA CUENTA DE ACUERDO A LA BODEGA DE MATERIALES 
	**SE PODRIA HACER QUE CAMBIE LA CUENTA DE ACEURDO AL DOCUMENTO QUE APLICA 
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT distinct ;
		 "02",;
		 "Inventario",;
		 "",;
		 "",;
		 "Ocs, Oas, Oes, Dvs ",;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		documentos ;


ENDPROC 

PROCEDURE IMPUESTOS
****Ctas de impuestos 
**Por el lado de las compras y a ventas 

******IVA LOCAL COMPRAS
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT distinct ;
		 "IVALOCAL",;
		 "Iva por compras locales ",;
		 "",;
		 "",;
		 "Ocs, Ogs, Oes, y todo lo local",;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		documentos ;
		

	******RETENCION DE IVA COMPRAS
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT distinct ;
		 "RIVA",;
		 "Retencion de Iva 1% por compras",;
		 "",;
		 "",;
		 "Ocs, Ogs, Oes, y toda compra ",;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		documentos ;

	******RETENCION DE RENTA COMPRAS 
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT distinct ;
		 "RENTA",;
		 "Retencion de Renta en compras ",;
		 "",;
		 "",;
		 "Ogs, Oes, y toda compra ",;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		documentos ;

	******IVA VENTAS
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT distinct ;
		 "IVAVENTA",;
		 "Iva por ventas por facturas ",;
		 "08",;
		 "",;
		 "VNs CCFS, FFS, FES, NCS ",;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		documentos ;

	   &&04 nov 2014 El iva debe especificarse por documentos para que funciones 

		INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
		SELECT distinct ;
			"IVAVENTA",;
			DOCUMENTOS.NOMBRE,;
			DOCUMENTOS.IDDOC,;
			" ",;
			"",;
			" ",;
			" ",;
			"1";
		FROM ;
			DOCUMENTOS;
		WHERE ;
			DOCUMENTOS.LEGAL=.T.  AND !INLIST(DOCUMENTOS.IDDOC,"08","99") &&SE EXCLUYEN EL 08=VN Y 99=FU


		
	******RIVA VENTAS
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT distinct ;
		 "RIVAVENTA",;
		 "Retencion Iva por ventas con facturas ",;
		 "",;
		 "",;
		 "VNs CCFS, FFS, FES, NCS ",;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		documentos ;

	******RIVA VENTAS
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT distinct ;
		 "RENTAVENTA",;
		 "Retencion por ventas con facturas ",;
		 "",;
		 "",;
		 "VNs CCFS, FFS, FES, NCS ",;
		 "  ",;
		 "  ",;
		 "1";
	FROM ;
		documentos 

ENDPROC 

PROCEDURE quedans 
****QUEDANS SOLO PROVEEDORES QUE TENGAN MOVIMIENTO
**Por abril de 2016 se cambio para que unicamene incluya dos parametros 
**Los locales y los del exteror
INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
values (;
	 "06",;
	 "Proveedores Locales",;
	 "01",;
	 " ",;
	 " ",;
	 "  ",;
	 "  ",;
	 "1")

INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
values (;
	 "06",;
	 "Proveedores Exterior",;
	 "02",;
	 " ",;
	 " ",;
	 "  ",;
	 "  ",;
	 "1")

ENDPROC

PROCEDURE cajas 
	****CAJAS CHICAS
	*Caja chica, una cuenta por cada cja chica
	INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT distinct ;
		 "07",;
		 "CAJAS CHICAS",;
		 "",;
		 CAJAS.IDCAJA,;
		 CAJAS.DESCRIPCION,;
		 "  ",;
		 "  ",;
		 "1";		 
	FROM ;
		CAJAS 

ENDPROC 


PROCEDURE FACTURAS
**Contabilización de facturas, las facturas tienen una carácteristicas especiales 
**y es que son un documento autocontenido, esto quiere decir que la factura 
**genera su cargo y abono a partir del mismo documento
*La cuenta de cliente se genera del codigo de cliente
*la cuenta de ingresos de las lineas de las partidas
*11 may 2017 5:30 am se cambio para que cada linea d la partida genere un codigo diferente 
*de acuerdo a las siguientes cosas:
*Campo tp de facturaslines: 1:inventario 2:servicios 3:otros 
*este cabio se da a partir de que era necesario manejar una cuenta ajena para transx

**11 may 2017 Se sugiere que a futuro la factura identifique si o que tiene en referencia es una cuenta
*de catálogo y si lo es que la contabilize en esa cuenta, la fecha todavia no lo hace 

**Ventas Cuenta Base de Clientes 

INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
SELECT distinct ;
	 "08",;
	 "Cta Clientes de Facturas",;
	 " ",;
	 " ",;
	 " ",;
	 "  ",;
	 "  ",;
	 "1";
FROM ;
	Facturas 


**Facturas por tipo CTA DE INGRESO EJP 511

**INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
SELECT distinct ;
	DOCUMENTOS.IDDOC,;
	DOCUMENTOS.NOMBRE,;
	DEPARTAMENTOS.IDDEPTO,;
	" ",;
	DEPARTAMENTOS.NOMBRE,;
	" ",;
	" ",;
	"1";
FROM ;
	DOCUMENTOS, DEPARTAMENTOS;
WHERE ;
	DOCUMENTOS.LEGAL=.T.  AND !INLIST(DOCUMENTOS.IDDOC,"08","99")

**11 MAYO 2017 5:00 AM SE AGREGÓ QUE PUDIERA CREARSE UNA CONDICIONAL POR TIPO DE PRODUCTO FACTURADO
**INVENTARIO 
INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
SELECT distinct ;
	DOCUMENTOS.IDDOC,;
	DOCUMENTOS.NOMBRE,;
	DEPARTAMENTOS.IDDEPTO,;
	"1",;
	DEPARTAMENTOS.NOMBRE,;
	" ",;
	" ",;
	"1";
FROM ;
	DOCUMENTOS, DEPARTAMENTOS;
WHERE ;
	DOCUMENTOS.LEGAL=.T.  AND !INLIST(DOCUMENTOS.IDDOC,"08","99");
UNION ALL ; &&SERVICIOS
SELECT distinct ;
	DOCUMENTOS.IDDOC,;
	DOCUMENTOS.NOMBRE,;
	DEPARTAMENTOS.IDDEPTO,;
	"2",;
	DEPARTAMENTOS.NOMBRE,;
	" ",;
	" ",;
	"1";
FROM ;
	DOCUMENTOS, DEPARTAMENTOS;
WHERE ;
	DOCUMENTOS.LEGAL=.T.  AND !INLIST(DOCUMENTOS.IDDOC,"08","99");
UNION ALL ; &&OTROS 
SELECT distinct ;
	DOCUMENTOS.IDDOC,;
	DOCUMENTOS.NOMBRE,;
	DEPARTAMENTOS.IDDEPTO,;
	"3",;
	DEPARTAMENTOS.NOMBRE,;
	" ",;
	" ",;
	"2";
FROM ;
	DOCUMENTOS, DEPARTAMENTOS;
WHERE ;
	DOCUMENTOS.LEGAL=.T.  AND !INLIST(DOCUMENTOS.IDDOC,"08","99");
ORDER BY 3,4



ENDPROC 

PROCEDURE RETACEOS 
**Retaceos 
*Cotabilizacion de los retaceos, se refiere a la cuenta que se aplica cuando los retaceos se hacen 
*y se ingresan a inventario, generalmente es la cuenta de pedidosen transito 
INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
values (;
	 "0203",;
	 "Cuenta para Retaceos",;
	 " ",;
	 " ",;
	 " ",;
	 "  ",;
	 "  ",;
	 "1")


ENDPROC 


PROCEDURE PLANILLAS
**Retaceos 
*Cotabilizacion de los retaceos, se refiere a la cuenta que se aplica cuando los retaceos se hacen 
*y se ingresan a inventario, generalmente es la cuenta de pedidosen transito 
INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
values (;
	 "4903",;
	 "Planillas",;
	 "BANCO",;
	 " ",;
	 " ",;
	 "  ",;
	 "  ",;
	 "1")


INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
values (;
	 "4903",;
	 "Planillas",;
	 "AFP",;
	 " ",;
	 " ",;
	 "  ",;
	 "  ",;
	 "1")

INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
values (;
	 "4903",;
	 "Planillas",;
	 "ISSS",;
	 " ",;
	 " ",;
	 "  ",;
	 "  ",;
	 "1")

INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
values (;
	 "4903",;
	 "Planillas",;
	 "RENTA",;
	 " ",;
	 " ",;
	 "  ",;
	 "  ",;
	 "1")

INSERT INTO CataConfigTemp(con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
	SELECT ;
		"4903",;
		"Planillas"+departamentos.NOMBRE,;
		ALLTRIM(departamentos.iddepto),;
		"SUELDOBASE",;
		" ",;
		"  ",;
		"  ",;
		"1";
	FROM ;
		departamentos;
	UNION ALL ;
	SELECT ;
		"4903",;
		"Planillas"+departamentos.NOMBRE,;
		ALLTRIM(departamentos.iddepto),;
		"HEXTRA",;
		" ",;
		"  ",;
		"  ",;
		"1";
	FROM ;
		departamentos;
	UNION ALL ;
	SELECT ;
		"4903",;
		"Planillas"+departamentos.NOMBRE,;
		ALLTRIM(departamentos.iddepto),;
		"SALEXTRA",;
		" ",;
		"  ",;
		"  ",;
		"1";
	FROM ;
		departamentos;
	ORDER BY 1,3,2,4






ENDPROC 




PROCEDURE PUTDESCRIPTION
**poniendo la descripcion de conta 	y la cuenta de acuerdo a la que se ingreso 
SELECT cataconfigtemp
GO TOP 
SCAN 
	RELEASE laCataConfig,laNombre 
	SELECT RESULTADO;
	FROM ;
		CATACONFIG;
	WHERE ;
		IIF(EMPTY(cataconfigtemp.con1),.t.,CON1=cataconfigTemp.con1) AND ;
		IIF(EMPTY(cataconfigtemp.con2),.t.,CON2=cataconfigTemp.con2) AND ;
		IIF(EMPTY(cataconfigtemp.con3),.t.,CON3=cataconfigTemp.con3); 
	INTO ARRAY ;
		laCataConfig


		
	IF VARTYPE(laCataConfig)="U"
	ELSE
		lcResultado=laCataConfig
		SELECT nombre FROM cataconta WHERE UPPER(ALLTRIM(codigo))==UPPER(ALLTRIM(lcResultado)) INTO ARRAY laNombre 
		IF VARTYPE(laNombre)="U"
			lcNombre="No existe la cuenta"
		ELSE
			lcNombre=laNombre 
		ENDIF 
		
		replace resultado WITH lcResultado, desc_conta with lcNombre IN cataconfigtemp
		
	ENDIF 

ENDSCAN

ENDPROC 

PROCEDURE UPDATECATACONFIG 
SCAN 
	RELEASE laCataconfig 
	
	SELECT RESULTADO;
	FROM ;
		CATACONFIG;
	WHERE ;
		IIF(EMPTY(cataconfigtemp.con1),.t.,CON1=cataconfigTemp.con1) AND ;
		IIF(EMPTY(cataconfigtemp.con2),.t.,CON2=cataconfigTemp.con2) AND ;
		IIF(EMPTY(cataconfigtemp.con3),.t.,CON3=cataconfigTemp.con3); 
	INTO ARRAY ;
		laCataConfig


	*SELECT * ;
	FROM ;
		CATACONFIG;
	WHERE ;
		IIF(EMPTY(cataconfigtemp.con1),.t.,CON1=cataconfigTemp.con1) AND ;
		IIF(EMPTY(cataconfigtemp.con2),.t.,CON2=cataconfigTemp.con2) AND ;
		IIF(EMPTY(cataconfigtemp.con3),.t.,CON3=cataconfigTemp.con3)
	
	
	IF VARTYPE(laCataConfig)="U"
		INSERT INTO cataconfig(;
			con1,desc_doc,con2,con3,desc_sis,desc_conta,resultado,precedencia);
		values (;
			cataconfigtemp.con1,cataconfigtemp.desc_doc,cataconfigtemp.con2,cataconfigtemp.con3,cataconfigtemp.desc_sis,cataconfigtemp.desc_conta,cataconfigtemp.resultado,cataconfigtemp.precedencia)
	ELSE 
		UPDATE ;
			CATACONFIG ;
		SET ;
			RESULTADO=CATACONFIGTEMP.RESULTADO,;
			PRECEDENCIa=CATACONFIGTEMP.PRECEDENCIA,;
			DESC_DOC=CATACONFIGTEMP.DESC_DOC,;
			DESC_SIS=CATACONFIGTEMP.DESC_SIS,;
			DESC_CONTA=CATACONFIGTEMP.DESC_CONTA;
		WHERE ;
			IIF(EMPTY(cataconfigtemp.con1),.t.,CON1=cataconfigTemp.con1) AND ;
			IIF(EMPTY(cataconfigtemp.con2),.t.,CON2=cataconfigTemp.con2) AND ;
			IIF(EMPTY(cataconfigtemp.con3),.t.,CON3=cataconfigTemp.con3)
			
	ENDIF 

ENDSCAN

ENDPROC 