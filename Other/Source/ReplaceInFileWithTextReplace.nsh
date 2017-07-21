Function ReplaceInFile
	Exch $0
	Exch
	Exch $1
	Exch 2
	Exch $2
	Exch 3
	Exch $3
	Push $4
	Push $5
	StrCpy $4 `$2.OldReplaceInFile`
	${textreplace::ReplaceInFile} "$2" "$4" "$1" "$0" "$3 /C=0" $5
	IntCmp $5 0 StackCleanup ReturnError RenameToOriginal
	ReturnError:
		SetErrors
		Goto StackCleanup
	RenameToOriginal:
		Delete $2
		Rename $4 $2
	StackCleanup:
		Pop $5
		Pop $4
		Pop $3
		Pop $0
		Pop $1
		Pop $2
		${textreplace::Unload}
FunctionEnd
!macro ReplaceInFileCS SOURCE_FILE SEARCH_TEXT REPLACEMENT
	Push `/S=1`
	Push `${SOURCE_FILE}`
	Push `${SEARCH_TEXT}`
	Push `${REPLACEMENT}`
	Call ReplaceInFile
!macroend
!macro ReplaceInFile SOURCE_FILE SEARCH_TEXT REPLACEMENT
	Push `/S=0`
	Push `${SOURCE_FILE}`
	Push `${SEARCH_TEXT}`
	Push `${REPLACEMENT}`
	Call ReplaceInFile
!macroend
!define ReplaceInFileCS '!insertmacro "ReplaceInFileCS"'
!define ReplaceInFile '!insertmacro "ReplaceInFile"'
!macro ReplaceInFileU16CS SOURCE_FILE SEARCH_TEXT REPLACEMENT
	Push `/U=1 /S=1`
	Push `${SOURCE_FILE}`
	Push `${SEARCH_TEXT}`
	Push `${REPLACEMENT}`
	Call ReplaceInFile
!macroend
!macro ReplaceInFileU16 SOURCE_FILE SEARCH_TEXT REPLACEMENT
	Push `/U=1 /S=0`
	Push `${SOURCE_FILE}`
	Push `${SEARCH_TEXT}`
	Push `${REPLACEMENT}`
	Call ReplaceInFile
!macroend
!define ReplaceInFileU16CS '!insertmacro "ReplaceInFileU16CS"'
!define ReplaceInFileU16 '!insertmacro "ReplaceInFileU16"'
