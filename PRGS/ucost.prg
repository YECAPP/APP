lPARAMETERS tdfecha1, tdfecha2

CREATE CURSOR TABLAMES  (;
	codigo c(15),;
	nombre c(180),;
	unidad c(15),;
	año int,;
	mes int ,;
	PCANT N(10,4),;
	PCOST N(10,4),;
	SALDOI N(10,4),;
	CANTENT N(10,4)	,;
	ENTRADAS N(10,4),;
	CANTSAL N(10,4),;
	SALIDAS N(10,4),;
	UCANT N(10,4),;	
	UCOST N(10,4),;
	SALDOF N(10,4))


IF VARTYPE(_screen.yDataManage1)="U"
	_screen.NewObject("yDataManage1","yDataManage","\lib1.0\yoapp.vcx")
ENDIF

_screen.YDATAMANAGE1.MOVINV_USE 

SELECT MOVINV 
SET ORDER TO CODIGO_FEC  IN movinv 

IF USED("inventario")

ELSE
	USE inventario IN 0 	
ENDIF 

SET ORDER TO CODIGO IN inventario 

*DO calcper WITH CTOD("02/01/2014"),CTOD("31/03/2014")
DO calcper WITH tdfecha1,tdfecha2
*!*	DO calcper WITH CTOD("01/01/2013"),CTOD("31/01/2013")
*!*	DO calcper WITH CTOD("01/02/2013"),CTOD("28/02/2013")
*!*	DO calcper WITH CTOD("01/03/2013"),CTOD("31/03/2013")
*!*	DO calcper WITH CTOD("01/04/2013"),CTOD("30/04/2013")
*!*	DO calcper WITH CTOD("01/05/2013"),CTOD("31/05/2013")
*!*	DO calcper WITH CTOD("01/06/2013"),CTOD("30/06/2013")
*!*	DO calcper WITH CTOD("01/07/2013"),CTOD("31/07/2013")
*!*	DO calcper WITH CTOD("01/08/2013"),CTOD("31/08/2013")
*!*	DO calcper WITH CTOD("01/09/2013"),CTOD("30/09/2013")
*!*	DO calcper WITH CTOD("01/10/2013"),CTOD("31/10/2013")
*!*	DO calcper WITH CTOD("01/11/2013"),CTOD("30/11/2013")
*!*	DO calcper WITH CTOD("01/12/2013"),CTOD("31/12/2013")

PROCEDURE limpiarInv
	SELECT inventario 
		replace ALL ;
		pcant WITH 0.000 ,;
		Pcost WITH 0.000 ,;
		Saldoi  WITH 0.00 ,;
		Cantent WITH 0.00 ,;
		Entradas WITH 0.00,;
		Cantsal WITH 0.00,;
		Salidas WITH 0.00,;
		Ucant WITH 0.00 ,;
		Ucost  WITH 0.00,;
		Saldof WITH 0.00 
ENDPROC 

PROCEDURE calcper
LPARAMETERS tdFecha1, tdFecha2
	DO limpiarInv
	ldFecha1=tdFecha1 
	ldFecha2=tdFecha2 

	DO SALDO_INICIAL 
	DO SALDO_FINAL 
	DO movs
	
	INSERT INTO TABLAMES  ;
		SELECT 	;
			codigo ,;
			nombre ,;
			unidad,;
			YEAR(ldfecha2),;
			MONTH(ldfecha2) int ,;
			PCANT ,;
			PCOST ,;
			SALDOI ,;
			CANTENT ,;
			ENTRADAS ,;
			CANTSAL ,;
			SALIDAS ,;
			UCANT ,;	
			UCOST ,;
			SALDOF;
		FROM ;
			inventario 



ENDPROC 




PROCEDURE movs
	lcCodigo=""
	lnEntrada=0.0000
	lnSalida=0.0000
	lnCantEnt=0.0000
	lnCantSal=0.0000
	SELECT movinv 
	SCAN FOR fecha>=ldFecha1 AND fecha<=ldFecha2
		IF !EMPTY(lcCodigo)
			IF lcCodigo<>movinv.codigo 
				SELECT inventario 
				SEEK lcCodigo  
				IF FOUND()
					replace cantent WITH lnCantEnt,entradas WITH lnEntrada ,cantsal WITH lnCantSal ,salidas WITH lnSalida IN inventario 	
					WAIT "Poniendo entradas y salidas a "+lcCodigo  WINDOW NOWAIT 
				ENDIF 
				
				lnSalida =0.0000
				lnEntrada = 0.0000
				lnCantSal =0.0000
				lnCantEnt=0.0000
			ENDIF 
		ENDIF 
		SELECT movinv 
		lcCodigo=movinv.codigo 
		lnCost=movinv.costo	
		lnCant=movinv.cant

		IF lnCant<0
			lnSalida= lnSalida+ROUND(lnCant*lnCost,4)
			lnCantSal = lnCantSal + lnCant
		ELSE 
			lnEntrada = lnEntrada +ROUND(lnCant*lnCost,4)
			lnCantEnt = lnCantEnt + lnCant
		ENDIF 
		
*!*			IF lcCodigo="01010202"
*!*				MESSAGEBOX(	"lnCantSal :"+TRANSFORM(lnCantSal)+CHR(13)+;
*!*							"lnCantEnt :"+TRANSFORM(lnCantEnt ))
*!*			ENDIF 
	ENDSCAN 

	SELECT inventario 
	SEEK lcCodigo  
	IF FOUND()
		REPLACE cantent WITH lnCantEnt,entradas WITH lnEntrada ,cantsal WITH lnCantSal ,salidas WITH lnSalida IN inventario 	
		WAIT "Poniendo entradas y salidas a "+lcCodigo  WINDOW NOWAIT 
	ENDIF 

ENDPROC 


PROCEDURE SALDO_INICIAL 
	lcCodigo=""
	lnUCost=0.0000
	lnCant=0.0000
	SELECT movinv 
**	SCAN FOR fecha<=ldFecha1 5 de mar 2014

	SCAN FOR fecha<ldFecha1
		IF !EMPTY(lcCodigo)
			IF lcCodigo<>movinv.codigo 
				SELECT inventario 
				SEEK lcCodigo  
				IF FOUND()
					replace pcant WITH lnCant,pcost WITH lnUCost,saldoi WITH ROUND(lnCant*lnUCost,4) IN inventario 	
					WAIT "Poniendo costo inicial a "+lcCodigo  WINDOW NOWAIT 
				ENDIF 
				lnCant =0.0000
			ENDIF 
		ENDIF 
		SELECT movinv 
		lcCodigo=movinv.codigo 
		lnUCost=movinv.costoprom 	
		lnCant = lnCant + movinv.cant
	ENDSCAN 

	SELECT inventario 
	SEEK lcCodigo  
	IF FOUND()
		replace pcant WITH lnCant,pcost WITH lnUCost,saldoi WITH ROUND(lnCant*lnUCost,4) IN inventario 	
		WAIT "Poniendo costo inicial a "+lcCodigo  WINDOW NOWAIT 
	ENDIF 

ENDPROC 

PROCEDURE SALDO_FINAL
	lcCodigo=""
	lnCant=0.0000
	SELECT movinv 	
	SCAN FOR fecha<=ldFecha2
		IF !EMPTY(lcCodigo)
			IF lcCodigo<>movinv.codigo 
				SELECT inventario 
				SEEK lcCodigo  
				IF FOUND()
					replace ucant WITH lnCant,ucost WITH lnUCost,saldof WITH ROUND(lnCant*lnUCost,4)  IN inventario 	
					WAIT "Poniendo costo final a  "+lcCodigo  WINDOW NOWAIT 
				ENDIF 
				lnCant =0.0000
			ENDIF 
		ENDIF 
		SELECT movinv 
		lcCodigo=movinv.codigo 
		lnUCost=movinv.costoprom 	
		lnCant = lnCant + movinv.cant
	ENDSCAN 

	SELECT inventario 
	SEEK lcCodigo  
	IF FOUND()
		REPLACE ucant WITH lnCant,ucost WITH lnUCost,saldof WITH ROUND(lnCant*lnUCost,4)  IN inventario 	
		WAIT "Poniendo costo final a  "+lcCodigo  WINDOW NOWAIT 
	ENDIF 


ENDPROC 

