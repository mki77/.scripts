:: FFmpeg Video Encoder Script
:: https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-essentials.7z
@echo off
set "startTime=%time: =0%"
call :encMP4
call :timer %startTime%
pause &exit /b

:timer
setlocal EnableDelayedExpansion
set "startTime=%*"
set "endTime=%time: =0%"
set "end=!endTime:%time:~8,1%=%%100)*100+1!" & set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100)"
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
echo.
echo Start:		%startTime%
echo End:		%endTime%
echo Elapsed:	%hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%
echo.
goto :eof

:encMP4
rem https://trac.ffmpeg.org/wiki/Encode/H.264
rem -aspect 4:3|3:2|16:9|21:9 -c copy
rem -s 426:240|640:360|854:480|1024x576|1280:720|1920:1080 -sws_flags lanczos
rem -vf "crop=in_h/9*16:in_h,scale=-2:240:flags=lanczos"
rem -vf "scale=640:-2:flags=lanczos,crop=in_w:in_h-72"
rem -b:v 250K | -crf 24 -maxrate 1M -bufsize 2M (streaming)
rem -c:a aac -ac 1 -ar 22050 -b:a 64k (mono)
rem -ss 00:01:00 -to 00:02:00
rem -pix_fmt yuv420p (dumb players)

for %%f in ("*.avi") do (
	ffmpeg -i "%%f" -ss 00:01:00 -to 00:02:00 -c:v libx264 -crf 24 -preset veryfast -movflags +faststart -c:a aac -ac 2 -b:a 96k -y "%%~nf.mp4" -hide_banner -threads 0
)
goto :eof

:encWEBM
rem https://trac.ffmpeg.org/wiki/Encode/VP9
rem ffmpeg -h encoder=libvpx-vp9
rem -b:v 500k -crf 33 (CQ mode: costant quality, lower crf are higher quality)
rem -b:v 500k (VBR mode: balances quality and bitrate)
rem -quality realtime|good|best -speed 4 -threads 4

for %%f in ("*.avi") do (
	ffmpeg -i "%%f" -ss 00:01:00 -to 00:02:00 -movflags +faststart -pix_fmt yuv420p -c:v libvpx-vp9 -quality good -speed 4 -c:a libopus -ac 2 -b:a 96k -af "channelmap=channel_layout=5.1" -y "%%~nf.webm" -hide_banner -threads 0
)
goto :eof

:mapVA
rem -fflags +genpts -i <FIX INVALID TIMESTAMPS>
for %%f in ("*.m4v") do (
	ffmpeg -i "%%f" -i "%%~nf.m4a" -map 0:v -map 1:a -c copy -y "%%~nf.mp4"
)
goto :eof

:fixSeek
for %%f in ("*.m4v") do (
	ffmpeg -i "%%f" -c:v copy -movflags +faststart -an "%%~nf.mp4"
)
goto :eof

:getAudio
for %%f in ("*.mp4") do (
	ffmpeg -i "%%f" -vn -c:a copy "%%~nf.m4a"
rem ffmpeg -i "%%f" -ss 00:01:00 -vframes 1 -y "%%~nf.jpg"
)
goto :eof

:encM4A
for %%f in ("*.mp3") do (
	ffmpeg -i "%%f" -c:a aac -b:a 160k "%%~nf.m4a"
)
goto :eof

:encMP3
for %%f in ("*.m4a") do (
	ffmpeg -i "%%f" -vn -q:a 4 -ar 44100 "%%~nf.mp3"
)
goto :eof

:encJpeg
for %%f in ("*.m4a") do (
	ffmpeg -framerate 1 -loop 1 -i "%%~nf.jpg" -i "%%f" -c:v libx264 -preset veryfast -tune stillimage -movflags +faststart -c:a copy -y -shortest "%%~nf.mp4" -hide_banner
)
goto :eof

:setJpeg
set AtomicParsley=tag.exe
for %%f in ("*.m4a") do (
	%AtomicParsley% "%%f" --artwork "%%~nf.jpg" --overWrite
rem %AtomicParsley% "%%f" --artwork REMOVE_ALL
)
goto :eof
