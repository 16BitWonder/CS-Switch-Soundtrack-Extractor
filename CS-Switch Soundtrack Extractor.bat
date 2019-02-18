@echo off
::Options should be:
::(1) Extract Famitracks from Base-XCI
::(2) Extract Famitracks from Base-NSP (Requires titlekey!)
::(3) Extract Ridiculon from Update-NSP (Requires titlekey!)
:BEGIN
echo --------------------------------------------------------
echo ====== CS-Switch Soundtrack Extractor by Charstorm =====
echo ======   All of these options require keys.txt!    =====
echo --------------------------------------------------------
echo                    Make a selection
echo.
echo         1.  Extract Famitracks from Base-XCI
echo         2.  Extract Famitracks from Base-NSP (Requires base-game titlekey!)
echo         3.  Extract Ridiculon from Update-NSP (Requires update titlekey!)
echo.
echo         Q.  Quit
echo =========================================================
echo.
set input=
set /p input=Selection (1, 2, 3 or Q): 
echo.

if /i "%input%"=="1" GOTO FAM_XCI
if /i "%input%"=="2" GOTO FAM_NSP
if /i "%input%"=="3" GOTO RID_NSP
if /i "%input%"=="Q" GOTO END
if /i not "%input%"=="Q" (
	if /i not "%input%"=="1" (
		if /i not "%input%"=="2" (
			if /i not "%input%"=="3" (
				cls
				GOTO BEGIN
			)
		)
	)
) 

:FAM_XCI
::Check if there's an NSP in CS-Base\, throw error if there isn't
if not exist CS-Base\*.xci GOTO BASE_XCI_DNE

::Set up the path to the XCI
for /f "delims=" %%F in ('dir /b /s "CS-Base\*.xci" 2^>nul') do set baseXCIPath=%%F
for %%i IN ("%baseXCIPath%") DO set baseXCI=CS-Base\%%~ni.xci

::Warn that this only supports USA Cave Story+ XCI, and that if it doesn't work the dump may be corrupt
echo [WARNING] Due to the nature of how XCIs are structured they cannot be verified,
echo           this XCI extraction option is only compatible with the USA
echo           XCI of CS+.
echo           If this option does not work, then either your XCI is corrupt/bad, or you
echo           have incorrect/missing keys.
pause

::Extract the XCI
hactool.exe -x -k keys.txt -txci --securedir="Extracted_XCI" "%baseXCI%"

::Check if the correct nca exists, otherwise throw error saying it's not the right XCI or something
if not exist Extracted_XCI\97e31c6e7b60b1effcc89f6bc608e9b6.nca GOTO XCI_EXTRACT_FAILED

::Extract NCA contents to romfs
hactool.exe -x -k keys.txt -tnca Extracted_XCI\97e31c6e7b60b1effcc89f6bc608e9b6.nca --romfsdir="romfs"

::Check if the romfs exists, otherwise throw error saying it's not the right XCI or something
if not exist romfs GOTO XCI_EXTRACT_FAILED

::Move Famitracks out of romfs, and then delete Extracted_XCI\ and romfs\
move romfs\data\base\ogg17 ogg17
if exist romfs rmdir /s /q romfs
if exist Extracted_XCI rmdir /s /q Extracted_XCI
GOTO END

:FAM_NSP
::Check if there's an NSP in CS-Base\, throw error if there isn't
if not exist CS-Base\*.nsp GOTO BASE_NSP_DNE

::Set up the path to the NSP
for /f "delims=" %%F in ('dir /b /s "CS-Base\*.nsp" 2^>nul') do set baseNSPPath=%%F
for %%i IN ("%baseNSPPath%") DO set baseNSP=CS-Base\%%~ni.nsp

::If for some reason temp exists, get rid of it, and then fill new one with NSP path
if exist temp del temp
echo "%baseNSP%" > temp

::Send temp to python to identify the TID
python IdentifyFile.py
set /p baseTID=<temp

::Get rid of temp
del temp

::Check if the NSP is an update NSP, or an unknown NSP, throw an error if any of these are the case
if /i "%baseTID%"=="0100A55003B5C800" GOTO BASE_NSP_UPDATE
if /i "%baseTID%"=="0100B7D0022EE800" GOTO BASE_NSP_UPDATE
if /i "%baseTID%"=="Unknown" GOTO BASE_NSP_UNKNOWN

::Init baseTitleKey, and extract the NSP
set baseTitleKey=""
hactool.exe -x -k keys.txt -tpfs0 --pfs0dir="Extracted_NSP" "%baseNSP%"

::Prompt for appropriate key, and then extract
if /i "%baseTID%"=="0100A55003B5C000" set /p baseTitleKey=Enter the European CS+ base titlekey: 
if /i "%baseTID%"=="0100A55003B5C000" (
hactool.exe -x -k keys.txt --titlekey=%baseTitleKey% -tnca Extracted_NSP\53da387053fc647f677fc7432460bdd5.nca --romfsdir="romfs"
)
if /i "%baseTID%"=="0100B7D0022EE000" set /p baseTitleKey=Enter the United States CS base titlekey: 
if /i "%baseTID%"=="0100B7D0022EE000" (
hactool.exe -x -k keys.txt --titlekey=%baseTitleKey% -tnca Extracted_NSP\d54ae7d54d79a8111d838459c0f22e01.nca --romfsdir="romfs"
)

::Check if the game extracted into romfs, if it didn't then throw an error for incorrect titlekey
if not exist romfs (
rmdir /s /q Extracted_NSP
GOTO INVALID_TITLEKEY
)

::Move Famitracks out of romfs, and then delete Extracted_NSP\ and romfs\
move romfs\data\base\ogg17 ogg17
rmdir /s /q romfs
rmdir /s /q Extracted_NSP
GOTO END

:RID_NSP
::Check if there's an NSP in CS-Update\, throw error if there isn't
if not exist CS-Update\*.nsp GOTO UPDATE_NSP_DNE

::Set up the path to the NSP
for /f "delims=" %%F in ('dir /b /s "CS-Update\*.nsp" 2^>nul') do set updateNSPPath=%%F
for %%i IN ("%updateNSPPath%") DO set updateNSP=CS-Update\%%~ni.nsp

::If for some reason temp exists, get rid of it, and then fill new one with NSP path
if exist temp del temp
echo "%updateNSP%" > temp

::Send temp to python to identify the TID
python IdentifyFile.py
set /p updateTID=<temp

::Get rid of temp
del temp

::Check if the NSP is an update NSP, or an unknown NSP, throw an error if any of these are the case
if /i "%updateTID%"=="0100A55003B5C000" GOTO UPDATE_NSP_BASE
if /i "%updateTID%"=="0100B7D0022EE000" GOTO UPDATE_NSP_BASE
if /i "%updateTID%"=="Unknown" GOTO UPDATE_NSP_UNKNOWN

::Init baseTitleKey, and extract the NSP
set updateTitleKey=""
hactool.exe -x -k keys.txt -tpfs0 --pfs0dir="Extracted_NSP" "%updateNSP%"

::Prompt for appropriate key, and then extract
if /i "%updateTID%"=="0100A55003B5C800" set /p updateTitleKey=Enter the European CS+ update titlekey: 
if /i "%updateTID%"=="0100A55003B5C800" (
hactool.exe -x -k keys.txt --titlekey=%updateTitleKey% -tnca Extracted_NSP\868eb47e724368eaef9f409874295ac7.nca --basefake --romfsdir="romfs"
)
if /i "%updateTID%"=="0100B7D0022EE800" set /p updateTitleKey=Enter the United States CS update titlekey: 
if /i "%updateTID%"=="0100B7D0022EE800" (
hactool.exe -x -k keys.txt --titlekey=%updateTitleKey% -tnca Extracted_NSP\cfa563964177c66b8834956022905d83.nca --basefake --romfsdir="romfs"
)

::Check if the game extracted into romfs, if it didn't then throw an error for incorrect titlekey
if not exist romfs (
rmdir /s /q Extracted_NSP
GOTO INVALID_TITLEKEY
)

::Move Ridiculon out of romfs, and then delete Extracted_NSP\ and romfs\
move romfs\data\base\ogg_ridic ogg_ridic
rmdir /s /q romfs
rmdir /s /q Extracted_NSP
GOTO END


:BASE_NSP_DNE
echo ERROR: Your base game NSP is not in CS-Base\!
GOTO END

:UPDATE_NSP_DNE
echo ERROR: Your update NSP is not in CS-Update\!
GOTO END

:BASE_XCI_DNE
echo ERROR: Your base game XCI is not in CS-Base\!
GOTO END

:XCI_EXTRACT_FAILED
if exist romfs rmdir /s /q romfs
if exist Extracted_XCI rmdir /s /q Extracted_XCI
echo ERROR: Your XCI either failed to extract, you provided an unsupported XCI or your keys are incorrect!
GOTO END

:BASE_NSP_UNKNOWN
echo ERROR: Your base game NSP in CS-Base\ is not Cave Story+!
GOTO END

:UPDATE_NSP_UNKNOWN
echo ERROR: Your update NSP in CS-Update\ is not Cave Story+!
GOTO END

:INVALID_TITLEKEY
echo ERROR: You have entered an incorrect titlekey, make sure you are using the correct key for your update/game and region!
GOTO END

:BASE_NSP_UPDATE
if /i "%baseTID%"=="0100A55003B5C800" echo ERROR: You placed Cave Story+ (EUR) update NSP into CS-Base\!
if /i "%baseTID%"=="0100B7D0022EE800" echo ERROR: You placed Cave Story+ (USA) update NSP into CS-Base\!
GOTO END

:UPDATE_NSP_BASE
if /i "%baseTID%"=="0100A55003B5C000" echo ERROR: You placed Cave Story+ (EUR) base game NSP into CS-Update\!
if /i "%baseTID%"=="0100B7D0022EE000" echo ERROR: You placed Cave Story+ (USA) base game NSP into CS-Update\!
GOTO END

:END
pause