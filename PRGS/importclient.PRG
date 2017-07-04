**03/06/2013 9:25pm	Se empieza creacion de comandos Inserts, que agilizaran el proceso de insercion de datos 
**					simplificando la creacion de nuevos registros
**03/06/2013 9:26pm Se empieza con los clientes se depuro con bbt y lic acosta 


LOCAL err as Exception 
CREATE CURSOR tempClient(;
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
	
SELECT tempClient

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

	DO InsertClient with lcImportNombre,lcImportIDDEPARTAMENTO,lcImportIDMUNICIPIO ,lcImportREGISTRO ,lcImportNIT ,lcImportDIRECCION ,lcImportDEPARTAMENTO ,lcImportIMPORT,lcImportFPAGO ,lcImportAFILIADA ,lcImportGIRO ,lcImportCAT ,lcImportNOMBCONTRIB 
	SELECT tempClient
			
ENDSCAN
