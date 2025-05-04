$host.ui.RawUI.WindowTitle = "Make Drawpile-Timelapse from DPREC Recording"
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
# if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
$Script_Version=1.0

$MyPowershellVersionVariable = $PSVersionTable.PSVersion.ToString()
Write-Host ""
Write-Host "Powershell Version:                     $MyPowershellVersionVariable "
Write-Host "Drawpile-Timelapse.ps1 Script Version:  1.2"

function PauseScript {
    Read-Host -Prompt "Press any key to continue..."
	
    # Old Info below
    # Write-Host "Press any key to exit script..."
	#$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
	# Press Any Key to Continue Readme
	# https://devtipscurator.wordpress.com/2017/02/01/quick-tip-how-to-wait-for-user-keypress-in-powershell/
}

Write-Host ""

# -C, --ffmpeg-location <ffmpeg_location>
#      Path to ffmpeg executable. If not given, it just looks in PATH.
$exeName = "ffmpeg.exe"
if (Test-Path -Path "C:\Windows\System32\$exeName") {
    $FFMPEG_Executable="C:\Windows\System32\$exeName"
    Write-Host "Location: $FFMPEG_Executable"
} elseif (Get-Command $exeName -ErrorAction SilentlyContinue) {
    Write-Host "$exeName exists in PATH."
    $FFMPEG_Executable=(get-command $exeName).Path
    Write-Host "Location: $FFMPEG_Executable"
} else {
    Write-Host "$exeName does not exist in PATH."
    If (Test-Path -Path "$PSScriptRoot\$exeName") {
        $FFMPEG_Executable="$PSScriptRoot\$exeName"
        Write-Host "Location: $PSScriptRoot\$exeName"
    } Else {
        Write-Host "Cannot locate ffmpeg.exe in Path environment variable or script directory."
        Write-Host "Script will not function as intended."
        Write-Host ""
        Write-Host ""
        Write-Host "Windows EXE Files Should be the download needed:"
        Write-Host "https://ffmpeg.org/download.html"
        Write-Host ""
        Write-Host "Recommended: If you select Windows Builds from gyan.dev - https://www.gyan.dev/ffmpeg/builds/"
        Write-Host " Downloaded 'ffmpeg-git-full.7z' under the section 'latest git master branch build'"
        Write-Host ""
        Write-Host "If you select 'Windows builds by BtbN' - https://github.com/BtbN/FFmpeg-Builds/releases"
        Write-Host ""
        Write-Host "Includes all dependencies, even those that require full GPL instead of just LGPL."
        Write-Host "Please let me know what option works for you. "     
        Write-Host "ffmpeg-master-latest-win64-gpl-shared.zip  -> Includes all dependencies, even those that require full GPL instead of just LGPL."
        Write-Host "ffmpeg-master-latest-win64-gpl.zip         -> Lacking libraries that are GPL-only. Most prominently libx264 and libx265."
        Write-Host "ffmpeg-master-latest-win64-lgpl-shared.zip -> Same as gpl, but comes with the libav* family of shared libs instead of pure static executables."
        Write-Host "ffmpeg-master-latest-win64-lgpl.zip        -> Same again, but with the lgpl set of dependencies."
        Write-Host ""
        Write-Host ""
        Write-Host "Extract the contents, and then the exe file should be in the bin folder."
        Write-Host "You can put the ffmpeg.exe file in the same folder as this script or"
        Write-Host "somewhere else if you set the Path environment variable."
        Write-Host ""
        Write-Host "This is an example of all files that should be side by side, inspired by a certain someone"
        Write-Host "who may have just slapped folders in there and asked 'why no worky'?"
        Write-Host "00_Drawpile-Timelapse_Start.bat"
        Write-Host "drawpile-timelapse.exe"
        Write-Host "Drawpile-Timelapse.ps1"
        Write-Host "ffmpeg.exe"
        Write-Host "ffplay.exe"
        Write-Host "ffprobe.exe"
        Write-Host ""
        Write-Host "If you want to add a path for it in Windows, try this tutorial:"
        Write-Host "  https://www.howtogeek.com/118594/how-to-edit-your-system-path-for-easy-command-line-access/"
        Write-Host ""
        Write-Host "Just do it for ffmpeg instead, start with 'How to Add a Folder to Your PATH'"
        Write-Host ""
        Write-Host ""
        Write-Host "Script will exit in 60 seconds."
        Write-Host ""
        Start-Sleep -Seconds 60
        exit
    }   
}
$errOutput = $( $output = & $FFMPEG_Executable 2>&1 ) 2>&1
$string = "$output"
$char = "configuration:"
$newString = $string.Substring(0, $string.IndexOf($char))
Write-Host "$newString"

Write-Host ""

if (Test-Path -Path "D:\Program Files\Drawpile" -PathType Container) {
    $drawpile_install_folder="D:\Program Files\Drawpile"
    Write-Host "Located Drawpile Installation: $drawpile_install_folder"
} elseif (Test-Path -Path "D:\Program Files (x86)\Drawpile" -PathType Container) {
    $drawpile_install_folder="D:\Program Files (x86)\Drawpile"
    Write-Host "Located Drawpile Installation: $drawpile_install_folder"
} elseif (Test-Path -Path "D:\App Directory\Drawpile" -PathType Container) {
    $drawpile_install_folder="D:\App Directory\Drawpile"
    Write-Host "Located Drawpile Installation: $drawpile_install_folder"
} elseif (Test-Path -Path "C:\Program Files\Drawpile" -PathType Container) {
    $drawpile_install_folder="C:\Program Files\Drawpile"
    Write-Host "Located Drawpile Installation: $drawpile_install_folder"
} elseif (Test-Path -Path "C:\Program Files (x86)\Drawpile" -PathType Container) {
    $drawpile_install_folder="C:\Program Files (x86)\Drawpile"
    Write-Host "Located Drawpile Installation: $drawpile_install_folder"
} else {
    Write-Host "Drawpile install directory does not exist."
}

Write-Host ""

if (Test-Path -Path "$drawpile_install_folder\drawpile-timelapse.exe") {
	$drawpile_timelapse_folder="$drawpile_install_folder"
    $drawpile_timelapse_exe="$drawpile_install_folder\drawpile-timelapse.exe"
    Write-Host "Located drawing timelapse tool..."
    # Write-Host "Test 1"
    # Start-Process -FilePath "$drawpile_timelapse_exe" -ArgumentList "--version --out C:\ --dimensions 1x1"
    # Write-Host "Test 2"
    # "$drawpile_install_folder\.\drawpile-timelapse.exe --version --out C:\ --dimensions 1x1"
    # Write-Host "Test 3"
    $Command="$drawpile_timelapse_folder\.\drawpile-timelapse.exe"
    $Parameters="--version --out C:\ --dimensions 1x1"
    $Parameters = $Parameters.Split(" ")
    & "$Command" $Parameters
} Elseif (Test-Path -Path "$PSScriptRoot\drawpile-timelapse.exe")  {
	$drawpile_timelapse_folder="$PSScriptRoot\"
    $drawpile_timelapse_exe="$drawpile_timelapse_folder\drawpile-timelapse.exe"
    $Command="$PSScriptRoot\.\drawpile-timelapse.exe"
    $Parameters="--version --out C:\ --dimensions 1x1"
    $Parameters = $Parameters.Split(" ")
    & "$Command" $Parameters
} else {
    Write-Host "Drawpile Timelapse exe does not exist."
    Write-Host ""
    Write-Host "Please put Drawpile-Timelapse.exe in one of the following locations:"
	Write-Host " $drawpile_install_folder"
    Write-Host " $drawpile_timelapse_folder"
    Write-Host " $PSScriptRoot\drawpile-timelapse.exe"
    Write-Host ""
    Write-Host "Script will exit in 30 seconds."
    Write-Host ""
    Start-Sleep -Seconds 30
    exit
}

Function Get-DPREC-FileName($initialDirectory)
{  
    [System.Reflection.Assembly]::LoadWithPartialName(“System.windows.forms”) | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = “Binary Recordings (*.dprec)| *.dprec”
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
} #end function Get-DPREC-FileName

Function Get-PNG-FileName($initialDirectory)
{  
    [System.Reflection.Assembly]::LoadWithPartialName(“System.windows.forms”) | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = “PNG (*.png)| *.png”
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
} #end function Get-PNG-FileName

Function Set-Output-FileName($initialDirectory)
{  
    [System.Reflection.Assembly]::LoadWithPartialName(“System.windows.forms”) | Out-Null
    
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $SaveFileDialog.initialDirectory = $initialDirectory
    # $SaveFileDialog.filter = “MP4 Video (*.mp4)| *.mp4”
    $SaveFileDialog.filter = “All files (*.*)| *.*”
    $SaveFileDialog.ShowDialog() | Out-Null
    $SaveFileDialog.filename
} #end function Get-DPREC-FileName

Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
Write-Host "Please select a completed DPREC recording made in Drawpile."
Write-Host "To make one, before drawing, select 'File', 'Record'."
Write-Host "Finish your drawing, then 'File', 'Stop Recording'."
Write-Host ""
$DPREC_FileName_Selected=Get-DPREC-FileName -initialDirectory “c:fso”

if ($DPREC_FileName_Selected -eq $null -or $DPREC_FileName_Selected -eq "") {
    while ($DPREC_FileName_Selected -eq $null -or $DPREC_FileName_Selected -eq "") {
        Write-Host "Null or empty value provided, script cannot continue."
        Write-Host "Please select a valid DPREC file."
        Write-Host ""
        $DPREC_FileName_Selected=Get-DPREC-FileName -initialDirectory “c:fso”
        Start-Sleep -Seconds 1 # Pause for 1 second to avoid excessive looping
    }
    Write-Host "DPREC Recording File Selected: $DPREC_FileName_Selected"
} else {
    Write-Host "DPREC Recording File Selected: $DPREC_FileName_Selected"
}
Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
Write-Host "Choose a location and write the filename to output a video."
Write-Host ""
$Video_FileName_Selected=Set-Output-FileName -initialDirectory “c:fso”

if ($Video_FileName_Selected -eq $null -or $Video_FileName_Selected -eq "") {
    while ($Video_FileName_Selected -eq $null -or $Video_FileName_Selected -eq "") {
        Write-Host "Null or empty value provided, script cannot continue."
        Write-Host "Please select a filename to save your time lapse file(s)."
        Write-Host ""
        $Video_FileName_Selected=Set-Output-FileName -initialDirectory “c:fso”
        Start-Sleep -Seconds 1 # Pause for 1 second to avoid excessive looping
    }
    Write-Host "Video File Name Set to: $Video_FileName_Selected"
} else {
    Write-Host "Video File Name Set to: $Video_FileName_Selected"
}

Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
#
# -f, --format <output_format>
#      Output format. Use 'mp4' or 'webm' for sensible presets in those two
#      formats that should work in most places. Use `custom` to manually
#      specify the output format using -c/--custom-argument. Use `raw` to
#      not run ffmpeg at all and instead just dump the raw frames. Defaults
#      to 'mp4'.
#
Write-Host "--------------------"
Write-Host " Acceptable Formats"
Write-Host "--------------------"
Write-Host " * mp4 (default video format)"
Write-Host " * webm (video format)"
Write-Host " * raw (dump images/raw frames series)"
Write-Host ""
Write-Host " Note: There are custom formats and arguments one could set here, but this"
Write-Host "       script will not support that function."
Write-Host ""
Write-Host "Enter one of the above values (e.g. mp4)."
Write-Host ""
$Drawpile_Format_Output= Read-Host -Prompt 'What format for output would you like to use? Blank defaults to mp4.'

If (($Drawpile_Format_Output -eq "mp4") -or ([string]::IsNullOrEmpty($Drawpile_Format_Output))) {
    if ([string]::IsNullOrEmpty($Drawpile_Format_Output)) {
        Write-Host ""
        Write-Host "Left blank, selecting mp4."
    }
    $Drawpile_Format_Output_Variable="--format mp4"
	$Drawpile_Format_Output_Extension_Variable="mp4"
} Elseif ($Drawpile_Format_Output -eq "webm") {
    $Drawpile_Format_Output_Variable="--format webm"
	$Drawpile_Format_Output_Extension_Variable="webm"
} Elseif ($Drawpile_Format_Output -eq "raw") {
    $Drawpile_Format_Output_Variable="--format raw"
	$Drawpile_Format_Output_Extension_Variable=""
} Else {
    Write-Host "Invalid option selected. Will use mp4 type."
    $Drawpile_Format_Output_Variable="--format mp4"
	$Drawpile_Format_Output_Extension_Variable="mp4"
}

Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
function No_Crop_Resolution_Input_Function {
	Write-Host ""
	Write-Host "-------------------------------------------------------------------------"
	Write-Host "-------------------------------------------------------------------------"
	Write-Host ""
	Write-Host "Alright, skipping crop. To automatically provide a suggested video"
	Write-Host "resize for the canvas, can you provide the full dimensions of the"
	Write-Host "canvas instead? (RECOMMENDED)"
	Write-Host ""
	Write-Host "Note: You will need to open the DPREC file and grab the canvas" -ForegroundColor Black -BackgroundColor Yellow
	Write-Host "      by going to Edit, Resize Canvas after playing the DPREC" -ForegroundColor Black -BackgroundColor Yellow
	Write-Host "      to the end of the recording (since canvas size may change" -ForegroundColor Black -BackgroundColor Yellow
	Write-Host "      during playback)." -ForegroundColor Black -BackgroundColor Yellow
	Write-Host ""
	Write-Host "Valid Answers: y, Y, yes, YES, n, N, no, NO"
	$script:Drawpile_No_Crop_Size_Query= Read-Host -Prompt 'Can you provide the canvas dimensions? Blank entry will skip this step.'

	If (($script:Drawpile_No_Crop_Size_Query -eq "Y") -or ($script:Drawpile_No_Crop_Size_Query -eq "yes")) {
		[int]$script:number_1 = 0
		[int]$script:number_2 = 0
		
		Write-Host ""
		Write-Host "-------------------------------------------------------------------------"
		Write-Host ""
		$script:number_3 = -1
		Write-Host "Edit, Resize canvas. Drawpile displays coordinates in this menu with "
		Write-Host "the format [ X ] x [ Y ]. Provide value X."
		while ($script:number_3 -lt 1 -or $script:number_3 -gt 50000) {
			[int]$script:number_3 = Read-Host "Enter a number."
			[int]$script:number_3_offset=$number_3
			If ($script:number_3 -match "\D") {
				Write-Host "Invalid input. Please enter a number."
				$script:number_3 = -1
			} elseif ($script:number_3 -lt 1 -or $script:number_3 -gt 50000) {
				Write-Host "Number is out of range. Please enter a number between 1 and 50000."
				Write-Host ""
			} elseif ($script:number_3_offset -le 0) {
				Write-Host "The number is zero or negative. Please try again."
				$script:number_3 = -1
			} else {
				# Correct value entered.
			}
		}
		Write-Host ""
		Write-Host "-------------------------------------------------------------------------"
		Write-Host ""
		$script:number_4 = -1
		Write-Host "Edit, Resize canvas. Drawpile displays coordinates in this menu with "
		Write-Host "the format [ X ] x [ Y ]. Provide value Y."
		while ($script:number_4 -lt 1 -or $script:number_4 -gt 50000) {
			[int]$script:number_4 = Read-Host "Enter a number."
			[int]$script:number_4_offset = $script:number_4
			If ($script:number_4 -match "\D") {
				Write-Host "Invalid input. Please enter a number."
				$script:number_4 = -1
			} elseif ($script:number_4 -lt 1 -or $script:number_4 -gt 50000) {
				Write-Host "Number is out of range. Please enter a number between 1 and 50000."
				Write-Host ""
			} elseif ($script:number_4_offset -le 0) {
				Write-Host "The number is zero or negative. Please try again."
				$script:number_4 = -1
			} else {
				# Correct value entered.
			}
		}
	} ElseIf (($Drawpile_No_Crop_Size_Query -eq "n") -or ($Drawpile_No_Crop_Size_Query -eq "no") -or ([string]::IsNullOrEmpty($Drawpile_No_Crop_Size_Query))) {
		write-host ""
		write-host "Skipping canvas size entry for automated video size suggestion..."
	} Else {
		write-host ""
		write-host "Invalid Value selected. Skipping canvas size entry for automated video size suggestion..."
	}
}

#
#     -x, --crop <crop>
#      Area(s) to crop. Must provide a string of the form
#      \"X:Y:WIDTH:HEIGHT\", followed by a comma-separated list of additional
#      croppings depending on resolution of the form
#      \"CANVAS_WIDTH:CANVAS_HEIGHT=X:Y:WIDTH:HEIGHT\".
#
Write-Host "This step is to set a crop area. Output video should not be greater than"
Write-Host " 1920 in either direction, so some image compression may be necessary in "
Write-Host " order to play on more devices. Bear this in mind when setting a crop area"
Write-Host " for very large timelapse images."
# Write-Host ""
# Write-Host "Note: Script cannot provide a video size suggestion if you choose to skip this step." -ForegroundColor Black -BackgroundColor Yellow
Write-Host ""
Write-Host "Valid Answers: y, Y, yes, YES, n, N, no, NO"
$Drawpile_Crop_Output_Query= Read-Host -Prompt 'Would you like to crop the canvas? Blank entry will skip this step.'

If (($Drawpile_Crop_Output_Query -eq "Y") -or ($Drawpile_Crop_Output_Query -eq "yes")) {
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------"
    Write-Host ""
    $number_1 = -1
    Write-Host "Drawpile displays coordinates in the lower left corner with the format (X, Y)"
    Write-Host "For the top left corner of the desired crop area, provide value X."
    while ($number_1 -lt 1 -or $number_1 -gt 50000) {
        $number_1 = Read-Host "Enter a number."
        $number_1 = [int]$number_1
        If ($number_1 -match "\D") {
            Write-Host "Invalid input. Please enter a number."
            $number_1 = -1
        } elseif ($number_1 -lt 1 -or $number_1 -gt 50000) {
            Write-Host "Number is out of range. Please enter a number between 1 and 50000."
            Write-Host ""
        } else {
            # Correct value entered.
        }
    }
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------"
    Write-Host ""
    $number_2 = -1
    Write-Host "Drawpile displays coordinates in the lower left corner with the format (X, Y)"
    Write-Host "For the top left corner of the desired crop area, provide value Y."
    while ($number_2 -lt 1 -or $number_2 -gt 50000) {
        $number_2 = Read-Host "Enter a number."
        $number_2 = [int]$number_2
        If ($number_2 -match "\D") {
            Write-Host "Invalid input. Please enter a number."
            $number_2 = -1
        } elseif ($number_2 -lt 1 -or $number_2 -gt 50000) {
            Write-Host "Number is out of range. Please enter a number between 1 and 50000."
            Write-Host ""
        } else {
            # Correct value entered.
        }
    }
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------"
    Write-Host ""
    $number_3 = -1
    Write-Host "Drawpile displays coordinates in the lower left corner with the format (X, Y)"
    Write-Host "For the bottom right corner of the desired crop area, provide value X."
    while ($number_3 -lt 1 -or $number_3 -gt 50000) {
        $number_3 = Read-Host "Enter a number."
        $number_3 = [int]$number_3
        $number_3_offset=$number_3 - $number_1
        $number_3_offset = [int]$number_3_offset
        If ($number_3 -match "\D") {
            Write-Host "Invalid input. Please enter a number."
            $number_3 = -1
        } elseif ($number_3 -lt 1 -or $number_3 -gt 50000) {
            Write-Host "Number is out of range. Please enter a number between 1 and 50000."
            Write-Host ""
        } elseif ($number_3_offset -le 0) {
            Write-Host "The number is zero or negative. Please try again."
            $number_3 = -1
        } else {
            # Correct value entered.
        }
    }
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------"
    Write-Host ""
    $number_4 = -1
    Write-Host "Drawpile displays coordinates in the lower left corner with the format (X, Y)"
    Write-Host "For the bottom right corner of the desired crop area, provide value Y."
    while ($number_4 -lt 1 -or $number_4 -gt 50000) {
        $number_4 = Read-Host "Enter a number."
        $number_4 = [int]$number_4
        $number_4_offset=$number_4 - $number_2
        $number_4_offset = [int]$number_4_offset
        If ($number_4 -match "\D") {
            Write-Host "Invalid input. Please enter a number."
            $number_4 = -1
        } elseif ($number_4 -lt 1 -or $number_4 -gt 50000) {
            Write-Host "Number is out of range. Please enter a number between 1 and 50000."
            Write-Host ""
        } elseif ($number_4_offset -le 0) {
            Write-Host "The number is zero or negative. Please try again."
            $number_4 = -1
        } else {
            # Correct value entered.
        }
    }
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------"
    Write-Host ""

    $number="$($number_1):$($number_2):$($number_3_offset):$($number_4_offset)"
    Write-Host "The top left crop area you entered is            : $($number_1):$($number_2)"
    Write-Host "The bottom right crop area you entered is        : $($number_3):$($number_4)"
    Write-Host "The offset values for bottom right crop area are : $($number_3_offset):$($number_4_offset)"
    Write-Host ""
    Write-Host "The script usable output for crop is             : $number"

    $Drawpile_Crop_Output_variable="--crop $number"
} ElseIf (($Drawpile_Crop_Output_Query -eq "n") -or ($Drawpile_Crop_Output_Query -eq "no") -or ([string]::IsNullOrEmpty($Drawpile_Crop_Output_Query))) {
	write-host ""
    write-host "Skipping cropping of canvas ..."
	No_Crop_Resolution_Input_Function
} Else {
	write-host ""
    write-host "Invalid Value selected. Skipping cropping of canvas ..."
	No_Crop_Resolution_Input_Function
}

Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""

[int]$Suggested_Video_Maximum_Size=1920
If (($Drawpile_Crop_Output_Query -ieq "Y") -or ($Drawpile_Crop_Output_Query -ieq "yes") -or ($Drawpile_No_Crop_Size_Query -ieq "Y") -or ($Drawpile_No_Crop_Size_Query -ieq "yes")) {
    # --------------------------------------------------------------------------------------------------------
    function Odd_or_Even_3_Suggestion_Function {
        if ($script:suggested_3_size -eq $null -or $script:suggested_3_size -eq "") {
            $script:suggested_3_size=$script:number_3_offset
        }
        if ($script:suggested_3_size % 2 -eq 1) {
            Write-Host "Width $script:suggested_3_size is an odd number." -BackgroundColor Red
            Write-Host "MP4 requires even width value, adding 1 to suggested value." -ForegroundColor Black -BackgroundColor Yellow
            $script:suggested_3_size=[int]$script:suggested_3_size + 1
            Write-Host ""
        } else {
            # Write-Host "suggested_3_size: $script:suggested_3_size is an even number."
        }
    }
    # --------------------------------------------------------------------------------------------------------
    function Odd_or_Even_4_Suggestion_Function {
        if ($script:suggested_4_size -eq $null -or $script:suggested_4_size -eq "") {
            $script:suggested_4_size=$script:number_4_offset
        }
        if ($script:suggested_4_size % 2 -eq 1) {
            Write-Host "Height: $script:suggested_4_size is an odd number." -BackgroundColor Red
            Write-Host "MP4 requires even height value, adding 1 to suggested value." -ForegroundColor Black -BackgroundColor Yellow
            $script:suggested_4_size=[int]$script:suggested_4_size + 1
            Write-Host ""
        } else {
            # Write-Host "suggested_4_size: $script:suggested_4_size is an even number."
        }
    }
    # --------------------------------------------------------------------------------------------------------
    # --------------------------------------------------------------------------------------------------------
    If ($number_3_offset -eq $number_4_offset) {
        If ($number_3_offset -gt $Suggested_Video_Maximum_Size) {
            Write-Host "Video is square, suggested reducing resolution for wider device compatibility to: $Suggested_Video_Maximum_Size by $Suggested_Video_Maximum_Size" -ForegroundColor Black -BackgroundColor Green
        } ElseIf ($number_3_offset -eq $Suggested_Video_Maximum_Size) {
            Write-Host "Video is square, suggested resolution: $Suggested_Video_Maximum_Size by $Suggested_Video_Maximum_Size" -ForegroundColor Black -BackgroundColor Green
        } ElseIf ($number_3_offset -lt $Suggested_Video_Maximum_Size) {
            $script:suggested_3_size=[int]$number_3_offset
            Odd_or_Even_3_Suggestion_Function
            $script:suggested_4_size=[int]$number_4_offset
            Odd_or_Even_4_Suggestion_Function
            Write-Host "Video is square, suggested resolution: $suggested_3_size by $suggested_4_size" -ForegroundColor Black -BackgroundColor Green

        } Else {
            Write-Host "Suggestion failed: This message shouldn't be visible for square video resolution suggestion." -BackgroundColor Red
        }
    } ElseIf ($number_3_offset -gt $number_4_offset) {
        If ($number_3_offset -gt $Suggested_Video_Maximum_Size) {
            $script:suggested_3_size=[int]$number_3_offset
            Odd_or_Even_3_Suggestion_Function
            $suggested_3_size_factor=$number_3_offset/$Suggested_Video_Maximum_Size
            $suggested_4_size=[Math]::Round($number_4_offset/$suggested_3_size_factor)
            Odd_or_Even_4_Suggestion_Function
            Write-Host "Video is a wide rectangle, suggested reducing resolution for wider device compatibility to: $Suggested_Video_Maximum_Size by $suggested_4_size" -ForegroundColor Black -BackgroundColor Green
        } ElseIf ($number_3_offset -eq $Suggested_Video_Maximum_Size) {
            $script:suggested_3_size=[int]$number_3_offset
            Odd_or_Even_3_Suggestion_Function
            $script:suggested_4_size=[int]$number_4_offset
            Odd_or_Even_4_Suggestion_Function
            Write-Host "Video is a wide rectangle, suggested resolution: $suggested_3_size by $suggested_4_size" -ForegroundColor Black -BackgroundColor Green
        } ElseIf ($number_3_offset -lt $Suggested_Video_Maximum_Size) {
            $script:suggested_3_size=[int]$number_3_offset
            Odd_or_Even_3_Suggestion_Function
            $script:suggested_4_size=[int]$number_4_offset
            Odd_or_Even_4_Suggestion_Function
            Write-Host "Video is a wide rectangle, suggested resolution: $suggested_3_size by $suggested_4_size" -ForegroundColor Black -BackgroundColor Green
        } Else {
            Write-Host "Suggestion failed: This message shouldn't be visible for wide rectangle video resolution suggestion." -BackgroundColor Red
        }
    } ElseIf ($number_3_offset -lt $number_4_offset) {
        If ($number_4_offset -gt $Suggested_Video_Maximum_Size) {
            $suggested_4_size_factor=$number_4_offset/$Suggested_Video_Maximum_Size
            $suggested_3_size=[Math]::Round($number_3_offset/$suggested_4_size_factor)
            Odd_or_Even_3_Suggestion_Function
            $script:suggested_4_size=[int]$number_4_offset
            Odd_or_Even_4_Suggestion_Function
            Write-Host "Video is a tall rectangle, suggested reducing resolution for wider device compatibility to: $suggested_3_size by $Suggested_Video_Maximum_Size" -ForegroundColor Black -BackgroundColor Green
        } ElseIf ($number_4_offset -eq $Suggested_Video_Maximum_Size) {
            $script:suggested_3_size=[int]$number_3_offset
            Odd_or_Even_3_Suggestion_Function
            $script:suggested_4_size=[int]$number_4_offset
            Odd_or_Even_4_Suggestion_Function
            Write-Host "Video is a tall rectangle, suggested resolution: $suggested_3_size by $suggested_4_size" -ForegroundColor Black -BackgroundColor Green
        } ElseIf ($number_4_offset -lt $Suggested_Video_Maximum_Size) {
            $script:suggested_3_size=[int]$number_3_offset
            Odd_or_Even_3_Suggestion_Function
            $script:suggested_4_size=[int]$number_4_offset
            Odd_or_Even_4_Suggestion_Function
            Write-Host "Video is a tall rectangle, suggested resolution: $suggested_3_size by $suggested_4_size" -ForegroundColor Black -BackgroundColor Green
        } Else {
            Write-Host "Suggestion failed: This message shouldn't be visible for tall rectangle video resolution suggestion." -BackgroundColor Red
        }
    } Else {
        Write-Host "Suggestion failed: This message shouldn't be visible for video resolution suggestion." -BackgroundColor Red
    }
} Else {
    Write-Host "Crop or full size not provided, cannot provide video resolution suggestion. Skipping." -ForegroundColor Black -BackgroundColor Yellow
    Write-Host ""
    Write-Host "The value that should be provided depends on the size of the canvas at "
    Write-Host "the end of the recording. Open the DPREC and go to the end of the recording."
    Write-Host "Then go to Edit, Resize Canvas. Make a note of the numbers in there to use"
    Write-Host "for the next step (close the recording to avoid accidental modification)."
    Write-Host ""
    Write-Host "Open Microsoft Paint, click 'Resize', and put in the values (In Pixels)."
    Write-Host "You may need to uncheck 'Maintain aspect ratio', click ok. Click 'Resize'"
    Write-Host "again and then click 'Pixels'. Change which ever number is largest to $Suggested_Video_Maximum_Size"
    Write-Host "and make a note of the values (horizontal is width, vertical is height)."
    Write-Host "You should use these values to set the video's dimensions."
    Write-Host ""
    Write-Host ""
}

#
#-d, --dimensions <dimensions>
#      Video dimensions, required. In the form WIDTHxHEIGHT. All frames
#      will be resized to fit into these dimensions.
#
Write-Host ""
Write-Host "Set the video dimension output results. This is required."
Write-Host ""
Write-Host "Output video should not be greater than 1920 in either"
Write-Host "direction, so some image compression may be necessary in "
Write-Host "order to play on more devices."
Write-Host ""

$number_1 = -1
Write-Host "Set a value for the video width."
while ($number_1 -lt 1 -or $number_1 -gt 10000) {
    $number_1 = Read-Host "Enter a number."
    $number_1 = [int]$number_1
    If ($number_1 -match "\D") {
        Write-Host "Invalid input. Please enter a number."
        $number_1 = -1
    } elseif ($number_1 -lt 1 -or $number_1 -gt 10000) {
        Write-Host "Number is out of range. Please enter a number between 1 and 10000."
        Write-Host ""
    } else {
        # Correct value entered.
    }
}
Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
$number_2 = -1
Write-Host "Set a value for the video height."
while ($number_2 -lt 1 -or $number_2 -gt 10000) {
    $number_2 = Read-Host "Enter a number."
    $number_2 = [int]$number_2
    If ($number_2 -match "\D") {
        Write-Host "Invalid input. Please enter a number."
        $number_2 = -1
    } elseif ($number_2 -lt 1 -or $number_2 -gt 10000) {
        Write-Host "Number is out of range. Please enter a number between 1 and 10000."
        Write-Host ""
    } else {
        # Correct value entered.
    }
}
$number="$($number_1)x$($number_2)"
$Drawpile_Video_Output_Variable="--dimensions $number"

Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
#    -I, --interpolation <interpolation>
#      Interpolation to use when scaling images. One of 'fastbilinear' (the
#      default), 'bilinear', 'bicubic', 'experimental', 'nearest', 'area',
#      'bicublin', 'gauss', 'sinc', 'lanczos' or 'spline'.
Write-Host "-----------------------"
Write-Host " Interpolation Options"
Write-Host "-----------------------"
Write-Host " * fastbilinear (default)  [shortened version -> fb ]"
Write-Host " * bilinear                [shortened version -> bl ]"
Write-Host " * bicubic                 [shortened version -> bc ]"
Write-Host " * experimental            [shortened version -> e  ]"
Write-Host " * nearest                 [shortened version -> n  ]"
Write-Host " * area                    [shortened version -> a  ]"
Write-Host " * bicublin                [shortened version -> bic]"
Write-Host " * gauss                   [shortened version -> g  ]"
Write-Host " * sinc                    [shortened version -> s  ]"
Write-Host " * lanczos                 [shortened version -> l  ]"
Write-Host " * spline                  [shortened version -> sp ]"
#Write-Host " * bilinear ()"
#Write-Host " * bicubic ()"
#Write-Host " * experimental ()"
#Write-Host " * nearest ()"
#Write-Host " * area ()"
#Write-Host " * bicublin ()"
#Write-Host " * gauss ()"
#Write-Host " * sinc ()"
#Write-Host " * lanczos ()"
#Write-Host " * spline (a method of approximating a smooth curve or surface by fitting piecewise polynomials (splines) to a set of data points)"
Write-Host ""
Write-Host "Enter one of the above values (e.g. bilinear or bl)."
Write-Host ""


$Drawpile_Interpolation_Option= Read-Host -Prompt 'What interpolation method would you like to use? If blank defaults to fastbilinear.'

If (($Drawpile_Logo_In_Video -eq "fastbilinear") -or ($Drawpile_Logo_In_Video -eq "fb") -or ([string]::IsNullOrEmpty($Drawpile_Format_Output))) {
    If ([string]::IsNullOrEmpty($Drawpile_Format_Output)) {
        Write-Host ""
        Write-Host "Left blank, selecting fastbilinear."
    }
    $Drawpile_Interpolation_Variable="--interpolation fastbilinear"
} Elseif (($Drawpile_Logo_In_Video -eq "bilinear") -or ($Drawpile_Logo_In_Video -eq "bl")) {
    $Drawpile_Interpolation_Variable="--interpolation bilinear"
} Elseif (($Drawpile_Logo_In_Video -eq "bicubic") -or ($Drawpile_Logo_In_Video -eq "bc")) {
    $Drawpile_Interpolation_Variable="--interpolation bicubic"
} Elseif (($Drawpile_Logo_In_Video -eq "experimental") -or ($Drawpile_Logo_In_Video -eq "e")) {
    $Drawpile_Interpolation_Variable="--interpolation experimental"
} Elseif (($Drawpile_Logo_In_Video -eq "nearest") -or ($Drawpile_Logo_In_Video -eq "n")) {
    $Drawpile_Interpolation_Variable="--interpolation nearest"
} Elseif (($Drawpile_Logo_In_Video -eq "area") -or ($Drawpile_Logo_In_Video -eq "a")) {
    $Drawpile_Interpolation_Variable="--interpolation area"
} Elseif (($Drawpile_Logo_In_Video -eq "bicublin") -or ($Drawpile_Logo_In_Video -eq "bic")) {
    $Drawpile_Interpolation_Variable="--interpolation bicublin"
} Elseif (($Drawpile_Logo_In_Video -eq "gauss") -or ($Drawpile_Logo_In_Video -eq "g")) {
    $Drawpile_Interpolation_Variable="--interpolation gauss"
} Elseif (($Drawpile_Logo_In_Video -eq "sinc") -or ($Drawpile_Logo_In_Video -eq "s")) {
    $Drawpile_Interpolation_Variable="--interpolation sinc"
} Elseif (($Drawpile_Logo_In_Video -eq "lanczos") -or ($Drawpile_Logo_In_Video -eq "l")) {
    $Drawpile_Interpolation_Variable="--interpolation lanczos"
} Elseif (($Drawpile_Logo_In_Video -eq "spline") -or ($Drawpile_Logo_In_Video -eq "sp")) {
    $Drawpile_Interpolation_Variable="--interpolation spline"
} Else {
    $Drawpile_Interpolation_Variable="--interpolation fastbilinear"
}

Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
# -r, --framerate <framerate>
Write-Host "Video frame rate. Defaults to 24. Higher values may not work on all"
Write-Host "platforms and may not play back properly or be allowed to upload!"
Write-Host ""
$number = -1
while ($number -lt 1 -or $number -gt 120) {
    $number = Read-Host "Enter a number between 1 and 120, default value is 24 if left blank."
    if ([string]::IsNullOrEmpty($number)) {
        Write-Host ""
        Write-Host "Left blank, using default value of 24."
        $number = 24
        $number = [int]$number
    } Else {
        $number = [int]$number
        If ($number -match "\D") {
            Write-Host "Invalid input. Please enter a number."
            $number = -1
        }
        elseif ($number -lt 1 -or $number -gt 120) {
            Write-Host "Number is out of range. Please enter a number between 1 and 120."
            Write-Host ""
        }
    }
}
Write-Host "The framerate you entered is: $number"
$Drawpile_Framerate_Variable="--framerate $number"
Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
#    -i, --interval <interval>
Write-Host "Interval between each frame, in milliseconds. Defaults to 10000,"
Write-Host "higher values mean the timelapse will be faster."
Write-Host ""
$number = -1
while ($number -lt 1 -or $number -gt 100000) {
    $number = Read-Host "Enter a number between 1 and 100000, default value is 10000 if left blank."
    if ([string]::IsNullOrEmpty($number)) {
        Write-Host ""
        Write-Host "Left blank, using default value of 10000."
        $number = 10000
        $number = [int]$number
    } Else {
        $number = [int]$number
        If ($number -match "\D") {
            Write-Host "Invalid input. Please enter a number."
            $number = -1
        } elseif ($number -lt 1 -or $number -gt 100000) {
            Write-Host "Number is out of range. Please enter a number between 1 and 100000."
            Write-Host ""
        }
    }
}
Write-Host "The interval time you entered is: $number"
$Drawpile_Interval_Variable="--interval $number"
Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
#    -F, --flash <flash>
Write-Host "The color of the flash when the timelapse is finished, in argb"
Write-Host "hexadecimal format. Default is 'ffffffff' for a solid white flash."
Write-Host "Use 'n', 'no', or 'none' for no flash."
Write-Host ""
$Drawpile_Flash_Output= Read-Host -Prompt 'Do you desire a flash on completion? Blank defaults to yes and white flash.'

If ([string]::IsNullOrEmpty($Drawpile_Flash_Output)) {
    Write-Host ""
    Write-Host "Left blank, defaulting to solid white flash."
    $Drawpile_Flash_Variable="--flash ffffffff"
} Elseif (($Drawpile_Flash_Output -eq "y") -or ($Drawpile_Flash_Output -eq "yes")) {
    function Is-ValidARGBHexCode {
        param(
            [Parameter(Mandatory=$true)]
            [string]$ARGBHex
        )

        $regex = "^([0-9a-fA-F]{8})$"

        return $ARGBHex -match $regex
    }

    Write-Host "ARGB = Alpha, Red, Green, Blue"
    Write-Host "Alpha Opacity = Hex Code"
    Write-Host "         100% = FF"
    Write-Host "         90%  = E5"
    Write-Host "         80%  = CC"
    Write-Host "         75%  = 4B"
    Write-Host "         70%  = B2"
    Write-Host "         60%  = 99"
    Write-Host "         50%  = BF"
    Write-Host "         25%  = 3F"
    Write-Host ""
    Write-Host "Pick the remaining six digits using a hex color tool or in Drawpile."
    Write-Host ""
    $argbCode = Read-Host "Enter an ARGB hex code (e.g., FFFFFFFF)"

    while (-not (Is-ValidARGBHexCode $argbCode)) {
        Write-Host "Invalid ARGB hex code. Please try again."
        $argbCode = Read-Host "Enter an ARGB hex code (e.g., FFRRGGBB)"
    }

    Write-Host "Valid ARGB hex code entered: $($argbCode)"

    $Drawpile_Flash_Variable="--flash $argbCode"
} Elseif (($Drawpile_Flash_Output -eq "n") -or ($Drawpile_Flash_Output -eq "no") -or ($Drawpile_Flash_Output -eq "none")) {
    $Drawpile_Flash_Variable="--flash none"
} Else {
    Write-Host "Invalid option selected. Will use white flash."
    $Drawpile_Flash_Variable="--flash ffffffff"
}

Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
#    -t, --linger-time <linger_time>
Write-Host "How many seconds to linger on the final result. Default is 5.0."
$number = -1
while ($number -lt 0 -or $number -gt 60) {
    $number = Read-Host "Enter a number between 0 and 60, default value is 5 if left blank."
    if ([string]::IsNullOrEmpty($number)) {
        Write-Host ""
        Write-Host "Left blank, using default value of 5."
        $number = 5
        $number = [int]$number
    } Else {
        $number = [int]$number
        If ($number -match "\D") {
            Write-Host "Invalid input. Please enter a number."
            $number = -1
        }
        elseif ($number -lt 0 -or $number -gt 60) {
            Write-Host "Number is out of range. Please enter a number between 1 and 60."
            Write-Host ""
        }
    }
}
$Drawpile_Linger_Time_Variable="--linger-time $number"
Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
Write-Host "If a logo is enabled, logo defaults to bottom left corner (can change however)."
Write-Host ""
Write-Host "Valid Answers: y, Y, yes, YES, n, N, no, NO"
$Drawpile_Logo_In_Video= Read-Host -Prompt 'Would you like to use the Drawpile logo (or other image) on your video? Blank entry will skip logo.'

If (($Drawpile_Logo_In_Video -eq "y") -or ($Drawpile_Logo_In_Video -eq "yes")) {
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------"
    Write-Host ""
   # -l, --logo-location <logo_location>
   #   Where to put the logo. One of 'bottom-left' (the default),
   #   'top-left', 'top-right', 'bottom-right' will put the logo in that
   #   corner. Use 'none' to remove the logo altogether.

   Write-Host "Where to put the logo. One of 'bottom-left' (the default), 'top-left', 'top-right', 'bottom-right' will put the logo in that corner. Use 'none' to remove the logo altogether."
   write-host ""
   $Drawpile_Logo_In_Video_Location= Read-Host -Prompt 'What location would you like to use? Leaving blank will default to bottom-left.'
   If (($Drawpile_Logo_In_Video_Location -ieq "bottom-left") -or ($Drawpile_Logo_In_Video_Location -ieq "bottom_left") -or ($Drawpile_Logo_In_Video_Location -ieq "bottom left") -or ($Drawpile_Logo_In_Video_Location -ieq "b l") -or ($Drawpile_Logo_In_Video_Location -ieq "bl") -or ([string]::IsNullOrEmpty($Drawpile_Logo_In_Video_Location))) {
        If ([string]::IsNullOrEmpty($Drawpile_Logo_In_Video_Location)) {
            Write-Host ""
            Write-Host "Left blank, defaulting to bottom-left position."
        }
        $Drawpile_Logo_In_Video_variable="--logo-location bottom-left"
   } Elseif (($Drawpile_Logo_In_Video_Location -ieq "top-left") -or ($Drawpile_Logo_In_Video_Location -ieq "top_left") -or ($Drawpile_Logo_In_Video_Location -ieq "top left") -or ($Drawpile_Logo_In_Video_Location -ieq "t l") -or ($Drawpile_Logo_In_Video_Location -ieq "tl")) {
        $Drawpile_Logo_In_Video_variable="--logo-location top-left"
   } Elseif (($Drawpile_Logo_In_Video_Location -ieq "bottom-right") -or ($Drawpile_Logo_In_Video_Location -ieq "bottom_right") -or ($Drawpile_Logo_In_Video_Location -ieq "bottom right") -or ($Drawpile_Logo_In_Video_Location -ieq "b r") -or ($Drawpile_Logo_In_Video_Location -ieq "br")) {
        $Drawpile_Logo_In_Video_variable="--logo-location bottom-right"
   } Elseif (($Drawpile_Logo_In_Video_Location -ieq "top-right") -or ($Drawpile_Logo_In_Video_Location -ieq "top_right") -or ($Drawpile_Logo_In_Video_Location -ieq "top right") -or ($Drawpile_Logo_In_Video_Location -ieq "t r") -or ($Drawpile_Logo_In_Video_Location -ieq "tr")) {
        $Drawpile_Logo_In_Video_variable="--logo-location top-right"
   } Elseif (($Drawpile_Logo_In_Video_Location -ieq "none") -or ($Drawpile_Logo_In_Video_Location -ieq "n")) {
        $Drawpile_Logo_In_Video_variable="--logo-location none"
   } Else {
        Write-Host "Invalid option selected. Will use logo in bottom-left location."
        $Drawpile_Logo_In_Video_variable="--logo-location bottom-left"
   }
   Write-Host ""
   Write-Host "-------------------------------------------------------------------------"
   Write-Host ""

   If (($Drawpile_Logo_In_Video_Location -ieq "none") -or ($Drawpile_Logo_In_Video_Location -ieq "n") -or ($Drawpile_Logo_In_Video_Location -ieq "no")) {
        Write-Host "Skipping other options for logo since it was disabled"
   } Else {
       # -L, --logo-path <logo_path>
       #   Path to the logo. Default is to use the Drawpile logo.

       $Drawpile_Logo_In_Video_Type= Read-Host -Prompt 'Yes for Drawpile Logo, No for custom logo. Would you like to use the Drawpile logo?'
       If (($Drawpile_Logo_In_Video_Type -ieq "n") -or ($Drawpile_Logo_In_Video_Type -eq "no")) {
            $PNG_FileName_Selected=Get-PNG-FileName -initialDirectory “c:fso”

            if ($PNG_FileName_Selected -eq $null -or $PNG_FileName_Selected -eq "") {
                while ($PNG_FileName_Selected -eq $null -or $PNG_FileName_Selected -eq "") {
                    Write-Host ""
                    Write-Host "-------------------------------------------------------------------------"
                    Write-Host "-------------------------------------------------------------------------"
                    Write-Host ""
                    Write-Host "Null or empty value provided, script cannot continue."
                    Write-Host "Please select a png to use as a watermark for your time lapse file(s)."
                    Write-Host ""
                    $PNG_FileName_Selected=Get-PNG-FileName -initialDirectory “c:fso”
                    Start-Sleep -Seconds 1 # Pause for 1 second to avoid excessive looping
                    Write-Host ""
                    Write-Host "-------------------------------------------------------------------------"
                    Write-Host "-------------------------------------------------------------------------"
                    Write-Host ""
                }
                Write-Host "PNG Logo File Selected: $PNG_FileName_Selected"
            } else {
                Write-Host "PNG Logo File Selected: $PNG_FileName_Selected"
            }
            $Drawpile_Logo_In_Video_variable="$Drawpile_Logo_In_Video_variable --logo-path `"$PNG_FileName_Selected`""
		} Elseif (($Drawpile_Logo_In_Video_Type -ieq "y") -or ($Drawpile_Logo_In_Video_Type -ieq "yes")) {
            $Drawpile_Logo_In_Video_variable="$Drawpile_Logo_In_Video_variable"
        } Else {
            $Drawpile_Logo_In_Video_variable="$Drawpile_Logo_In_Video_variable"
        }
        Write-Host ""
        Write-Host "-------------------------------------------------------------------------"
        Write-Host ""

       # -O, --logo-opacity <logo_opacity>
       #   Opacity of the logo, in percent. Default is 40.

       $number = -1
       Write-Host "Set the opacity of the logo."
        while ($number -lt 1 -or $number -gt 100) {
            $number = Read-Host "Enter a number between 1 and 100, default value is 40 if left blank."
            if ([string]::IsNullOrEmpty($number)) {
                Write-Host ""
                Write-Host "Left blank, using default value of 40."
                $number = 40
                $number = [int]$number
            } Else {
                $number = [int]$number
                If ($number -match "\D") {
                    Write-Host "Invalid input. Please enter a number."
                    $number = -1
                }
                elseif ($number -lt 1 -or $number -gt 100) {
                    Write-Host "Number is out of range. Please enter a number between 1 and 100."
                    Write-Host ""
                }
            }
        }
        Write-Host "The opacity you entered is: $number"
        $Drawpile_Logo_In_Video_variable="$Drawpile_Logo_In_Video_variable --logo-opacity $number"
        Write-Host ""
        Write-Host "-------------------------------------------------------------------------"
        Write-Host ""

       # -D, --logo-distance <logo_distance>
       #   Distance of the logo from the corner, in the format WIDTHxHEIGHT.
       #   Default is 20x20.

       $number = -1
       Write-Host "Set the distance of the logo from corner. Assumed square size (both sides are equal."
        while ($number -lt 1 -or $number -gt 512) {
            $number = Read-Host "Enter a number between 1 and 512, default value is 20 if left blank."
            if ([string]::IsNullOrEmpty($number)) {
                Write-Host ""
                Write-Host "Left blank, using default value of 20."
                $number = 20
                $number = [int]$number
            } Else {
                $number = [int]$number
                If ($number -match "\D") {
                    Write-Host "Invalid input. Please enter a number."
                    $number = -1
                }
                elseif ($number -lt 1 -or $number -gt 512) {
                    Write-Host "Number is out of range. Please enter a number between 1 and 512."
                    Write-Host ""
                }
            }
        }
        $number="$($number)x$($number)"
        Write-Host "The logo distance from corner entered is: $number"
        $Drawpile_Logo_In_Video_variable="$Drawpile_Logo_In_Video_variable --logo-distance $number"
        Write-Host ""
        Write-Host "-------------------------------------------------------------------------"
        Write-Host ""

       # -S, --logo-scale <logo_scale>
       #   Relative scale of the logo, in percent. Default is 100.

       $number = -1
       Write-Host "Set the scale of the logo."
        while ($number -lt 1 -or $number -gt 1000) {
            $number = Read-Host "Enter a number between 1 and 1000, default value is 100 if left blank."
            if ([string]::IsNullOrEmpty($number)) {
                Write-Host ""
                Write-Host "Left blank, using default value of 100."
                $number = 100
                $number = [int]$number
            } Else {
                $number = [int]$number
                If ($number -match "\D") {
                    Write-Host "Invalid input. Please enter a number."
                    $number = -1
                }
                elseif ($number -lt 1 -or $number -gt 1000) {
                    Write-Host "Number is out of range. Please enter a number between 1 and 1000."
                    Write-Host ""
                }
            }
        }
        Write-Host "The logo scale you entered is: $number"
        $Drawpile_Logo_In_Video_variable="$Drawpile_Logo_In_Video_variable --logo-scale $number"
    }
}
ElseIf (($Drawpile_Logo_In_Video -eq "n") -or ($Drawpile_Logo_In_Video -eq "no") -or ([string]::IsNullOrEmpty($Drawpile_Logo_In_Video))) {
	Write-Host ""
    If ([string]::IsNullOrEmpty($Drawpile_Logo_In_Video)) {
        Write-Host "Left blank, skipping use of Drawpile Logo."
    } Else {
        write-host "Skipping use of Drawpile Logo ..."
    }
    $Drawpile_Logo_In_Video_variable="--logo-location none"
}
Else {
	write-host "Invalid Value selected. Skipping use of Drawpile Logo ..."
    $Drawpile_Logo_In_Video_variable="--logo-location none"
}
Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
#    -U, --uncensor
Write-Host "Show censored layers instead of rendering them as censor squares."
Write-Host "This only applies to layers marked 'Censor' in Drawpile."
Write-Host ""
Write-Host "Valid Answers: y, Y, yes, YES, n, N, no, NO"
$Drawpile_Format_Output= Read-Host -Prompt 'Would you like to show censored layers? Leaving blank will uncensor.'

If (($Drawpile_Censor_Output_Status -eq "y") -or ($Drawpile_Censor_Output_Status -eq "yes") -or ([string]::IsNullOrEmpty($Drawpile_Format_Output))) {
    If ([string]::IsNullOrEmpty($Drawpile_Format_Output)) {
        Write-Host ""
        Write-Host "Left blank, will show censored layers."
    }
    $Drawpile_Censor_Output_Status_Variable="--uncensor"
} Elseif (($Drawpile_Censor_Output_Status -eq "n") -or ($Drawpile_Censor_Output_Status -eq "no")) {
    $Drawpile_Censor_Output_Status_Variable=""
} Else {
    Write-Host "Invalid option selected. Will show censored layers."
    $Drawpile_Censor_Output_Status_Variable="--uncensor"
}

Write-Host ""
Write-Host "-------------------------------------------------------------------------"
Write-Host "-------------------------------------------------------------------------"
Write-Host ""
Write-Host "-----------------"
Write-Host " Running Command:"
Write-Host "-----------------"
Write-Host ""
$Command="$drawpile_timelapse_folder\.\drawpile-timelapse.exe"
$Parameters="--ffmpeg-location `"$FFMPEG_Executable`" --acl $Drawpile_Format_Output_Variable $Drawpile_Crop_Output_variable $Drawpile_Video_Output_Variable $Drawpile_Interpolation_Variable $Drawpile_Framerate_Variable $Drawpile_Interval_Variable $Drawpile_Flash_Variable $Drawpile_Linger_Time_Variable $Drawpile_Logo_In_Video_variable $Drawpile_Censor_Output_Status_Variable --out `"$Video_FileName_Selected.$Drawpile_Format_Output_Extension_Variable`" `"$DPREC_FileName_Selected`""
$Parameters = $Parameters.Split(" ")
Write-Host "& $Command $Parameters"
Write-Host ""
& "$Command" $Parameters
Write-Host ""
Write-Host ""
Write-Host "Script completed."
Write-Host ""
PauseScript