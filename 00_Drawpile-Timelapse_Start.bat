@echo off
Title Start Drawpile-Timelapse Script
set Version=1.1

REM --------------------------------------------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------------------------------------------
SETLOCAL EnableDelayedExpansion
REM
REM Variable expansion means replacing a variable (e.g. %windir%) with its value C:\WINDOWS
REM 	* By default expansion will happen just once, before each line is executed.
REM 	* The !delayed! expansion is performed each time the line is executed, or for each loop in a FOR looping command.
REM For simple commands this will make no noticable difference, but with loop commands like FOR, compound or bracketed 
REM      expressions delayed expansion will allow you to always see the current value of the variable.
REM When delayed expansion is in effect, variables can be immediately read using !variable_name! you can still read and 
REM      use %variable_name% but that will continue to show the initial value (expanded at the beginning of the line).
REM The SET command was first introduced with MS-DOS 2.0 in March 1983, at that time memory and CPU were very limited 
REM      and the expansion of variables once per line was enough.
REM Delayed Expansion was introduced some 16 years later in 1999 by which time millions of batch files had been written 
REM      using the earlier syntax. Retaining immediate expansion as the default preserved backwards compatibility with 
REM      existing batch files.
REM 
REM Source:		https://ss64.com/nt/delayedexpansion.html
REM --------------------------------------------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------------------------------------------

goto comment_drawpile_timelapse_help
drawpile-timelapse.exe -h
ARGS:
    <input>...
      Input recording file(s).

OPTIONS:
    -v, --version
      Displays version information and exits.

    -f, --format <output_format>
      Output format. Use 'mp4' or 'webm' for sensible presets in those two
      formats that should work in most places. Use `custom` to manually
      specify the output format using -c/--custom-argument. Use `raw` to
      not run ffmpeg at all and instead just dump the raw frames. Defaults
      to 'mp4'.

    -o, --out <output_path>
      Output file path, '-' for stdout. Required.

    -d, --dimensions <dimensions>
      Video dimensions, required. In the form WIDTHxHEIGHT. All frames
      will be resized to fit into these dimensions.

    -r, --framerate <framerate>
      Video frame rate. Defaults to 24. Higher values may not work on all
      platforms and may not play back properly or be allowed to upload!

    -i, --interval <interval>
      Interval between each frame, in milliseconds. Defaults to 10000,
      higher values mean the timelapse will be faster.

    -l, --logo-location <logo_location>
      Where to put the logo. One of 'bottom-left' (the default),
      'top-left', 'top-right', 'bottom-right' will put the logo in that
      corner. Use 'none' to remove the logo altogether.

    -L, --logo-path <logo_path>
      Path to the logo. Default is to use the Drawpile logo.

    -O, --logo-opacity <logo_opacity>
      Opacity of the logo, in percent. Default is 40.

    -D, --logo-distance <logo_distance>
      Distance of the logo from the corner, in the format WIDTHxHEIGHT.
      Default is 20x20.

    -S, --logo-scale <logo_scale>
      Relative scale of the logo, in percent. Default is 100.

    -F, --flash <flash>
      The color of the flash when the timelapse is finished, in argb
      hexadecimal format. Default is 'ffffffff' for a solid white flash.
      Use 'none' for no flash.

    -t, --linger-time <linger_time>
      How many seconds to linger on the final result. Default is 5.0.

    -C, --ffmpeg-location <ffmpeg_location>
      Path to ffmpeg executable. If not given, it just looks in PATH.

    -c, --custom-argument <custom_arguments>
      Custom ffmpeg arguments. Repeat this for every argument you want to
      append, like `-c -pix_fmt -c yuv420`.

    -p, --print-only
      Only print out what's about to be done and which arguments would be
      passed to ffmpeg, then exit. Useful for inspecting parameters before
      waiting through everything being rendered out.

    -A, --acl
      Performs ACL filtering. This will filter out any commands that the
      user wasn't allowed to actually perform, such as drawing on a layer
      that they didn't have permission to draw on. The Drawpile client
      would also filter these out when playing back a recording.

    -U, --uncensor
      Show censored layers instead of rendering them as censor squares.

    -x, --crop <crop>
      Area(s) to crop. Must provide a string of the form
      \"X:Y:WIDTH:HEIGHT\", followed by a comma-separated list of additional
      croppings depending on resolution of the form
      \"CANVAS_WIDTH:CANVAS_HEIGHT=X:Y:WIDTH:HEIGHT\".

    -I, --interpolation <interpolation>
      Interpolation to use when scaling images. One of 'fastbilinear' (the
      default), 'bilinear', 'bicubic', 'experimental', 'nearest', 'area',
      'bicublin', 'gauss', 'sinc', 'lanczos' or 'spline'.

    -h, --help
      Prints help information.
	  
drawpile-timelapse --acl --logo-location none --dimensions 1920x1880 --framerate 30 --interval 100 --linger-time 10 --crop 8608:9556:2944:2884 --out "D:\Users\%username%\Downloads\timelapse.mp4" "D:\Users\%username%\Downloads\2025-04-09 - Timelapse TRY TO LETS DE CREATIVEY FLOW - ope to learn and study.dprec"

:comment_drawpile_timelapse_help

REM ---------------------------------------------------------------------------------------------------------
REM ---------------------------------------------------------------------------------------------------------

set SCRIPTLOCATION=%~dp0
set Powershell_Script_Name=Drawpile-Timelapse.ps1
echo CMD Batch Script Version : !Version!
echo.
IF EXIST "!SCRIPTLOCATION!!Powershell_Script_Name!" (
	set drawpile_timelapse_ps1="!drawpile_timelapse!!Powershell_Script_Name!"
	echo Located Drawpile Timelapse Powershell Script!
	echo Script Location: !SCRIPTLOCATION!
	echo.
	echo --------------------------------------------------------------------------------------------------------------------------
	echo.
	echo Powershell Version
	powershell -Command "$PSVersionTable.PSVersion"
	
	FOR /F "tokens=*" %%G IN ('powershell -command "Invoke-Command -ScriptBlock { ( Powershell Get-ExecutionPolicy ).Trim() }"') DO (set "Get-Execution-Policy-Status=%%G")
	echo Powershell Execution Status: !Get-Execution-Policy-Status!
	echo.
	REM -------------------------------------------------------
	REM	Powershell commands for making changes
	REM
	REM	Get-ExecutionPolicy -List
	REM
	REM	Set-ExecutionPolicy Restricted
	REM	Set-ExecutionPolicy Restricted -Scope CurrentUser -Force
	REM	Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
	REM -------------------------------------------------------
) ELSE (
	echo Unable to locate !Powershell_Script_Name! Powershell Script.
	echo Script needs to be in the same directory as this one in order to run.
	echo.
	echo Exiting script in 30 seconds.
	echo.
	sleep 30
	exit /b
)
echo.
echo Starting Script with the following command:
echo  powershell.exe -noprofile -executionpolicy bypass -file "!SCRIPTLOCATION!!Powershell_Script_Name!"
echo.
echo --------------------------------------------------------------------------------------------------------------------------
echo --------------------------------------------------------------------------------------------------------------------------
echo --------------------------------------------------------------------------------------------------------------------------

powershell.exe -noprofile -executionpolicy bypass -file "!SCRIPTLOCATION!!Powershell_Script_Name!"
echo.
echo --------------------------------------------------------------------------------------------------------------------------
echo --------------------------------------------------------------------------------------------------------------------------
echo --------------------------------------------------------------------------------------------------------------------------
echo.
echo Operations completed. Script will now exit.
echo.
pause