**27/05/2014 11:00AM	se creo para jalar los proveedores desde un listado de excel 
**						El listado de excel debeguardarse en formato 95 y contener todos los campos que se detallan aqui 
**						Se empieza con los clientes y luego se creo este para los proveedores 
**						Probado y depurado con BBT


LOCAL err as Exception 
CREATE CURSOR tempProv(;
	NOMBRE 	C (80 ),;
	IDDEPARTAMENTO 	C (2 ),;
	IDMUNICIPIO 	C (4 ),;
	REGISTRO 	C (16 ),;
	NIT 	C (20),;
	DIRECCION 	C (80 ),;
	DEPARTAMENTO 	C (10 ),;
	IMPORT 	C (80 ),;
	FPAGO 	C (10 ),;
	AFILIADA 	L ,;
	GIRO c(80),;
	CAT c(2),;
	NOMBCONTRIB c(80))
	
SELECT tempProv

TRY 
	APPEND FROM GETFILE("xls") TYPE XLS 

CATCH TO err
	MESSAGEBOX(err.ErrorNo )
	lnErrorNo=err.ErrorNo 
	DO CASE
	CASE lnErrorNo=1426 &&1426 archivo esta abierto 
		lcMsg="Cierre el archivo y vuelva intentarlo"
	CASE lnErrorNo=1661 &&1661 archivo no compatible
		lcMsg="Archivo no compatible, guarde el archivo como excel 95"
	OTHERWISE
		lcMsg="Archivo no compatible"
	ENDCASE
	
	MESSAGEBOX(lcMsg,0,"Error")
	
		
ENDTRY 
BROWSE 
SCAN 
	lcImportNombre=nombre
	lcImportIDDEPARTAMENTO=IDDEPARTAMENTO
	lcImportIDMUNICIPIO =IDMUNICIPIO 
	lcImportREGISTRO =REGISTRO 
	lcImportNIT =NIT 
	lcImportDIRECCION =DIRECCION 
	lcImportDEPARTAMENTO =DEPARTAMENTO 
	lcImportIMPORT=IMPORT
	lcImportFPAGO =FPAGO 
	lcImportAFILIADA =AFILIADA 
	lcImportGIRO =GIRO 
	lcImportCAT =CAT 
	lcImportNOMBCONTRIB=NOMBCONTRIB

	DO InsertProv with lcImportNombre,lcImportIDDEPARTAMENTO,lcImportIDMUNICIPIO ,lcImportREGISTRO ,lcImportNIT ,lcImportDIRECCION ,lcImportDEPARTAMENTO ,lcImportIMPORT,lcImportFPAGO ,lcImportAFILIADA ,lcImportGIRO ,lcImportCAT ,lcImportNOMBCONTRIB 
	SELECT tempProv
			
ENDSCAN
