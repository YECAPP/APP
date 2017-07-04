SEGUIR=6
DO WHILE SEGUIR=6
	NUMERO=ALLTRIM(INPUTBOX("INGRESE FACTURA","INGRESO DE FACTURA"))
	lnNumero=VAL(INPUTBOX("INGRESE VALOR","INGRESE VALOR"))
	lcNUMERO="FF000"+NUMERO
	lnNumero=lnNumero/1.13

	IF !EMPTY(lnNumero) AND  !EMPTY(NUMERO)
		SELECT ;
			IDVENTA;
		FROM;
			FACTURAS;
		WHERE ;
			NUMERO=lcNUMERO;
		INTO ARRAY ;
			acIdVenta
			
			
				
		IF !TYPE("acIdVenta")="U"
			IF !USED("facturaslines")
				USE facturaslines IN 0
			ENDIF 
			SELECT facturaslines
			BROWSE FOR idventa=acIdVenta
			replace precio WITH lnNumero/CANTIDAD FOR idventa=acIdVenta AND cantidad=>1  IN FACTURASLINES 
			BROWSE FOR idventa=acIdVenta
			GENCURVAL2(.t.)
			SELECT PR 
			BROWSE FOR  idpresup=acIdVenta 
		ELSE 
			MESSAGEBOX("No se encontro esa factura")
		ENDIF 
	ELSE 
		MESSAGEBOX("Datos de Actualizacion incompletos ")
		IF !EMPTY(lcNumero)
			SELECT ;
				IDVENTA;
			FROM;
				FACTURAS;
			WHERE ;
				NUMERO=lcNUMERO;
			INTO ARRAY ;
				acIdVenta
			IF !TYPE("acIdVenta")="U"
				GENCURVAL2(.t.)
				SELECT PR 
				BROWSE FOR  idpresup=acIdVenta 

			ELSE 
				MESSAGEBOX("No se encontro esa factura")
			ENDIF 
		ENDIF 
	ENDIF 
	SEGUIR=MESSAGEBOX("SEGUIR",4)
ENDDO 