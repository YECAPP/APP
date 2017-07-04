**03/06/2013 9:25pm	Se empieza creacion de comandos Inserts, que agilizaran el proceso de insercion de datos 
**					simplificando la creacion de nuevos registros
**03/06/2013 9:26pm Se empieza con los clientes
**InsertClient(;
			"Nombre",;
			"06",;
			"0601",;
			"1556778",;
			"06140504821089",;
			"Direccion",;
			"01",;
			"import",;
			"FP00000001",;
			.F.,;
			"GIRO",;
			"01",;
			"CONTRIB")


PROCEDURE InsertClient
	LPARAMETERS tcNombre,;
				tcIddepartamento,;
				tcIdmunicipio,;
				tcRegistro,;
				tcNit,;
				tcDireccion,;
				tcDepartamento,;
				tcImport,;
				tcFpago,;
				tbAfiliada,;
				tcGiro,;
				tcCat,;
				tcNombContrib

	**declarando variables locales 
	LOCAL 	lcIdcliente,;
			lcNombre,;
			lcIddepartamento,;
			lcIdmunicipio,;
			lcRegistro,;
			lcNit,;
			lcDireccion,;
			lcDepartamento,;
			ldAlta,;
			lcImport,;
			lcFpago,;
			lbAfiliada,;
			lbActivo,;
			lcCat,;
			lcGiro,;
			lcNombContrib


	lcNombre="Cliente Nuevo"
	lcIddepartamento="06"
	lcIdmunicipio="0601"
	lcRegistro=""
	lcNit=""
	lcDireccion=""
	lcDepartamento="01"
	ldAlta=DATE()
	lcImport=""
	lcFpago="FP00000001"
	lbAfiliada=.f.
	lbActivo=.t.
	lcCat="01"
	lcGiro=""
	lcNombContrib=lcNombre
	**declarando variables de existencia 
	LOCAL 	lbRegistro,;
			lbNit,;
			lbNombre,;
			lnSumcmpro

	lbRegistro=.f.
	lbNit=.f.
	lbNombre=.f.

		
	**Capturando parametros (convirtiendo parametros en variables locales)
	lcNombre=IIF(!EMPTY(TcNombre),UPPER(ALLTRIM(TcNombre)),lcNombre)
	lcIddepartamento=IIF(!EMPTY(TcIddepartamento),TcIddepartamento,lcIdDepartamento)
	lcIdmunicipio=IIF(!EMPTY(TcIdmunicipio),TcIdmunicipio,lcIdmunicipio)
	lcRegistro=IIF(!EMPTY(TcRegistro),UPPER(ALLTRIM(STRTRAN(TcRegistro,"-",""))),lcRegistro)
	lcNit=IIF(!EMPTY(TcNit),UPPER(ALLTRIM(STRTRAN(TcNit,"-",""))),lcNit)	
	lcDireccion=IIF(!EMPTY(TcDireccion),tcDireccion,lcDireccion)
	lcDepartamento=IIF(!EMPTY(TcDepartamento),TcDepartamento,lcDepartamento)
	lcImport=IIF(!EMPTY(TcImport),TcImport,lcImport)
	lcFpago=IIF(!EMPTY(TcFpago),TcFpago,lcFpago)
	lbAfiliada=IIF(!EMPTY(TbAfiliada),TbAfiliada,lbAfiliada)
	lcCat=IIF(!EMPTY(tcCat),tcCat,lcCat)
	lcGiro=IIF(!EMPTY(tcGiro ),tcGiro,lcGiro)
	lcNombContrib=IIF(!EMPTY(tcNombContrib),tcNombContrib,lcNombre)


	**Estableciendo personeria 
	lbSociedad=;
		LIKE("*S.A.*",lcNombre) or ;
		LIKE("*SA*",lcNombre) or ;		
		LIKE("*SA.*",lcNombre) or ;		
		LIKE("*.SA*",lcNombre) or ;				
		LIKE("*.S.A.*",lcNombre) or ;
		LIKE("*S.A*",lcNombre) or ;
		LIKE("*.SA.*",lcNombre) or ;																						
		LIKE("*C.V.*",lcNombre) or ;
		LIKE("*CV*",lcNombre) or ;
		LIKE("*CV.*",lcNombre) OR ;
		LIKE("*.CV*",lcNombre) or ;		
		LIKE("*.C.V.*",lcNombre) or ;				
		LIKE("*C.V*",lcNombre) or ;		
		LIKE("*.CV.*",lcNombre)
	liPersoneria=IIF(lbSociedad,1,0)






	**buscando registro en clientes 
	SELECT REGISTRO FROM CLIENTES WHERE UPPER(ALLTRIM(REGISTRO))==lcRegistro INTO ARRAY laRegistroClient
	**buscando nit
	SELECT NIT FROM CLIENTES WHERE UPPER(ALLTRIM(NIT))==lcNit INTO ARRAY laNitClient
	**buscando nombre
	SELECT IDCLIENTE  FROM CLIENTES WHERE UPPER(ALLTRIM(NOMBRE))==lcNombre INTO ARRAY laNombre
	
	*Buscando registro en tabla contribuyentes 
	SELECT REGISTRO FROM contribuyentes WHERE UPPER(ALLTRIM(REGISTRO))==lcRegistro INTO ARRAY laRegistro
	**buscando nit en tabla personnaturales 
	SELECT NIT FROM personnaturales WHERE UPPER(ALLTRIM(NIT))==lcNit INTO ARRAY laNit

	IF !VARTYPE(laRegistro)="U"
		lbRegistro=.t.

	ENDIF 

	IF !VARTYPE(laNit)="U"
		lbNit=.t.

	ENDIF 

	IF !VARTYPE(laNombre)="U"
		lbNombre=.t.
		lcCampo="idcliente"
		lcKey="laNombre"
	ENDIF 
	
	IF !VARTYPE(laRegistroClient)="U"
		lbRegistro=.t.
		lcCampo="Registro"
		lcKey="laRegistroClient"
	ENDIF 

	IF !VARTYPE(laNitClient)="U"
		lbNit=.t.
		lcCampo="Nit"
		lcKey="laNitClient"
	ENDIF 
	
	**actualizacion de tablas 
	IF lbNit
		UPDATE personnaturales SET nombre=lcNombContrib, idclasificacion=lcCat  WHERE UPPER(ALLTRIM(nit))==lcnit
	ELSE 
		INSERT INTO personnaturales (nombre,nit,idclasificacion) VALUES (lcNombContrib,lcNit,lcCat)
	ENDIF 	
	
	IF lbRegistro
		UPDATE contribuyentes SET nombre=lcNombContrib,idclasificacion=lcCat, giro=lcGiro WHERE UPPER(ALLTRIM(registro))==lcregistro
	ELSE 
		INSERT INTO contribuyentes(nombre,registro,idclasificacion,giro) VALUES (lcNombContrib,lcRegistro,lcCat,lcGiro)
	ENDIF 	
	
	IF lbNombre
		
		UPDATE clientes SET ;
			NOMBRE=lcNombre,;
			IDDEPARTAMENTO=lcIddepartamento,;
			IDMUNICIPIO=lcIdmunicipio,;
			REGISTRO=lcRegistro,;
			NIT=lcNit,;
			DIRECCION=lcDireccion,;
			DEPARTAMENTO=lcDepartamento,;
			ALTA=ldAlta,;
			IMPORT=lcImport,;
			FPAGO=lcFpago,;
			AFILIADA=lbAfiliada,;
			ACTIVO=lbActivo,;
			PERSONERIA=liPersoneria;
		WHERE ;
			UPPER(ALLTRIM(&lcCampo ))==&lcKey
			
	ELSE 
	
		lcIdcliente=NUEVOCLIENTE(lcNombre)
*!*	messagebox('lcIdcliente'+': '+  +transform(lcIdcliente))
*!*	messagebox('lcNombre'+': '+  +transform(lcNombre))
*!*	messagebox('lcIddepartamento'+': '+  +transform(lcIddepartamento))
*!*	messagebox('lcIdmunicipio'+': '+  +transform(lcIdmunicipio))
*!*	messagebox('lcRegistro'+': '+  +transform(lcRegistro))
*!*	messagebox('lcNit'+': '+  +transform(lcNit))
*!*	messagebox('lcDireccion'+': '+  +transform(lcDireccion))
*!*	messagebox('lcDepartamento'+': '+  +transform(lcDepartamento))
*!*	messagebox('ldAlta'+': '+  +transform(ldAlta))
*!*	messagebox('lcImport'+': '+  +transform(lcImport))
*!*	messagebox('lcFpago'+': '+  +transform(lcFpago))
*!*	messagebox('lbAfiliada'+': '+  +transform(lbAfiliada))
*!*	messagebox('lbActivo'+': '+  +transform(lbActivo))
		
		INSERT INTO CLIENTES;
			(IDCLIENTE,NOMBRE,IDDEPARTAMENTO,IDMUNICIPIO,REGISTRO,NIT,DIRECCION,DEPARTAMENTO,ALTA,IMPORT,FPAGO,AFILIADA,ACTIVO,PERSONERIA);
		VALUES( ;
			lcIdcliente,;
			lcNombre,;
			lcIddepartamento,;
			lcIdmunicipio,;
			lcRegistro,;
			lcNit,;
			lcDireccion,;
			lcDepartamento,;
			ldAlta,;
			lcImport,;
			lcFpago,;
			lbAfiliada,;
			lbActivo,;
			liPersoneria)
	ENDIF 	
	
ENDPROC 
