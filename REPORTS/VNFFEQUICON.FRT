   �   @                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              �DRIVER=winspool
DEVICE=\\RECEPCION-1\HP LaserJet P2035
OUTPUT=USB001
ORIENTATION=0
PAPERSIZE=1
PAPERLENGTH=2794
PAPERWIDTH=2159
COPIES=1
DEFAULTSOURCE=7
PRINTQUALITY=600
COLOR=2
DUPLEX=1
COLLATE=0
                                            K  3  winspool  \\RECEPCION-1\HP LaserJet P2035  USB001                                                                    �\\RECEPCION-1\HP LaserJet P203   � 4�    �
o    X                                                                                              SDDM      HP LaserJet P2035                                                 	   	   	   	   	   	   	   	   	   	   	   	   	   	   	   	   	                              Z                      ��� �   ��   �   ��   � � �                 (   d                                                       �  �           �                                         ���b4          �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Arial                                                         VNDEPOT.IDVENTA                                               VNDEPOT.EXENTAS                                               "99,999.99"                                                                                                                 Arial Narrow                                                  vndepot.ventasexentas<>0                                      	idcliente                                                     VNDEPOT.CLIENTE                                               Arial Narrow                                                  [ALLTRIM(VNDEPOT.DIRECCION)+" "+ALLTRIM(VNDEPOT.DEPARTAMENTO)+" "+ALLTRIM(VNDEPOT.MUNICIPIO)                                                                                                 Arial Narrow                                                  VNDEPOT.FECHA                                                 Arial                                                         VNDEPOT.FORMAPAGO                                                                                                           Arial Narrow                                                  ysubstr(VNDEPOT.REGISTRO,1,len(alltrim(VNDEPOT.REGISTRO))-1)+"-"+SUBSTR(VNDEPOT.REGISTRO,len(alltrim(VNDEPOT.REGISTRO)),1)                                                                     Arial Narrow                                                  msubstr(VNDEPOT.NIT,1,4)+"-"+substr(VNDEPOT.NIT,5,6)+"-"+substr(VNDEPOT.NIT,11,3)+"-"+substr(VNDEPOT.NIT,14,1)                 Arial Narrow                                                  numero                                                        /ALLTRIM(VNDEPOT.DOCUMENTO)+" : "+VNDEPOT.NUMERO               Arial Narrow                                                  	idcliente                                                     VNDEPOT.SUMAS                                                 "999,999.99"                                                  Arial Narrow                                                  VNDEPOT.IVARET                                                "999,999.99"                                                  Arial Narrow                                                  VNDEPOT.SUBTOTAL                                              "999,999.99"                                                  Arial Narrow                                                  VNDEPOT.SUBTOTAL<>0                                           VNDEPOT.EXENTAS                                               "999,999.99"                                                  Arial Narrow                                                  VNDEPOT.MONTO                                                 "999,999.99"                                                  Arial Narrow                                                  VNDEPOT.MONTOLETRAS                                           Arial Narrow                                                  VNDEPOT.precio                                                "999,999.99"                                                                                                                Arial Narrow                                                  VNDEPOT.precio<>0                                             VNDEPOT.ventasexentas                                         
"9,999.99"                                                    Arial Narrow                                                  VNDEPOT.ventasexentas<>0                                      VNDEPOT.ventasafectas                                         "999,999.99"                                                  Arial Narrow                                                  VNDEPOT.ventasafectas<>0                                      VNDEPOT.descripcion                                           Arial Narrow                                                  0.00                                                          "999,999.99"                                                  Arial Narrow                                                  VNDEPOT.SOLICITANTE                                           Arial Narrow                                                  VNDEPOT.depto                                                 Arial Narrow                                                  "$"                                                           Arial Narrow                                                  "$"                                                           Arial Narrow                                                  "$"                                                           Arial Narrow                                                  "$"                                                           Arial Narrow                                                  "$"                                                           Arial Narrow                                                  "$"                                                           Arial Narrow                                                  "$"                                                           Arial Narrow                                                  ]VNDEPOT.proyecto+" "+iif(seek(VNDEPOT.proyecto,'proyectos','idproyecto'),proyectos.nombre,"")                                 Arial Narrow                                                  VNDEPOT.cantidad                                              Arial Narrow                                                  VNDEPOT.precio<>0                                             Arial                                                         Arial Narrow                                                  Arial                                                         Arial Narrow                                                  dataenvironment                                               �Top = 151
Left = 268
Width = 520
Height = 200
Visible = .F.
TabStop = .F.
InitialSelectedAlias = "vndepot"
DataSource = .NULL.
DataSourceType = "NATIVE"
Name = "Dataenvironment"
                                                                  PROCEDURE BeforeOpenTables
SET DATE TO FRENCH 
SET DELETED ON 
SET STATUS OFF
SET MULTILOCKS ON  
SET TALK OFF 
ENDPROC
                                                               ����    �   �                         �   %   b       �      |           �  U  *  G(� FRENCH� G � G0� G_ � G2� U  FRENCH BeforeOpenTables,     ��1 � a a a a 1                       t       )   �                           �<      cursor                                                       Top = 20
Left = 10
Height = 90
Width = 90
Alias = "vndepot"
Database = ..\data\cliprov.dbc
CursorSource = "vndepot"
Name = "Cursor1"
                                                                                                                                                                                 cursor                                                        �Top = 20
Left = 150
Height = 90
Width = 90
Alias = "proyectos"
Database = ..\data\proyectos.dbc
CursorSource = "proyectos"
Name = "Cursor2"
                                    