:: YouTube Music Downloader Script
:: https://yt-dl.org/latest/youtube-dl.exe
:: https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-essentials.7z
@echo off
title YouTube-Dl
if "%1" == "-a" (youtube-dl %1 -f 249 &exit)
if "%1" == "-v" (youtube-dl %1 -f 137+140 &exit)
if "%1" == "-h" goto help
goto init

:init
cls
echo.
set url=
set /p url="YouTube URL: "
if "%url%" == "" exit
set "ops=-f bestaudio[ext=m4a] -o %%(title)s.%%(ext)s --youtube-skip-dash-manifest"
:: audio // --embed-thumbnail // --skip-download --write-thumbnail
youtube-dl %url% %ops% || pause >nul
goto init

:help
echo 137   mp4   1080p
echo 136   mp4   720p
echo 135   mp4   480p
echo 134   mp4   360p
echo 133   mp4   240p
echo 140   m4a   128k
echo.
echo 248   vp9   1080p
echo 247   vp9   720p
echo 244   vp9   480p
echo 243   vp9   360p
echo 242   vp9   240p
echo 251   opus  160k
echo.
goto init
