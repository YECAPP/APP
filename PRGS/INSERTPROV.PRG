**27/05/2014 11:00AM	se creo para crear un proveedor automaticamente 
**						simplificando la creacion de nuevos registros
**						Se empieza con los clientes y luego se creo este para los proveedores 
**						Probado y depurado con BBT
**InsertProv(;
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


PROCEDURE InsertProv
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
	LOCAL 	lcIdProv,;
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
		

	**buscando registro en proveedores
	IF !EMPTY(lcRegistro)
		SELECT REGISTRO FROM PROVEEDORES WHERE UPPER(ALLTRIM(REGISTRO))==lcRegistro INTO ARRAY laRegistroClient
	ENDIF 
	**buscando nit
	IF  !EMPTY(lcNit)
		SELECT NIT FROM PROVEEDORES WHERE UPPER(ALLTRIM(NIT))==lcNit INTO ARRAY laNitClient
	ENDIF 
	**buscando nombre
	IF !EMPTY(lcNombre)
		SELECT IDPROV  FROM PROVEEDORES WHERE UPPER(ALLTRIM(NOMBRE))==lcNombre INTO ARRAY laNombre
	ENDIF 
	
	*Buscando registro en tabla contribuyentes 
	IF !EMPTY(lcRegistro)
		SELECT REGISTRO FROM contribuyentes WHERE UPPER(ALLTRIM(REGISTRO))==lcRegistro INTO ARRAY laRegistro
	ENDIF 
	**buscando nit en tabla personnaturales 
	IF !EMPTY(lcNit)
		SELECT NIT FROM personnaturales WHERE UPPER(ALLTRIM(NIT))==lcNit INTO ARRAY laNit
	ENDIF 

	IF !VARTYPE(laRegistro)="U"
		lbRegistro=.t.
	ENDIF 

	IF !VARTYPE(laNit)="U"
		lbNit=.t.
	ENDIF 

	IF !VARTYPE(laNombre)="U"
		lbNombre=.t.
		lcCampo="idprov"
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
	IF !EMPTY(lcnit)
	IF lbNit
		UPDATE personnaturales SET nombre=lcNombContrib, idclasificacion=lcCat  WHERE UPPER(ALLTRIM(nit))==lcnit
	ELSE 
		INSERT INTO personnaturales (nombre,nit,idclasificacion) VALUES (lcNombContrib,lcNit,lcCat)
	ENDIF 	
	ENDIF 
	
	IF EMPTY(lcregistro)
	IF lbRegistro
		UPDATE contribuyentes SET nombre=lcNombContrib,idclasificacion=lcCat, giro=lcGiro WHERE UPPER(ALLTRIM(registro))==lcregistro
	ELSE 
		INSERT INTO contribuyentes(nombre,registro,idclasificacion,giro) VALUES (lcNombContrib,lcRegistro,lcCat,lcGiro)
	ENDIF 	
	ENDIF 
	
	IF lbNombre
		
		UPDATE proveedores SET ;
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
		lcIdProv=nuevoproveedor(lcNombre)
*!*	messagebox('lcIdProv'+': '+  +transform(lcIdProv))
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
		
		INSERT INTO PROVEEDORES;
			(IDPROV,NOMBRE,IDDEPARTAMENTO,IDMUNI,REGISTRO,NIT,DIRECCION,DEPARTAMENTO,ALTA,IMPORT,FPAGO,AFILIADA,ACTIVO,PERSONERIA);
		VALUES( ;
			lcIdProv,;
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
