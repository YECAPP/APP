PROCEDURE genrm 
LPARAMETERS lcId 
**CURSOR RMM

IF !USED("PR")
	DO GENCURVAL2
ENDIF 

IF !USED("OC")
	DO GENCURVAL
ENDIF 

	CREATE CURSOR MaestroRMM ;
		(;
			IDABONO C(10),;
			FECHA D,;
			DESCRIPCION C(60),;
			REFERENCIA  C(10),;
			OBSERVACIONES C(60),;
			IDCUENTA C(40),;
			DEPTO C(10),;
			BANCO C(40),;
			TOTALCHPROPIOS N(10,2) ,;
			TOTALCHEQUESOTROS N(10,2) ,;
			TOTALEFECTIVO N(10,2),;
			TOTALGASTOS N(10,2),;
			TOTALNAS N(10,2);
		)

	INSERT INTO MaestroRMM;
			(;
				IDABONO,;
				FECHA,;
				DESCRIPCION,;
				REFERENCIA,;
				OBSERVACIONES,;
				IDCUENTA,;
				DEPTO,;
				BANCO;
			);
			SELECT ;
				idabono,;
				fecha ,;
				descripcion,;
				referencia,;
				observaciones,;
				datos(idcuenta,"Cuenta"),;
				depto,;
				datos(idcuenta,"NombreBanco");
			FROM ;
				abonosbanco;
			WHERE ;
				abonosbanco.idabono=lcId

		
		&&SUMANDO TOTAL EFECTIVO
		SELECT ;
			SUM(PARCIAL);
		FROM ;
			detalleabonosbanco;
		WHERE ;
			PAGOTP="Efectivo" AND ;
			IDABONO=lcId AND ;
			TP=1;		
		INTO ARRAY ;
			laEfectivo

		IF VARTYPE(laEfectivo)<>"X"
			replace TOTALEFECTIVO WITH laEfectivo IN MaestroRMM
		ENDIF 
		
		&&SUMANDO TOTAL CHEQUES PROPIOS 
		SELECT ;
			SUM(PARCIAL) ;
		FROM ;
			detalleabonosbanco INNER JOIN abonosbanco ON detalleabonosbanco.idabono=abonosbanco.idabono;
		WHERE ;
			detalleabonosbanco.PAGOTP="Cheque" AND ;
			detalleabonosbanco.IDABONO=lcId AND ;
			ALLTRIM(detalleabonosbanco.PAGOBAN)=ALLTRIM(Datos(abonosbanco.idcuenta,"CodigoBanco")) AND ;
			detalleabonosbanco.TP=1;
		INTO ARRAY;
			LATOTALCHPROP

		IF VARTYPE(LATOTALCHPROP)<>"X"
			replace TOTALCHPROPIOS  WITH LATOTALCHPROP IN MaestroRMM
		ENDIF 
			
		&&SUMANDO TOTAL CHEQUE OTROS 
		SELECT ;
			SUM(PARCIAL) ;
		FROM ;
			detalleabonosbanco INNER JOIN abonosbanco ON detalleabonosbanco.idabono=abonosbanco.idabono;
		WHERE ;
			detalleabonosbanco.PAGOTP="Cheque" AND ;
			detalleabonosbanco.IDABONO=lcId AND ;
			ALLTRIM(detalleabonosbanco.PAGOBAN)<>ALLTRIM(Datos(abonosbanco.idcuenta,"CodigoBanco")) AND ;
			detalleabonosbanco.TP=1;
		INTO ARRAY;
			LATOTALCHOTR 
		

		IF VARTYPE(LATOTALCHOTR)<>"X"
			REPLACE TOTALCHEQUESOTROS WITH LATOTALCHOTR IN MaestroRMM
		ENDIF
			
		&&SUMANDO TOTAL GASTOS
		SELECT ;
			SUM(PARCIAL) ;
		FROM ;
			detalleabonosbanco;
		WHERE ;
			IDABONO=lcId AND;
			TP=2;
		INTO ARRAY;
			LATOTAGASTOS

		IF VARTYPE(LATOTAGASTOS)<>"X"
			REPLACE TOTALGASTOS WITH LATOTAGASTOS IN MaestroRMM
		ENDIF
			
	&&SUMANDO TOTAL NOTAS DE ABONO
		SELECT ;
			SUM(PARCIAL) ;
		FROM ;
			detalleabonosbanco;
		WHERE ;
			PAGOTP="Nota de Abono" AND ;
			IDABONO=lcId AND;
			TP=1;
		INTO ARRAY;
			LATOTANAS

		IF VARTYPE(LATOTANAS)<>"X"
			REPLACE TOTALNAS WITH LATOTANAS IN MaestroRMM
		ENDIF
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	**CURSOR RM1
	CREATE CURSOR DetalleRM1 ;
		(;
			IDABONO C(10),;
			FECHA D,;
			NUMERO C(10),;
			NUMERO2 C(10),;		
			DSC C(80),;
			PARCIAL N(10,2),;
			INFOPAGO C(25);
		)

	tp=1

		INSERT INTO DetalleRM1;
			(;
				IDABONO,;
				FECHA,;
				NUMERO ,;
				NUMERO2,;
				DSC ,;
				PARCIAL,;
				INFOPAGO;						
			);
			SELECT ;
				detalleabonosbanco.idabono,;
				CAST(Datos(detalleabonosbanco.referencia,"Fecha",tp) as D) as fecha ,;
				CAST(datos(detalleabonosbanco.referencia,"Numero",tp) AS C(10)) AS NUMERO,;
				CAST(datos(detalleabonosbanco.referencia,"FormularioUnico",tp) AS C(10)) AS NUMERO2,;
				CAST(datos(detalleabonosbanco.referencia,"Cliente",tp)+" "+datos(detalleabonosbanco.referencia,"Dsc",tp) AS C(40)) AS DSC,;
				detalleabonosbanco.parcial,;
				ALLTRIM(detalleabonosbanco.pagotp)+" "+ALLTRIM(detalleabonosbanco.pagoref)+" "+ALLTRIM(datos(detalleabonosbanco.pagoban,"Banco",tp)) AS INFOPAGO ;
			FROM ;
				detalleabonosbanco;
			WHERE;
				 detalleabonosbanco.idabono=lcId AND detalleabonosbanco.tp=1

	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	**CURSOR DetalleRMCosto
	CREATE CURSOR DetalleRMCosto ;
		(;
			FECHA D,;
			IDABONO C(10),;
			DOCUMENTO C(10),;		
			DSC C(80),;
			PARCIAL N(10,2);
		)



	Tp=2

	INSERT INTO DetalleRMCosto;
		(;
			IDABONO ,;
			FECHA,;
			DOCUMENTO,;
			DSC ,;
			PARCIAL;
		);
		SELECT ;
			detalleabonosbanco.idabono,;
			CAST(Datos(detalleabonosbanco.referencia,"Fecha",Tp) as D) as fecha ,;
			detalleabonosbanco.referencia as documento,;
			CAST(datos(detalleabonosbanco.referencia,"Dsc",Tp)+""+datos(detalleabonosbanco.referencia,"Prov",Tp) AS C(40)) AS DSC,;
			detalleabonosbanco.parcial;
		FROM ;
			detalleabonosbanco;
		WHERE;
			detalleabonosbanco.idabono=lcId AND detalleabonosbanco.tp=2

	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	**INDEXAR Y RELACIONAR 

	SELECT DetalleRM1
	INDEX ON IDABONO TAG IDABONO
	SET ORDER TO IDABONO   && NUMERO 

	SELECT DetalleRMCosto
	INDEX ON IDABONO TAG IDABONO
	SET ORDER TO IDABONO

	SELECT MaestroRMM 
	INDEX ON IDABONO TAG IDABONO
	SET ORDER TO IDABONO
		
	SET RELATION TO IDABONO INTO DetalleRM1 ,IDABONO INTO DetalleRMCosto 
	SET SKIP TO DetalleRM1,DetalleRMCosto 
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	**CERRAR CURSORES 
	*IF USED("MaestroRMM")
	*	SELECT MaestroRMM
	*	USE 
	*ENDIF 
	*IF USED("DetalleRM1")
	*	SELECT DetalleRM1
	*	USE  
	*ENDIF 
	*IF USED("DetalleRMCosto")
	*	SELECT DetalleRMCosto 
	*	USE 
	*ENDIF 

ENDPROC 

PROCEDURE datos 
	LPARAMETERS lcIdabono,lcType,lnTp
	LOCAL lcReturn
	DO CASE 
	CASE lctype="Monto" AND lnTp=1 	
	SELECT monto FROM pr WHERE idpresup=lcIdabono INTO ARRAY laAbonos
	IF VARTYPE(laAbonos)="U"
		laAbonos=0.00
	ENDIF 
	lcReturn=laAbonos

	CASE lctype="Saldo" AND lnTp=1
		SELECT monto FROM pr WHERE idpresup=lcIdabono INTO ARRAY laAbonos
		IF VARTYPE(laAbonos)="U"
			laAbonos=0.00
		ENDIF 

		SELECT SUM(PARCIAL) FROM RMDETALLE WITH (BUFFERING=.T.) WHERE REFERENCIA=LCIDABONO INTO ARRAY	LACARGOS
		IF VARTYPE(laCargos)="X"
			laCargos=0.00
		ENDIF 
		
		lcReturn=laAbonos-laCargos
	CASE lctype="Cliente" AND lnTp=1
		SELECT PR.IDCLIENTE+" "+ALLTRIM(CLIENTES.NOMBRE) FROM PR INNER JOIN CLIENTES ON PR.IDCLIENTE=CLIENTES.IDCLIENTE	WHERE PR.IDPRESUP=LCIDABONO	INTO ARRAY LACLIENTE
		IF VARTYPE(LACLIENTE)="U"
			LACLIENTE=""
		ENDIF 
			
		lcReturn=LACLIENTE	
	CASE lctype="Dsc" AND lnTp=1
		IF SUBSTR(ALLTRIM(LCIDABONO),1,2)="VN"
			SELECT ALLTRIM(PR.dsc) FROM PR WHERE PR.IDPRESUP=LCIDABONO INTO ARRAY LADSC
			IF VARTYPE(LADSC)="U"
				LADSC=""
			ENDIF 
		ELSE
			SELECT OBSERVACIONES FROM ORDENESDEGASTOS WHERE NOGASTO=LCIDABONO UNION ALL SELECT descrip FROM otring WHERE idotring=LCIDABONO  INTO ARRAY LADSC
			IF VARTYPE(LADSC)="U"					
				LADSC=""
			ENDIF 
		ENDIF 
		lcReturn=LADSC
	CASE lctype="Numero" AND lnTp=1
		SELECT numero FROM facturas  WHERE idventa=lcIdabono INTO ARRAY laNumero
		IF VARTYPE(laNumero)="U"
			SELECT OC.NORDEN FROM OC   WHERE NORDEN=lcIdabono INTO ARRAY laNumero
			IF VARTYPE(laNumero)="U"
				SELECT otring.idotring FROM otring WHERE idotring=lcIdabono INTO ARRAY laNumero
				IF VARTYPE(laNumero)="U"
					laNumero=""
				ENDIF 
			ENDIF 
		ENDIF 
		lcReturn=laNumero
	CASE lctype="FormularioUnico" AND lnTp=1
		SELECT numero2 FROM facturas  WHERE idventa=lcIdabono INTO ARRAY laNumero2
		IF VARTYPE(laNumero2)="U"
			laNumero2=""
		ENDIF 
		
		lcReturn=laNumero2

	CASE lctype="Monto" AND lnTp=2
		SELECT monto FROM oc WHERE norden=lcIdabono INTO ARRAY laAbonos
		IF VARTYPE(laAbonos)="U"
			laAbonos=0.00
		ENDIF 
		lcReturn=laAbonos
	CASE lctype="Saldo" AND lnTp=2
		SELECT monto FROM oc WHERE norden=lcIdabono INTO ARRAY laAbonos
		IF VARTYPE(laAbonos)="U"
			laAbonos=0.00
		ENDIF 

		SELECT SUM(PARCIAL) FROM RMDETALLE WITH (BUFFERING=.T.) WHERE REFERENCIA=LCIDABONO INTO ARRAY	LACARGOS
		IF VARTYPE(laCargos)="X"
			laCargos=0.00
		ENDIF 
		lcReturn=laAbonos-laCargos
	CASE lctype="Prov" AND lnTp=2
		SELECT proveedor+" "+ALLTRIM(PROVEEdores.nombre) FROM oc INNER JOIN proveedores ON oc.proveedor=proveedores.idprov WHERE norden=lcIdabono INTO ARRAY laProv
		IF VARTYPE(laProv)="U"
			laProv=""
		ENDIF 
		lcReturn=laProv
	CASE lctype="Dsc" AND lnTp=2
		SELECT oc.proyecto+" "+ALLTRIM(proyectos.nombre) FROM oc INNER JOIN proyectos ON oc.proyecto=proyectos.idproyectos WHERE norden=lcIdabono INTO ARRAY laProy	
		IF VARTYPE(laProy)="U"
			laProy=""
		ENDIF 
		lcReturn=laProy
	
	CASE lctype="Fecha" 
		lcSubstr=SUBSTR(lcIdabono,1,2)
		DO CASE 
		CASE lcSubstr="VN"
			SELECT FECHA FROM FACTURAS  WHERE idventa=lcIdabono INTO ARRAY laFecha
		CASE lcSubstr="OC"
			SELECT FECHA FROM ORDENCOMPRA WHERE norden=lcIdabono INTO ARRAY laFecha
		OTHERWISE
			SELECT FECHA FROM ORDENESDEGASTOS WHERE nogasto=lcIdabono INTO ARRAY laFecha
		ENDCASE
		
		IF VARTYPE(laFecha)="U"
			laFecha=DATE()
		ENDIF 
		lcReturn=laFecha



	CASE lctype="Banco" 
		SELECT descripcion  FROM bancos  WHERE idbanco=lcIdabono INTO ARRAY laBanc
		
		IF VARTYPE(laBanc)="U"
			laBanc=""
		ENDIF 
		lcReturn=laBanc
	CASE lctype="Cuenta" 
		SELECT Numero  FROM cuentasbancarias  WHERE idcuenta=lcIdabono INTO ARRAY laIdcuenta
		
		IF VARTYPE(laIdcuenta)="U"
			laIdcuenta=""
		ENDIF 
		lcReturn=laIdcuenta
	CASE lctype="NombreBanco" 

		SELECT idbanco  FROM cuentasbancarias  WHERE idcuenta=lcIdabono INTO ARRAY laIdcuenta
		
		IF VARTYPE(laIdcuenta)="U"
			laBanc=""
		ELSE 
			SELECT descripcion  FROM bancos  WHERE idbanco=laIdcuenta INTO ARRAY laBanc		
			IF VARTYPE(laBanc)="U"
				laBanc=""
			ENDIF 
		ENDIF 
		lcReturn=laBanc
	CASE lctype="CodigoBanco" 

		SELECT idbanco  FROM  cuentasbancarias  WHERE idcuenta=lcIdabono INTO ARRAY laIdcuenta
		
		IF VARTYPE(laIdcuenta)="U"
			laIdcuenta=""
		ENDIF 
		lcReturn=laIdcuenta
	OTHERWISE
		lcReturn=" "
	ENDCASE

	RETURN lcReturn

ENDPROC 
