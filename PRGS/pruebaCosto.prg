DO fillmove 
DO CreateTable
DO calc 

PROCEDURE calc
	lcCodigo=""
	lcPeriodo=""
	lnEnCant=000.0000
	lnEnCosto=000.0000
	lnEnMonto=000.0000
	lnSalCant=000.0000
	lnSalCosto=000.0000
	lnSalMonto=000.0000
	lnSfCant=000.0000
	lnSfCosto=000.0000
	lnSfMonto=000.0000

	SELECT periodos 
	SCAN 
		
		IF lcCodigo<>periodos.codigo
			lcCodigo=""
			lcPeriodo=""
			lnEnCant=000.0000
			lnEnCosto=000.0000
			lnEnMonto=000.0000
			lnSalCant=000.0000
			lnSalCosto=000.0000
			lnSalMonto=000.0000
			lnSfCant=000.0000
			lnSfCosto=000.0000
			lnSfMonto=000.0000		
		ENDIF 
		WAIT "Calculando: " + lcCodigo WINDOW NOWAIT 
		
		replace SALCOSTO WITH IIF((lnSfCant+EnCant)=0,0,ROUND((lnSfMonto+ENMONTO)/(lnSfCant+EnCant),4))
		replace SALMONTO WITH ROUND(SALCANT*SALCOSTO,4)
		
		replace SFCANT WITH ROUND(lnSfCant+ENCANT-SALCANT,4)
		

		replace SFMONTO WITH ROUND(lnSfMonto+ENMONTO-SALMONTO,4)
		replace SFCOSTO WITH IIF(SFCANT=0,0,ROUND(SFMONTO/SFCANT,4))
		
		
		
		lcCodigo=CODIGO
		lcPeriodo=PERIODO
		lnEnCant=ENCANT
		lnEnCosto=ENCOSTO
		lnEnMonto=ENMONTO
		lnSalCant=SALCANT
		lnSalCosto=SALCOSTO
		lnSalMonto=SALMONTO
		lnSfCant=SFCANT
		lnSfCosto=SFCOSTO
		lnSfMonto=SFMONTO
	
		

	ENDSCAN

	SELECT periodos
	GO TOP
	_vfp.DataToClip(,,3)

	
ENDPROC 


PROCEDURE fillMove
LPARAMETERS tccodigo

	IF !VARTYPE(tccodigo)="L"
		lcClausuleWhere=" WHERE alltrim(UPPER(codigo))==UPPER(tccodigo) "
		lcClausuleWhereFacturas=" WHERE tp=1 AND ALLTRIM(UPPER(referencia))==UPPER(tccodigo) "
	ELSE
		lcClausuleWhere=""
		lcClausuleWhereFacturas=""
	ENDIF 
	
	CREATE CURSOR base(;
		periodo c(6),;
		doc c(10),;
		codigo c(15),;
		entrada n(12,4),;
		salida n(12,4),;
		costo n(12,4))
		
		lnCero=000.0000




	**Entradas en requisiciones
	INSERT INTO base ;
		SELECT ;
			periodo(m.fecha),d.norden,ALLTRIM(d.codigo),d.cantidad,lnCero,IIF(d.costo=lnCero,precioref(d.codigo),d.costo) ;
		FROM ;
			detalleorden D inner join ordencompra M on D.norden=M.norden &lcClausuleWhere
			
	**Salida en requisiciones 
	INSERT INTO base ;
		SELECT;
			periodo(m.fecha),d.nrequisicion,ALLTRIM(d.codigo),lncero,d.cantidad,lncero ;
		FROM ;
			detallerequisicion D inner join requisiciones M on D.nrequisicion=M.nrequisicion  &lcClausuleWhere
	**Salida en facturas 		
	INSERT INTO base ;
		SELECT ;
			periodo(m.fecha),d.idventa,ALLTRIM(d.referencia),lncero,d.cantidad,lncero ;
		FROM ;
			facturaslines D inner join facturas M on  D.idventa=M.idventa &lcClausuleWhereFacturas

ENDPROC 


PROCEDURE CreateTable
	CREATE CURSOR periodos(;
			periodo c(6),;
			codigo c(15),;
			nombre c(60),;
			encant n(12,4),;
			encosto n(12,4),;
			enmonto n(12,4),;
			salcant n(12,4),;
			salcosto n(12,4),;
			salmonto n(12,4),;
			sfcant n(12,4),;
			sfcosto n(12,4),;
			sfmonto n(12,4))
	lnCero=000.0000
	
 	INSERT INTO periodos (periodo,codigo,nombre,encant,encosto,enmonto,salcant);
 		SELECT ;
 			b.Periodo ,;
			b.codigo,;
			i.nombre,;
			SUM(b.entrada),;
			AVG(b.costo),;
			SUM(b.entrada*b.costo),;
			SUM(b.salida);
		FROM ;
			base b inner join inventario i on b.codigo=i.codigo;
		group by;
			1,2,3;
		order by ;
			2,1
			
			
	
ENDPROC 

PROCEDURE Periodo
LPARAMETERS tdFecha 
	lnMonth=MONTH(tdFecha )
	lnYear=YEAR(tdFecha )
	lcreturn=TRANSFORM(lnYear)+PADL(TRANSFORM(lnMonth),2,"0")
	RETURN lcreturn
ENDPROC 

PROCEDURE PrecioRef
lparameter tcCodigo
	**calculando el valor para los que estan a cero 
	SELECT precioref FROM inventario WHERE ALLTRIM(codigo)==UPPER(tccodigo) INTO ARRAY laCostoRef
	
	IF !VARTYPE(laCostoRef)="U"
		lnCostoRef=laCostoRef
	ELSE 
		lnCostoRef=0.00
	ENDIF 
	**calculando el valor para los que estan a cero 
	RETURN lnCostoRef
ENDPROC 

PROCEDURE pruebacosto2
LPARAMETERS tccodigo,tdfecha
	CREATE CURSOR base(;
		fecha d,;
		doc c(10),;
		codigo c(15),;
		entrada n(12,4),;
		salida n(12,4),;
		costo n(12,4))
		
		lnCero=000.0000
		
	INSERT INTO base ;
		SELECT ;
			m.fecha,d.norden,ALLTRIM(d.codigo),d.cantidad,lnCero,d.costo ;
		FROM ;
			detalleorden D inner join ordencompra M on D.norden=M.norden ;
		WHERE ;
			alltrim(UPPER(codigo))==UPPER(tccodigo) AND M.fecha<=tdfecha
		
	INSERT INTO base ;
		SELECT;
			m.fecha,d.nrequisicion,ALLTRIM(d.codigo),lncero,d.cantidad,lncero ;
		FROM ;
			detallerequisicion D inner join requisiciones M on D.nrequisicion=M.nrequisicion;
		WHERE;
			ALLTRIM(UPPER(codigo))==UPPER(tccodigo) AND M.fecha<=tdfecha
		
	INSERT INTO base ;
		SELECT ;
			m.fecha,d.idventa,ALLTRIM(d.referencia),lncero,d.cantidad,lncero ;
		FROM ;
			facturaslines D inner join facturas M on  D.idventa=M.idventa;
		WHERE ;
			tp=1 AND ALLTRIM(UPPER(referencia))==UPPER(tccodigo) AND M.fecha<=tdfecha
			
	
	SELECT base 

	SELECT SUM(entrada*IIF(costo=0,lnCostoRef,costo))/SUM(entrada) FROM base INTO ARRAY laCostoEntrada

**PASAR A EXCEL 
	SELECT ;
		fecha,;
		doc,;
		CODIGO,;
		entrada,;
		SALIDA,;
		IIF(costo=0,lnCostoRef,costo);
	FROM ;
		base ;
	INTO CURSOR PARAPRUEBA 
	SELECT PARAPRUEBA 
	GO TOP 
	_VFP.DataToClip(,,3)
**PASAR A EXCEL 	 

	IF !VARTYPE(laCostoEntrada)="X"
		SELECT SUM(entrada*IIF(costo=0,lnCostoRef,costo)-salida*laCostoEntrada)/SUM(entrada-salida) FROM base 
	ENDIF 

	
ENDPROC 
