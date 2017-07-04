tbdet="detalleCC"
*tbdet="detallecargosbanco"
DO actualiza
 
PROCEDURE  actualiza
	IF USED(tbdet)
		GO TOP 
		IF USED("oc")
			SCAN 	
				lcOC=ALLTRIM(&tbdet..referencia )
				SELECT monto FROM oc WHERE norden=lcOC INTO ARRAY aloc
				IF !empty(aloc)
					IF aloc >=0
						replace &tbdet..parcial WITH aloc 
						replace &tbdet..tp WITH 1 
					ELSE 
						replace &tbdet..tp WITH 2
						DO actualizaOg WITH lcOC
						replace &tbdet..parcial WITH aloc*-1 
					ENDIF 
				ENDIF 
			ENDSCAN
		ENDIF 
	ENDIF 
ENDPROC 

PROCEDURE actualizaOg
	LPARAMETERS lcOg
		lcAlias=ALIAS()
		SELECT detallegasto
		SCAN FOR NOGASTO=lcOg
			IF cantidad<0
				replace cantidad WITH cantidad*-1
			ENDIF 
			IF costo<0
				replace costo WITH costo*-1
			ENDIF 
		ENDSCAN
		SELECT (lcAlias)
ENDPROC 