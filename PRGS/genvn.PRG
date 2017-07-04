PROCEDURE GENVN 
	LPARAMETERS lcIdventa,lnMonto,lniva,lnRetIva,lcRetencion
	IF PCOUNT()=5
		lbCallWith5=.t.
	ELSE
		lbCallWith5=.f.
	ENDIF 
	
	DO OPENTABLAS 
	SET SQLBUFFERING ON 
	SET DELETED ON 
	
	IF lbCallWith5
		lnTotal=lnMonto+lniva &lcRetencion lnRetIva
	ELSE
		lnTotal=vtmaestro.siva+vtmaestro.sneto &lcRetencion vtmaestro.sriva
	ENDIF 

*	lnTotal=IIF(!EMPTY(lnMonto),,)
	IF VARTYPE(lnTotal)="X"
		lnTotal=0.00
	ENDIF 
	
	lnRetIva=IIF(lbCallWith5,lnRetIva,vtmaestro.sriva) 
	lnSubTotal=IIF(lbCallWith5,lnMonto+lnIva,vtmaestro.siva+vtmaestro.sneto)
	lnIva=IIF(lbCallWith5,lnIva,vtmaestro.SIVA )
	lnMonto=IIF(lbCallWith5,lnMonto,vtmaestro.sneto)
*********************************
**calculo de valores segun documento 
**09 Factura Consumidor Final 10 Credito Fiscal Venta                    
**11 Nota de Credito Fiscal 12 Nota de Debito
**13 Factura de Exportacion 14 Nota de Remision
**15 Retencion de iva
**23/01/2011 3:39 pm yec 	
    
**10/06/2013 poner decimales 
**29/05/2017 se agrego que guse diferentes decimales para detalle y total 
	lnPrecisionDet=gnDecimals4FactDet
	lnPrecisionTot=gnDecimals4Fact
**29/05/2017 se agrego que guse diferentes decimales para detalle y total 	
**10/06/2013 poner decimales 
	   
	   

	
	SELECT IDDOC FROM FACTURAS WHERE IDVENTA=lcIdventa INTO ARRAY laFactIdDoc
	
	IF !VARTYPE(laFactIdDoc)="U"
		lcIdoc=laFactIdDoc
	ELSE 
		lcIdoc=""
	ENDIF 


	IF INLIST(lcIdoc,"09","13")
		lnIva=0.00
		lnMonto=lnTotal+lnRetIva
	ENDIF 



	
	DO CASE
	CASE lcIdoc="15" 
		SELECT;
			FACTURAS.IDVENTA 									AS IDVENTA,;		
			SUBSTR(FACTURAS.NUMERO,3,8)							AS NUMERO,;
			FACTURAS.NUMERO										AS ANUMERO,;
			FACTURAS.NUMERO2									AS ANUMERO2,;
			FACTURAS.TIVA										AS TIVA,;
			FACTURAS.TRIVA										AS TRIVA,;
			FACTURAS.MRIVA										AS MRIVA,;			
			FACTURAS.IVA										AS LBIVA ,;
			FACTURAS.RETENCIONIVA								AS LBRIVA ,;
			FACTURAS.IDDOC 										AS IDDOC,;
			FACTURAS.EXENTO										AS EXENTO,;
			facturas.idproy										AS PROYECTO,;			
			CAST(ALLTRIM(IIF(gbShowClientInFactPrinted=.t.,FACTURAS.IDCLIENTE,""))+" "+ALLTRIM(NOMBRE2(FACTURAS.IDCLIENTE)) AS C(80))	as cliente,;
			proveedores.DIRECCION 									as direccion,;		
			CAST(MUNI(proveedores.IDMUNI) AS CHAR(30))		as municipio,; 	
			CAST(DEPTO(proveedores.iddepartamento) AS CHAR(30))		as DEPARTAMENTO,;
			proveedores.NIT										AS NIT,;
			"    		"										AS DUI,;	
			FACTURAS.FECHA										AS FECHA,;
			CAST(FORMAPAGO(FACTURAS.FPAGO) AS CHAR(20))			AS FORMAPAGO,;
			proveedores.REGISTRO									AS REGISTRO,;
			CAST(GIRO(proveedores.REGISTRO)   AS CHAR(80))			as GIRO,;
			CAST(CONVNUM(lnRetIva ) AS CHAR(40))	AS MONTOLETRAS,;
			CAST(DOCUMENTO(FACTURAS.IDDOC) 	AS CHAR(40) )		AS DOCUMENTO,;
			CAST(CORREL(FACTURAS.IDAUTOCORREL2) as char(10))	AS IDAUTOCORREL2,;
			SUBSTR(FACTURAS.NUMERO2,3,8) 						AS NUMERO2,;
			FACTURAS.SOLICITANTE								AS SOLICITANTE,;
			FACTURAS.DEPTO										AS DEPTO,;
			CAST(IIF(FACTURAS.EXENTO=.T.,lnMonto,0.00) 	as n(12,lnPrecisionTot) null )	AS EXENTAS,;
			CAST(IIF(FACTURAS.EXENTO=.F.,lnMonto,0.00) 	as n(12,lnPrecisionTot) null )	AS SUMAS,;
			CAST(lnIva		as n(12,lnPrecisionTot) null)					AS IVA,;
			CAST(IIF(FACTURAS.EXENTO=.F.,lnSubTotal,0.00) 	as n(12,lnPrecisionTot) null )	AS SUBTOTAL,;
			CAST(lnRetIva 	as n(12,lnPrecisionTot) null)						AS IVARET,;
			CAST(lnTotal 	as n(12,lnPrecisionTot) null )						AS MONTO,;
			NVL(PROYECTOS.NOMBRE,"   ")							AS PROYNOMB,;				
			NVL(PROYECTOS.ENCARGA,"   ")							AS ENCARGA;				
		FROM; 
			FACTURAS LEFT  JOIN proveedores ON FACTURAS.IDCLIENTE=proveedores.idprov;
						LEFT JOIN PROYECTOS ON FACTURAS.IDPROY=PROYECTOS.IDPROYECTOS;
		WHERE ;
			FACTURAS.IDVENTA=lcIdventa;
		INTO CURSOR ;
			VN READWRITE 
	OTHERWISE
		SELECT;
			FACTURAS.IDVENTA 									AS IDVENTA,;		
			SUBSTR(FACTURAS.NUMERO,3,8)							AS NUMERO,;
			FACTURAS.NUMERO										AS ANUMERO,;
			FACTURAS.NUMERO2									AS ANUMERO2,;			
			FACTURAS.TIVA										AS TIVA,;
			FACTURAS.TRIVA										AS TRIVA,;
			FACTURAS.MRIVA										AS MRIVA,;			
			FACTURAS.IVA										AS LBIVA ,;
			FACTURAS.RETENCIONIVA								AS LBRIVA ,;
			FACTURAS.IDDOC 										AS IDDOC,;
			FACTURAS.EXENTO										AS EXENTO,;
			facturas.idproy										AS PROYECTO,;
			CAST(IIF(gbShowClientInFactPrinted=.t.,FACTURAS.IDCLIENTE,"")+" "+NOMBRE(FACTURAS.IDCLIENTE) AS C(80))	as cliente,;
			IIF(EMPTY(FACTURAS.DIRECCION),CLIENTES.DIRECCION,FACTURAS.DIRECCION)as direccion,;		
			CAST(MUNI(CLIENTES.IDMUNICIPIO) AS CHAR(30))		as municipio,; 	
			CAST(DEPTO(CLIENTES.IDDEPARTAMENTO) AS CHAR(30))		as DEPARTAMENTO,;
			CLIENTES.NIT										AS NIT,;
			"    		"										AS DUI,;	
			FACTURAS.FECHA										AS FECHA,;
			CAST(FORMAPAGO(FACTURAS.FPAGO) AS CHAR(20))			AS FORMAPAGO,;
			CLIENTES.REGISTRO									AS REGISTRO,;
			CAST(GIRO(CLIENTES.REGISTRO)   AS CHAR(80))			as GIRO,;
			CAST(CONVNUM(lnTotal) AS CHAR(90))	AS MONTOLETRAS,;
			CAST(DOCUMENTO(FACTURAS.IDDOC) 	AS CHAR(40) )		AS DOCUMENTO,;
			CAST(CORREL(FACTURAS.IDAUTOCORREL2) as char(10))	AS IDAUTOCORREL2,;
			SUBSTR(FACTURAS.NUMERO2,3,8) 						AS NUMERO2,;
			FACTURAS.SOLICITANTE								AS SOLICITANTE,;
			FACTURAS.DEPTO										AS DEPTO,;
			CAST(IIF(FACTURAS.EXENTO=.T.,lnMonto,0.00) 	as n(12,lnPrecisionTot) null )	AS EXENTAS,;
			CAST(IIF(FACTURAS.EXENTO=.F.,lnMonto,0.00) 	as n(12,lnPrecisionTot) null )	AS SUMAS,;
			CAST(lnIva		as n(12,lnPrecisionTot) null)					AS IVA,;
			CAST(IIF(FACTURAS.EXENTO=.F.,lnSubTotal,0.00) 	as n(12,lnPrecisionTot) null )	AS SUBTOTAL,;
			CAST(lnRetIva 	as n(12,lnPrecisionTot) null)						AS IVARET,;
			CAST(lnTotal 	as n(12,lnPrecisionTot) null )						AS MONTO,;
			NVL(PROYECTOS.NOMBRE,"   ")							AS PROYNOMB,;				
			NVL(PROYECTOS.ENCARGA,"   ")							AS ENCARGA;				
		FROM; 
			FACTURAS LEFT  JOIN CLIENTES ON FACTURAS.IDCLIENTE=CLIENTES.IDCLIENTE;
					LEFT JOIN PROYECTOS ON FACTURAS.IDPROY=PROYECTOS.IDPROYECTOS;
		WHERE ;
			FACTURAS.IDVENTA=lcIdventa;
		INTO CURSOR ;
			VN READWRITE 
	ENDCASE

	IF INLIST(lcIdoc,"09","13")
		SELECT ;
			FACTURASLINES.IDVENTA,;
			REFERENCIA,;
			CAST(ROUND(cantidad,lnPrecisionDet) as n(12,lnPrecisionDet)) as cantidad,;
			CAST(facturaslines.descripcion as c(gnAnchoDetFacts)) as descripcion,;
			CAST(IIF(FACTURAS.EXENTO=.T.,ROUND(PRECIO,lnPrecisionDet),ROUND(PRECIO*(1+IIF(VN.LBIVA=.T.,VN.TIVA,0.00)),lnPrecisionDet)) as n(12,lnPrecisionDet))as precio,;
			CAST(IIF(FACTURAS.EXENTO=.T.,ROUND(cantidad*PRECIO,lnPrecisionDet),0.00) as n(12,lnPrecisionDet)) AS VENTASEXENTAS,;
			CAST(IIF(FACTURAS.EXENTO=.T.,0.00,ROUND(ROUND(cantidad,lnPrecisionDet)*ROUND(PRECIO*(1+IIF(VN.LBIVA=.T.,VN.TIVA,0.00)),lnPrecisionDet)   ,lnPrecisionTot)) as n(12,lnPrecisionTot)) AS VENTASAFECTAS;
		FROM ;
			FACTURASLINES LEFT JOIN FACTURAS ON FACTURASLINES.IDVENTA=FACTURAS.IDVENTA;
		WHERE;
			FACTURASLINES.IDVENTA=lcIdventa;
		INTO CURSOR ;
			VNDET readwrite
			
	ELSE
		SELECT ;
			FACTURASLINES.IDVENTA,;
			REFERENCIA,;
			CAST(ROUND(cantidad,lnPrecisionDet) as n(12,lnPrecisionDet)) as cantidad,;
			CAST(facturaslines.descripcion as c(gnAnchoDetFacts)) as descripcion,;
			CAST(ROUND(precio,lnPrecisionDet) as n(12,lnPrecisionDet))as precio,;
			CAST(IIF(FACTURAS.EXENTO=.T.,ROUND(cantidad*PRECIO,lnPrecisionTot),0.00) as n(12,lnPrecisionDet)) AS VENTASEXENTAS,;
			CAST(IIF(FACTURAS.EXENTO=.T.,0.00,ROUND(cantidad*PRECIO,lnPrecisionTot)) as n(12,lnPrecisionTot)) AS VENTASAFECTAS;
		FROM ;
			FACTURASLINES LEFT JOIN FACTURAS ON FACTURASLINES.IDVENTA=FACTURAS.IDVENTA;
		WHERE;
			FACTURASLINES.IDVENTA=lcIdventa;
		INTO CURSOR ;
			VNDET readwrite
	ENDIF 

	LNNOLINESALLOWED=GETNOLINES(lcIdoc)
	lnLines=RECCOUNT("VNDET")
	FOR n=1 TO LNNOLINESALLOWED-lnLines
		
		INSERT INTO vndet;
			(referencia,IDVENTA) ;
			VALUES ;
			(SPACE(10),lcIdventa)
	ENDFOR  	
	
	
IF lcIdoc="14"
	IF FILE("DATA\VNDEPOTNR.DBF")
	DELETE FROM VNDEPOTNR 
		
	INSERT INTO VNDEPOTNR ;
		SELECT ;
			VN.*,;
			VNDET.REFERENCIA,;
			VNDET.CANTIDAD,;
			VNDET.DESCRIPCION,;				
			VNDET.PRECIO,;				
			VNDET.VENTASEXENTAS,;
			VNDET.VENTASAFECTAS;												
		FROM ;
			VN INNER JOIN VNDET ON VN.IDVENTA=VNDET.IDVENTA 
		
	ENDIF 

ELSE 


	***YEC

	
	IF FILE("DATA\VNDEPOT.DBF")
		DELETE FROM VNDEPOT 
		INSERT INTO VNDEPOT ;
			SELECT ;
				VN.*,;
				VNDET.REFERENCIA,;
				VNDET.CANTIDAD,;
				VNDET.DESCRIPCION,;				
				VNDET.PRECIO,;				
				VNDET.VENTASEXENTAS,;
				VNDET.VENTASAFECTAS;												
			FROM ;
				VN INNER JOIN VNDET ON VN.IDVENTA=VNDET.IDVENTA 
	ENDIF 
ENDIF 
	
**FIN CREAR CURSOR VNDEPOT
	SELECT VNDET 

ENDPROC 



PROCEDURE OPENTABLAS
	
	IF !USED("FACTURAS")
		USE FACTURAS  IN 0
	ENDIF 
	IF !USED("FACTURASLINES")
		USE FACTURASLINES IN 0
	ENDIF 

	IF !USED("FORMAPAGOPRESUP")
		USE FORMAPAGOPRESUP IN 0
	ENDIF 

	IF !USED("CLIENTES")
		USE CLIENTES IN 0
	ENDIF 

	IF !USED("CONTRIBUYENTES")
		USE CONTRIBUYENTES IN 0
	ENDIF 
	IF !USED("CLIENTES")
		USE CLIENTES IN 0
	ENDIF 
	IF !USED("MUNICIPIOS")
		USE MUNICIPIOS IN 0
	ENDIF 
	IF !USED("DEPART")
		USE DEPART IN 0
	ENDIF 

	IF !USED("personnaturales")
		USE personnaturales IN 0
	ENDIF 
	IF !USED("documentos")
		USE documentos IN 0
	ENDIF 

	IF !USED("autocorrel")
		USE autocorrel IN 0
	ENDIF 

	IF !USED("PROVEEDORES")
		USE PROVEEDORES IN 0
	ENDIF 

ENDPROC 

PROCEDURE CORREL
LPARAMETERS lcFactura_IdAutoCorrel2
	RETURN UPPER(IIF(SEEK(lcFactura_IdAutoCorrel2,"autocorrel","IDAUTOCORR"),autocorrel.autorizacion,""))
ENDPROC 


PROCEDURE DOCUMENTO
LPARAMETERS lcFactura_IdDoc
	RETURN IIF(SEEK(lcFactura_IdDoc,"documentos","iddoc"),documentos.nombre,"")
ENDPROC 


PROCEDURE FORMAPAGO
LPARAMETERS lcFactura_Fpago
	RETURN IIF(SEEK(lcFactura_Fpago,"FORMAPAGOPRESUP","idfpago"),FORMAPAGOPRESUP.descripcion,"")
ENDPROC 

PROCEDURE GIRO
LPARAMETERS lcClientes_Registro
	RETURN IIF(SEEK(lcClientes_Registro,"contribuyentes","registro"),contribuyentes.giro,"")
ENDPROC 

PROCEDURE MUNI
LPARAMETERS lcClientes_Idmunicipio
	RETURN IIF(SEEK(lcClientes_Idmunicipio,"municipios","idmunicipi"),municipios.DESCRIPCION,"")
ENDPROC 


PROCEDURE DEPTO
LPARAMETERS lcClientes_Departamento
	RETURN IIF(SEEK(lcClientes_Departamento,"depart","iddepart"),depart.nombre,"")
ENDPROC 

PROCEDURE NOMBRE
LPARAMETERS lcIdCliente
	LOCAL lcRegistro,lcNit
	IF gcTpNombreInFact="1"  &&11 SEP FACTURAR CON NOMBRE DE CLIENTE 
	
		lcRegistro=IIF(SEEK(lcIdCliente,"clientes","idcliente"),ALLTRIM(clientes.registro),"")
		IF !EMPTY(lcRegistro)
			lcNombre=IIF(SEEK(lcRegistro,"contribuyentes","registro"),ALLTRIM(contribuyentes.nombre),"")
		ELSE &&tiene nit?
			lcNit=IIF(SEEK(lcIdCliente,"clientes","idcliente"),ALLTRIM(clientes.nit),"")
			IF !EMPTY(lcNit)
				lcNombre=IIF(SEEK(lcNit,"personnaturales","NIT"),ALLTRIM(personnaturales.apellidoS)+" "+ALLTRIM(personnaturales.nombre),"")
			else 
				lcNombre=IIF(SEEK(lcIdCliente,"clientes","idCliente"),ALLTRIM(clientes.nombre),"")
			ENDIF 
		ENDIF 
	ELSE
		SELECT NOMBRE FROM CLIENTES WHERE ALLTRIM(IDCLIENTE)==ALLTRIM(lcIdCliente) INTO ARRAY LANOMBRE 
		IF VARTYPE(LANOMBRE)="U"
			lcNombre=""
		ELSE
			lcNombre=LANOMBRE
		ENDIF 
	ENDIF 
	RETURN lcNombre
ENDPROC 


PROCEDURE NOMBRE2
LPARAMETERS lcIdProv
	LOCAL lcRegistro,lcNit
	IF gcTpNombreInFact="1"  &&11 SEP FACTURAR CON NOMBRE DE CLIENTE 
		lcRegistro=IIF(SEEK(lcIdProv,"proveedores","idprov"),ALLTRIM(proveedores.registro),"")
		IF !EMPTY(lcRegistro)
			lcNombre=IIF(SEEK(lcRegistro,"contribuyentes","registro"),ALLTRIM(contribuyentes.nombre),"")
		ELSE &&tiene nit?
			lcNit=IIF(SEEK(lcIdProv,"proveedores","idprov"),ALLTRIM(proveedores.nit),"")
			IF !EMPTY(lcNit)
				lcNombre=IIF(SEEK(lcNit,"personnaturales","NIT"),ALLTRIM(personnaturales.apellidoS)+" "+ALLTRIM(personnaturales.nombre),"")
			else 
				lcNombre=IIF(SEEK(lcIdProv,"proveedores","idprov"),ALLTRIM(proveedores.nombre),"")
			ENDIF 
		ENDIF 
	ELSE
		SELECT NOMBRE FROM PROVEEDORES WHERE ALLTRIM(IDPROV)==ALLTRIM(lcIdCliente) INTO ARRAY LANOMBRE 
		IF VARTYPE(LANOMBRE)="U"
			lcNombre=""
		ELSE
			lcNombre=LANOMBRE
		ENDIF 
	ENDIF 
	RETURN lcNombre
ENDPROC 