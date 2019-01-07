#pragma compile(Out, ListeTotale.exe)
; Uncomment to use the following icon. Make sure the file path is correct and matches the installation of your AutoIt install path.
;~ #pragma compile(Icon,"C:\Users\Lodhar\Documents\_workspace\Ico\developpement-des-logiciels-icone-4322.ico")
#pragma compile(Icon,"E:\_workspace\Ico\happy-face-forfait-smiley-jouets-icone-6205.ico")
;~ #pragma compile(ExecLevel, highestavailable)
#pragma compile(Compatibility, win7)
;~ #pragma compile(UPX, False)
;~ #pragma compile(FileDescription, myProg - a description of the application)
#pragma compile(ProductName, Compilation Listes Everything)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0) ; The last parameter is optional.
#pragma compile(LegalCopyright, © Lodhar)
#pragma compile(LegalTrademarks, 'GPL License')
#pragma compile(CompanyName, 'Bad Company')

#include <Array.au3> ; Only required to display the arrays
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <String.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include <TreeViewConstants.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <Debug.au3>

If @Compiled Then
   _DebugSetup("Total List", True,4,'log.txt',True) ; Put the debug in a file
Else
   _DebugSetup("Total List", True,2,'',True) ; Put the debug in the console
EndIf

Global $folder
$folder = SelectFolder()
;~ _DebugOut($folder & @CRLF)

   GetFilesAndFolders($folder)



Func GetFilesAndFolders($filePath)

   $include = "HDD*.efu"
   $exclude = " "
   $Exclude_Folders = " "

   Local $aArray = _FileListToArrayRec($filePath, $include & "|" & $exclude & "|" & $Exclude_Folders, $FLTAR_FILES , $FLTAR_NORECUR , $FLTAR_SORT, $FLTAR_FULLPATH  ) ; Get EFU files
   If (@error) Then
	  MsgBox(16, "Error", "No *.efu files found in the directory" & @CRLF &"_FileListToArrayRec error:"& @error&" extended:"&@extended )
	  Exit
   EndIf

   Local $arrayResult[0]
   For $i = 0 To UBound ($aArray) - 1 ;
	  _ArrayAdd($arrayResult, $aArray[$i] )
   Next

;~    Local $aArray = _ArrayUnique($arrayResult) ; enlève les doublons
   _ArrayDelete($arrayResult, 0) ; enlève le count
   ConsoleWrite("_ArrayDeleteError:" & @error & @CRLF)


   Dim $resultArray[0]
   Local $sDrive = "", $sDir = "", $sFilename = "", $sExtension = ""
   $header = "Filename,Size,Date Modified,Date Created,Attributes" & @CRLF
   ;create temporary file
   Local $hFileOpen = FileOpen("./ListeTotaleTemp.efu", $FO_APPEND  + + $FO_UTF8_NOBOM)
	  If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred when operating the file (@temporary).")
        Return False
	 EndIf
   ;Writing header
   FileWrite($hFileOpen, $header)
;~    File encoding value
;~     0 = ANSI
;~     32 = UTF16 Little Endian.
;~     64 = UTF16 Big Endian.
;~     128 = UTF8 (with BOM).
;~     256 = (without BOM).

   For $vElement In $arrayResult ; pour chaque éléments
;~ 	  $vElement = $aArray[2]
	  ; READ FILE
	  Local $hFileOpenList = FileOpen($vElement, $FO_READ + $FO_UTF8_NOBOM )
	  Local $fileGetEncodingValue = FileGetEncoding ( $hFileOpenList)

	  If $hFileOpenList = -1 Then
		 _DebugOut("An error occurred when reading the file:" & $vElement)
		 Return False
	  EndIf

	  ; Read the contents of the file using the handle returned by FileOpen.
	  Local $sFileRead = FileRead($hFileOpenList)
	  Local $aPathSplit = _PathSplit($vElement, $sDrive, $sDir, $sFilename, $sExtension)
	  _DebugOut($sFilename & ": " & $fileGetEncodingValue)
;~ 	  "I:
	  $sFileRead = StringRegExpReplace($sFileRead,'".:','\"' & $sFilename & ':')
	  $sFileRead = StringRegExpReplace($sFileRead,'Filename,Size,Date Modified,Date Created,Attributes\r\n','')

;~ 	  ConsoleWrite ($sFileRead)
	  ; Close the handle returned by FileOpen.
	  FileClose($hFileOpenList)

	  ;WRITE FILE
	   ; Write temporary file
    FileWrite($hFileOpen, $sFileRead)


   Next

 ; Close temporary file
    FileClose($hFileOpen)

   FileMove("./ListeTotaleTemp.efu","ListeTotaleFinale.efu",$FC_OVERWRITE)
   FileDelete("./ListeTotaleTemp.efu")

EndFunc




Func SelectFolder()
    ; Create a constant variable in Local scope of the message to display in FileSelectFolder.
    Local Const $sMessage = "Select a folder"
   Local $sFileSelectFolder = FileSelectFolder($sMessage, @WorkingDir, Default, @WorkingDir)
    If @error Then
		_DebugOut("ERROR: " & @error & " - " & "No folder was selected." )
		Exit
    Else
		_DebugOut("SUCCES: " & "You chose the following folder:" & $sFileSelectFolder )
	 EndIf
	 Return $sFileSelectFolder
  EndFunc   ;==>Example





