SELECT;
	D.REFERENCIA,;
	D.PARCIAL ,;
	F.IDCLIENTE,;
	F.FECHA,;
	C.NOMBRE,;
	F.DESCRIPCION,;
	F.SNETO,;
	F.SIVA,;
	F.SRIVA,;
	F.STOTAL;
FROM ;
	FACTURAS AS F  INNER JOIN DETALLEFACTURAS AS D ON F.IDVENTA=D.IDVENTA ;
					INNER JOIN CLIENTES AS C ON F.IDCLIENTE=C.IDCLIENTE;
WHERE ;
	D.REFERENCIA="PA";
INTO CURSOR ;
	VENTASCONAUTOS
	
SELECT ;
	v.idpresup,;
	v.idvehiculo,;
	v.observaciones,;
	v.placa,;
	v.marca,;
	v.año,;
	v.modelo,;
	v.kilometraje,;
	vc.fecha,;
	vc.idcliente,;
	vc.nombre,;
	vc.descripcion,;
	vc.sneto,;
	vc.siva,;
	vc.sriva,;
	vc.stotal;
FROM ;
	VEHICULOSPRESUP as V INNER JOIN VENTASCONAUTOS as VC ON V.IDPRESUP=VC.REFERENCIA;
into CURSOR ;
	VEHICULOSFACTURADOS
	
	
