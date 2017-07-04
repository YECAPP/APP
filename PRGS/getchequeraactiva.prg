PROCEDURE getChequeraActiva
LPARAMETERS lcIdCuenta
	LOCAL lcChequeraActiva,lnActivas,lnInicia,lnFinaliza,lcAlias
	**comprobar si esta abierta la tabla de chequeras 
	lcAlias=ALIAS()
	
	&&verificar numero chequeras activas, debe ser igual a 1
	SELECT ;
		COUNT(IdChequera) as ChequerasActivas;
	FROM chequeras ;
	WHERE ;
		IdCuenta=lcIdCuenta AND ;
		activa=.t.;
	INTO CURSOR tempchequeracount
	lnActivas=tempchequeracount.chequerasActivas

	IF lnActivas=1
		&&Consultar IDChequera
		SELECT ;
			IdChequera, ;
			inicia, ;
			finaliza; 
		FROM chequeras ;
		WHERE ;
			IdCuenta=lcIdCuenta AND ;
			activa=.t.;
		INTO CURSOR tempchequera
		SELECT tempchequera
		&&si existen dos activas devolvera la primera
		GO top
		lcChequeraActiva=tempchequera.IdChequera
		lnInicia=tempchequera.inicia
		lnFinaliza=tempchequera.finaliza
		
		
		
		
		IF USED("tempchequeracount")
		
			SELECT tempchequeracount
			USE 
		
		ENDIF 	
		
		
		IF USED("tempchequera")
			SELECT tempchequera

			USE 
		ENDIF 
		

		IF USED("chequeras")
			SELECT chequeras
			USE 
		ENDIF 
		IF !EMPTY(lcAlias)
			SELECT (lcAlias)
		ENDIF 
		RETURN lcChequeraActiva
	ELSE
		IF  USED("chequeras")
			SELECT chequeras
			USE 
		ENDIF 
		RETURN .null.
	ENDIF 
ENDPROC 