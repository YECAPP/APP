**SE USO PARA CORRER EL CORRELATIVO 2 O 1 ATRAS EN LA TABLA FACTURAS 
CLOSE TABLES ALL 
USE facturas IN 0 

SELECT 	facturas
SCAN 
	lcidventa=facturas.idventa
	lcNumero2=facturas.NUMERO2
	IF !EMPTY(lcNumero2)
		IF lcidventa>="VN00008822"
			replace numero2 WITH "FU"+PADL(TRANSFORM(VAL(SUBSTR(numero2,3,8))-2),8,"0") IN facturas
		ENDIF 
	ENDIF 

ENDSCAN

SELECT 	facturas 
SCAN 
	lcidventa=facturas.idventa
	lcNumero2=facturas.NUMERO2
	IF !EMPTY(lcidventa)
		IF lcidventa>="VN00009429"
			replace numero2 WITH "FU"+PADL(TRANSFORM(VAL(SUBSTR(numero2,3,8))-1),8,"0") IN facturas
		ENDIF 
	ENDIF 

ENDSCAN

*VN00008822 -2

*VN00009429 -1
