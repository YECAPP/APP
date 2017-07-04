*!* The code below is not designed to run all at once
*!* Run the individual examples seperately

SET LIBRARY TO (LOCFILE("vfpconnection.fll","FLL"))
*?FTPGet("FTP://yernesto:Ernesto2012!!@xerber.net/tiservicios.net/Source.zip", "C:\Destination.zip", "MyProgress()", "MyTrace()")


?FTPPut("C:\Users\YEC\Documents\web\veniculos.html",;
		"FTP://reportes@slt.com.sv:t2em7xptlmra@ftp.slt.com.sv/reportes/vehiculos.html", "MyProgress()", "MyTrace()")

*?FTPPut("C:\Users\YEC\Documents\web\veniculosD.html",;
		"FTP://reportes@slt.com.sv:t2em7xptlmra@ftp.slt.com.sv/reportes/vehiculosD.html", "MyProgress()", "MyTrace()")


PROCEDURE SUBIR
	********************************************************************
	*!* Upload Examples
	********************************************************************
	SET LIBRARY TO (LOCFILE("vfpconnection.fll","FLL"))
	*!* FILE
	?FILEGet("File:///C:\Source.txt", "C:\Destination.txt", "MyProgress()", "MyTrace()")
	*!* FTP
	?FTPGet("FTP://UserName:Password@somedomain.com/directory/Source.zip", "C:\Destination.zip", "MyProgress()", "MyTrace()")
	*!* FTPS
	?FTPSGet("FTPS://UserName:Password@somedomain.com:21/directory/Source.zip", "C:\Destination.zip", "MyProgress()", "MyTrace()")
	*!* HTTP
	?HTTPGet("http://www.somedomain.com/Source.htm", "C:\Destination.htm", "MyProgress()", "MyTrace()")
	*!* HTTPS
	?HTTPSGet("https://www.somedomain.com/Source.htm", "C:\Destination.htm", "MyProgress()", "MyTrace()")
	SET LIBRARY TO
ENDPROC 


PROCEDURE BAJAR
	********************************************************************
	*!* Download Examples
	********************************************************************
	SET LIBRARY TO (LOCFILE("vfpconnection.fll","FLL"))
	*!* FILE
	?FILEPut("C:\Source.txt", "File:///C:\Destination.txt", "MyProgress()", "MyTrace()")
	*!* FTP
	?FTPPut("C:\Source.zip", "FTP://UserName:Password@somedomain.com/directory/Destination.zip", "MyProgress()", "MyTrace()")
	*!* FTPS
	?FTPSPut("C:\Source.zip", "FTPS://UserName:Password@somedomain.com:21/directory/Destination.zip", "MyProgress()", "MyTrace()")
	*!* HTTP
	?HTTPPut("C:\Source.htm", "http://www.somedomain.com/Destination.htm", "MyProgress()", "MyTrace()")
	*!* HTTPS
	?HTTPSPut("C:\Source.htm", "https://www.somedomain.com/Destination.htm", "MyProgress()", "MyTrace()")
	SET LIBRARY TO
ENDPROC 

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
ENDFUNC

