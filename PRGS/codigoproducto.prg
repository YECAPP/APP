FUNCTION  CodigoProducto
	LPARAMETERS xProducto
	IF LEN(ALLTRIM(xProducto))=0
	RETURN "vacio"
	ELSE 
	SELECT inventario.nombre FROM inventario WHERE codigo=xProducto INTO CURSOR xInv
	RETURN xInv.NOMBRE
	ENDIF 
ENDFUNC  