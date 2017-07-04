**PONER CLIENTES A SUCURSALES
SELECT;
	mcontrato_eq.idequipo,; 
	mcontrato_eq.descrip2,;
	msucursal.idsucursal,;
	mcontrato.idcontrato,;
	mcontrato.idcliente;
FROM ;
	mcontrato_eq 	INNER JOIN msucursal ON mcontrato_eq.idsucursal=msucursal.idsucursal ;
					INNER JOIN mcontrato on msucursal.idcontrato=mcontrato.idcontrato ;
INTO CURSOR ;
	eqsbycontract
	
	
SELECT eqsbycontract
SCAN 
	lcIdEquipo=eqsbycontract.idequipo
	lcIdSucursal=eqsbycontract.idsucursal
	lcIdContrato=eqsbycontract.idcontrato
	lcIdCliente=eqsbycontract.idcliente
	lcDescrip2=ALLTRIM(eqsbycontract.descrip2)
	SELECT idequipo FROM equipos WHERE idequipo=lcIdEquipo INTO ARRAY laEquipo
	
	IF !VARTYPE(laEquipo)="U"
		UPDATE 	EQUIPOS SET;
			idequipo=lcIdEquipo,;
			idsucursal=lcIdSucursal,;
			idcontrato=lcIdContrato,;
			idcliente=lcIdCliente,;
			encontrato=.t.,;
			ubicacion=lcDescrip2;
		WHERE;
			idequipo=lcIdEquipo
	ELSE
		MESSAGEBOX(lcIdEquipo+" Equipo no se encuentra en los manttos")
	ENDIF 
ENDSCAN
