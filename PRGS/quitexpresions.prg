PROCEDURE QuitExpresions
	LPARAMETERS lcNombre
	DIMENSION laExpresion(5)
	lnBegin=0
	lnLarge=0
	lnLargeNombre=LEN(lcNombre)
	laExpresion(1)="(01)"
	laExpresion(2)="(02)"
	laExpresion(3)="(03)"
	laExpresion(4)="(04)"
	laExpresion(5)="(05)"
	FOR n=1 TO ALEN(laExpresion) 
		lnBegin=ATC(laExpresion(n),lcNombre)
		lnLarge=LEN(laExpresion(n))
		
		IF lnBegin>0
			lcNombre=SUBSTR(lcNombre,1,lnBegin-1)
			lcNombre = lcNombre +  SUBSTR(lcNombre,lnBegin+lnLarge,lnLargeNombre-lnLarge)
		ENDIF 
	ENDFOR 
	RETURN lcNombre
ENDPROC 