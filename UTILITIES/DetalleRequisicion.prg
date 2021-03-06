**DetalleRequisicion.prg
**26 de mayo de 2014 
**sirve para sacar los detalles de movimientos de requisiciones anteriores 
SET DATE FRENCH
SET DELETED ON 

*USE ("29_03_14 07_01_17 AM_DETALLEREQUISICION.DBF") ALIAS DET
SELECT;
	R.FECHA,;
	R.BODEGA,;
	R.NREQUISICION,;
	R.SOLICITANTE,;
	R.DEPTO,;
	R.OBSERVACIONES,;
	R.PROYECTO,;
	DET.CODIGO,;
	NVL(INV.NOMBRE,"SIN CODIGO"),;
	DET.CANTIDAD,;
	DET.COSTO,;
	DET.LINE;
FROM ;
	REQUISICIONES AS R 	INNER JOIN ("c:/det.DBF") AS DET ON R.nrequisicion=DET.nrequisici ;
						LEFT JOIN INVENTARIO AS INV ON ALLTRIM(DET.CODIGO)=ALLTRIM(INV.CODIGO);
WHERE ;
	YEAR(R.FECHA)=2012;
ORDER BY ;
	1;
INTO CURSOR ;
	REQ 

SELECT req 
_vfp.DataToClip(,,3)