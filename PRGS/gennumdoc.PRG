*******************************************************	*
*Grupo:   generadores de documentos 					*
*14/09/2012 se agrego documento 8101 control de contratos 
*Fecha: 25/mar/09										*
*Uso: 	Genera el numero de los siguientes documentos:	*
*		a)Orden de Compra(02)							*
*		b)Cheque(03)									*
*		C)Idcargo(04) 									*
*Llamado por: Creacion de orden de compra cheque etc	*
*********************************************************

PROCEDURE genNumDoc
PARAMETERS lcIdDoc,lcIdCuenta
**Setear estado a exacto 
SET EXACT ON 

DO CASE 
CASE lcIddoc="02" &&orden de compra CH00000006

	SELECT NVL(MAX(SUBSTR(NORDEN,3,8)),"0") AS Num FROM Ordencompra WHERE SUBSTR(NORDEN,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  

CASE lcIddoc="03" &&Cheque 
	&&variables a utilizar 
	LOCAL lcChequera,lnInicia,lnFinaliza
	&&getChequeraActiva() verifica el estado de la chequera activa 
	lcChequera=getChequeraActiva(lcIdCuenta) &&Retorna la chequera activa de la cuenta pasada 

	IF !ISNULL(lcChequera)

		SELECT ;
			Inicia,;
			Finaliza;
		FROM ;
			chequeras;
		where ;
			idChequera=lcChequera;
		into cursor ;
			TempRangoCh
		
		lnInicia=TempRangoCh.Inicia
		lnFinaliza=TempRangoCh.Finaliza
		SELECT NVL(MAX(SUBSTR(Referencia,3,8)),"0") AS Num  FROM CargosBanco WHERE IdChequera=lcChequera AND SUBSTR(referencia,1,2)="CH" INTO CURSOR Documento
		*si el valor maximo esta entre el inciio y el fin de la chequera y no hay chqueras duplicadas ;
		o no estan todas las chequera inactivas returnar el valor masuno 
		DO CASE
		CASE 	BETWEEN(VAL(Documento.num)+1,lnInicia,lnFinaliza) AND; 	&&Esta entre el rango de la chequera
				VAL(documento.num)!=0 								&&Es diferente de 0 es decir la chequera inicia
				RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
		CASE 	VAL(documento.num)=0 &&chequera inicia 
				RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(lnInicia)),8,"0") &&retornar valor inicial configurado en la chequera
		CASE 	VAL(documento.num)=lnFinaliza &&la chequera se termino 
				UPDATE chequeras SET Activa=.f. WHERE idchequera=lcChequera
				MESSAGEBOX("la Chequera se ha agotado, Abra El modulo de cuentas bancaias e introduzca una nueva chequera",64,"Chequera se agoto")
				RETURN .null.
		OTHERWISE
				MESSAGEBOX("Hubo un Error en la generacion del cheque a Emitir",16,"Error")
				RETURN .null.
		ENDCASE
	ELSE 
		MESSAGEBOX("Revise el modulo de cuentas bancarias en el apartado de chequera y verifique que existan"+CHR(13)+;
					"Chequeras activas o que no esten dos activas al mismo tiempo",64,"Atencion")
		RETURN .null.
	ENDIF 
CASE lcIddoc="04" &&IdCargo tabla CargoBancos
	SELECT NVL(MAX(SUBSTR(idCargo,3,8)),"0") AS Num  FROM CargosBanco WHERE SUBSTR(idcargo,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="05" &&nOTA DE cARGO tabla CargoBancos
	SELECT NVL(MAX(SUBSTR(Referencia,3,8)),"0") AS Num  FROM CargosBanco WHERE SUBSTR(Referencia,1,2)="NC" INTO CURSOR Documento
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="06" &&QUEDAN EN tabla DOCPROV
	SELECT NVL(MAX(SUBSTR(IDDOCPROV,3,8)),"0") AS Num  FROM DOCPROV WHERE SUBSTR(IDDOCPROV,1,2)="QD" INTO CURSOR Documento
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="07" &&CAJA CHICA EN TABLA CC
	SELECT NVL(MAX(SUBSTR(IDCC,3,8)),"0") AS Num  FROM CC WHERE SUBSTR(IDCC,1,2)="CC" INTO CURSOR Documento
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="08" &&idventa tabla facturas 
	&&05 DE MAYO 2016 ADD MULTIPLES USUARIOS PUEDAN FACTURAR AL MISMO TIEMPO, SE HIZO PARA EQUICON 
	*SELECT NVL(MAX(SUBSTR(IDVENTA,3,8)),"0") AS Num  FROM FACTURAS WHERE SUBSTR(IDVENTA,1,2)="VN" INTO CURSOR Documento

	*RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
	**se debe haber creaado en mayo 2016 por que no se ha creado el nuevo formulario de factura, por eso cuando se ejecuto 
	**	DO INSERTDOCNUM WITH "08" IN altertable2 dio error por que estaba redundando, se resuelve corrigiendo el error en INSERTDOCNUM  en altertable2.prg
	lcId=nuevoid("08")
	RETURN lcId
	
CASE INLIST(lciddoc,"99","09","10","11","12","13","14","15") &&Consumidor Final, Credito Fiscal,Nota de CRedito,Nota de Debito,Factura de Exportacion,Nota de Remision,Retencion de Iva	
	&&variables a utilizar 
	LOCAL lcAutoCorrel,lnInicia,lnFinaliza
	&&getChequeraActiva() verifica el estado de la chequera activa 
	lcAutoCorrel=getAutoCorrelActivo(lcIdDoc) &&Retorna el correlativo activo de la cuenta pasada 
	
	IF !ISNULL(lcAutoCorrel)
		SELECT ;
			Inicia,;
			Finaliza;
		FROM ;
			AutoCorrel;
		WHERE ;
			idAutoCorrel=lcAutoCorrel;
		INTO CURSOR ;
			TempRangoAutoCorrel
		lnInicia=TempRangoAutoCorrel.Inicia
		lnFinaliza=TempRangoAutoCorrel.Finaliza
		
		IF !lcIdDoc="99"
			SELECT NVL(MAX(SUBSTR(Numero,3,8)),"0") AS Num  FROM Facturas WHERE IdAutoCorrel=lcAutoCorrel INTO CURSOR Documento
			*si el valor maximo esta entre el inciio y el fin de correlativo y no hay correlativos duplicados ;
			o no estan todos los correlativos inactivos retornar el valor mas uno 
		ELSE 
			SELECT NVL(MAX(SUBSTR(Numero2,3,8)),"0") AS Num  FROM Facturas WHERE IdAutoCorrel2=lcAutoCorrel INTO CURSOR Documento
		ENDIF 

						
		DO CASE
		CASE 	BETWEEN(VAL(Documento.num)+1,lnInicia,lnFinaliza) AND; 			&&Esta entre el rango del correlativo
				VAL(documento.num)!=0 											&&Es diferente de 0 es decir el correlativo no inicia
				
				RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

		CASE 	VAL(documento.num)=0 											&&correlativo inicia 
				
				RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(lnInicia)),8,"0") 					&&retornar valor inicial configurado en el correlativo

		CASE 	VAL(documento.num)=lnFinaliza-10							 	&&El correlativo esta a punto de terminarse  

				RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
				MESSAGEBOX("El Correlativo Esta a punto de agostarse, Solicite autorizacion al Ministerio de Hacienda",64,"Correlativo se esta Agotando")

		CASE 	VAL(documento.num)=lnFinaliza 									&&El Correlativo se ha terminado
				UPDATE AutoCorrel SET Activa=.f. WHERE idAutoCorrel=lcAutoCorrel
				MESSAGEBOX("El Correlativo se ha agotado, Abra El modulo de Correlativos e introduzca uno nuevo ",64,"Correlativo se agoto")
				RETURN .null.
		OTHERWISE
				MESSAGEBOX("Hubo un Error en la generacion del Correlativo",16,"Error")
				RETURN .null.
		ENDCASE
	ELSE 
		MESSAGEBOX("Revise el modulo de Correlativo en el apartado de Correlativos y verifique que existan"+CHR(13)+;
					"Activas o que no esten dos activos al mismo tiempo",64,"Atencion")
		RETURN .null.
	ENDIF 
CASE lcIddoc="16" &&idabono tabla tabla abonosbanco  
	SELECT NVL(MAX(SUBSTR(IDABONO,3,8)),"0") AS Num  FROM ABONOSBANCO WHERE SUBSTR(IDabono,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="17" &&Remesas tabla tabla abonosbanco 
	SELECT NVL(MAX(SUBSTR(referencia,3,8)),"0") AS Num  FROM ABONOSBANCO WHERE SUBSTR(referencia,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="18" &&Nota de Abono tabla abonosbanco
	SELECT NVL(MAX(SUBSTR(referencia,3,8)),"0") AS Num  FROM ABONOSBANCO WHERE SUBSTR(referencia,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="19" &&Rentas 10%
	SELECT NVL(MAX(SUBSTR(idrenta,3,8)),"0") AS Num  FROM retencionesrenta WHERE SUBSTR(idrenta,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="20" &&Otros Ingresos 
	SELECT NVL(MAX(SUBSTR(IDOTRING,3,8)),"0") AS Num  FROM OTRING WHERE SUBSTR(IDOTRING,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="21" &&Otros Ingresos 
	SELECT NVL(MAX(SUBSTR(IDTPOTRING,3,8)),"0") AS Num  FROM OTRING_TP WHERE SUBSTR(IDTPOTRING,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="22" &&Remision de facturas
	SELECT NVL(MAX(SUBSTR(IDRF,3,8)),"0") AS Num  FROM RFACT WHERE SUBSTR(IDRF,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="25" &&Creditos Fiscales compras
	SELECT NVL(MAX(SUBSTR(nogasto,3,8)),"0") AS Num  FROM ordenesdegastos WHERE SUBSTR(nogasto,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="26" &&Provisiones 
	SELECT NVL(MAX(SUBSTR(IDPV,3,8)),"0") AS Num  FROM PROV WHERE SUBSTR(IDPV,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="2701" &&LLAMADAS 
	SELECT NVL(MAX(SUBSTR(IDCALL,4,7)),"0") AS Num  FROM CLCALL WHERE SUBSTR(IDCALL,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

CASE lcIddoc="2702" &&LLAMADAS 
	SELECT NVL(MAX(SUBSTR(IDCALL,4,7)),"0") AS Num  FROM CLCLASIF WHERE SUBSTR(IDCALL,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

CASE lcIddoc="31" &&Presupuesto Mantenimiento 
	SELECT NVL(MAX(SUBSTR(idpresup,3,8)),"0") AS Num  FROM presupuestos WHERE SUBSTR(idpresup,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="32" &&Presupuesto Reparaciones
	SELECT NVL(MAX(SUBSTR(idpresup,3,8)),"0") AS Num  FROM presupuestos WHERE SUBSTR(idpresup,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="33" &&Presupuesto Autos 
	SELECT NVL(MAX(SUBSTR(idpresup,3,8)),"0") AS Num  FROM presupuestos WHERE SUBSTR(idpresup,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="34" &&Presupuesto Instalaciones
	SELECT NVL(MAX(SUBSTR(idpresup,3,8)),"0") AS Num  FROM presupuestos WHERE SUBSTR(idpresup,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="36" &&Tipo Forma de Pago 
	SELECT NVL(MAX(SUBSTR(idfpago,3,8)),"0") AS Num  FROM formapagopresup WHERE SUBSTR(idfpago,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="37" &&VEHICULO
	SELECT NVL(MAX(SUBSTR(IDVEHICULO,3,8)),"0") AS Num  FROM VEHICULOS WHERE SUBSTR(IDVEHICULO,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="38" &&VEHICULO
	SELECT NVL(MAX(SUBSTR(IDVEHRECEP,3,8)),"0") AS Num  FROM VEHICULORECEP WHERE SUBSTR(IDVEHRECEP,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="3901" &&Orden de Trabajo
	SELECT NVL(MAX(SUBSTR(IDOT,3,8)),"0") AS Num  FROM ot WHERE SUBSTR(idot,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="4901" &&personal 
	SELECT NVL(MAX(SUBSTR(IDPERSON,4,7)),"0") AS Num  FROM PLPER  WHERE SUBSTR(IDPERSON,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

CASE lcIddoc="4911" &&PERSONAL MINISTERIAL 
	SELECT NVL(MAX(SUBSTR(IDMNPER,4,7)),"0") AS Num  FROM MNPER  WHERE SUBSTR(IDMNPER,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

CASE lcIddoc="4902" &&personal 
	SELECT NVL(MAX(SUBSTR(IDVOUCHER ,4,7)),"0") AS Num  FROM PLVOUCH  WHERE SUBSTR(IDVOUCHER ,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

CASE lcIddoc="4903" &&planilla
	SELECT NVL(MAX(SUBSTR(IDPLNA,4,7)),"0") AS Num  FROM PLPLNA  WHERE SUBSTR(IDPLNA ,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

CASE lcIddoc="4904" &&Ingreso y Egreso
	SELECT NVL(MAX(SUBSTR(IDIE,4,7)),"0") AS Num  FROM PLIE  WHERE SUBSTR(IDIE ,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

CASE lcIddoc="4905" &&Elementos 
	SELECT NVL(MAX(SUBSTR(IDELEMENT,4,7)),"0") AS Num  FROM PlPer_Elem  WHERE SUBSTR(IDELEMENT,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

	
CASE BETWEEN(lcIddoc,"4","5") &&Cualquier gasto
	SELECT NVL(MAX(SUBSTR(NOGASTO,3,8)),"0") AS Num  FROM ORDENESDEGASTOS WHERE SUBSTR(NOGASTO,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 



CASE lcIddoc="51" &&Ajuste de inventario
	SELECT NVL(MAX(SUBSTR(NORDEN,3,8)),"0") AS Num  FROM ORDENCOMPRA WHERE SUBSTR(NORDEN,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="53" &&DEVOLUCION
	SELECT NVL(MAX(SUBSTR(NORDEN,3,8)),"0") AS Num  FROM ORDENCOMPRA WHERE SUBSTR(NORDEN,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="541" &&ACTIVOS FIJOS 
	SELECT NVL(MAX(SUBSTR(IDAF,3,8)),"0") AS Num  FROM AFACTIVOS WHERE SUBSTR(IDAF,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	
CASE lcIddoc="542" &&CLASIFICACION ACTIVOS FIJOS 
	SELECT NVL(MAX(SUBSTR(IDCLASIF,3,8)),"0") AS Num  FROM AFCLASIF WHERE SUBSTR(IDCLASIF,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	
CASE lcIddoc="543" &&UBICACION DE ACTIVOS FIJOS 
	SELECT NVL(MAX(SUBSTR(IDUBICA,3,8)),"0") AS Num  FROM AFUBICAS WHERE SUBSTR(IDUBICA,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	

CASE lcIddoc="55" &&ORden del exterior
	SELECT NVL(MAX(SUBSTR(NORDEN,3,8)),"0") AS Num  FROM ORDENCOMPRA WHERE SUBSTR(NORDEN,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

	
CASE lcIddoc="5501" &&ORden del exterior
*	?"      "
	**Parametros de Tabla 
	lcAlias=_screen.doc1.gettablam(lcIddoc)
	lcCampo=_screen.doc1.getcampoid(lcIddoc)
*	?"lcAlias: "+TRANSFORM(lcAlias)
*	?"lcCampo: "+TRANSFORM(lcCampo)
	
	lcPrefijo=_screen.doc1.getprefijofromiddoc(lcIddoc)
	
*	?"lcPrefijo: "+TRANSFORM(lcPrefijo)
	lnLargeOfChar=LEN(lcPrefijo)
*	?"lnLargeOfChar: "+TRANSFORM(lnLargeOfChar)
	
	**Guardar estado 
	lnAreaAnt = SELECT()
	lcReprAnt = SET('REPROCESS')
  	lcSucursal=ALLTRIM(TRANSFORM(gnDefaultSucursal))
  	lnSucursalLen=LEN(lcSucursal)

	SET REPROCESS TO AUTOMATIC


	lnCharBegin=lnLargeOfChar+lnSucursalLen+1 &&mas uno de la sucursal 3+1+1=5 OEC1000001
	lnCharEnd=10-lnCharBegin+1
	
  	lnSucursalCharBegin=lnLargeOfChar+1
  	*lnSucursalCharEnd=lnSucursalCharBegin+lnSucursalLen
*	?"lnCharEnd:"+TRANSFORM(lnCharEnd)
	
	IF NOT USED(lcAlias)
    	USE (lcAlias) IN 0  &&poner en uso docmun si no esta en uso 
*   	?"USED:" +TRANSFORM(USED(lcAlias))
	ENDIF
	

	IF FLOCK(lcAlias)
*		?"FLOCK(lcAlias)"+TRANSFORM(FLOCK(lcAlias))
		
		SELECT ;
			NVL(MAX(SUBSTR(&lcCampo,lnCharBegin,lnCharEnd)),"0") AS Num  ;
		FROM;
			(lcAlias) ;
		WHERE;
			SUBSTR(&lcCampo,1,lnLargeOfChar)=lcPrefijo AND ;
			SUBSTR(&lcCampo,lnSucursalCharBegin,lnSucursalLen)=lcSucursal;
		INTO CURSOR ;
			Documento	

		lcNumDoc=lcPrefijo+lcSucursal+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),lnCharEnd,"0")  	 
		
		INSERT INTO &lcAlias (&lcCampo) VALUES(lcNumDoc)
		UNLOCK IN (lcAlias)
	ENDIF 
	
*	?lcPrefijo+lcSucursal+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),lnCharEnd,"0")
	
	RETURN lcNumDoc
	
CASE lcIddoc="56" &&ajuste de inventario 
	SELECT NVL(MAX(SUBSTR(IDOAGEN,3,8)),"0") AS Num  FROM OAGEN WHERE SUBSTR(IDOAGEN,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 


CASE lcIddoc="52" &&NREQUISICON
	SELECT NVL(MAX(SUBSTR(Nrequisicion,3,8)),"0") AS Num  FROM REQUISICIONES WHERE SUBSTR(Nrequisicion,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="61" &&VEHICULO DE COMBUSTIBLE 
	SELECT NVL(MAX(SUBSTR(IDVEHICULO,3,8)),"0") AS Num  FROM CVEHICULOS WHERE SUBSTR(IDVEHICULO,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="62" &&VALE DE COMBUSTIBLE 
	SELECT NVL(MAX(SUBSTR(IDVALE,3,8)),"0") AS Num  FROM CVALES WHERE SUBSTR(IDVALE,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="63" &&FACTURAS DE COMBUSTIBLE 
	SELECT NVL(MAX(SUBSTR(idfactura,3,8)),"0") AS Num  FROM CFACTURAS WHERE SUBSTR(IDFACTURA,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="64" &&LIQUIDACIONES DE COMBUSTIBLE 
	SELECT NVL(MAX(SUBSTR(IDLIQUID,3,8)),"0") AS Num  FROM CLIQUIDACIONES WHERE SUBSTR(IDLIQUID,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="65" &&CUOTAS COMBUSTIBLE 
	SELECT NVL(MAX(SUBSTR(IDCUOTA,3,8)),"0") AS Num  FROM CCUOTAS WHERE SUBSTR(IDCUOTA,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="66" &&GASOLINERAS COMBUSTIBLE 
	SELECT NVL(MAX(SUBSTR(IDGASOL,3,8)),"0") AS Num  FROM Cgasolineras WHERE SUBSTR(IDGASOL,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="67" &&INSUMOS COMBUSTIBLE 
	SELECT NVL(MAX(SUBSTR(IDINSUMO,3,8)),"0") AS Num  FROM CINSUMOS WHERE SUBSTR(IDINSUMO,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="68" &&IMPUESTOS DE COMBUSTIBLE
	SELECT NVL(MAX(SUBSTR(IDIMPUESTO,3,8)),"0") AS Num  FROM CIMPUESTOS WHERE SUBSTR(IDIMPUESTO,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="69" &&IMPUESTOS DE COMBUSTIBLE
	SELECT NVL(MAX(SUBSTR(NUMERO,3,8)),"0") AS Num  FROM CVALES WHERE SUBSTR(NUMERO,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="70" &&MOTOROLOS
	SELECT NVL(MAX(SUBSTR(IDMOTORISTA,3,8)),"0") AS Num  FROM CMOTORISTA WHERE SUBSTR(IDMOTORISTA,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="81" &&mantenimniento
	SELECT NVL(MAX(SUBSTR(idcontrato,3,8)),"0") AS Num  FROM mcontrato WHERE SUBSTR(idcontrato,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

CASE lcIddoc="8101" &&mantenimniento
	SELECT NVL(MAX(SUBSTR(idcnc,4,7)),"0") AS Num  FROM cnctr WHERE SUBSTR(idcnc,1,3)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),7,"0")  	 

CASE lcIddoc="82" &&SUCURSAL
	SELECT NVL(MAX(SUBSTR(idsucursal,3,8)),"0") AS Num  FROM msucursal WHERE SUBSTR(idsucursal,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="83" &&EQUIPOS
	SELECT NVL(MAX(SUBSTR(idequipo,3,8)),"0") AS Num  FROM equipos WHERE SUBSTR(idequipo,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="84" &&MECANICOS 
	SELECT NVL(MAX(SUBSTR(IDMECA,3,8)),"0") AS Num  FROM MMECA WHERE SUBSTR(IDMECA,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="85" &&GRUPO DE MECANICO 
	SELECT NVL(MAX(SUBSTR(idgrupo,3,8)),"0") AS Num  FROM Mgrupo WHERE SUBSTR(idgrupo,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="86" &&Rutas
	SELECT NVL(MAX(SUBSTR(idruta,3,8)),"0") AS Num  FROM mrutas WHERE SUBSTR(idruta,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="87" &&Programas de Mantteniemiento 
	SELECT NVL(MAX(SUBSTR(idprogra,3,8)),"0") AS Num  FROM mprogra_cld WHERE SUBSTR(idprogra,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="88" &&HOJAS de Mantteniemiento 
	SELECT NVL(MAX(SUBSTR(idhoja,3,8)),"0") AS Num  FROM MHOJA WHERE SUBSTR(idhoja,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 
CASE lcIddoc="90" && PARTIDAS
	SELECT NVL(MAX(SUBSTR(IDPART,3,8)),"0") AS Num  FROM PARTIDA WHERE SUBSTR(IDPART,1,2)=genPrefijoDoc(lcIdDoc) INTO CURSOR Documento	
	RETURN genPrefijoDoc(lcIdDoc)+PADL(ALLTRIM(STR(VAL(Documento.Num)+1)),8,"0")  	 

OTHERWISE
	&&15 OCTUBRE 2015 Generador para todos los que no han sido contemplados anteriormente
	SELECT ;
		NOMBRE,;
		PREFIJO,;
		TABLA_M,;
		IDCAMPO;
	FROM ;
		DOCUMENTOS;
	WHERE ;
		ALLTRIM(iddoc)==ALLTRIM(lcIdDoc);
	INTO ARRAY ;
		laDOCUMENTOS;
		
	IF !VARTYPE(laDOCUMENTOS)="U"
		lcNombre=ALLTRIM(laDOCUMENTOS(1))
		lcPrefijo=ALLTRIM(laDOCUMENTOS(2))
		lcTable=ALLTRIM(laDOCUMENTOS(3))
		lcIdcampo=ALLTRIM(laDOCUMENTOS(4))
		lnLenPrefijo=LEN(lcPrefijo)
		lnUntil=10-lnLenPrefijo
		
		*MESSAGEBOX(	" lcNombre "+TRANSFORM(lcNombre)+CHR(13)+;
					" lcPrefijo "+TRANSFORM(lcPrefijo)+CHR(13)+;
					" lcTable "+TRANSFORM(lcTable)+CHR(13)+;
					" lcIdcampo "+TRANSFORM(lcIdcampo)+CHR(13)+;
					" lnLenPrefijo "+TRANSFORM(lnLenPrefijo)+CHR(13)+;					
					" lnUntil "+TRANSFORM(lnUntil))
		

		
		lcSql='SELECT NVL(MAX(SUBSTR( '+ lcIdCampo +' ,lnLenPrefijo+1,lnUntil)),"0") FROM ' + lcTable +;
		' WHERE SUBSTR( '+lcIdCampo +' ,1,lnLenPrefijo)=lcPrefijo '+;
		' INTO ARRAY	laDocumento'



		
		&lcSql
		
	
		
		RETURN lcPrefijo+PADL(ALLTRIM(STR(VAL(laDocumento)+1)),lnUntil,"0")
		
	ENDIF 
ENDCASE
ENDPROC 