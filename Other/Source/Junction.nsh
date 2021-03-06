/* !include "Junction.nsh"
Some basic differences between these three guys are:
• All 3 must be located on a NTFS volume (but not necessarily their target)
• All 3 system must be Windows 2000 or newer

Hard Links
• only for files
• both the link and the target must be on the same volume and must exist
• _PATH must be absolute
• it is indistinguishable from the original file and doesn't really act like a
link, but rather like another copy of the target file (except that when you edit
one, both get changed; but you need to delete both to get that file actually
deleted)

Junctions:
• only for folders
• in XP and older, when they are deleted in the explorer, the target gets wiped
out as well (see wikipedia entry on junctions)
• _PATH must be absolute, target can be anywhere
• on Win XP SP 4, creation fails if the target doesn't exist, on Win 7, it gets
created (didn't try anywhere else)

Symbolic Links:
• only Vista and newer
• supports both files and folders
• target can be anywhere and doesn't need to exist
• _PATH can be relative or absolute

Resources:
http://msdn.microsoft.com/en-us/library/aa365680(v=vs.85).aspx
http://msdn.microsoft.com/en-us/library/aa365006(v=vs.85).aspx
http://en.wikipedia.org/wiki/NTFS_junction_point
http://en.wikipedia.org/wiki/NTFS_symbolic_link

*//* ##### ¤ CHECKS ¤
	${IsHardLink} "${_PATH}" ${_RETURN}
	• checks if target is a hard link.

	${IsSoftLink} "${_PATH}" ${_RETURN}
	• checks if target is a soft link.
	• (symbolic link or junction)

	${IsLink} "${_PATH}" ${_RETURN}
	• checks if target is either a hard or soft link.

*//* ##### ¤ CREATION : FILES ¤
	${CreateHardLink} "${Junction}" "${Target}" ${_RETURN}
	• creates a hard link
	• files only
	• must be on same volume
	• target must exist

	${CreateSymbolicLinkFile} "${Junction}" "${Target}" ${_RETURN}
	• creates a symbolic link
	• files only
	• Windows Vista and newer
	• target does not have to exist
	• target can be anywhere

	${CreateLinkFile} "${Junction}" "${Target}" ${_RETURN}
	• tries to create a symbolic link, if unsuccessful, a hard link.
	• files only

*//* ##### ¤ CREATION : FOLDERS ¤
	${CreateSymbolicLinkFolder} "${Junction}" "${Target}" ${_RETURN}
	• creates a symbolic link for a folder.
	• Windows Vista and newer.
	• target does not have to exist.

	${CreateJunction} "${Junction}" "${Target}" ${_RETURN}
	• creates a junction
	• folders only.
	• absolute _PATHs only
	• target must exists

	${CreateLinkFolder} "${Junction}" "${Target}" ${_RETURN}
	; tries to create symbolic link first and when it fails, then it tries to 
	create a junctions (directories only)

*//* ##### ¤ DELETION ¤
	${DeleteLinkFolder} "${_PATH}" ${_RETURN}
	• checks if a folder is a junction or symbolic link
	• if it is, it's deleted.

	${DeleteLinkFile} "${_PATH}" ${_RETURN}
	• checks if a file is a symbolic or hard link.
	• if it is, it's deleted.

*//* ##### ¤ RETURN VALUE ¤
	• 0 = fail
	• usually 1, but not always = success
	*//*
____________________________________________________________________________
 
                            GetFileAttributes v1.2
____________________________________________________________________________
Get attributes of file or directory.
 
Syntax:
${GetFileAttributes} "[File]" "[Attributes]" $var
 
"[File]"          ; File or directory
                  ;
"[Attributes]"    ; "ALL"  (default)
                  ;  -all attributes of file combined with "|" to output
                  ;
                  ; "READONLY|HIDDEN|SYSTEM|DIRECTORY|ARCHIVE|
                  ; DEVICE|NORMAL|TEMPORARY|SPARSE_FILE|REPARSE_POINT|
                  ; COMPRESSED|OFFLINE|NOT_CONTENT_INDEXED|ENCRYPTED"
                  ;  -file must have specified attributes
                  ;
$var              ; Return value:
                  ;    "ALL" = attr1|attr2|attr3|attr4|...
                  ;    1 = YES
                  ;    0 = NO
                  ;
                  ; Note: 
                  ;    Error flag if file does not exist.
*/
;Function GetFileAttributes
;	!define GetFileAttributes `!insertmacro GetFileAttributesCall`
;	!macro GetFileAttributesCall __PATH _ATTR _RESULT
;		Push `${__PATH}`
;		Push `${_ATTR}`
;		Call GetFileAttributes
;		Pop ${_RESULT}
;	!macroend
;	Exch $1
;	Exch
;	Exch $0
;	Exch
;	Push $2
;	Push $3
;	Push $4
;	Push $5
;	System::Call 'kernel32::GetFileAttributes(t r0)i .r2'
;	StrCmp $2 -1 error
;	StrCpy $3 ''
;	IntOp $0 $2 & 0x4000
;	IntCmp $0 0 +2
;	StrCpy $3 'ENCRYPTED|'
;	IntOp $0 $2 & 0x2000
;	IntCmp $0 0 +2
;	StrCpy $3 'NOT_CONTENT_INDEXED|$3'
;	IntOp $0 $2 & 0x1000
;	IntCmp $0 0 +2
;	StrCpy $3 'OFFLINE|$3'
;	IntOp $0 $2 & 0x0800
;	IntCmp $0 0 +2
;	StrCpy $3 'COMPRESSED|$3'
;	IntOp $0 $2 & 0x0400
;	IntCmp $0 0 +2
;	StrCpy $3 'REPARSE_POINT|$3'
;	IntOp $0 $2 & 0x0200
;	IntCmp $0 0 +2
;	StrCpy $3 'SPARSE_FILE|$3'
;	IntOp $0 $2 & 0x0100
;	IntCmp $0 0 +2
;	StrCpy $3 'TEMPORARY|$3'
;	IntOp $0 $2 & 0x0080
;	IntCmp $0 0 +2
;	StrCpy $3 'NORMAL|$3'
;	IntOp $0 $2 & 0x0040
;	IntCmp $0 0 +2
;	StrCpy $3 'DEVICE|$3'
;	IntOp $0 $2 & 0x0020
;	IntCmp $0 0 +2
;	StrCpy $3 'ARCHIVE|$3'
;	IntOp $0 $2 & 0x0010
;	IntCmp $0 0 +2
;	StrCpy $3 'DIRECTORY|$3'
;	IntOp $0 $2 & 0x0004
;	IntCmp $0 0 +2
;	StrCpy $3 'SYSTEM|$3'
;	IntOp $0 $2 & 0x0002
;	IntCmp $0 0 +2
;	StrCpy $3 'HIDDEN|$3'
;	IntOp $0 $2 & 0x0001
;	IntCmp $0 0 +2
;	StrCpy $3 'READONLY|$3'
;	StrCpy $0 $3 -1
;	StrCmp $1 '' end
;	StrCmp $1 'ALL' end
;	attrcmp:
;		StrCpy $5 0
;		IntOp $5 $5 + 1
;		StrCpy $4 $1 1 $5
;		StrCmp $4 '' +2
;		StrCmp $4 '|'  0 -3
;		StrCpy $2 $1 $5
;		IntOp $5 $5 + 1
;		StrCpy $1 $1 '' $5
;		StrLen $3 $2
;		StrCpy $5 -1
;		IntOp $5 $5 + 1
;		StrCpy $4 $0 $3 $5
;		StrCmp $4 '' notfound
;		StrCmp $4 $2 0 -3
;		StrCmp $1 '' 0 attrcmp
;		StrCpy $0 1
;		goto end
;	notfound:
;		StrCpy $0 0
;		goto end
;	error:
;		SetErrors
;		StrCpy $0 ''
;	end:
;		Pop $5
;		Pop $4
;		Pop $3
;		Pop $2
;		Pop $1
;		Exch $0
;FunctionEnd
/*
GetParent
	input, top of stack  (e.g. C:\Program Files\Poop)
	output, top of stack (replaces, with e.g. C:\Program Files)
	modifies no other variables.

Usage:
	Push "C:\Program Files\Directory\Whatever"
	Call GetParent
	Pop $R0
	; at this point $R0 will equal "C:\Program Files\Directory"
*/
;Function _GetParent
;	!define GetParent `!insertmacro GetParent`
;	!macro GetParent _PATH _RESULT
;		Push `${_PATH}`
;		Call _GetParent
;		Pop ${_RESULT}
;	!macroend
;	Exch $R0
;	Push $R1
;	Push $R2
;	Push $R3
;	StrCpy $R1 0
;	StrLen $R2 $R0
;	loop:
;		IntOp $R1 $R1 + 1
;		IntCmp $R1 $R2 get 0 get
;		StrCpy $R3 $R0 1 -$R1
;		StrCmp $R3 "\" get
;		Goto loop
;	get:
;		StrCpy $R0 $R0 -$R1
;		Pop $R3
;		Pop $R2
;		Pop $R1
;		Exch $R0
;FunctionEnd
################################################################################
                                # CHECK NTFS #                                     
################################################################################
;StrCpy $0 $WINDIR 3
;System::Call 'Kernel32::GetVolumeInformation(t "$0",t,i ${NSIS_MAX_STRLEN},*i,*i,*i,t.r1,i ${NSIS_MAX_STRLEN})i.r0'
;IntCmp $0 0 +6
;StrCmpS $1 NTFS +5
;StrCpy $MissingFileOrPath `NTFS Filesystem`
;MessageBox MB_ICONSTOP|MB_TOPMOST `$(LauncherFileNotFound)`
;Call Unload
;Quit
################################################################################
                                # VALIDATE #                                     
################################################################################
!define FILE_SUPPORTS_REPARSE_POINTS 0x00000080
!macro YESNO _FLAGS _BIT _VAR
	IntOp ${_VAR} ${_FLAGS} & ${_BIT}
	${IfThen} ${_VAR} <> 0 ${|} StrCpy ${_VAR} 1 ${|}
	${IfThen} ${_VAR} == 0 ${|} StrCpy ${_VAR} 0 ${|}
!macroend
Function ValidateFS
	!macro _ValidateFS _PATH _RETURN
		Push `${_PATH}`
		Call ValidateFS
		Pop ${_RETURN}
	!macroend
	!define ValidateFS `!insertmacro _ValidateFS`
	Exch $0
	Push $1
	Push $2
	StrCpy $0 $0 3
	System::Call `Kernel32::GetVolumeInformation(t "$0",t,i ${NSIS_MAX_STRLEN},*i,*i,*i.r1,t,i ${NSIS_MAX_STRLEN})i.r0`
	${If} $0 <> 0
		!insertmacro YESNO $1 ${FILE_SUPPORTS_REPARSE_POINTS} $2
	${EndIf}
	Pop $0
	Pop $1
	Exch $2
FunctionEnd
################################################################################
                                # UPDATED #                                     
################################################################################
!define CreateParentFolder `!insertmacro CreateParentFolder`
!macro CreateParentFolder _PATH
	Push $1
	${GetParent} `${_PATH}` $1
	CreateDirectory `$1`
	Pop $1
!macroend
################################################################################
## CHECKS
################################################################################
!define IsLink `!insertmacro IsLink`
!macro IsLink _PATH _RETURN
	${IsSoftLink} `${_PATH}` ${_RETURN}
	${If} ${_RETURN} = 0
		${IsHardLink} `${_PATH}` ${_RETURN}
	${EndIf}
!macroend
 
Function IsSoftLink
	!define IsSoftLink `!insertmacro IsSoftLink`
	!macro IsSoftLink _PATH _RETURN
		Push `${_PATH}`
		Call IsSoftLink
		Pop ${_RETURN} ; 1=yes, 0=no
	!macroend
	Exch $R0
	${GetFileAttributes} `$R0` `REPARSE_POINT` $R0
	${If} $R0 != 1
		StrCpy $R0 0
	${EndIf}
	Exch $R0
FunctionEnd
 
Function IsHardLink
	!define IsHardLink `!insertmacro IsHardLink`
	!macro IsHardLink _PATH _RETURN
		Push $0
		Push `${_PATH}`
		Call IsHardLink
		Exch $0
		Pop ${_RETURN}
	!macroend
	Exch $1
	System::Call `kernel32::CreateFileW(w "$1", i 0x40000000, i 0, i 0, i 3, i 0, i 0) i .r0`
	${If} $0 = -1
		StrCpy $0 0
		Goto End
	${EndIf}
	System::Call `*(&i256 0) i. r1`
	System::Call `kernel32::GetFileInformationByHandle(i r0, i r1) i .s`
	System::Call `kernel32::CloseHandle(i r0) i.r0`
	Pop $0
	${If} $0 = 0
		Goto End
	${EndIf}
	System::Call `*$1(&i40 0, &i4 .r0)`
	${If} $0 != 0
		IntOp $0 $0 - 1
	${EndIf}
	End:
	Pop $1
FunctionEnd
################################################################################
## CREATE : FILES
################################################################################
!define CreateSymbolicLinkFile `!insertmacro CreateSymbolicLinkFile`
!macro CreateSymbolicLinkFile _JUNCTION _TARGET _RETURN
	${CreateParentFolder} `${_JUNCTION}`
	System::Call `kernel32::CreateSymbolicLinkW(w "${_JUNCTION}", w "${_TARGET}", i 0) i .s`
	Pop ${_RETURN}
	StrCmp ${_RETURN} error 0 +2
	StrCpy ${_RETURN} 0
!macroend
 
!define CreateHardLink `!insertmacro CreateHardLink`
!macro CreateHardLink _JUNCTION _TARGET _RETURN
	${CreateParentFolder} `${_JUNCTION}`
	System::Call `kernel32::CreateHardLinkW(w "${_JUNCTION}", w "${_TARGET}", i 0) i .s`
	Pop ${_RETURN}
	StrCmp ${_RETURN} 0 0 +3
	StrCpy ${_RETURN} 1
	Goto +2
	StrCpy ${_RETURN} 0
!macroend
 
!define CreateLinkFile `!insertmacro CreateLinkFile`
!macro CreateLinkFile _JUNCTION _TARGET _RETURN
	${CreateSymbolicLinkFile} `${_JUNCTION}` `${_TARGET}` ${_RETURN}
	${If} ${_RETURN} = 0
		${CreateHardLink} `${_JUNCTION}` `${_TARGET}` ${_RETURN}
	${EndIf}
!macroend
 
!define DeleteLinkFile `!insertmacro DeleteLinkFile`
!macro DeleteLinkFile _PATH _RETURN
	${IsLink} `${_PATH}` ${_RETURN}
	${If} ${_RETURN} != 1
		SetFileAttributes `${_PATH}` NORMAL
		System::Call `kernel32::DeleteFileW(w "${_PATH}") i.s`
		Pop ${_RETURN}
	${EndIf}
!macroend
###############################################################################
## CREATE : FOLDER
###############################################################################
Function Create_JUNCTION
	!define Create_JUNCTION `!insertmacro Create_JUNCTION`
	!macro Create_JUNCTION _JUNCTION _TARGET _RETURN
		Push $0
		Push `${_JUNCTION}`
		Push `${_TARGET}`
		Call Create_JUNCTION
		Exch $0
		Pop ${_RETURN}
	!macroend
	Exch $4
	Exch
	Exch $5
	Push $1
	Push $2
	Push $3
	Push $6
	CreateDirectory `$5`
	System::Call `kernel32::CreateFileW(w "$5", i 0x40000000, i 0, i 0, i 3, i 0x02200000, i 0) i .r6`
	StrCmp $0 -1 0 +4
	StrCpy $0 0
	RMDir `$5`
	Goto END
	CreateDirectory `$4`
	StrCpy $4 `\??\$4`
	StrLen $0 $4
	IntOp $0 $0 * 2
	IntOp $1 $0 + 2
	IntOp $2 $1 + 10
	IntOp $3 $1 + 18
	System::Call `*(i 0xA0000003, &i4 $2, &i2 0, &i2 $0, &i2 $1, &i2 0, &w$1 "$4", &i2 0)i.r2`
	System::Call `kernel32::DeviceIoControl(i r6, i 0x900A4, i r2, i r3, i 0, i 0, *i r4r4, i 0) i.r0`
	System::Call `kernel32::CloseHandle(i r6) i.r1`
	StrCmp $0 0 0 +2
	RMDir `$5`
	END:
	Pop $6
	Pop $3
	Pop $2
	Pop $1
	Pop $5
	Pop $4
FunctionEnd
 
!define CreateSymbolicLinkFolder `!insertmacro CreateSymbolicLinkFolder`
!macro CreateSymbolicLinkFolder _JUNCTION _TARGET _RETURN
	System::Call `kernel32::CreateSymbolicLinkW(w "${_JUNCTION}", w "${_TARGET}", i 1) i .s`
	Pop ${_RETURN}
	StrCmp ${_RETURN} error 0 +2
	StrCpy ${_RETURN} 0
!macroend
 
!define CreateLinkFolder `!insertmacro CreateLinkFolder`
!macro CreateLinkFolder _JUNCTION _TARGET _RETURN
	${CreateSymbolicLinkFolder} `${_JUNCTION}` `${_TARGET}` ${_RETURN}
	${If} ${_RETURN} = 0
		${Create_JUNCTION} `${_JUNCTION}` `${_TARGET}` ${_RETURN}
	${EndIf}
!macroend
 
!define DeleteLinkFolder `!insertmacro DeleteLinkFolder`
!macro DeleteLinkFolder _PATH _RETURN
	SetFileAttributes `${_PATH}` NORMAL
	System::Call `kernel32::RemoveDirectoryW(w "${_PATH}") i.s`
	Pop ${_RETURN}
!macroend
 
Section "-_JUNCTIONRemoveWarnings"
	Return
	Call Create_JUNCTION
	Call IsHardLink
	Call IsSoftLink
SectionEnd