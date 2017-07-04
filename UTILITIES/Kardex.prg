PROCEDURE kardex
LPARAMETERS tcCodigo
	SELECT ;
		fecha,;
		detalleorden.norden,;
		detalleorden.descripcion,;
		detalleorden.codigo,;
		detalleorden.cantidad,;
		detalleorden.costo,;
		ROUND(detalleorden.cantidad*detalleorden.costo,4) as entrada,;
		VAL("0000.000000") as salida,;
		detalleorden.line  ;
	FROM ;
		detalleorden INNER JOIN ordencompra ON detalleorden.norden=ordencompra.norden ;
	WHERE  ;
		codigo=tcCodigo;
	UNION ALL ;
	SELECT ;
		fecha,;
		detallerequisicion.nrequisicion,;
		detallerequisicion.descripcion,;
		detallerequisicion.codigo,;
		detallerequisicion.cantidad*-1,;
		detallerequisicion.costo,;
		VAL("0000.000000") as entrada,;		
		ROUND(detallerequisicion.cantidad*detallerequisicion.costo,4) as salida,;
		detallerequisicion.line  ;
	FROM ;
		detallerequisicion INNER JOIN requisiciones ON detallerequisicion.nrequisicion=requisiciones.nrequisicion ;
	WHERE ;
		codigo=tcCodigo ;
	ORDER BY 1

ENDPROC 