   s   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        +;
								SUBS      Arialat_pos4+m.at_pos5)
      H  !  winspool HP LaserJet III \\Joe-gateway \hp iii                                           �HP LaserJet III                  � @ g           ,  ,                                                                                 @ MSUDHP LaserJet III                 �              d 
                    �DRIVER=winspool
DEVICE=HP LaserJet III
OUTPUT=\\Joe-gateway \hp iii
ORIENTATION=0
PAPERSIZE=1
COPIES=1
DEFAULTSOURCE=1
PRINTQUALITY=300
YRESOLUTION=300
TTOPTION=2
                       &SGAASDEC(SUBSTR(susr.encrypted,109,1))                                                         Courier New                    DATE()                         Courier New                    TranStr("Page ","R")           Courier New                    _PAGENO                        Courier New                    $TranStr("User Passwords Report","R")                            Arial                          TranStr("ID","R")              Arial                          TranStr("Password","R")        Arial                          TranStr("Name","R")            Arial                          &SGAASDEC(SUBSTR(susr.encrypted,105,3))                                                         Courier New                    &SGAASDEC(SUBSTR(susr.encrypted,95,10))                          &SGAASDEC(SUBSTR(susr.encrypted,85,10))                          dataenvironment                                               Courier New                    TranStr("Page:","R")           Courier New                    _PAGENO                        Courier New                    TIME()                         Courier New                    &SGAASDEC(SUBSTR(susr.encrypted,15,10))                                                         Courier New                    TranStr("Date","R")            Arial                          Arial                          Courier New                                                   Courier New                    TranStr("Pd.","R")             Arial                          Courier New                    Courier New                                                   Courier New                    TranStr("Scrn.","R")           Arial                          Arial                          �TRIM(SGAASDEC(SUBSTR(susr.encrypted,65,20))) + ', ' + TRIM(SGAASDEC(SUBSTR(susr.encrypted,25,20))) + ' ' + SGAASDEC(SUBSTR(susr.encrypted,45,20))                  jLeft = 10
Top = 195
Width = 177
Height = 190
InitialSelectedAlias = "susr"
Name = "Dataenvironment"
                        �PROCEDURE OpenTables
SET TALK OFF
SET DELETED ON

IF _SCREEN.oApp.OpenView('USERS_V','System_v','susr',,,,,,,SET('DATASESSION'))
   INDEX ON SUBSTR(encrypted,15,10) TAG user_id
ENDIF

ENDPROC
                           F���    -  -                        ��   %   �       �      �           �  U  n  G2� G �E %�C� USERS_V� System_v� susr������C� DATASESSIONv�9�  � ��g � & �C� ��
\��� � � U  OAPP OPENVIEW	 ENCRYPTED USER_ID
 OpenTables,     ��1 a a RaA 2                       �       )   -                      !         H���5  , 