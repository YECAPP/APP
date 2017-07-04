DO CONFIGAPP 
*DO DATOSJOINUS
*DO DATOSREQ
*DO DATOSORDENCOMPRA
*DO ACTUALIZAR 
*DO DATOSPRUEBA

IF !VARTYPE(_SCREEN.YDATAManage)="O"
	_screen.newObject("yDataManage","ydatamanage","lib1.0\yoapp.vcx")	
ENDIF 

DO CREAR_MOVINV 
_SCREEN.YDATAMANAGE.Movinv_Costos_Update

PROCEDURE DATOSJOINUS 
	IF !VARTYPE(_SCREEN.YDATAManage)="O"
		_screen.newObject("yDataManage","ydatamanage","lib1.0\yoapp.vcx")	
	ENDIF 

	IF USED("MOVINV")
		SELECT movinv 
		USE 
	ENDIF 
	
	lbOk=.f.
	TRY 
		USE movinv exclusive IN 0 
		lbOk=.t.
	CATCH
		
	FINALLY

	ENDTRY

	IF lbOk
		SELECT movinv 
		DELETE ALL 
		PACK 
	ELSE
		USE movinv IN 0 
		DELETE ALL 
	ENDIF 


	CREATE CURSOR JOINUS (;
		LINE I ,;
		FECHA D,;
		CODIGO C(8),;
		DOC C(10),;
		OBSERVACIONES C(155),;
		DESCRIPCION C(100),;
		CANTIDAD N(12,4),;
		COSTO N(12,4);
	)
	
	SELECT JOINUS 
	INDEX ON DTOS(FECHA)+ ALLTRIM(STR(LINE,10,0)) TAG FECHA
	
		
	INSERT INTO JOINUS ;
	SELECT ;
		d.line,;
		m.fecha,;
		d.codigo,;
		d.nrequisicion,;
		m.observaciones,;
		d.descripcion,;
		d.cantidad*-1,;
		d.costo ;
	FROM ;
		REQUISICIONES as m INNER JOIN DETALLEREQUISICION as d ON m.nrequisicion=d.nrequisicion;
	UNION ALL ;
	SELECT ;
		d.line,;
		m.fecha,;
		d.codigo,;
		d.norden,;
		m.observaciones,;
		d.descripcion,;
		d.cantidad,;
		d.costo ;
	FROM ;
		ordencompra as m INNER JOIN detalleorden as d ON m.norden=d.norden

	SELECT JOINUS 
	SET ORDER TO FECHA 
	GO TOP IN JOINUS 
	
	
	
	
	DO WHILE !EOF("JOINUS")
			NLINE=0
			NLINEINDOC=JOINUS.LINE
			DFECHA=JOINUS.FECHA 
			CCODIGO=JOINUS.CODIGO
			CDOC=JOINUS.DOC
			CDESCDOC=JOINUS.OBSERVACIONES
			CDESCDET=JOINUS.DESCRIPCION
			NCANT=JOINUS.CANTIDAD
			NCOSTO=JOINUS.COSTO
			NSALDO=1
						
			_screen.yDataManage.MOVINV_INS(NLINE,NLINEINDOC,DFECHA,CCODIGO,CDOC,CDESCDOC,CDESCDET,NCANT,NCOSTO,NSALDO)
			SELECT JOINUS 
			SKIP 1 IN JOINUS 

	ENDDO 	
	
*!*		IF !VARTYPE(LAEXISTEN)="U"
*!*			FOR lnExisten=1 TO ALEN(LAEXISTEN,1) 
*!*		
*!*				NLINE=0
*!*				NLINEINDOC=LAEXISTEN(lnExisten,1)
*!*				DFECHA=LAEXISTEN(lnExisten,2)
*!*				CCODIGO=LAEXISTEN(lnExisten,3)
*!*				CDOC=LAEXISTEN(lnExisten,4)
*!*				CDESCDOC=LAEXISTEN(lnExisten,5)
*!*				CDESCDET=LAEXISTEN(lnExisten,6)
*!*				NCANT=LAEXISTEN(lnExisten,7)
*!*				NCOSTO=LAEXISTEN(lnExisten,8)
*!*				NSALDO=1
*!*				
*!*				*_screen.yDataManage.MOVINV_INS(NLINE,NLINEINDOC,DFECHA,CCODIGO,CDOC,CDESCDOC,CDESCDET,NCANT,NCOSTO,NSALDO)
*!*			ENDFOR 
*!*		ENDIF 

ENDPROC 

PROCEDURE DATOSREQ
	IF !VARTYPE(_SCREEN.YDATAManage)="O"
		_screen.newObject("yDataManage","ydatamanage","lib1.0\yoapp.vcx")	
	ENDIF 

	SELECT ;
		d.line,;
		m.fecha,;
		d.codigo,;
		d.nrequisicion,;
		m.observaciones,;
		d.descripcion,;
		d.cantidad,;
		d.costo ;
	FROM ;
		REQUISICIONES as m INNER JOIN DETALLEREQUISICION as d ON m.nrequisicion=d.nrequisicion;
	into ARRAY ;
		LAEXISTEN

		
	FOR N=1 TO ALEN(LAEXISTEN,1) 
		NLINE=0
		NLINEINDOC=LAEXISTEN(n,1)
		DFECHA=LAEXISTEN(n,2)
		CCODIGO=LAEXISTEN(n,3)
		CDOC=LAEXISTEN(n,4)
		CDESCDOC=LAEXISTEN(n,5)
		CDESCDET=LAEXISTEN(n,6)
		NCANT=LAEXISTEN(n,7)
		NCOSTO=LAEXISTEN(n,8)
		NSALDO=1
		_screen.yDataManage.MOVINV_INS(NLINE,NLINEINDOC,DFECHA,CCODIGO,CDOC,CDESCDOC,CDESCDET,NCANT,NCOSTO,NSALDO)
		
	ENDFOR 

ENDPROC 

PROCEDURE DATOSORDENCOMPRA
	IF !VARTYPE(_SCREEN.YDATAManage)="O"
		_screen.newObject("yDataManage","ydatamanage","lib1.0\yoapp.vcx")	
	ENDIF 


	**enviar lo que ya esta 
	SELECT ;
		d.line,;
		m.fecha,;
		d.codigo,;
		d.norden,;
		m.observaciones,;
		d.descripcion,;
		d.cantidad,;
		d.costo ;
	FROM ;
		ordencompra as m INNER JOIN detalleorden as d ON m.norden=d.norden;
	into ARRAY ;
		LAEXISTEN

		
	FOR N=1 TO ALEN(LAEXISTEN,1) 
		NLINE=0
		NLINEINDOC=LAEXISTEN(n,1)
		DFECHA=LAEXISTEN(n,2)
		CCODIGO=LAEXISTEN(n,3)
		CDOC=LAEXISTEN(n,4)
		CDESCDOC=LAEXISTEN(n,5)
		CDESCDET=LAEXISTEN(n,6)
		NCANT=LAEXISTEN(n,7)
		NCOSTO=LAEXISTEN(n,8)
		NSALDO=1
		_screen.yDataManage.MOVINV_INS(NLINE,NLINEINDOC,DFECHA,CCODIGO,CDOC,CDESCDOC,CDESCDET,NCANT,NCOSTO,NSALDO)		
	ENDFOR 
ENDPROC 


PROCEDURE actualizar
LPARAMETERS tnline,tccodigo,tnsentido

**HACIA ADELANTE 
	IF !USED("MOVINV")
		USE MOVINV IN 0  
	ENDIF 
	
	SELECT movinv 
	SET ORDER TO line 
	SEEK tnline 

	
IF tnSentido=1
	IF FOUND()
		SET ORDER TO fecha 

		lnSaldo=MOVINV.Saldo 
		lnCalc=MOVINV.CALC
		lnCostoProm=MOVINV.COSTOPROM
		lnAcum_neg=MOVINV.ACUM_NEG
		lnSaldo_Pos=MOVINV.SALDO_POS
		
		lnSaldo_Ant=0
		SKIP 1 
		DO WHILE !EOF() OR lnSaldo=0
		
		
		
		*	BROWSE FIELDS fecha,cant, costo,calc,saldo,costoprom,acum_neg,Saldo_pos
			
		&&1)SUMAR  SALDO 
			lnSaldo_Ant=lnSaldo
			lnSaldo = lnSaldo + MOVINV.cant 
			replace saldo WITH lnSaldo
		&&FIN SUMAR SALDO 	

		&&2)PONIENDO EL COSTO
			IF MOVINV.CANT<=0   &&???duda 
				REPLACE COSTO WITH lnCostoPRom
			ENDIF 
		&&FIN PONIENDO EL COSTO

		&&3)SUMAR EL SALDO POSITIVO 
			IF lnSaldo_Ant<0
				IF MOVINV.CANT>=0
					lnSaldo_Pos = lnSaldo_Pos + MOVINV.CANT
				ELSE 
					&&lnSaldo_Pos=0.00
				ENDIF 
			ELSE
				lnSaldo_Pos=0.00
			ENDIF 
			replace SALDO_POS WITH lnSaldo_Pos					
		&&FIN SUMAR EL SALDO POSITIVO 
		
		&&4)PONIENDO EL CALC
			IF (lnsaldo_Ant+MOVINV.CANT)>=0
				lncalc = lncalc + ROUND(MOVINV.COSTO*MOVINV.CANT,4)
			ELSE
				IF lnSaldo_Ant>0
					lncalc = lncalc + ROUND(MOVINV.COSTO*lnSaldo_Ant,4)*-1
					
				ELSE 
					IF MOVINV.CANT>0
						lncalc = lncalc + ROUND(MOVINV.COSTO*MOVINV.CANT,4)
						
					ELSE 
						lncalc=0
					ENDIF 
				ENDIF 
			ENDIF 
			REPLACE CALC WITH lnCalc 
		&&FIN PONIENDO EL CALC
		
		&&5)PONIENDO EL  NUEVO COSTOPROM 
					*MESSAGEBOX(	"MOVINV.CALC:"+TRANSFORM(MOVINV.CALC)+CHR(13)+;
						"MOVINV.SALDO:"+TRANSFORM(MOVINV.SALDO)+CHR(13)+;
						"lnSaldo_pos:"+TRANSFORM(lnSaldo_pos))

		
			IF MOVINV.SALDO>0
				IF lnSaldo_Ant>=0

					lnCostoProm =  ROUND(MOVINV.CALC/MOVINV.SALDO,4)
				ELSE 

					lnCostoProm =  ROUND(MOVINV.CALC/lnSaldo_Pos,4)
					
				ENDIF 
			ELSE 
				IF MOVINV.CANT>0

					lnCostoProm =  ROUND(MOVINV.CALC/lnSaldo_Pos,4)
					
				ELSE
					lnCostoProm =0.00	
				ENDIF 
			ENDIF 
						
			replace COSTOPROM WITH lnCostoProm
		&&FIN PONER COSTO PROMEDIO 
		
		&&6)ACUMULADOR NEGATIVO 
			IF MOVINV.SALDO<0 AND MOVINV.cant <0
				IF lnSaldo_Ant>=0
					LNACUM_NEG = MOVINV.SALDO
					*MESSAGEBOX(TRANSFORM(line)+": MOVINV.SALDO*-1  :  "+TRANSFORM(MOVINV.SALDO*-1))
				ELSE
					LNACUM_NEG = MOVINV.cant 
				ENDIF
			ENDIF  	
			IF MOVINV.SALDO<0 AND MOVINV.cant >=0
				LNACUM_NEG = MOVINV.cant 
			ENDIF 
			IF MOVINV.SALDO=>0 AND MOVINV.cant >=0
				IF lnSaldo_Ant<0 
					LNACUM_NEG = lnSaldo_Ant*-1
				ELSE
					LNACUM_NEG=0
				ENDIF
			ENDIF 
			IF MOVINV.SALDO>=0 AND MOVINV.cant <0
				LNACUM_NEG=0
			ENDIF 	
			
			replace acum_neg WITH lnAcum_Neg 
		&&FIN ACUMULADOR NEGATIVO 
		
			SKIP 1 
		ENDDO 
	ENDIF 
ELSE 
**HACIA ATRAS
	IF !USED("MOVINV")
		USE MOVINV IN 0  
	ENDIF 
	SELECT movinv 
	SET ORDER TO line 
	SEEK tnline 
	IF FOUND()
		SET ORDER TO fecha 
		lnVariableRetorno=.f. 
		
		
		lnReverse=0
		lnAcum_Neg_Ant=0.00
		lncostoprom=0.00
		lncalc=0.00
		lbIn=.T.
		DO WHILE lbIn
			IF lnVariableRetorno=.f. 
				IF ACUM_NEG>=0
					lnReverse= lnReverse + ROUND(MOVINV.COSTO*MOVINV.ACUM_NEG,4)
					IF lnAcum_Neg_Ant<0
						lnVariableRetorno=.T. 
						lncalc=MOVINV.CALC
						lnsaldo_Ant=MOVINV.SALDO
						SKIP 1
						&&por si estuviera en el ultimo hay que comprobar eof()
						IF EOF()
							lbIn=.F. 
						ENDIF 
						LOOP 
					ENDIF 
				ELSE 
					IF lnAcum_Neg_Ant=>0
						lncostoprom=ROUND(lnReverse/MOVINV.SALDO*-1,4)
					ENDIF 
					
					REPLACE COSTOPROM WITH lncostoprom
					
					IF MOVINV.COSTO=0
						REPLACE COSTO WITH lnCostoprom  

					ELSE 
						lncosto=ROUND(  (ROUND(  (MOVINV.CANT-MOVINV.SALDO)*MOVINV.COSTO  ,4)+ ROUND( lncostoprom*MOVINV.ACUM_NEG   ,4) ) /;
										(MOVINV.ACUM_NEG+(MOVINV.CANT-MOVINV.SALDO))                                                           ,4)
						REPLACE COSTO WITH lncosto

					ENDIF 
				ENDIF 				
				lnAcum_Neg_Ant=MOVINV.ACUM_NEG
				BROWSE FIELDS line,fecha,cant, costo,calc,saldo,costoprom,acum_neg,Saldo_pos
				&&comprobar si llego al final sino salir 
				SKIP -1 
				IF BOF()
					lbIn=.F. 
				ENDIF 
			ELSE

				lnCalc = lnCalc + ROUND(MOVINV.COSTO*MOVINV.CANT,4)		
				REPLACE CALC WITH lnCalc 				
				lnCostoProm = lnCalc/MOVINV.SALDO 
				REPLACE COSTOPROM WITH lnCostoProm 
				BROWSE FIELDS fecha,cant, costo,calc,saldo,costoprom,acum_neg,Saldo_pos
				SKIP 1 
				IF EOF()
					lbIn=.F. 
				ENDIF 

			ENDIF &&lnVariableRetorno=.f. 
		ENDDO &&DOWHILE TNSENTIDO=2
	ENDIF &&IF FOUND()
ENDIF &&IF TNSENTIDO=1
ENDPROC 

PROCEDURE DATOSPRUEBA
	CLOSE TABLES ALL 
	USE movinv 
	DELETE ALL 

	lnyear=2013
	lnmonth=1
	lnDay=12

	IF !VARTYPE(_SCREEN.YDATAManage)="O"
		_screen.newObject("yDataManage","ydatamanage","lib1.0\yoapp.vcx")	
	ENDIF 

	lnline=1
	DIMENSION LAEXISTEN(lnline,2)
	LAEXISTEN(lnline,1)=-10 &&1
	LAEXISTEN(lnline,2)=100

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-3  &&2
	LAEXISTEN(lnLine ,2)=23

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=4
	LAEXISTEN(lnLine ,2)=45


	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=1
	LAEXISTEN(lnLine ,2)=200

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=2
	LAEXISTEN(lnLine ,2)=300

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=1
	LAEXISTEN(lnLine ,2)=30

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=2
	LAEXISTEN(lnLine ,2)=20

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-1
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-3
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-8
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-1
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=3
	LAEXISTEN(lnLine ,2)=500

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-2
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-1
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=4
	LAEXISTEN(lnLine ,2)=200

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-4
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-6
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-5
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-5
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=-10
	LAEXISTEN(lnLine ,2)=0

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=5
	LAEXISTEN(lnLine ,2)=10

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=16  &&21
	LAEXISTEN(lnLine ,2)=12

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=1
	LAEXISTEN(lnLine ,2)=2

	lnLine =lnLine + 1 
	DIMENSION LAEXISTEN(lnLine ,2)
	LAEXISTEN(lnLine ,1)=1
	LAEXISTEN(lnLine ,2)=4.50

	lnLineAfter=0

	ldfecha=DATE(lnYear,lnMonth,lnDay)
	FOR N=1 TO ALEN(LAEXISTEN,1) 
		lnFactorDay=1+INT(RAND()*10)
		NLINE=0
		NLINEINDOC=N
		DFECHA=ldfecha+lnFactorDay
		CCODIGO="COD"
		CDOC="norde"
		CDESCDOC="ordencompra"
		CDESCDET="codigox"
		NCANT=LAEXISTEN(n,1)
		NCOSTO=LAEXISTEN(n,2)
		NSALDO=1
		ldfecha=DFECHA
		_screen.yDataManage.MOVINV_INS(NLINE,NLINEINDOC,DFECHA,CCODIGO,CDOC,CDESCDOC,CDESCDET,NCANT,NCOSTO,NSALDO)
		lnLineAfter=N
	ENDFOR 

	SELECT fecha FROM movinv WHERE lineinDoc=8 INTO ARRAY lafecha2Insert

		lnLineAfter = lnLineAfter + 1 
		NLINE=0
		NLINEINDOC=lnLineAfter 
		DFECHA=lafecha2Insert
		CCODIGO="COD"		
		CDOC="norde"
		CDESCDOC="ordencompra"
		CDESCDET="codigox"
		NCANT=2
		NCOSTO=5
		NSALDO=1
		_screen.yDataManage.MOVINV_INS(NLINE,NLINEINDOC,DFECHA,CCODIGO,CDOC,CDESCDOC,CDESCDET,NCANT,NCOSTO,NSALDO)

		lnLineAfter = lnLineAfter + 1 
		NLINE=0
		NLINEINDOC=lnLineAfter 
		DFECHA=lafecha2Insert
		CCODIGO="COD"		
		CDOC="norde"
		CDESCDOC="ordencompra"
		CDESCDET="codigox"
		NCANT=3
		NCOSTO=1
		NSALDO=1
		_screen.yDataManage.MOVINV_INS(NLINE,NLINEINDOC,DFECHA,CCODIGO,CDOC,CDESCDOC,CDESCDET,NCANT,NCOSTO,NSALDO)

	*MESSAGEBOX("ingresado correctamente")
	USE movinv 
	BROWSE
ENDPROC 

PROCEDURE CREAR_MOVINV 
CLOSE TABLES ALL 
USE MOVINV EXCLUSIVE 
ZAP  IN MOVINV 

INSERT INTO MOVINV(LINEINDOC,FECHA,CODIGO,DOC,DESCDOC,DESCDET,CANT,COSTO);	
SELECT ;
	d.line,;
	m.fecha,;
	d.codigo,;
	d.norden,;
	m.observaciones,;
	d.descripcion,;
	d.cantidad,;
	d.costo ;
FROM ;
	ordencompra as m INNER JOIN detalleorden as d ON m.norden=d.norden;
UNION ALL ;
SELECT ;
	d.line,;
	m.fecha,;
	d.codigo,;
	d.nrequisicion,;
	m.observaciones,;
	d.descripcion,;
	d.cantidad*-1,;
	d.costo ;
FROM ;
	REQUISICIONES as m INNER JOIN DETALLEREQUISICION as d ON m.nrequisicion=d.nrequisicion


ENDPROC 

