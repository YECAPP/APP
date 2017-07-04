CREATE CURSOR PRECIOS (CODIGO C(15),NOMBRE C(60),PRECIO N(10,2))
SELECT precios 
APPEND FROM GETFILE("XLS") TYPE XLS 
GO TOP IN "precios"
DO WHILE !EOF("precios")
	lnPrecio=precios.precio 
	lcCodigo=precios.codigo
	UPDATE inventario SET precioref=lnPrecio WHERE ALLTRIM(codigo)==ALLTRIM(lcCodigo)
	SKIP 1 IN "precios"
ENDDO
