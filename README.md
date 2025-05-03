*Please note, these instructions are written for Windows users to make a command line tool easier to use. Other systems will not be able to use this script. A general disclaimer as well, using scripts from online sources you do not trust is not safe. Just because I'm a moderator does not mean I couldn't decide to do bad things. The scripts do not need admin rights to run, and only run them if you feel sure the content is safe. This disclaimer exists so you don't run other scripts and then mess up your computer.*

If you've ever wanted to do an art timelapse in Drawpile, the easiest way to do so is with Drawpile's built in option. Simply go to File, Record. Once you've made an appropriate file and stopped the recording, you can now start working on making a timelapse video.

**__Necessary Tools__**
* First, you'll need Drawpile-Timelapse.exe. This tool Can be downloaded here ( https://drawpile.net/download/#Archive ). The download in question is called `Drawpile Server and Tools 2.2.2 Portable ZIP`. Of course, the version number may change in the future but it is more or less the same.
* Then you'll need a copy of FFMPEG. The main website has a bunch of available downloads (<https://www.ffmpeg.org/download.html>), I suggest using `Windows builds from gyan.dev`. The download should be at the top of the list, called `ffmpeg-git-full.7z`.  You may need to install 7-zip (either from the [official website](<https://www.7-zip.org/download.html>) or use [ninite](<https://ninite.com/7zip/>) to get it and install fast).
* Once you have those, you'll need the scripts to make it easier to run. I suggest using the `Download Zip` button in the upper right corner. https://gist.github.com/Bluestrings-Drawpile/d9ed3049158f0c58ca914c69fe99b8c9
  * I've created a gist on Github with the appropriate batch file to run alongside the main powershell script. Batch script exists due to restrictions on many systems with default powershell scripts.

Once you have those downloaded, you'll need to then put everything in the same folder somewhere. It should look something like the list of files below. If you have a folder in there and not the files like this, it's wrong. They all need to be in the *same* directory as displayed below in order to function.
* 00_Drawpile-Timelapse_Start.bat
* drawpile-timelapse.exe
* Drawpile-Timelapse.ps1
* ffmpeg.exe
 * ffplay.exe
 * ffprobe.exe

Once that's done, you should be able to double click `00_Drawpile-Timelapse_Start.bat` and will check that everything ready to work. If it isn't, the script will yell at you and exit. At the end, you should have a shiny new timelapse video to look at from your DPREC recording. If you have any questions or found a bug where something doesn't seem to work, let me know!
