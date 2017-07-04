*****************************************************************
*                                                               *
*   ProMatrix Corporation                                       *
*                                                               *
*   Copyright � 1995-2000 ProMatrix Corporation                 *
*                                                               *
*   5225 Ehrlich Road, Suite C                                  *
*   Tampa, FL  33624                                            *
*   U.S.A.                                                      *
*                                                               *
*   This computer program is protected by copyright law and     *
*   international treaties.  No part of this program may be     *
*   reproduced or transmitted in any form or by any means,      *
*   electronic or mechanical, for any purpose, without the      *
*   express written permission of ProMatrix Corporation.        *
*   Unauthorized reproduction or distribution of this program,  *
*   or any portion of it, may result in severe civil and        *
*   criminal penalties, and will be prosecuted to the maximum   *
*   extent possible under the law.                              *
*                                                               *
*****************************************************************

***************
* S<prefix>ULg2 - Display the product name and copyright notice.
***************   Called by S<Prefix>ULgo.

LOCAL slcText,slcCurYear,slcStartYear,slnAreaHeight,slnAreaTop,slnGap

IF NOT _SCREEN.oApp.lCopyrightNotice
   RETURN
ENDIF

* Display the product name.
IF TYPE('_SCREEN.lblProduct') <> 'O'
   _SCREEN.AddObject('lblProduct','label')
ENDIF
_SCREEN.lblProduct.BackStyle = 0
_SCREEN.lblProduct.FontBold = .T.
_SCREEN.lblProduct.FontName = 'Times New Roman'
_SCREEN.lblProduct.FontSize = 11
_SCREEN.lblProduct.Caption = _SCREEN.oApp.cAppTitle
IF TYPE('_SCREEN.oApp.oInt') = 'O'
   * This is an international application so translate the product name.
   _SCREEN.oApp.oInt.TranslateCaption(_SCREEN.lblProduct)
ENDIF
= LabelWidth(_SCREEN.lblProduct)
_SCREEN.lblProduct.Left = (_SCREEN.Width-_SCREEN.lblProduct.Width)/2

* Display the copyright line.
slcCurYear = ALLTRIM(STR(YEAR(DATE())))
IF EMPTY(fapd.start)
   slcText = slcCurYear
ELSE
   slcStartYear = ALLTRIM(STR(YEAR(fapd.start)))
   IF slcStartYear == slcCurYear
      slcText = slcCurYear
   ELSE
      slcText = slcStartYear+' - '+slcCurYear
   ENDIF
ENDIF
IF TYPE('_SCREEN.lblCopyright') <> 'O'
   _SCREEN.AddObject('lblCopyright','label')
ENDIF
_SCREEN.lblCopyright.BackStyle = 0
_SCREEN.lblCopyright.FontBold = .T.
_SCREEN.lblCopyright.FontName = 'Times New Roman'
_SCREEN.lblCopyright.FontSize = 11
_SCREEN.lblCopyright.Caption = 'Copyright � '+slcText
IF TYPE('_SCREEN.oApp.oInt') = 'O'
   * This is an international application so translate the copyright notice.
   _SCREEN.oApp.oInt.TranslateCaption(_SCREEN.lblCopyright)
ENDIF
= LabelWidth(_SCREEN.lblCopyright)
_SCREEN.lblCopyright.Left = (_SCREEN.Width-_SCREEN.lblCopyright.Width)/2

* Display the company name.
IF TYPE('_SCREEN.lblCompany') <> 'O'
   _SCREEN.AddObject('lblCompany','label')
ENDIF
_SCREEN.lblCompany.BackStyle = 0
_SCREEN.lblCompany.FontBold = .T.
_SCREEN.lblCompany.FontName = 'Times New Roman'
_SCREEN.lblCompany.FontSize = 11
_SCREEN.lblCompany.Caption = ALLTRIM(fapd.company)
IF TYPE('_SCREEN.oApp.oInt') = 'O'
   * This is an international application so translate the company name.
   _SCREEN.oApp.oInt.TranslateCaption(_SCREEN.lblCompany)
ENDIF
= LabelWidth(_SCREEN.lblCompany)
_SCREEN.lblCompany.Left = (_SCREEN.Width-_SCREEN.lblCompany.Width)/2

* Position the labels vertically.  They will be displayed halfway between
* the bottom of the logo object and the bottom of the application window.
* If there is no logo object, the labels will be displayed in the center
* of the bottom half of the application window.
IF TYPE('_SCREEN.imgLogo') = 'O'
   slnAreaTop = _SCREEN.imgLogo.Top+_SCREEN.imgLogo.Height
ELSE
   slnAreaTop = INT(_SCREEN.Height/2)
ENDIF
slnAreaHeight = _SCREEN.Height-slnAreaTop
slnGap = INT(_SCREEN.lblProduct.Height/2)
_SCREEN.lblProduct.Top = slnAreaTop+INT((slnAreaHeight-;
   _SCREEN.lblProduct.Height-_SCREEN.lblCopyright.Height-;
   _SCREEN.lblCompany.Height-slnGap*2)/2)
_SCREEN.lblCopyright.Top = _SCREEN.lblProduct.Top+_SCREEN.lblProduct.Height+;
   slnGap
_SCREEN.lblCompany.Top = _SCREEN.lblProduct.Top+_SCREEN.lblProduct.Height+;
   _SCREEN.lblCopyright.Height+slnGap*2
_SCREEN.lblProduct.Visible = .T.
_SCREEN.lblCopyright.Visible = .T.
_SCREEN.lblCompany.Visible = .T.

*******************
FUNCTION LabelWidth
*******************
* Change the width of the label control based on the current value in the
* Caption property.

LPARAM stoLabel

LOCAL slcFontStyle

slcFontStyle = ''
IF stoLabel.FontBold
   slcFontStyle = slcFontStyle+'B'
ENDIF
IF stoLabel.FontItalic
   slcFontStyle = slcFontStyle+'I'
ENDIF
IF stoLabel.FontOutline
   slcFontStyle = slcFontStyle+'O'
ENDIF
IF stoLabel.FontShadow
   slcFontStyle = slcFontStyle+'S'
ENDIF
IF stoLabel.FontStrikethru
   slcFontStyle = slcFontStyle+'-'
ENDIF
IF stoLabel.FontUnderline
   slcFontStyle = slcFontStyle+'U'
ENDIF
IF stoLabel.BackStyle = 1
   slcFontStyle = slcFontStyle+'Q'
ELSE
   slcFontStyle = slcFontStyle+'T'
ENDIF

stoLabel.Width = ROUND(TXTWIDTH(RTRIM(stoLabel.Caption),;
   stoLabel.FontName,stoLabel.FontSize,slcFontStyle)*;
   FONTMETRIC(6,stoLabel.FontName,stoLabel.FontSize,slcFontStyle)+.49,0)



&&GENERACION DEL TOOLBA PRINCIPAL 
*PUBLIC oToolBar
*oToolBar = CREATEOBJECT("MyToolBar",5)
*oToolBar.Show()
*oToolBar.DOCK(1)

*PUBLIC OTIMER
*OTIMER=CREATEOBJECT("MYTIMER")&&
*OTIMER.INTERVAL=5000

*DEFINE CLASS MYTIMER AS TIMER
*	PROCEDURE TIMER
*		MESSAGEBOX("HOLA")
		
*	ENDPROC
*ENDDEFINE 

*DEFINE CLASS MyToolBar AS ToolBar
*	PROCEDURE INIT
*	LPARAMETERS tnButtons
*		MESSAGEBOX(_SCREEN.oApp.oSec.cStatus)
*		FOR lnCounter=1 TO tnButtons
*			lcName = "cmd"+TRANSFORM(lnCounter,"@L 99")
*			This.AddObject(lcName,"CommandButton")
*			loCommand = EVALUATE("This."+lcName)
*			loCommand.Visible = .T.
*		ENDFOR
*	ENDPROC
*ENDDEFINE 