DO CONFIGAPP
* Refox lines used when branding the application.
IF .F.
   _ReFox_=(9876543210)
   _ReFox_=(9876543210)
ENDIF

ON KEY LABEL CTRL+F12 do form ventanacomandos

* Instantiate the Application object.
SET CLASSLIB TO ProApp ADDITIVE
SET CLASSLIB TO VPMApp ADDITIVE
_SCREEN.AddProperty('oApp')
_SCREEN.oApp = CREATEOBJECT('ProApp')
IF TYPE('_SCREEN.oApp') <> 'O'
   RELEASE CLASSLIB ProApp,VPMApp
   RETURN
ENDIF



* Initialize the application environment, bring up the application interface, and issue
* the READ EVENTS command. Pass the application prefix to the Startup method to identify
* the application being run.

_SCREEN.oApp.Startup('GAA')

* The CLEAR EVENTS command has been issued so release the Application object and exit
* the application.
_SCREEN.oApp.Cleanup_ExitApplication()

****LIMPIAR APP
_SCREEN.RemoveObject("genDoc1")
_SCREEN.RemoveObject("yoapp1")
_SCREEN.RemoveObject("label1")
_SCREEN.RemoveObject("yDataManage1")
_SCREEN.RemoveObject("yTimer1")
_SCREEN.RemoveObject("functions1")
_SCREEN.RemoveObject("doc1")
_SCREEN.RemoveObject("utilityconta1")
_SCREEN.RemoveObject("colors1")
_SCREEN.RemoveObject("conta1")

 
***************


_SCREEN.oApp = .F.



**********************
FUNCTION AppEntryError
**********************
* The application's initial ON ERROR command calls this function when an error occurs
* before complete entry into the application has been attained. Therefore, the normal
* method if displaying error messages using the messaging system cannot be used.

LPARAM stnErrNum,stcMess,stcCode,stcProg16,stnCurLine

slnCodeLength = 191-LEN(ALLTRIM(STR(stnErrNum)))-LEN(stcMess)-LEN(stcProg16)-LEN(ALLTRIM(STR(stnCurLine)))
IF slnCodeLength > 0
   WAIT WINDOW 'ERROR #: '+ALLTRIM(STR(stnErrNum))+CHR(13)+'MESSAGE: '+stcMess+CHR(13)+;
      'PROGRAM: '+stcProg16+CHR(13)+'LINE #: '+ALLTRIM(STR(stnCurLine))+CHR(13)+;
      'CODE: '+LEFT(stcCode,slnCodeLength)+CHR(13)+CHR(13)+'Press any key...'
ELSE
   WAIT WINDOW 'ERROR #: '+ALLTRIM(STR(stnErrNum))+CHR(13)+'MESSAGE: '+stcMess+CHR(13)+;
      'PROGRAM: '+stcProg16+CHR(13)+'LINE #: '+ALLTRIM(STR(stnCurLine))+CHR(13)+CHR(13)+'Press any key...'
ENDIF
_SCREEN.oApp.Cleanup_ExitApplication()
_SCREEN.oApp = .F.
QUIT

