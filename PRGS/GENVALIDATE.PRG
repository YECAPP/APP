PROCEDURE GENVALIDATE 
PARAMETERS TestValue,tpValue
SET EXACT ON 
	TestValue=ALLTRIM(TestValue)
	IF !EMPTY(TestValue)
		DO AbrirTbs
		DO CASE 
		CASE tpValue=1 
			RETURN 	vdepto(TestValue)	&&Departamento
		CASE tpvalue=2 
			RETURN 	vproyecto(TestValue)&&Proyecto
		CASE tpvalue=3 
			RETURN 	vriva(TestValue)	&&Retencion de Iva
		CASE tpvalue=4 
			RETURN  vreg(TestValue)		&&Registro de Iva
		CASE tpvalue=5
			RETURN 	vprov(TestValue)	&&Proveedor
		CASE tpvalue=6
			RETURN 	vrenta(TestValue)	&&Renta
		CASE tpvalue=7
			RETURN 	vclie(TestValue)	&&Cliente
		CASE tpvalue=8
			RETURN 	vregclie(TestValue)	&&Registro Iva Cliente
		CASE tpvalue=9
			RETURN 	vrivaclie(TestValue)&&RetencionIva  Cliente
		CASE tpvalue=10
			RETURN VNitClie(TestValue)&&verificar si nit es valido
		CASE tpvalue=11
			RETURN Vtpingreso(TestValue)&&verificar si tipo de ingreso es valido solo para otros ingresos 
		OTHERWISE
		ENDCASE
		DO CerrarTbs
	ELSE 
		RETURN .f. 
	ENDIF 

ENDPROC 

**abrir tablaspara buscar informacion 
PROCEDURE AbrirTbs

	IF !USED("departamentos")
		USE departamentos IN 0 ALIAS departamentos
	ENDIF 	
	IF !USED("proyectos")
		USE proyectos IN 0 ALIAS proyectos
	ENDIF 
	IF !USED("proveedores")
		USE proveedores IN 0 ALIAS proveedores
	ENDIF 
	IF !USED("contribuyentes")
		USE contribuyentes IN 0 ALIAS contribuyentes
	ENDIF 
	IF !USED("clasificacioncontribuyentes")
		USE clasificacioncontribuyentes IN 0 ALIAS clasificacioncontribuyentes
	ENDIF 
	IF !USED("personnaturales")
		USE personnaturales IN 0 ALIAS personnaturales
	ENDIF 
	IF !USED("otring_tp")
		USE otring_tp  IN 0 ALIAS otring_tp 
	ENDIF 

ENDPROC 
**cerrar tablas que fueron abiertas 
PROCEDURE CerrarTbs

	IF USED("departamentos")
		SELECT departamentos 
		USE
	ENDIF 	
	IF USED("proyectos")
		SELECT proyectos 
		USE 
	ENDIF 
	IF USED("proveedores")
		SELECT  proveedores 
		USE 
	ENDIF 
	IF USED("contribuyentes")
		SELECT  contribuyentes 
		use
	ENDIF 
	IF USED("clasificacioncontribuyentes")
		SELECT  clasificacioncontribuyentes 
		use
	ENDIF 
	IF USED("personnaturales")
		SELECT  personnaturales 
		USE 
	ENDIF 
	IF USED("otring_tp")
		SELECT  otring_tp
		USE 
	ENDIF 

ENDPROC 

PROCEDURE Vtpingreso
PARAMETERS lcTpIng
	RETURN SEEK(lcTpIng,"otring_tp","idtpotring") 
ENDPROC 


PROCEDURE Vdepto
PARAMETERS lcDepto
	RETURN SEEK(lcdepto,"departamentos","iddepto") 
ENDPROC 

PROCEDURE VProyecto
PARAMETERS lcProy
	RETURN SEEK(lcProy,"proyectos","idproyecto") 
ENDPROC 

PROCEDURE VProv
PARAMETERS lcProv
	RETURN SEEK(lcProv,"proveedores","idprov") 
ENDPROC 


PROCEDURE VReg
PARAMETERS lcProv
	lcReg=IIF(SEEK(lcProv,"proveedores","idprov"),proveedores.registro,"")&&Tiene proveedor el registro 
	RETURN SEEK(ALLTRIM(lcReg),"contribuyentes","registro")
ENDPROC 

PROCEDURE VRiva
PARAMETERS lcProv
	lcReg=IIF(SEEK(lcProv,"proveedores","idprov"),proveedores.registro,"")&&Tiene registro el Proveedor ?
	lcClasif=IIF(SEEK(ALLTRIM(lcReg),"contribuyentes","registro"),contribuyentes.idclasificacion,"no existe")
	RETURN IIF(SEEK(lcClasif,'clasificacioncontribuyentes','idclasific'),clasificacioncontribuyentes.riva,.f.)
ENDPROC 

PROCEDURE VRenta
PARAMETERS lcProv
	lcNit=IIF(SEEK(lcProv,"proveedores","idprov"),proveedores.nit,"") &&Tiene proveedor el nit 
	RETURN SEEK(lcNit,"personnaturales","nit") 
ENDPROC 

PROCEDURE VClie
PARAMETERS lcClie
	RETURN SEEK(lcClie,"clientes","idcliente") 
ENDPROC 

PROCEDURE VRegClie
PARAMETERS lcClie
	lcReg=IIF(SEEK(lcClie,"clientes","idcliente"),clientes.registro,"")&&Tiene proveedor el registro 
	RETURN SEEK(ALLTRIM(lcReg),"contribuyentes","registro")
ENDPROC 

PROCEDURE VRivaClie
PARAMETERS lcClie
	lcNit=IIF(SEEK(lcClie,"clientes","idcliente"),clientes.nit,"")&&Tiene nit el cliente ?
	lcClasif=ALLTRIM(IIF(SEEK(ALLTRIM(lcNit),"personnaturales","nit"),personnaturales.idclasificacion,"no existe"))
	RETURN IIF(SEEK(ALLTRIM(lcClasif),'clasificacioncontribuyentes','idclasific'),clasificacioncontribuyentes.riva2,.f.)
ENDPROC 

PROCEDURE VNitClie
PARAMETERS lcClie
	lcNit=IIF(SEEK(lcClie,"clientes","idcliente"),clientes.nit,"")&&Tiene nit el cliente ?
	RETURN SEEK(ALLTRIM(lcNit),"personnaturales","nit")
ENDPROC 