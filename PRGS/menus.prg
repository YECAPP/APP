PROCEDURE MENUS
PARAMETERS lcTp,lcRef
	LOCAL lcValue
	DO CASE
		CASE lcTp="Proveedores"
			DEFINE POPUP menúcontex SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF menúcontex PROMPT ""+TranStr("Buscar Proveedor (Ctrl + F9)","M")+"" ;
				PICTURE "..\ico\PROVEEDOR.png"
			DEFINE BAR 2 OF menúcontex PROMPT ""+TranStr("Crear Nuevo Proveedor (Ctrl + F8)","M")+"" ;
				SKIP FOR SKIPPER(106) ;
				PICTURE "..\ico\PROVEEDOR.png"
			DEFINE BAR 3 OF menúcontex PROMPT ""+TranStr("Modificar Proveedor ","M")+"" ;
				SKIP FOR SKIPPER(106) ;
				PICTURE "..\ico\PROVEEDOR.png"
			ON SELECTION BAR 1 OF menúcontex do form fcProv TO lcValue
			ON SELECTION BAR 2 OF menúcontex DO FORM prv WITH 1,"",.t.    TO lcValue
			ON SELECTION BAR 3 OF menúcontex DO FORM prv WITH 2,lcRef,.t. TO lcValue
			ACTIVATE POPUP menúcontex
			
		
		CASE lcTp="Proyectos"
			DEFINE POPUP menúcontex SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF menúcontex PROMPT ""+TranStr("Buscar Proyecto (Ctrl + F9)","M")+"" ;
				PICTURE "..\ico\PROYECTOS.png"
			DEFINE BAR 2 OF menúcontex PROMPT ""+TranStr("Crear Nuevo Proyecto (Ctrl + F8)","M")+"" ;
				SKIP FOR SKIPPER(104) ;
				PICTURE "..\ico\PROYECTOS.png"
			DEFINE BAR 3 OF menúcontex PROMPT ""+TranStr("Modificar Proyecto ","M")+"" ;
				SKIP FOR SKIPPER(104) ;
				PICTURE "..\ico\PROYECTOS.png"
			ON SELECTION BAR 1 OF menúcontex do form fcProy TO lcValue 
*			ON SELECTION BAR 2 OF menúcontex do form proyectos with .t. to lcValue 
			ON SELECTION BAR 2 OF menúcontex do form proy with 1,"",.T. TO lcValue 
*			ON SELECTION BAR 3 OF menúcontex do form proyectos with .t.,lcRef to lcValue 
			ON SELECTION BAR 3 OF menúcontex do form proy with 2,lcRef, .T. TO lcValue 
			ACTIVATE POPUP menúcontex
		CASE lcTp="Existencias"
			DEFINE POPUP menúcontex SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF menúcontex PROMPT ""+TranStr("Buscar Materiales con o sin existencias(Ctrl+F9)","M")+"" ;
				PICTURE "..\ico\materiales.png"
*			ON SELECTION BAR 1 OF menúcontex do form fcExistencias TO lcValue 
			ON SELECTION BAR 1 OF menúcontex do form articulos  TO lcValue 
			ACTIVATE POPUP menúcontex
		CASE lcTp="Mo"
			DEFINE POPUP menúcontex SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF menúcontex PROMPT ""+TranStr("Buscar Mano de Obra (Ctrl+F9)","M")+"" ;
				PICTURE "..\ico\mo.png"
			DEFINE BAR 2 OF menúcontex PROMPT ""+TranStr("Crear Nuevo Codigo de Mano de Obra (Ctrl+F10)","M")+"" ;
				PICTURE "..\ico\mo.png"
			DEFINE BAR 3 OF menúcontex PROMPT ""+TranStr("Modificar Mano de Obra (Ctrl+F8)","M")+"" ;
				PICTURE "..\ico\mo.png"
			ON SELECTION BAR 1 OF menúcontex do form fcmo TO lcValue 
			ON SELECTION BAR 2 OF menúcontex do form MO with .t. to lcValue 
			ON SELECTION BAR 3 OF menúcontex do form MO with .t.,lcRef to lcValue 
			ACTIVATE POPUP menúcontex
		CASE lcTp="Equipos"
			DEFINE POPUP menúcontex SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF menúcontex PROMPT ""+TranStr("Buscar Equipo (Ctrl+F9)","M")+"" ;
				PICTURE "..\ico\mo.png"
			DEFINE BAR 2 OF menúcontex PROMPT ""+TranStr("Crear Nuevo Equipo(Ctrl+F10)","M")+"" ;
				PICTURE "..\ico\mo.png"
			DEFINE BAR 3 OF menúcontex PROMPT ""+TranStr("Modificar Equipo(Ctrl+F8)","M")+"" ;
				PICTURE "..\ico\mo.png"
			ON SELECTION BAR 1 OF menúcontex do form FcEquipos TO lcValue 
			ON SELECTION BAR 2 OF menúcontex do form Equipos with .t. to lcValue 
			ON SELECTION BAR 3 OF menúcontex do form Equipos with .t.,lcRef to lcValue 
			ACTIVATE POPUP menúcontex
		CASE lcTp="Vehiculos"
			DEFINE POPUP menúcontex SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF menúcontex PROMPT ""+TranStr("Buscar Vehiculo(Ctrl+F9)","M")+"" ;
				PICTURE "..\ico\mo.png"
			DEFINE BAR 2 OF menúcontex PROMPT ""+TranStr("Crear Nuevo Vehiculo(Ctrl+F10)","M")+"" ;
				PICTURE "..\ico\mo.png"
			DEFINE BAR 3 OF menúcontex PROMPT ""+TranStr("Modificar Vehiculo(Ctrl+F8)","M")+"" ;
				PICTURE "..\ico\mo.png"
			ON SELECTION BAR 1 OF menúcontex do form VEHICULOS with 2 TO lcValue  
			ON SELECTION BAR 2 OF menúcontex DO FORM vehiculo WITH 1,"",.t.  TO lcValue
			ON SELECTION BAR 3 OF menúcontex DO FORM vehiculo WITH 2,lcRef,.t.  TO lcValue
			ACTIVATE POPUP menúcontex
		CASE lcTp="Ventas"
			DEFINE POPUP VENTASPOPUP SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF VENTASPOPUP PROMPT ""+TranStr("Buscar Vehiculo(Ctrl + F9)","M")+"" ;
				PICTURE "..\ico\mo.png"
			DEFINE BAR 2 OF VENTASPOPUP PROMPT ""+TranStr("Crear Nuevo Vehiculo(Ctrl + F8)","M")+"" ;
				PICTURE "..\ico\mo.png"
			DEFINE BAR 3 OF VENTASPOPUP PROMPT ""+TranStr("Modificar Vehiculo","M")+"" ;
				PICTURE "..\ico\mo.png"
			ON SELECTION BAR 1 OF VENTASPOPUP do form FcEquipos TO lcValue 
			ON SELECTION BAR 2 OF VENTASPOPUP do form Equipos with .t. to lcValue 
			ON SELECTION BAR 3 OF VENTASPOPUP do form Equipos with .t.,lcRef to lcValue 
			ACTIVATE POPUP VENTASPOPUP
		CASE lcTp="Presupuestos"
			DEFINE POPUP PRESUPPOPUP SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF PRESUPPOPUP PROMPT "Buscar Presupuestos" ;
				PICTURE "..\ico\presupuestos_16x16.png"
			DEFINE BAR 2 OF PRESUPPOPUP PROMPT "Crear Nuevo Presupuesto" ;
				PICTURE "..\ico\presupuestos_16x16.png"
			DEFINE BAR 3 OF PRESUPPOPUP PROMPT "Modificar Presupuesto" ;
				PICTURE "..\ico\presupuestos_16x16.png"
			DEFINE BAR 4 OF PRESUPPOPUP PROMPT "Modificar Hoja" ;
				PICTURE "..\ico\Copy_16.png"
			DEFINE BAR 5 OF PRESUPPOPUP PROMPT "Buscar Hoja" ;
				PICTURE "..\ico\Copy_16.png"
				
			&&barra uno 
			ON SELECTION BAR 1 OF PRESUPPOPUP do form FcPresup TO lcValue
			
			
			
			*nota la clave debe venir en el siguiente formato lcRef="03yur-001pm00000001" la se deglosara asi substr(lcref,1,2)=depto substr(lcref,3,7)=idcliente substr(lcref,8,10)=idpresup
			&&barra dos 
			IF SUBSTR(lcRef,1,2)="03" &&si el depto es tres 
				IF validardepto(lcRef)		&&verificar si depto es valido y no esta vacio
					IF validarcliente(lcRef)&&verificar si cliente  es valido y no esta vacio
						ON SELECTION BAR 2 OF PRESUPPOPUP do form presupVeh with 1,"",5,SUBSTR(lcRef,3,7),SUBSTR(lcRef,1,2),1 to lcValue &&ejecutar formulario presupveh
					ELSE 
						lcValue=""
					ENDIF
				ELSE 
					lcValue="" 
				ENDIF 
			ELSE
				IF validardepto(lcRef)
					IF validarcliente(lcRef)
						ON SELECTION BAR 2 OF PRESUPPOPUP do form presupRep  with 1,"",5,SUBSTR(lcRef,3,7),SUBSTR(lcRef,1,2),1 to lcValue &&ejecutar formulario presuprep
					ELSE 
						lcValue=""
					ENDIF
				ELSE 
					lcValue="" 
				ENDIF 
 

			ENDIF 

			IF SUBSTR(lcRef,1,2)="03"
				IF SUBSTR(lcRef,10,2)="PA"
					ON SELECTION BAR 3 OF PRESUPPOPUP do form presupVeh with 2,SUBSTR(lcRef,10,10),5,"","",1 to lcValue 
				ELSE
					lcValue=""
				ENDIF 
			ELSE 
				IF INLIST(SUBSTR(lcRef,10,2),"PR","PM","PI")
					ON SELECTION BAR 3 OF PRESUPPOPUP do form presupRep with 2,SUBSTR(lcRef,10,10),5,"","",1 to lcValue 
				ELSE
					lcValue=""
				ENDIF 
			ENDIF 
			
			
			IF SUBSTR(lcRef,10,2)="HM"
				ON SELECTION BAR 4 OF PRESUPPOPUP do form hoja  with 2,SUBSTR(lcRef,10,10),.T. to lcValue 
			ENDIF 
			ON SELECTION BAR 5 OF PRESUPPOPUP do form hojas  with 2 to lcValue 
			ACTIVATE POPUP PRESUPPOPUP 

		CASE lcTp="Remesas"
			DEFINE POPUP REMENU SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF REMENU PROMPT "Buscar Facturas" ;
				PICTURE "..\ico\presupuestos_16x16.png"
			DEFINE BAR 2 OF REMENU PROMPT "Buscar Prestamos" ;
				PICTURE "..\ico\presupuestos_16x16.png"
			DEFINE BAR 3 OF REMENU PROMPT "Buscar Complemento" ;
				PICTURE "..\ico\COMPLEMENTOS.png"
			DEFINE BAR 4 OF REMENU PROMPT "Modificar Complemento" ;
				PICTURE "..\ico\COMPLEMENTOS.png"
			DEFINE BAR 5 OF REMENU PROMPT "Crear Complemento" ;
				PICTURE "..\ico\COMPLEMENTOS.png"
			DEFINE BAR 6 OF REMENU PROMPT "Buscar Otros Ingresos" ;
				PICTURE "..\ico\OtrosIngresos_24x24.png"
			DEFINE BAR 7 OF REMENU PROMPT "Modificar Otros ingresos" ;
				PICTURE "..\ico\OtrosIngresos_24x24.png"
			DEFINE BAR 8 OF REMENU PROMPT "Crear Otros Ingreso" ;
				PICTURE "..\ico\OtrosIngresos_24x24.png"
			

			ON SELECTION BAR 1 OF REMENU do form FcVentas TO lcValue
			ON SELECTION BAR 2 OF REMENU do form fcOg2 WITH "44" to lcValue
			ON SELECTION BAR 3 OF REMENU do form fcOg2 WITH "454" to lcValue
			IF 	SUBSTR(LCREF,1,2)=="CP"
				
				ON SELECTION BAR 4 OF REMENU DO FORM OG WITH "454",2,"",.T. TO lcValue	 
			ENDIF 
			ON SELECTION BAR 5 OF REMENU DO FORM OG WITH "454",1,"",.T. TO lcValue	
			ON SELECTION BAR 6 OF REMENU do form fcOtring  TO lcValue
			IF 	SUBSTR(LCREF,1,2)=="OI"
				ON SELECTION BAR 7 OF REMENU do form otrosingreso with 2,lcRef,5,"20" TO lcValue
			ENDIF 
			ON SELECTION BAR 8 OF REMENU do form otrosingreso WITH 1,lcRef,5,"20" TO lcValue
			ACTIVATE POPUP REMENU
		CASE lcTp="Otring"
			DEFINE POPUP OIMENU SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF OIMENU  PROMPT "Buscar Materiales con Existencias" ;
				PICTURE "..\ico\materiales.png"
			DEFINE BAR 2 OF OIMENU PROMPT "Buscar Materiales con o sin existencias" ;
				PICTURE "..\ico\materiales.png"
			DEFINE BAR 3 OF OIMENU PROMPT "Buscar Conceptos de Otros Ingresos" ;
				PICTURE "..\ico\OtrosIngresos_24x24.png"
			ON SELECTION BAR 1 OF OIMENU do form fcExistencias TO lcValue 
			ON SELECTION BAR 2 OF OIMENU do form articulos  TO lcValue 
			ON SELECTION BAR 3 OF OIMENU do form fccatal WITH "20" to lcValue
			ACTIVATE POPUP OIMENU
			
			
			
		CASE lcTp="Clientes"
			DEFINE POPUP clientes SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF clientes PROMPT "Buscar Cliente" ;
				PICTURE "..\ico\CLIENTES.png"
			DEFINE BAR 2 OF clientes PROMPT "Crear Nuevo Cliente" ;
				PICTURE "..\ico\CLIENTES.png"
			DEFINE BAR 3 OF clientes PROMPT "Modificar Cliente" ;
				PICTURE "..\ico\CLIENTES.png"

			ON SELECTION BAR 1 OF clientes do form FcClientes TO lcValue 
			ON SELECTION BAR 2 OF clientes do form CLIE with 1,"",.t. to lcValue 
			ON SELECTION BAR 3 OF clientes do form Clie with 2,lcRef,.t. to lcValue 

			ACTIVATE POPUP clientes 

	OTHERWISE
	ENDCASE
	RETURN lcValue 
ENDPROC 


PROCEDURE ValidarDepto
	LPARAMETERS lcRef
	LOCAL lbReturn,lcExact
	lcExact=SET("Exact")
	SET EXACT ON 
	IF !USED("departamentos")	&&si tabla no esta abierta
		USE departamentos 		&&	abrir 
	ENDIF 						&&finsi

	IF EMPTY(SUBSTR(lcRef,1,2))	&&si depto esta vacio el parametro 
		lbReturn=.f.	&&	retornar .f.
	ELSE 			&&sino
		IF SEEK(SUBSTR(lcRef,1,2),"departamentos","iddepto")&&	si depto existe 
			lbReturn=.t.							&&		retornar .t.
		ELSE 									&&	sino
			lbReturn=.F.							&&		retornar .f.
		ENDIF 									&&	finsi
	ENDIF 			&&finsi
	SET EXACT &lcExact
	RETURN lbReturn
ENDPROC 

PROCEDURE ValidarCliente
	LPARAMETERS lcRef
	LOCAL lbReturn,lcExact
	lcExact=SET("Exact")
	SET EXACT ON 
	IF !USED("clientes")	&&si tabla no esta abierta
		USE clientes 		&&	abrir 
	ENDIF 						&&finsi

	IF EMPTY(SUBSTR(lcRef,1,2))	&&si depto esta vacio el parametro 
		lbReturn=.f.	&&	retornar .f.
	ELSE 			&&sino
		IF SEEK(SUBSTR(lcRef,3,7),"clientes","idcliente")&&	si depto existe 
			lbReturn=.t.							&&		retornar .t.
		ELSE 									&&	sino
			lbReturn=.F.							&&		retornar .f.
		ENDIF 									&&	finsi
	ENDIF 			&&finsi
	SET EXACT &lcExact
	RETURN lbReturn
	
	