PROCEDURE PROGRAMAR 
	LPARAMETERS lnTp,lcIdprogra,lcIdgrupo,ldFechaI,lnDias,lcIdSucursal,lnEquipos

	DO CASE
	CASE lntp=1 &&SOLO REQUIERE EL CODIGO DEL PROGRAMA PARA REALIZAR TODOS LOS CALENDARIOS  DE LAS SUCURSALES 
		DO gencursor WITH lcIdProgra
		
	CASE lnTp=2 &&REQUIERE EL CONJUNTO DE PARAMETROS COMPLETOS PARA REALIZAR LA PROGRAMACION DE UNS SOLA SUCURSAL 
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



		DO iniciar WITH ldFechaI,lnDias,lcIdSucursal,lnEquipos,lcIdprogra,lcIdgrupo
	CASE lnTp=3 &&REQUIERE EL CONJUNTO DE PARAMETROS MENOS LA FECHA LA CUAL DEBERA CALCULAR AUTOMATICAMENTE 
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
		MCONTRATO_EQ INNER JOIN MSUCURSAL ON MCONTRATO_EQ.IDSUCURSAL=MSUCURSAL.IDSUCURSAL;
	WHERE IDGRUPO=PgToProgram.IDGRUPO AND ;
		MSUCURSAL.ESTADO>=1;
	GROUP BY;
		1,2,3;
	INTO CURSOR;
		ScsToProgram
		
		
	&&Si no ha sido creada la variable para fecha inicial global crearla 	
	IF VARTYPE(gdFechaI)="U"
		PUBLIC gdFechaI 		&&despues de programar la primera sucursal esta variable 
	ELSE 
		gdFechaI=DATE(PgToProgram.Año,PgToProgram.Mes,1)
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
	LOCAL lndias1,lnDias2,lnNoEqs1,lnNoEqs2,ldFechaI2
	*("lnDias recibido en inciar ")
	*MESSAGEBOX(lnDias)
	lnDias1=INT(lndias)
	lnDias2=lnDias-lnDias1
	lnNoEqs1=lnNoEqs-lnDias2*4 &&SE UTILIZA CUANDO LOS EQUIPOSXDIA>=4
	lnNoEqs2=(lnDias-lnDias1)*4 &&SE UTILIZA CUANDO LOS EQUIPOSXDIA<4 
	ldFechaI2 = ldFechaI + IIF(lnDias2=0,lndias,lnDias1+1)
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
	ORDER BY ;
		4,1;
	INTO CURSOR ;
		eqsToProgram
	
	*MESSAGEBOX("equipos  a programar son")
	
	SELECT eqsToProgram 
	GO TOP 
	*BROWSE 
	
	IF lnDias1>0
		IF  lnDias2>0
			glCalcEspaOcu=.f.
		ELSE 
			glCalcEspaOcu=.t.
		ENDIF 
		*MESSAGEBOX("lnDias1 que se envia desde iniciar")
		*MESSAGEBOX(lnDias1)
		DO tres WITH ldFechaI,lnDias1,lcIdSucursal,lnNoEqs1,lcIdProgra,lcIdgrupo
	ENDIF

	IF lnDias2>0
			IF lndias1=0
				ldFechaI2 = ldFechaI2 - 1 		
			ENDIF 

		glCalcEspaOcu=.t.
		DO tres WITH ldFechaI2,lnDias2,lcIdSucursal,lnNoEqs2,lcIdProgra,lcIdgrupo
	ENDIF 
	*MESSAGEBOX("stop a las llamadas ")
ENDPROC 



PROCEDURE TRES 
	LPARAMETERS ldFechaI,lnDias,lcIdSucursal,lnNoEqs,lcIdProgra,lcIdgrupo
	*Declarar e Inicializar variables 
	LOCAL ldFechaN,lnEq,lnDia,lnEspaciosTotales,lnFaltante,lnEspacioXDia,lnEspacioXDiaqSobra
	ldFechaN=ldFechaI
	lnEQ=1
	lnDia=1
	lnEspaciosTotales=SUMESPACIOS(ldFechaI,lnDias,lcIdSucursal,lnNoEqs) 
	lnFaltante=lnNoEqs-lnEspaciosTotales
	&&calcular equipos que sobran por dia ejemplo:
	&&se pide programar 5 equipos en 1 dia sobrar uno ya que el promedio de equipos 
	&&por dia es de 4 por lo que el que sobra debera ser reprogramado para incluirse 
	&&dentro del mismo dia que los demas 
	IF MOD(lnFaltante,lnDias)>0
		lnFaltanteXdia=INT(lnFaltante/lnDias)+1
	ELSE 
		lnFaltanteXdia=lnFaltante/lnDias
	ENDIF 
	&&desde el dia 1 hasta el numero de dias se hara la programacion 
	DO WHILE  lnDia<=IIF(lnDias<1,1,lnDias)

		&&calular los espacios disponibles para el dia N
		lnEspacioXDia=ESPACIOS(ldFechaN,lcIdSucursal,lnDias,lnNoEqs)
		*MESSAGEBOX(lnEspacioXDia)
		&&se disminuira este variable a medida se programen los equipos 
		&&al final esta variable sera Cero si el numero de equipos coincide 
		&&con el numero total de dias y no hay faltante; de lo contrario contendra 
		&&el numero de espacios que quedan disponibles al final de programar todos los equipos
		lnEspacioXDiaqSobra=lnEspacioXDia
		
		&&si existen espacios disponibles para programar en la fecha solicitada se procede a programar
		IF lnEspacioXDia>0
			&&si todavia quedan equipos faltantes de programar se incrementa la cantidad de 
			&&equipos por dia a fin de distribuir los faltantes entre el numero de dias 
			&&equitativamente, tambien se disminuye el numero de equipos faltantes que quedan 
			&&por programar 
			IF lnFaltante>0 
				lnEspacioXDia=lnEspacioXDia+lnFaltanteXDia
				lnFaltante=lnFaltante-lnFaltanteXDia
			ENDIF
			&&se programan los equipos que caben en esta fecha 
			FOR k=1 TO lnEspacioXDia
				IF lnEq<=lnNoEqs	
					&&se inserta la informacion en la tabla correspondiente 
					INSERT INTO mprogra	(idprogra,idequipo,idgrupo,fecha,secuencia,diasugerido,	precio,estado,idsucursal);
								VALUES (lcIdprogra,eqsToProgram.idequipo,lcIdGrupo,ldFechaN,k,eqsToProgram.diasugerido,eqsToProgram.precio,1,lcIdSucursal) 	
					&&se incrementa el conteo de equipos programados por dia 
					lnEq=lneq+1
					&&se actualiza el calculo de equipos por dia que van sobrando 
					lnEspacioXDiaqSobra = lnEspacioXDiaqSobra - 1 
					&&moverse al siguiente equipo 
					SKIP 1 IN eqsToProgram
				ELSE 
					&&Si el numero de dias digitado es entero se asume que se quiere utilizar la
					&&totalidad de los dias señalados sin dejar espacio por lo que se disminuye 
					&& lnEspacioXDiaqSobra para que no sobre nada, osea se reserva el espacio
					IF lnDias-INT(lnDias)=0 				
						lnEspacioXDiaqSobra = lnEspacioXDiaqSobra - 1 
					ENDIF 
				ENDIF 
			ENDFOR
			&&ir al siguiente dia 
			lnDia=lnDia+1
		ENDIF 
		&&si no habian espacios en la fecha solicitada se prueba con otra fecha 
		ldFechaN=ldFechaN+1	
	ENDDO
	&&Probablemente no se utilize 
	IF 	glCalcEspaOcu=.t.
		gnEspacioQOcupa=4-lnEspacioXDiaqSobra
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
	*MESSAGEBOX("lnNoEqs en espacios()")
	*MESSAGEBOX(lnNoEqs)
	*MESSAGEBOX("lnDias en espacios()")	
	*MESSAGEBOX(lnDias)
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
