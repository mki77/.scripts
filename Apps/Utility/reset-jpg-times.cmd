@echo off
:: Reset JPEG modification time using the shooting time embed in EXIF
:: ...and remove IPTC/XPM/thumbnails
%~dp0\jhead -ft -dt -dc -di -du -zt *.jpg
timeout /t 10
