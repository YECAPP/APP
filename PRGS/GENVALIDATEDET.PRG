PROCEDURE genvalidateDet
PARAMETERS lcTestValue,lcIdDoc
	LOCAL lcMsg
	lcMsg="Ok"
	*DO ABRIRTBS &&solo para pruebas se usa 
	IF 	lcMsg="Ok" AND vacio(lcTestValue,lcIdDoc)
		lcMsg="Registro Vacio"
	ENDIF 
	
	IF 	lcMsg="Ok" AND !existe(lcTestValue,lcIdDoc)
		lcMsg="Documento: "+lcTestValue+" No Existe, "+CHR(13)+"Ingrese un documento Valido"
	ENDIF 
	
	DO CASE
	CASE lcIdDoc="07" &&CAJA CHICA
		IF lcMsg="Ok" AND SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("07")
			lcMsg="Documento: "+lcTestValue+" Es una caja chica, "+CHR(13)+" No es posible incluir una caja chica dentro de otra caja chica"
		ENDIF 
	
 		*IF 	lcMsg="Ok" AND caja(lcTestValue)>1
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en una caja chica"
		*ENDIF 
		*IF 	lcMsg="Ok" AND cheque(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en un cheque"
		*ENDIF 
		*IF 	lcMsg="Ok" AND quedan(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en un quedan"
		*ENDIF 
		*IF 	lcMsg="Ok" AND REMESA(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en una remesa"
		*ENDIF 

	CASE INLIST(lcIdDoc,"04","03","05") &&CHEQUE 
		IF lcMsg="Ok" AND (SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("04") OR SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("05") )
			lcMsg="Documento: "+lcTestValue+" Es un cheque, "+CHR(13)+" No es posible incluir una cheque dentro de otro cheque"
		ENDIF 

		*IF 	lcMsg="Ok" AND caja(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en una caja chica"
		*ENDIF 
		*IF 	lcMsg="Ok" AND cheque(lcTestValue)>1
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en un cheque"
		*ENDIF 
		*IF 	lcMsg="Ok" AND quedan(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en un quedan"
		*ENDIF 
		*IF 	lcMsg="Ok" AND REMESA(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en una remesa"
		*ENDIF 

	CASE lcIdDoc="06" &&QUEDAN 
		IF lcMsg="Ok" AND SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("06")
			lcMsg="Documento: "+lcTestValue+" Es un quedan, "+CHR(13)+" No es posible incluir un quedan dentro de otro quedan"
		ENDIF 
		
		*IF 	lcMsg="Ok" AND caja(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en una caja chica"
		*ENDIF 
		*IF 	lcMsg="Ok" AND cheque(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en un cheque"
		*ENDIF 
		*IF 	lcMsg="Ok" AND quedan(lcTestValue)>1
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en un quedan"
		*ENDIF 
		*IF 	lcMsg="Ok" AND REMESA(lcTestValue)>0
		*	lcMsg="Documento: "+lcTestValue+" Esta pagado en una remesa"
		*ENDIF 
	CASE lcIdDoc="08" &&VENTA
		IF lcMsg="Ok" AND (	SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("08") OR ;
							SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("09") OR ;
							SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("10") OR ;
							SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("11") OR ;
							SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("12") OR ;
							SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("13");
						   )
			lcDocument=IIF(SEEK(SUBSTR(lcTestValue,1,2),"DOCUMENTOS","PREFIJO"),DOCUMENTOS.NOMBRE,"")
			lcMsg="Documento: "+lcTestValue+" Es un: "+ lcDocument+","+CHR(13)+"No es posible incluir un "+ lcDocument+" dentro de una factura"
		ENDIF 
		IF 	lcMsg="Ok" AND VENTA(lcTestValue)>1
			lcMsg="Documento: "+lcTestValue+" Esta facturado ya "
		ENDIF 
	CASE lcIdDoc="83" &&EQUIPOS DE MANTENIMIENTO 
		IF 	lcMsg="Ok" AND EQUIPO(lcTestValue)>1
			lcMsg="Equipo: "+lcTestValue+" se encuentra asignado a otro mantenimiento ya"
		ENDIF 
	CASE lcIdDoc="17" OR lcIdDoc="18" &&REMESAS 
		DO CASE
		CASE SUBSTR(lcTestValue,1,2)="VN" &&SI ES VENTA SOLO REVISAS QUE NO SEA REMESA O NOTA DE ABONO

			IF lcMsg="Ok" AND (SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("17") OR SUBSTR(lcTestValue,1,2)==GENPREFIJODOC("18") )
				lcDocument=IIF(SEEK(SUBSTR(lcTestValue,1,2),"DOCUMENTOS","PREFIJO"),DOCUMENTOS.NOMBRE,"")
				lcMsg="Documento: "+lcTestValue+" Es un: "+ lcDocument+","+CHR(13)+"No es posible incluir un "+ lcDocument+" dentro de una Remesa"
			ENDIF 
		CASE SUBSTR(lcTestValue,1,2)="OI" &&Si es documento de OTRO INGRESO 
			*21/10/2010: 
			*Ordenes de Ingresos se pueden pagar en multiples remesas tal y como se hace con las 
			*facturas  siempre y cuando no se paguen de mas 
			
			
		OTHERWISE
		
			&&Nota01:21/10/2010:En desuso 
			&&20/07/2010DE LO CONTRARIO REVISA QUE NO ESTE EN CHEQUE QUEDAN CAJA O REMESA 
			&&Modificacion miercoles 28/07/10 ya que no dejaba guardar complementos en remesas 
			&&solo debe verificarse en remesas y en algun otro documento de abono que se cree posteriormente 
			*IF 	lcMsg="Ok" AND caja(lcTestValue)>0
			*	lcMsg="Documento: "+lcTestValue+" Esta pagado en una caja chica"
			*ENDIF 
			*IF 	lcMsg="Ok" AND cheque(lcTestValue)>0
			*	lcMsg="Documento: "+lcTestValue+" Esta pagado en un cheque"
			*ENDIF 
			*IF 	lcMsg="Ok" AND quedan(lcTestValue)>0
			*	lcMsg="Documento: "+lcTestValue+" Esta pagado en un quedan"
			*ENDIF 
			&&Nota02: 21/10/2010 los complementos "CP", Prestamos "PT" y otros documentos deudores incluidos en las remesas en el haber 
			&&no se validan mas por duplicacion, esto era un error pues deben existir dentro de una 
			&&caja chica cheque o quedan para poder ser liquidados en una remesa
			&&Nota03: 21/10/2010 los complementos "CP", Prestamos "PT" y otros documentos deudores incluidas en las remesas del lado del haber 
			&&no se podran pagar en abonos unicamente en un solo pago por lo que debe verificarse que no existan ya dentro de otra remesa 
			&&Nota04 ya no se verificaran que un documento exista dos veces 
			*IF 	lcMsg="Ok" AND REMESA(lcTestValue)>1
			*	lcMsg="Documento: "+lcTestValue+" Esta pagado en una remesa"
			*ENDIF 
		ENDCASE &&endcase de validacion documentos de remesas y facturas 

	OTHERWISE
	ENDCASE
	RETURN lcMsg
ENDPROC 


PROCEDURE abrirtbs 
	IF !USED("DETALLECARGOSBANCO")
		USE DETALLECARGOSBANCO IN 0
	ENDIF 	
	IF !USED("INVENTARIO")
		USE INVENTARIO IN 0
	ENDIF 	
	IF !USED("CATACONTA")
		USE CATACONTA IN 0
	ENDIF 	

	IF !USED("DETALLECC")
		USE DETALLECC IN 0
	ENDIF 	
	IF !USED("DETALLEDOCPROV")
		USE DETALLEDOCPROV IN 0
	ENDIF 	
	IF !USED("OC")
		GENCURVAL(.T.)
	ENDIF 	
	IF !USED("PR")
		GENCURVAL2(.T.)
	ENDIF 	
	IF !USED("EQ")
		GENCURVAL3(.T.)
	ENDIF 	
ENDPROC 


PROCEDURE vacio
	PARAMETERS lcTestValue,lcIdDoc
	
	IF lcIdDoc="83" &&01/04/2016
		IF SUBSTR(lcTestValue,1,2)="EQ" &&01/04/2016
			RETURN EMPTY(lcTestValue) &&01/04/2016			
		ELSE &&01/04/2016

			RETURN .f. &&01/04/2016
		ENDIF &&01/04/2016
	ELSE &&01/04/2016
		RETURN EMPTY(lcTestValue) 
	ENDIF &&01/04/2016
ENDPROC 

PROCEDURE existe
	PARAMETERS lcTestValue,lcIdDoc
		DO CASE
		CASE INLIST(lcIdDoc,"07","04","06")
			RETURN SEEK(lcTestValue,"OC","NORDEN")
		CASE INLIST(lcIdDoc,"08","17","18")
			IF INLIST(SUBSTR(lcTestValue,1,2),"VN","OI")
				RETURN SEEK(lcTestValue,"PR","IDPRESUP")
			ELSE 
				RETURN SEEK(lcTestValue,"OC","NORDEN")
			ENDIF 
		CASE INLIST(lciddoc,"83")
			IF SUBSTR(lcTestValue,1,2)="EQ" &&01/04/2016
				RETURN SEEK(lcTestValue,"EQ","IDEQUIPO")
			ELSE &&01/04/2016 
				
				RETURN .t. &&01/04/2016
			ENDIF &&01/04/2016 
		
		CASE INLIST(lciddoc,"20","53")
			
			SELECT codigo FROM inventario WHERE codigo=lcTestValue ;
			UNION ALL ;
			SELECT codigo FROM cataconta WHERE codigo=lcTestValue ;
			INTO ARRAY ;
			acCodigo
		IF TYPE("acCodigo")="U"
			RETURN .f.
		ELSE 
			RETURN .t.
		ENDIF 
			
		OTHERWISE
		ENDCASE
ENDPROC 

PROCEDURE cheque 
	PARAMETERS lcTestValue
	lcRefDuplicada=lcTestValue
	SELECT COUNT(DETALLECARGOSBANCO.REFERENCIA);
		FROM DETALLECARGOSBANCO WITH (BUFFERING=.T.) ;
			WHERE REFERENCIA=lcRefDuplicada ;
				INTO ARRAY aRefConteoCH
	RETURN aRefConteoCH[1]
ENDPROC 

PROCEDURE caja
	PARAMETERS lcTestValue
	lcRefDuplicada=lcTestValue
	SELECT COUNT(DETALLECC.REFERENCIA);
		FROM DETALLECC WITH (BUFFERING=.T.) ;
			WHERE REFERENCIA=lcRefDuplicada ;
				INTO ARRAY aRefConteoCC
	RETURN aRefConteoCC[1]
ENDPROC 

PROCEDURE quedan 
	PARAMETERS lcTestValue
	lcRefDuplicada=lcTestValue
	SELECT COUNT(DETALLEDOCPROV.REFERENCIA);
		FROM DETALLEDOCPROV WITH (BUFFERING=.T.) ;
			WHERE REFERENCIA=lcRefDuplicada ;
				INTO ARRAY aRefConteoQD
	RETURN aRefConteoQD[1]
ENDPROC 
PROCEDURE VENTA 
	PARAMETERS lcTestValue
	lcRefDuplicada=lcTestValue
	SELECT COUNT(DETALLEFACTURAS.REFERENCIA);
		FROM DETALLEFACTURAS WITH (BUFFERING=.T.) ;
			WHERE REFERENCIA=lcRefDuplicada ;
				INTO ARRAY aRefConteoVT
	RETURN aRefConteoVT[1]
ENDPROC 

PROCEDURE EQUIPO
	PARAMETERS lcTestValue
	IF SUBSTR(lcTestValue,1,2)="EQ"  &&01/04/2016 
		lcRefDuplicada=lcTestValue
		SELECT COUNT(MCONTRATO_EQ.IDEQUIPO);
			FROM MCONTRATO_EQ WITH (BUFFERING=.T.) ;
				WHERE IDEQUIPO=lcRefDuplicada ;
					INTO ARRAY aRefConteoEQ
		RETURN aRefConteoEQ[1]		
	ELSE &&01/04/2016 

		RETURN 1  &&01/04/2016 
	ENDIF 	&&01/04/2016 
ENDPROC 

PROCEDURE REMESA
	PARAMETERS lcTestValue
	lcRefDuplicada=lcTestValue
	SELECT COUNT(DETALLEABONOSBANCO.REFERENCIA);
		FROM DETALLEABONOSBANCO WITH (BUFFERING=.T.) ;
			WHERE REFERENCIA=lcRefDuplicada ;
				INTO ARRAY aRefConteoRM
	RETURN aRefConteoRM[1]
ENDPROC 