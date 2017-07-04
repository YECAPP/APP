PROCEDURE getAutoCorrelActivo
	LPARAMETERS lcIdDoc
	LOCAL lcAutoCorrelActivo,lnActivos,lnInicia,lnFinaliza
	
	&&verificar numero chequeras activas, debe ser igual a 1
	SELECT ;
		COUNT(IdAutoCorrel) as AutoCorrelActivos;
	FROM AutoCorrel ;
	WHERE ;
		IdDoc=lcIdDoc AND ;
		activa=.t.;
	INTO CURSOR TempAutoCorrelCount
	lnActivos=TempAutoCorrelCount.AutoCorrelActivos
	
	DO CASE
	CASE lnActivos=0
		MESSAGEBOX("No existen Autorizaciones de Correlativos Activos para este tipo de documento")
		RETURN .null.
	CASE lnActivos=1
		&&Consultar IDAutoCorrel
		SELECT ;
			IdAutoCorrel, ;
			inicia, ;
			finaliza; 
		FROM ;
			AutoCorrel ;
		WHERE ;
			IdDoc=lcIdDoc AND ;
			activa=.t.;
		INTO CURSOR TempAutoCorrel
		SELECT TempAutoCorrel
		&&si existen dos activas devolvera la primera
		GO top
		lcAutoCorrelActivo=TempAutoCorrel.IdAutoCorrel
		RETURN lcAutoCorrelActivo
	CASE  lnActivos>=2
		&&Consultar IDAutoCorrel
		SELECT ;
			IdAutoCorrel, ;
			inicia, ;
			finaliza; 
		FROM ;
			AutoCorrel ;
		WHERE ;
			IdDoc=lcIdDoc AND ;
			activa=.t.;
		INTO CURSOR TempAutoCorrel
		SELECT TempAutoCorrel
		&&si existen dos activas devolvera la primera
		MESSAGEBOX("Existen 2 o mas Autorizaciones de correlativos activos para este documento se devolvera el primero")
		GO TOP
		lcAutoCorrelActivo=TempAutoCorrel.IdAutoCorrel
		RETURN lcAutoCorrelActivo
	OTHERWISE
		MESSAGEBOX("Ocurrio un error con la autorizacion de correlativos ")
		RETURN .null.
	ENDCASE
ENDPROC 