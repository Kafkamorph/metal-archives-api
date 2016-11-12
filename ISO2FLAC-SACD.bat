@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
SETLOCAL DISABLEDELAYEDEXPANSION
SET PATH=%PATH%;"C:\Program Files\Foobar2000\"
SET Stereo_or_Mch=-m
SET Stereo_or_Mch=
Rem ^^^ Please uncomment previous line ^^^, if you want to get _Stereo_ mix from .ISO
SET ThresholdHiHighest=12
IF EXIST *.iso CALL :Rename_To_Ascii *.iso
IF EXIST *.iso FOR /F "tokens=*" %%K IN ('dir /b *.iso') DO "Programs/sacd_extract.exe" -c %Stereo_or_Mch% -p -i"%%K"
Rem --- Cycle through subdirectories, created by sacd_extract.exe  ----
FOR /D %%D IN (*) DO IF NOT "%%D"=="Programs" IF NOT EXIST %%D\foo_dr.txt (
PUSHD %%D
CALL :Rename_To_Ascii *.dff
SETLOCAL ENABLEDELAYEDEXPANSION
CALL :foo_DR dff
SET HighestVal=9999
SET HighestTrNo=0
SET HighVal=9999
SET HighTrNo=0
FOR /F "tokens=2,3,4,5,6,7,8,9,10 delims=-. " %%I IN (foo_dr.txt) DO IF "%%K"=="dB" (
IF %%I%%J LEQ !HighestVal! (
SET HighTrNo=!HighestTrNo!
SET HighVal=!HighestVal!
IF "%%P"=="?" (SET HighestTrNo=%%Q
) ELSE SET HighestTrNo=%%P
SET HighestVal=%%I%%J
) ELSE IF %%I%%J LEQ !HighVal! (
IF "%%P"=="?" (SET HighTrNo=%%Q
) ELSE SET HighTrNo=%%P
SET HighVal=%%I%%J
)
)
SET /A HighestTrNo = 100!HighestTrNo! %% 100
SET /A HighTrNo    = 100!HighTrNo!    %% 100
ECHO -------------- Found among .dff: HighestTrNo="!HighestTrNo!", HighTrNo="!HighTrNo!", HighestPeak="!HighestVal!",HighPeak="!HighVal!". >> %~n0.Log 2>&1
IF NOT "!HighestVal!"=="000" (
SET /A DiffHiHighest = !HighVal! - !HighestVal!
SET TrNo=0
FOR %%K IN (*.dff) DO ( SET /A TrNo += 1
IF !TrNo! EQU !HighestTrNo! ( ECHO "%%~nK" to .wav0&&ECHO TrNo="!TrNo!" "%%~nK" to .wav0 >>%~n0.Log &&CALL :saraco 0.0
SETLOCAL DISABLEDELAYEDEXPANSION &&ECHO INPUT_0=%%K>> d2p.src&&ENDLOCAL &&CALL :saracon
)
IF !TrNo! EQU !HighTrNo! IF !DiffHiHighest! LEQ !ThresholdHiHighest! ( ECHO "%%~nK" to .wav0&&ECHO TrNo="!TrNo!" "%%~nK" to .wav0 >>%~n0.Log &&CALL :saraco 0.0
SETLOCAL DISABLEDELAYEDEXPANSION &&ECHO INPUT_0=%%K>> d2p.src&&ENDLOCAL &&CALL :saracon
)
)
CALL :foo_DR wav
IF EXIST *.foo_dr.txt REN *.foo_dr.txt highest.foo_dr.txt
SET GAIN=9999
IF !DiffHiHighest! LEQ !ThresholdHiHighest! (
FOR /F "tokens=2,3,4 delims=-. " %%I IN (foo_dr.txt) DO IF "%%K"=="dB" IF %%I%%J LSS !GAIN! SET GAIN=%%I%%J
) ELSE FOR %%A IN (highest.foo_dr.txt) DO FOR /F "usebackq tokens=1,3,4,5,6,7,9,10,12,13,15,16,18,19,21,22,24,25 delims=-. " %%H IN ("%%A") DO (
IF "%%H"=="Peak"                  IF %%I%%J LSS !GAIN! SET GAIN=%%I%%J
IF "%%H"=="Peak" IF NOT "%%L"=="" IF %%L%%M LSS !GAIN! SET GAIN=%%L%%M
IF "%%H"=="Peak" IF NOT "%%N"=="" IF %%N%%O LSS !GAIN! SET GAIN=%%N%%O
IF "%%H"=="Peak" IF NOT "%%P"=="" IF %%P%%Q LSS !GAIN! SET GAIN=%%P%%Q
IF "%%H"=="Peak" IF NOT "%%R"=="" IF %%R%%S LSS !GAIN! SET GAIN=%%R%%S
IF "%%H"=="Peak" IF NOT "%%T"=="" IF %%T%%U LSS !GAIN! SET GAIN=%%T%%U
IF "%%H"=="Peak" IF NOT "%%V"=="" IF %%V%%W LSS !GAIN! SET GAIN=%%V%%W
IF "%%H"=="Peak" IF NOT "%%X"=="" IF %%X%%Y LSS !GAIN! SET GAIN=%%X%%Y
)
IF "!GAIN!"=="9999" ECHO Wrong GAIN. && pause && exit
IF NOT "!GAIN!"=="000" (
IF !GAIN! GTR 601 SET GAIN=601
SET /A GAIN -= 1
SET GAIN=!GAIN:~0,-2!.!GAIN:~-2!
ECHO +!GAIN! > gain_from_1or2wavs.txt
REN *.wav *.1or2wavs
IF EXIST foo_dr_wav.txt REN foo_dr_wav.txt foo_dr_1or2wavs.txt
IF EXIST   *.foo_dr.txt REN *.foo_dr.txt *.1wav.txt
) ELSE SET /P GAIN="Clipping (0.00 dB) found in track !HighestTrNo!, please enter negative GAIN manually [like -1.23]:"
) ELSE SET /P GAIN="Clipping (0.00 dB) found in track !HighestTrNo!, please enter negative GAIN manually [like -1.23]:"
FOR %%K IN (*.dff) DO ( ECHO "%%~nK" to .wav1&&ECHO "%%~nK" to .wav1 Gain=!GAIN!>>%~n0.Log&&CALL :saraco !GAIN!
SETLOCAL DISABLEDELAYEDEXPANSION &&ECHO INPUT_0=%%K>> d2p.src&&ENDLOCAL &&CALL :saracon
)
CALL :foo_DR wav
SET GAIN=9999
FOR /F "tokens=2,3,4 delims=-. " %%I IN (foo_dr.txt) DO IF "%%K"=="dB" IF %%I%%J LSS !GAIN! SET GAIN=%%I%%J
IF "!GAIN!"=="9999" ECHO Wrong GAIN. && pause && exit
IF  !GAIN! EQU 0 (
REM  Clipping found, so let's start from the scratch to find the GAIN from the all wavs
ECHO Clipping found, so let's start from the scratch >>%~n0.Log
ECHO Clipping found, so let's start from the scratch
REN foo_dr_wav.txt foo_dr_clipping_from_1or2wavs.txt
DEL /Q *.wav
REN *.1or2wavs *.wav
FOR %%K IN (*.dff) DO IF NOT EXIST "%%~nK.wav" ( ECHO "%%~nK" to .wav2&&ECHO "%%~nK" to .wav2 >>%~n0.Log&&CALL :saraco 0.0
SETLOCAL DISABLEDELAYEDEXPANSION &&ECHO INPUT_0=%%K>> d2p.src&&ENDLOCAL &&CALL :saracon
)
CALL :foo_DR wav
SET GAIN=9999
FOR /F "tokens=2,3,4 delims=-. " %%I IN (foo_dr.txt) DO IF "%%K"=="dB" IF %%I%%J LSS !GAIN! SET GAIN=%%I%%J
IF "!GAIN!"=="9999" ECHO Wrong GAIN. && pause && exit
IF !GAIN! GTR 601 SET GAIN=601
SET /A GAIN -= 1
SET GAIN=!GAIN:~0,-2!.!GAIN:~-2!
ECHO +!GAIN! > gain_from_all_wavs.txt
REN foo_dr_wav.txt foo_dr_all0wavs.txt
DEL /Q *.wav
FOR %%K IN (*.dff) DO ( ECHO "%%~nK" to .wav3&&ECHO "%%~nK" to .wav3 Gain=!GAIN!>>%~n0.Log&&CALL :saraco !GAIN!
SETLOCAL DISABLEDELAYEDEXPANSION &&ECHO INPUT_0=%%K>> d2p.src&&ENDLOCAL &&CALL :saracon
)
CALL :foo_DR wav
) ELSE DEL /Q *.1or2wavs
REN foo_dr_wav.txt foo_dr_pre-flac_wavs.txt
SETLOCAL DISABLEDELAYEDEXPANSION
FOR /F "tokens=*" %%K IN ('dir /b *.wav') DO ECHO "%%~nK" to .flac&&"../Programs/flac.exe" -8 -V -s --skip=90 --until=-90 --delete-input-file "%%K" >> %~n0.Log 2>&1
ENDLOCAL
rem IF EXIST *.flac CALL :foo_DR flac ELSE CALL :foo_DR wav
ECHO -------------- subdirectory processing is completed. >> %~n0.Log
ENDLOCAL
POPD >> %~n0.Log 2>&1
)
Rem DEL /Q %~n0.Log
Rem ^^^ uncomment previous line ^^^, if you don't want .Log file
ECHO We did it.
GOTO :EOF

:foo_DR
:: Extention - %1
if NOT EXIST *.%1 echo Can not pass *.%1 to foobar: files do not exist.&&pause
IF EXIST foo_dr.txt DEL /Q foo_dr.txt >> %~n0.Log 2>&1
ECHO.
ECHO -------------- Startnig Dynamic Range Meter in foobar *.%1 >> %~n0.Log 2>&1
START foobar2000.exe /runcmd=Clear
PING 127.0.0.1 -n 5 > NUL
START foobar2000.exe /add *.%1 /immediate /show
PING 127.0.0.1 -n 5 > NUL
START foobar2000.exe /runcmd-playlist="Dynamic Range Meter"
:foo_dr_txt_not_exist
PING 127.0.0.1 -n 10 > NUL
ECHO Waiting for Dyn.Range.. If not running, please start it manually or press Ctrl+C to break
IF NOT EXIST *foo_dr.txt GOTO foo_dr_txt_not_exist
START foobar2000.exe /exit
IF EXIST foo_dr.txt COPY foo_dr.txt foo_dr_%1.txt >> %~n0.Log 2>&1
GOTO :EOF

:saraco
:: Gain - %1
ECHO Dim fso, f                                                     > WriteExpGAIN.vbs
ECHO Set fso = CreateObject("Scripting.FileSystemObject")          >> WriteExpGAIN.vbs
ECHO Set f = fso.OpenTextFile("d2p.src", 8, false)                 >> WriteExpGAIN.vbs
ECHO f.WriteLine Replace("GAIN=" ^& Exp( Log(10) * %1/20),",",".") >> WriteExpGAIN.vbs
ECHO f.Close                                                       >> WriteExpGAIN.vbs
ECHO Manufacturer=Weiss Engineering> d2p.src
ECHO Product=Saracon>> d2p.src
ECHO Module=D2P>> d2p.src
(ECHO Version=1.0)>> d2p.src
(ECHO BATCH=1)>> d2p.src
(ECHO DESTINATION=.)>> d2p.src
CALL   WriteExpGAIN.vbs >> %~n0.Log 2>&1
DEL /Q WriteExpGAIN.vbs
ECHO POSTFIX=>> d2p.src
(ECHO POSTFIXENA=0)>> d2p.src
(ECHO INPUT_COUNT=1)>> d2p.src
GOTO :EOF

:saracon
(ECHO QUANTIZER=0)>> d2p.src
(ECHO FORMAT=1245187)>> d2p.src
(ECHO SAMPLERATE=192000)>> d2p.src
(ECHO VORBIS_QUALITY=0.5)>> d2p.src
saracon.exe -p -T d2p.src -V all >> %~n0.Log 2>&1
ECHO.                                               >> %~n0.Log 2>&1
ECHO -------------- Saracon ErrorLevel:%ErrorLevel% >> %~n0.Log 2>&1
ECHO.                                               >> %~n0.Log 2>&1
if NOT ErrorLevel 0 (echo Saracon error! Check files d2p.src, and .Log &&pause
) ELSE DEL /Q d2p.src
GOTO :EOF

:Rename_To_Ascii
:: must be invoked with SETLOCAL DISABLEDELAYEDEXPANSION
ECHO Dim fso, I, O                                         >Replace_q.vbs
ECHO Set fso = CreateObject("Scripting.FileSystemObject") >>Replace_q.vbs
ECHO Set I = fso.OpenTextFile("_Inp_Track.Nam", 1)        >>Replace_q.vbs
ECHO Set O = fso.OpenTextFile("_Out_Track.Nam", 2, true)  >>Replace_q.vbs
ECHO O.WriteLine  Replace( I.ReadLine, "?", "_" )         >>Replace_q.vbs
ECHO I.Close : O.Close                                    >>Replace_q.vbs
FOR %%F IN (%1) DO (
ECHO %%F>_Inp_Track.Nam
CALL Replace_q.vbs
FOR /F "delims=" %%N IN (_Out_Track.Nam) DO REN "%%F" "%%N"
)
DEL /Q Replace_q.vbs & DEL /Q _???_Track.Nam
GOTO :EOF
