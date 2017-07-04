SELECT distinct codigo FROM detalleorden WHERE cantidad>0 AND costo=<0 INTO ARRAY laCodigos 

IF !VARTYPE(laCodigos )="U"
	FOR lnCod=1 TO ALEN(laCodigos ,1)
		RELEASE laPRecioRef
		
		lcCodigo=ALLTRIM(laCodigos(lnCod,1))
		SELECT precioref FROM inventario WHERE ALLTRIM(codigo)==lcCodigo INTO ARRAY laPRecioRef 
		IF !VARTYPE(laPRecioRef)="U"
			*UPDATE detalleorden SET descripcion="XSV_"+ALLTRIM(descripcion)  WHERE ALLTRIM(codigo)==lcCodigo AND cantidad>0 AND costo=<0 
			UPDATE detalleorden SET COSTO=laPRecioRef,descripcion="XSV_"+ALLTRIM(descripcion)  WHERE ALLTRIM(codigo)==lcCodigo AND cantidad>0 AND costo=<0 
		ENDIF 
		
	ENDFOR 
	
ENDIF 
*UPDATE detalleorden SET descripcion=SUBSTR(ALLTRIM(descripcion),5,LEN(descripcion))  WHERE SUBSTR(descripcion,1,4)=="XSV_"
