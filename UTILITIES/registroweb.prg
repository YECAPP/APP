DO registroweb
procedure registroweb

lcEmail="correo@nuevo"
lcNombre="correo"
lcEmpresa="empresa"
lcTipo="tipo"
lcApp="contaportable"
lcOrigen="ylap"
lcPwd="WbService123"

oHTTP = CREATEOBJECT('Msxml2.ServerXMLHTTP.6.0')
lcSite="http://www.tiservicios.net/webservice/registroConta.php"

lcUrl=lcSite+;
	"?email="+lcEmail+;
	"&nombre="+lcNombre+;
	"&empresa="+lcEmpresa+;
	"&tipo="+lcTipo+;
	"&app="+lcApp+;
	"&origen"+lcOrigen+;
	"&pwd"+lcPwd

*http://www.tiservicios.net/webservice/registroConta.php?email=ventas3@tiservicios.net&nombre=yec

oHTTP.OPEN("GET", lcUrl, .F.)
oHTTP.SEND("")
cResponse = oHTTP.responseText
?cResponse 
MESSAGEBOX(cResponse)
oHTTP = NULL

ENDPROC 