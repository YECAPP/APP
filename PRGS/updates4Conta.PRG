PROCEDURE updates4Conta
LPARAMETERS tbMessagebox


LNCOUNT=0
lcMsg="Esta funcion actualizara todas las cuentas contables desde el modulo de contabilidad,"+CHR(13)+"Desea continuar "
lbSeguir=.f.

IF !tbMessagebox
	IF MESSAGEBOX(lcMsg,52,"Atencion!")=6
		lbSeguir=.t.
	ELSE
		lbSeguir=.f.
	ENDIF 
ELSE
	lbSeguir=.t.
ENDIF 

IF lbSeguir
*	CLOSE TABLES ALL 
	**actualizar c1 en conta 
	SET EXCLUSIVE OFF 

	IF DIRECTORY("CONTA")
		IF DIRECTORY("DATA")
			IF !USED("C1") AND !USED("contabc1")
				USE ("CONTA\DATA\c1.dbf") ALIAS contabc1 IN 0 shared 		
			ENDIF 
		ELSE 
			IF !USED("C1") AND !USED("contabc1")
				USE CONTA\c1.dbf ALIAS contabc1 IN 0 shared 	
			ENDIF 
		ENDIF 
	ELSE
		MESSAGEBOX("No se encontro la base de datos de Conta",16,"Error en la actualización")
		RETURN 
	ENDIF 
	
	IF !USED("cataconta") AND !USED("catacontadest")
		USE cataconta ALIAS catacontadest IN 0 SHARED 
	ENDIF 
	**haciendo respaldo de datos 

	SELECT catacontadest 
*	COPY TO "C:\"+ALIAS()+"_"+TTOC(datetime(),1)


	**limpiando tabla de cataconta
*!*		SELECT contabc1.codigo,contabc1.nombre,NVL(criva,.f.) as criva,NVL(civa,.f.) as civa,NVL(crenta,.f.) as crenta ;
*!*		FROM contabc1 LEFT JOIN catacontadest ON  contabc1.codigo=catacontadest.codigo;
*!*		INTO CURSOR cataCon 

		SELECT 	contabc1.codigo,;
				contabc1.nombre,;
				.f. as criva,;
				.f. as civa,;
				.f. as crenta ;
		FROM ;
			contabc1 ;
		WHERE ;
			contabc1.codigo NOT IN (SELECT catacontadest.codigo FROM catacontadest );
		INTO CURSOR ;
			cataCon 


	IF _TALLY>0
		INSERT INTO catacontadest (CODIGO, NOMBRE, CIVA, CRIVA, CRENTA);
		SELECT CODIGO, NOMBRE, CRIVA , CIVA, CRENTA FROM cataCon 
		LNCOUNT=RECCOUNT("cataCon")
*!*			SET SAFETY ON 
*!*			ZAP IN catacontadest 
*!*			APPEND FROM DBF("cataCon")	
	ELSE
		LNCOUNT=0
	ENDIF 
	
	IF !tbMessagebox
		MESSAGEBOX(TRANSFORM(LNCOUNT) + " Cuentas agregadas",64,"Cuentas agregadas")
	ENDIF 
	
	**actualizando datos
ENDIF 

RETURN LNCOUNT
ENDPROC 
