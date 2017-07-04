*DO DELALL 
*DO INSERTOC
*DO INSERTRQ
*DO EXISTENCIA  
*DO BACKUPOC
*DO BACKUPRQ
PROCEDURE BACKUPOC
	USE DETALLEORDEN 
	COPY TO FULLPATH("")+STRTRAN(STRTRAN(ttoc(DATEtime())+"_"+ALIAS(),"/","_"),":","_")
	MESSAGEBOX("Orden de compra respaldada")
ENDPROC 

PROCEDURE BACKUPRQ
	USE DETALLEREQUISICION
	COPY TO FULLPATH("")+STRTRAN(STRTRAN(ttoc(DATEtime())+"_"+ALIAS(),"/","_"),":","_")
	MESSAGEBOX("Requisicion respaldada")
ENDPROC 

PROCEDURE EXISTENCIA 

	SELECT ;
		RES.CODIGO,;
		SUM(RES.CANTIDAD);
	FROM ;
	(SELECT ;
		D.CODIGO AS CODIGO,;
		SUM(D.CANTIDAD) AS CANTIDAD;
	FROM ;
		ORDENCOMPRA as M inner join DETALLEORDEN as D on m.norden=D.norden;
	WHERE ;
		YEAR(fecha)<2014;
	GROUP BY 1;
	UNION ALL ;
	SELECT ;
		D.CODIGO,;
		SUM(D.CANTIDAD*-1);
	FROM ;
		REQUISICIONES as M inner join DETALLEREQUISICION as D on m.NREQUISICION=D.NREQUISICION;
	WHERE ;
		YEAR(fecha)<2014;
	GROUP BY ;
		1) AS RES;
	GROUP BY 1

ENDPROC 	
	
	


PROCEDURE DELALL
	DELETE FROM DETALLEORDEN WHERE NORDEN IN (SELE NORDEN FROM ORDENCOMPRA WHERE YEAR(FECHA)<2014 )
	DELETE FROM DETALLEREQUISICION WHERE NREQUISICION IN (SELE NREQUISICION FROM REQUISICIONES WHERE YEAR(FECHA)<2014 )
	MESSAGEBOX("TODO BORRADO ")
ENDPROC 

PROCEDURE INSERTRQ
lcTable=GETFILE("DBF","RQ")
IF JUSTFNAME(lcTable)="29_03_14 07_01_17 AM_DETALLEREQUISICION.DBF"
	INSERT INTO DETALLEREQUISICION (;
		NREQUISICION,;
		CODIGO,;
		DESCRIPCION,;
		CANTIDAD,;
		COSTO,;
		EXIST,;
		FEC_VENC,;
		LOTE,;
		IMEI,;
		PROYECTO,;
		DEPTO);
	Sele ;
		NREQUISICI,;
		CODIGO,;
		DESCRIPCIO,;
		CANTIDAD,;
		COSTO,;
		EXIST,;
		FEC_VENC,;
		LOTE,;
		IMEI,;
		PROYECTO,;
		DEPTO;
	from ;
		(lcTable);
ELSE 
	MESSAGEBOX("TABLA NO ES "+"29_03_14 07_01_17 AM_DETALLEREQUISICION.DBF")
ENDIF 

ENDPROC 

PROCEDURE INSERTOC
	lcTable=GETFILE("DBF","OC")
	IF ALLTRIM(JUSTFNAME(lcTable))="COPIA_DETALLEORDEN_ANTESDELIQUIDAR_29_MAR_2014.DBF"
		INSERT INTO DETALLEORDEN (;
			NORDEN,;
			DESCRIPCION,;
			CODIGO,;
			CANTIDAD,;
			COSTO,;
			IDCATALOGO,;
			FEC_VENC,;
			LOTE,;
			IMEI,;
			PROYECTO,;
			DEPTO,;
			CPERSON,;
			CIVA,;
			CRIVA,;
			CRENTA);
		SELE ;
			NORDEN,;
			DESCRIPCIO,;
			CODIGO,;
			CANTIDAD,;
			COSTO,;
			IDCATALOGO,;
			FEC_VENC,;
			LOTE,;
			IMEI,;
			PROYECTO,;
			DEPTO,;
			CPERSON,;
			CIVA,;
			CRIVA,;
			CRENTA;
		FROM ;
			(lcTable)
	ELSE
		MESSAGEBOX("TABLA NO ES "+"copia_detalleorden_antesdeliquidar_29_mar_2014.DBF")
	ENDIF 
ENDPROC 


*SELECT ;
	M.fecha,;
	D.*;
from ;
	ordencompra as M inner join detalleorden as D on m.norden=D.norden;
where ;
	YEAR(fecha)<2014

*SELECT M.fecha,D.* from ordencompra as M inner join detalleorden as D on m.norden=D.norden where YEAR(fecha)<2014

*INSERT INTO DETALLEORDEN (;
	NORDEN,;
	DESCRIPCION,;
	CODIGO,;
	CANTIDAD,;
	COSTO,;
	IDCATALOGO,;
	FEC_VENC,;
	LOTE,;
	IMEI,;
	PROYECTO,;
	DEPTO,;
	CPERSON,;
	CIVA,;
	CRIVA,;
	CRENTA);
SELE ;
	NORDEN,;
	DESCRIPCIO,;
	CODIGO,;
	CANTIDAD,;
	COSTO,;
	IDCATALOGO,;
	FEC_VENC,;
	LOTE,;
	IMEI,;
	PROYECTO,;
	DEPTO,;
	CPERSON,;
	CIVA,;
	CRIVA,;
	CRENTA;
FROM ;
	COPIA_DETALLEORDEN_ANTESDELIQUIDAR_29_MAR_2014
	



	
*INSERT INTO DETALLEREQUISICION (;
	NREQUISICION,;
	CODIGO,;
	DESCRIPCION,;
	CANTIDAD,;
	COSTO,;
	EXIST,;
	FEC_VENC,;
	LOTE,;
	IMEI,;
	PROYECTO,;
	DEPTO);
Sele ;
	NREQUISICI,;
	CODIGO,;
	DESCRIPCIO,;
	CANTIDAD,;
	COSTO,;
	EXIST,;
	FEC_VENC,;
	LOTE,;
	IMEI,;
	PROYECTO,;
	DEPTO;
from ;
	("C:\USERS\YEC\DOCUMENTS\FOX\GAA\CIERRE INV\29_03_14 07_01_17 AM_DETALLEREQUISICION.DBF");




*SELECT ;
	M.fecha,;
	D.*;
from ;
	REQUISICIONES as M inner join DETALLEREQUISICION as D on m.NREQUISICION=D.NREQUISICION;
where ;
	YEAR(fecha)<2014


	