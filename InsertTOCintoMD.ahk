/*
Function       : InsertTOCintoMD
Version        : v0.1
Author         : hi5
Doc + Examples : https://github.com/hi5/InsertTOCintoMD/
AutoHotkey     : AutoHotkey 1.1+ series
Purpose        : Insert Table of contents into readme.md for posting on GitHub

Documentation

GitHub automatically inserts anchors into your Markdown files when browsing a 
GH repository, this script inserts a table of contents into your Markdown file(s). 

# InsertTOCintoMD(filename[,marker="<!-- [toc] -->,<!-- [/toc] -->", heading="`n**Table of contents**`n`n"])

Parameter    Description

filename     Name of markdown file to insert table of contents based on #-##-### headings
             Supports three level nesting: Heading 1 is Ordered list item, Headings 2 & 3 are
             nested Unordered (bullet) lists. 

marker       Markers identifing the start and end of the location where to insert the table of contents
             in an MD file allowing you to update existing an existing table of contents.
             Start and end markers are seperated by a comma which are in turn used in a regular 
             expression to find the current table of contents in order to replace it
             Default values are <!-- [toc] -->,<!-- [/toc] -->

heading      Text to insert above table of contents 
             Default value is `n**Table of contents**`n`n"

Remarks:

- first heading it finds is skipped by default as it assumes that is the title of the file
  which will be excluded from the table of contents.

Example:

InsertTOCintoMD("readme.md")
#include InsertTOCintoMD.ahk

*/

InsertTOCintoMD(filename,marker="<!-- [toc] -->,<!-- [/toc] -->", heading="`n**Table of contents**`n`n")
	{
	 IDs:=FindIDs(filename)
	 toc:=CreateToc(IDs)
	 SaveMD(filename,marker,heading,toc)
	}

SaveMD(filename,marker,heading,toc)
	{
	 FileRead, file, %filename%
	 StringSplit, m, marker, `,
	 updatetoc:="isU)\Q" m1 "\E.*\Q" m2 "\E"
	 If (RegExMatch(file,updatetoc) = 0)
		{
		 MsgBox, 48, Missing marker..., % "Start and End makers (" m1 "," m2 ") not present in Markdown file.`nFile not updated"
		 Return
		}
	 ; Create backup for safety
	 FileCopy, %filename%, %filename%.bak, 1
	 file:=RegExReplace(file, updatetoc, m1 heading toc "`n`n" m2)
	 FileDelete, %filename%
	 FileAppend, %file%, %filename%
	}

; format:
; [id name with spaces](#idnamewithoutspaces)
CreateToc(IDs)
	{
	 tocIndex:=0
	 tocIndexShow:=1
	 Loop, parse, IDs, `n, `r
		{
		 If (A_Index = 1) or (A_LoopField = "")
		 	Continue
		 line:=A_LoopField
		 tocIndent:=InStr(line,A_Space)
		 If (tocIndent = 2)
		 	{
			 tocIndex++
			 tocIndexShow:=1
		   	}	
		 tline:=Trim(line,"# ")
		 aline:=RegExReplace(tline,"m)[\'\?\(\)\&]")
		 tline:=RegExReplace(tline,"i)\s*<a.*/a>\s*")
		 if InStr(aline,"a name=")
		 	aline:=RegExReplace(aline,"iU)^.*name=['\""]*(.*)['\""]*></a>.*$","$1")
		 StringReplace,aline,aline,%A_Space%,-,All
		 StringLower, aline, aline
		 toc .= pad(tocIndent,tocIndexShow,tocIndex) " [" tline "](#" trim(aline,"'""") ")`n" 
		 tocIndexShow:=0
		}
	 toc:=Trim(toc,"`n")
	 Return toc
	}

FindIDs(filename)
	{
	 FileRead, file, %filename%
	 Loop, parse, file, `n, `r
		If RegExMatch(A_LoopField,"^#")
			IDs .= A_LoopField "`n"
	 Return IDs		
	}

Pad(x,y,z)
	{
	 If (y = 1)
	 	return z "."
	 Loop % x
		s .= A_Space
	 If (x = 3)	
		s .= A_Space A_Space A_Space
	 If (x = 4)	
		s .= A_Space A_Space A_Space A_Space A_Space A_Space
	 Return s "*"	
	}
