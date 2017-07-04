PROCEDURE PROGRAMAR 
	LPARAMETERS lnTp,lcIdprogra,lcIdgrupo,ldFechaI,lnDias,lcIdSucursal,lnEquipos

	DO CASE
	CASE lntp=1 &&SOLO REQUIERE EL CODIGO DEL PROGRAMA PARA REALIZAR TODOS LOS CALENDARIOS  DE LAS SUCURSALES 
		DO gencursor WITH lcIdProgra
		
	CASE lnTp=2 &&REQUIERE EL CONJUNTO DE PARAMETROS COMPLETOS PARA REALIZAR LA PROGRAMACION DE UNS SOLA SUCURSAL 
		DO iniciar WITH ldFechaI,lnDias,lcIdSucursal,lnEquipos,lcIdprogra,lcIdgrupo
	CASE lnTp=3 &&REQUIERE EL CONJUNTO DE PARAMETROS MENOS LA FECHA LA CUAL DEBERA CALCULAR AUTOMATICAMENTE 
		DO iniciar WITH ldFechaI,lnDias,lcIdSucursal,lnEquipos,lcIdprogra,lcIdgrupo

	OTHERWISE
	ENDCASE
ENDPROC 

PROCEDURE GENCURSOR 
	LPARAMETERS lcIdProgra
	LOCAL lnEquipos,lnDias,ldFechaI,lnMEs,lnAño,lcIdProgra,lcIdGrupo,lcIdSucursal
	*Abrir tablas si no estan abiertas 
	IF !USED("MPROGRA_CLD")
		USE MPROGRA_CLD IN 0
	ENDIF 
	IF !USED("mcontrato_eq")
		USE MCONTRATO_EQ IN 0
	ENDIF 
	&&SELEC MPROGRA_CLD.DBF  de acuerdo al parametro lcIDProgra e ir al primero 
	SELECT * FROM;
		MPROGRA_CLD ;
	WHERE ;
		idprogra=lcIdProgra;
	INTO CURSOR ;
		PgToProgram


	SELECT PgToProgram
	GO TOP
	&&Crear cursor 	ScsToProgram de acuerdo al grupo del programa seleccionado 
	SELECT ;
		MPROGRA_CLD.IDPROGRA AS IDPROGRA,;
		MPROGRA_CLD.IDGRUPO  AS IDGRUPO,;
		MCONTRATO_EQ.IDSUCURSAL,;
		COUNT(IDEQUIPO) 	AS EQUIPOS,;
		MIN(DIASUGERIDO) 	AS DIASUGERIDO;
	FROM ;
		MCONTRATO_EQ;
	WHERE IDGRUPO=MPROGRA_CLD.IDGRUPO ;		
	GROUP BY;
		1,2,3;
	INTO CURSOR;
		ScsToProgram
		
		
	&&Si no ha sido creada la variable para fecha inicial global crearla 	
	IF VARTYPE(gdFechaI)="U"
		PUBLIC gdFechaI 		&&despues de programar la primera sucursal esta variable 
	ELSE 
		gdFechaI=DATE(MPROGRA_CLD.Año,MPROGRA_CLD.Mes,1)
	ENDIF 						&&contendra la fechaInicial con la que se programara la proxima sucursal
	&&Si no ha sido creada la variable para espaciosocupados en la fecha inicial global crearla 	
	IF VARTYPE(gnEspacioQOcupa)="U" 
		PUBLIC gnEspacioQOcupa  &&despues de programas la primera sucursal esta variable 
	ELSE
		gnEspacioQOcupa=0
	ENDIF 						&&contendra el el numero de equipoos ya programados en la fecha incial global 
	IF VARTYPE(glCalcEspaOcu)="U"
		PUBLIC glCalcEspaOcu 		&&despues de programar la primera sucursal esta variable 
	ELSE
		glCalcEspaOcu=.f.
	ENDIF 						&&contendra la fechaInicial con la que se programara la proxima sucursal


	&&Hacer mientras ScsToProgram no llegue al ultimo registro
	&&sirve para programar cada sucursal 
	&&SELEC ScsToProgram e ir al primero 
	SELECT ScsToProgram
	GO TOP 
	DO WHILE !EOF()
		IF EMPTY(gdFechaI)
			ldFechaI=DATE(PgToProgram.Año,PgToProgram.Mes,1)
		ELSE
			ldFechaI=gdFechaI
		ENDIF 
		IF EMPTY(gnEspacioQOcupa)
			gnEspacioQOcupa=0	
		ENDIF 

		glCalcEspaOcu=.f.
		
		lnDias=ScsToProgram.equipos*(1/4)

		DO iniciar WITH ldFechaI,lnDias,ScsToProgram.idsucursal,ScsToProgram.equipos,ALLTRIM(PgToProgram.IDPROGRA),ALLTRIM(ScsToProgram.idgrupo)
		
		SELECT ScsToProgram
		SKIP 
	ENDDO
ENDPROC 



PROCEDURE INICIAR
	LPARAMETERS ldFechaI,lnDias,lcIdSucursal,lnNoEqs,lcIdProgra,lcIdgrupo
	LOCAL lndias1,lnDias2,lnNoEqs1,lnNoEqs2,ldFechaI2,lnIdEq 
	lnDias1=INT(lndias)
	lnDias2=lnDias-lnDias1
	lnNoEqs1=lnNoEqs-lnDias2*4 &&SE UTILIZA CUANDO LOS EQUIPOSXDIA>=4
	lnNoEqs2=(lnDias-lnDias1)*4 &&SE UTILIZA CUANDO LOS EQUIPOSXDIA<4 
	ldFechaI2 = ldFechaI + IIF(lnDias2=0,lndias,lnDias1+1)
	lnIdEq=1
	&&filtrar equipos a programar 
	SELECT ;
		idequipo,;
		idsucursal,;
		precio,;
		diasugerido,;
		idgrupo;
	FROM ;
		mcontrato_eq;
	WHERE ;
		idsucursal=lcIdSucursal AND ;
		idgrupo=lcIdgrupo ;
	INTO CURSOR ;
		eqsToProgram
	
	MESSAGEBOX("equipos  a programar son")
	
	SELECT eqsToProgram 
	GO TOP 
	BROWSE 
	
	IF lnDias1>0
		IF  lnDias2>0
			glCalcEspaOcu=.f.
		ELSE 
			glCalcEspaOcu=.t.
		ENDIF 
		DO tres WITH ldFechaI,lnDias1,lcIdSucursal,lnNoEqs1,lnIdEq,lcIdProgra,lcIdgrupo
	ENDIF
	?"___"
	IF lnDias2>0
			IF lndias1=0
				ldFechaI2 = ldFechaI2 - 1 		
			ENDIF 

		glCalcEspaOcu=.t.
		DO tres WITH ldFechaI2,lnDias2,lcIdSucursal,lnNoEqs2,lnIdEq,lcIdProgra,lcIdgrupo
	ENDIF 
	MESSAGEBOX("stop a las llamadas ")
ENDPROC 



PROCEDURE TRES 
	LPARAMETERS ldFechaI,lnDias,lcIdSucursal,lnNoEqs,lnIdEq,lcIdProgra,lcIdgrupo
	*Declarar e Inicializar variables 
	LOCAL ldFechaN,lnEq,lnDia,lnEspaciosTotales,lnFaltante,lnEspacioXDia,lnEspacioXDiaqSobra
	ldFechaN=ldFechaI
	lnEQ=1
	lnDia=1
	lnEspaciosTotales=SUMESPACIOS(ldFechaI,lnDias,lcIdSucursal,lnNoEqs) 
	lnFaltante=lnNoEqs-lnEspaciosTotales
	? ldFechaN
	?"espacios totales en fecha anterior descrita   "+TRANSFORM(lnEspaciosTotales)
	?"------------faltante"+TRANSFORM(lnFaltante)
	IF MOD(lnFaltante,lnDias)>0
		lnFaltanteXdia=INT(lnFaltante/lnDias)+1
	ELSE 
		lnFaltanteXdia=lnFaltante/lnDias
	ENDIF 
	DO WHILE  lnDia<=IIF(lnDias<1,1,lnDias)
		lnEspacioXDia=ESPACIOS(ldFechaN,lcIdSucursal,lnDias,lnNoEqs)
		lnEspacioXDiaqSobra=lnEspacioXDia
		IF lnEspacioXDia>0
			IF lnFaltante>0 
				lnEspacioXDia=lnEspacioXDia+lnFaltanteXDia
				lnFaltante=lnFaltante-lnFaltanteXDia
			ENDIF
			FOR k=1 TO lnEspacioXDia
				IF lnEq<=lnNoEqs	
					INSERT INTO mprogra	(idprogra,idequipo,idgrupo,fecha,secuencia,diasugerido,	precio,estado);
								VALUES (lcIdprogra,eqsToProgram.idequipo,lcIdGrupo,ldFechaN,k,eqsToProgram.diasugerido,eqsToProgram.precio,1) 	
					lnIdEq = lnIdEq + 1 
					lnEq=lneq+1
					lnEspacioXDiaqSobra = lnEspacioXDiaqSobra - 1 
					SKIP 1 IN eqsToProgram
				ELSE 
					IF lnDias-INT(lnDias)=0 				
						?TRANSFORM(lnEQ-lnNoEqs)+"    Espacio Vacio reservado:   "+	DTOC(ldFechaN)+"orden---> "+TRANSFORM(k)
						lnEspacioXDiaqSobra = lnEspacioXDiaqSobra - 1 

					ENDIF 
				ENDIF 
			ENDFOR
			lnDia=lnDia+1
		ENDIF 
		ldFechaN=ldFechaN+1	
	ENDDO
	IF 	glCalcEspaOcu=.t.
		gnEspacioQOcupa=4-lnEspacioXDiaqSobra
		?"gnEspacioQOcupa"+TRANSFORM(gnEspacioQOcupa)	
		?"lnEspacioXDiaqSobra"+TRANSFORM(lnEspacioXDiaqSobra)
		?"Ultima Fecha Programable:"+TRANSFORM(ldFechaN-1)
		gdFechaI=ldFechaN-1
		gcIdSucursal=lcIdSucursal
	ENDIF 
ENDPROC 


PROCEDURE SUMESPACIOS
LPARAMETERS ldFechaI,lnDias,lcIdSucursal,lnNoEqs
	LOCAL FechaN,FechaF,lnEspacios
	FechaN=ldFechaI
	lnEQ=1
	lndia=1
	lnEspacios=0
	*Faltante=lnNoeqs-SUMESPACIOS(ldFechaI,lnDias,lcIdContrato,lnNoEqs)
	DO WHILE  lnDia<=lnDias 
		IF ESPACIOS(fechaN,lcIdSucursal,lnDias,lnNoEqs)>0
				FOR k=1 TO ESPACIOS(fechaN,lcIdSucursal,lnDias,lnNoEqs)
					IF lnEq<=lnNoEqs					
						lnEspacios=lnEspacios+1
					ENDIF 
					lnEq=lneq+1
				ENDFOR
			lnDia=lnDia+1
		ENDIF 
		fechaN=fechaN+1	
	ENDDO
	RETURN lnEspacios
ENDPROC 



PROCEDURE ESPACIOS
	LPARAMETERS ldFecha,lcIdSucursal,lnDias,lnNoEqs
	LOCAL lnEspacio
	lnEspacio=0
	IF !feriado(ldFecha) 
		DO CASE
		CASE DOW(ldFecha)=1
			IF vfec(ldFecha,lcIdSucursal)
				lnEspacio=IIF(ROUND(lnNoeqs/lnDias,0)<4,4,ROUND(lnNoeqs/lnDias,0)) -gnEspacioQOcupa
			ENDIF 
		CASE DOW(ldFecha)=7
			IF vfec(ldFecha,lcIdSucursal)
				lnEspacio=IIF(ROUND(lnNoeqs/lnDias,0)<4,4,ROUND(lnNoeqs/lnDias,0))-gnEspacioQOcupa&&ROUND(lnNoeqs/lnDias,0)
			ELSE 
				lnEspacio=2
			ENDIF 
		OTHERWISE
			lnEspacio=IIF(ROUND(lnNoeqs/lnDias,0)<4,4,ROUND(lnNoeqs/lnDias,0))-gnEspacioQOcupa&&ROUND(lnNoeqs/lnDias,0)
		ENDCASE
	ELSE 
		IF vfec(ldFecha,lcIdSucursal)
			lnEspacio=IIF(ROUND(lnNoeqs/lnDias,0)<4,4,ROUND(lnNoeqs/lnDias,0))-gnEspacioQOcupa&&ROUND(lnNoeqs/lnDias,0)
		ENDIF 
	ENDIF  
		IF gnEspacioQOcupa>0
			gnEspacioQOcupa=0
		ENDIF 
	RETURN lnEspacio
ENDPROC 


**determinar si un dia es domingo y se valido como normal 
PROCEDURE VFEC 
	LPARAMETERS  ldFecha,lcIdSucursal
	SELE FECHAS 
	SELECT VALIDA FROM FECHAS WHERE IDSUCURSAL=lcIdSucursal AND FECHA=ldFecha INTO ARRAY laValida
	IF !VARTYPE(laValida)="U"
		RETURN laValida(1)
	ELSE 
		RETURN .f.
	ENDIF 
ENDPROC 


**Determinar si un dia es feriado 
PROCEDURE FERIADO
	LPARAMETERS  ldFecha
	IF !USED("FECHAS")
		USE FECHAS IN 0
	ENDIF 
	SELE FECHAS 
	SELECT feriado FROM FECHAS WHERE  FECHA=ldFecha INTO ARRAY laFeriado
	IF !VARTYPE(laFeriado)="U"
		RETURN laFeriado(1)
	ELSE 
		RETURN .f.
	ENDIF 
ENDPROC 
