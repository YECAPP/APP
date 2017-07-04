PUBLIC oToolBar
oToolBar = CREATEOBJECT("MyToolBar",5)
oToolBar.Show()
oToolBar.DOCK(1)

*PUBLIC OTIMER
*OTIMER=CREATEOBJECT("MYTIMER")&&
*OTIMER.INTERVAL=5000

*DEFINE CLASS MYTIMER AS TIMER
*	PROCEDURE TIMER
*		MESSAGEBOX("HOLA")
		
*	ENDPROC
*ENDDEFINE 



DEFINE CLASS MyToolBar AS ToolBar
	PROCEDURE INIT
	LPARAMETERS tnButtons
		FOR lnCounter=1 TO tnButtons
			lcName = "cmd"+TRANSFORM(lnCounter,"@L 99")
			This.AddObject(lcName,"CommandButton")
			loCommand = EVALUATE("This."+lcName)
			loCommand.Visible = .T.
		ENDFOR
		THIS.AddObject("smp1","smp",)
		this.smp1.visible=.t.
		this.smp1.cAlias = "oc"
		this.smp1.cData = "descrip,descrip2"
		this.smp1.ctooltipfield="descrip2"
		this.smp1.ciconfield="Image"
		this.smp1.cdefaulticon="..\ICO\REPORT.bmp"
		this.smp1.nDefaultview=3
		this.smp1.lLink=.t.
		this.smp1.lcheckboxes=.F.
		this.smp1.PopulateList
	ENDPROC
ENDDEFINE 

DEFINE CLASS smp as Simplelist OF "..\LIB1.0\Simplelist.vcx"
	PROCEDURE INIT
	LPARAMETERS lcMensaje
		MESSAGEBOX("Se creo")
		DO gencurval 
		
	ENDPROC 	
ENDDEFINE 