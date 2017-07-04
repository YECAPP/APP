lcFileProject="sgaa.pjx"
?ProjectLineCount(lcFileProject)
SELECT Presumen 
GO TOP 
_vfp.DataToClip(,,3)

PROCEDURE ProjectLineCount
**** Begin Code
#Define CR Chr(13)
#Define CRLF CR+Chr(10)
#Define CRLFTAB CRLF+Chr(9)
LParameters tcProject



Local ji, laFiles(1), lcCurDir, lcFile, lcProject, lcTalk, ;
     lcType, lnFCnt, lnLineCnt     
Store "" To lcCurDir, lcFile, lcProject, lcTalk, lcType
Store 0 To ji, lnFCnt, lnLineCnt

If Vartype(tcProject)#"C" Or Empty(tcProject) ;
          Or !File(ForceExt(tcProject, "pjx"))
     MessageBox("Must pass in valid project name.", 16)
     Return 0
EndIf

lcProject = FullPath(ForceExt(tcProject, "pjx"))

lcCurDir = FullPath(CurDir())
CD (JustPath(lcProject))

Close All
Select PadR(Alltrim(Strtran(name, Chr(0))),254), type ;
     From (ForceExt(lcProject, "pjx")) ;
     Where type $ "KPV" ;
     Into Array laFiles
lnFCnt=_Tally
Use && close the pjx
lnLineCnt = 0
lcTalk = Set("Talk")
Set Talk Off
CREATE CURSOR Presumen (line i, nlines i,ntlines i,nfile c(254),tp c(1))

For ji = 1 To lnFCnt
     lcFile = Alltrim(laFiles[ji,1])
     Wait Window lcFile + Chr(13) + Transform(ji) + " of " + Transform(lnFCnt) nowait
     lcType = laFiles[ji,2]
	
	
	lnLineThisFile=0
	
     If lcType = "P"
          *-- program
          	lnLineThisFile=RealLines(FileToStr(lcFile))
          	*lnLineCnt = lnLineCnt + RealLines(FileToStr(lcFile))
          	lnLineCnt = lnLineCnt + lnLineThisFile          	
          	INSERT INTO Presumen (line , nlines ,ntlines ,nfile ,tp )values (ji,lnLineThisFile,lnLineCnt,lcFile, lcType )
     Else
          *-- form or classlib

          Use (lcFile) IN 0 ALIAS file2search
          SELECT file2search
          Scan For !Empty(methods)
				lnLineThisFile=lnLineThisFile+RealLines(Alltrim(methods))
				*lnLineCnt = lnLineCnt + RealLines(Alltrim(methods))
          ENDSCAN
          lnLineCnt = lnLineCnt + lnLineThisFile
          USE IN file2search
          INSERT INTO Presumen (line , nlines ,ntlines ,nfile ,tp )values (ji,lnLineThisFile,lnLineCnt,lcFile, lcType )
     EndIf
EndFor
Set Talk &lcTalk
CD (lcCurDir)
Return lnLineCnt
ENDPROC 
*--------------
* RealLines
*--------------
*     return the "real" line count from the given string
*     may need to be modified depending on your definition of
*     a "real" line - e.g., this version does not elminate
*     comments.
Function RealLines(tcString)
     Local lcString, laLines(1)

     lcString=Alltrim(tcString)
     lcString=Strtran(lcString, CRLFTAB, CRLF)
     Do While CRLF+CRLF $ lcString
          lcString = Strtran(lcString, CRLF+CRLF, CRLF)
     EndDo
     Do While !IsAlpha(Right(lcString, 1)) And !IsDigit(Right(lcString,1))
          lcString = Left(lcString, Len(lcString)-1)
     EndDo
     Return  ALines(laLines, lcString)
EndFunc
*** EndCode