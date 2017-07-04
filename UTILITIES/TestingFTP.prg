		LOCAL lcDirectory AS STRING 
	lcDirectory="HTML"

	SET LIBRARY TO (LOCFILE("vfpconnection.fll","FLL"))
	
	
	CLEAR
	DIMENSION laFiles(8)
	laFiles(1)="vehiculosD.html"
	laFiles(2)="vehiculos.html"
	laFiles(3)="R_veh_tab.xlsx"
	laFiles(4)="R_veh_D.xlsx"
	laFiles(5)="proyectos.html"
	laFiles(6)="proyectosD.html"
	laFiles(7)="R_pry_tab.xlsx"
	laFiles(8)="R_pry_D.xlsx"
	
	SET LIBRARY TO (LOCFILE("vfpconnection.fll","FLL"))
	SetConnectTimeout(30) && Default is 10 seconds
	SetResponseTimeout(30) && Default is 10 seconds
    STRTOFILE(" "+CHR(13),"FTP.TXT",1)
    STRTOFILE(" "+CHR(13),"FTP.TXT",1)
    STRTOFILE(" "+CHR(13),"FTP.TXT",1)

&&gcLocalWeb="C:\Users\YEC\Documents\web"
	FOR EACH Archivo IN laFiles
		lcFile=Archivo
		WAIT "Copiando Archivo: "+lcFile WINDOW NOWAIT 
		IF FILE(lcDirectory+"\"+lcFile)
		    STRTOFILE("enviando archivo :"+lcFile+CHR(13),"FTP.TXT",1)
		    STRTOFILE("================================================"+CHR(13),"FTP.TXT",1)
			?FTPPut("HTML\"+lcFile,;
			"FTP://u340603853:yecyec@ftp.pymepro.esy.es/reportes/"+lcFile, "MyProgress()", "MyTrace()")		


**			?FTPPut("HTML\"+lcFile,;
			"FTP://u340603853:yecyec@ftp.pymepro.esy.es/reportes/"+lcFile, "MyProgress()", "MyTrace()")		
	
		ENDIF 
	ENDFOR 

SET LIBRARY TO
			
			
***********************
FUNCTION MyProgress() && Callback from the FLL - can be used to track operation progress
***********************
    *!* You can create your own function, procedure or method to handle this and name it whatever you want.
    *!* The nConnectTotalBytes and nConnectBytesSoFar are private variables created on-the-fly by the FLL
    ?m.nConnectTotalBytes
    ?m.nConnectBytesSoFar
ENDFUNC

***********************
FUNCTION MyTrace() && Callback from the FLL - used to provide a detailed trace of the operation
***********************
    *!* You can create your own function, procedure or method to handle this and name it whatever you want.
    *!* The nTraceDataType and cTraceData are private variables created on-the-fly by the FLL
#DEFINE TYPE_TEXT 0
#DEFINE TYPE_HEADER_IN 1
#DEFINE TYPE_HEADER_OUT 2
#DEFINE TYPE_DATA_IN 3
#DEFINE TYPE_DATA_OUT 4
#DEFINE TYPE_SSL_DATA_IN 5
#DEFINE TYPE_SSL_DATA_OUT 6
#DEFINE TYPE_END 7
    ?ICASE(m.nTraceDataType = TYPE_TEXT, "STATUS:", ;
     m.nTraceDataType = TYPE_HEADER_IN, "<RECV HEADER: ", ;
     m.nTraceDataType = TYPE_HEADER_OUT, ">SEND HEADER: ", ;
     m.nTraceDataType = TYPE_DATA_IN, "<RECV DATA: ", ;
     m.nTraceDataType = TYPE_DATA_OUT, ">SEND DATA: ", ;
     m.nTraceDataType = TYPE_SSL_DATA_IN, "<RECV SSL DATA: ", ;
     m.nTraceDataType = TYPE_SSL_DATA_OUT, ">SEND SSL DATA: ", ;
     m.nTraceDataType = TYPE_END, "END: ", "UNKNOWN: ")
    ??m.cTraceData
    STRTOFILE(m.cTraceData+CHR(13),"FTP.TXT",1)
ENDFUNC