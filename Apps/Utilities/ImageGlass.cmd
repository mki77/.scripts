@echo off
curl.exe -L -o ImageGlass-7.0-x64.msi https://github.com/d2phap/ImageGlass/releases/download/7.0.7.26/ImageGlass_7.0.7.26_x64.msi
ImageGlass-7.0-x64.msi /passive
mkdir "%AppData%\ImageGlass"
copy igconfig.xml "%AppData%\ImageGlass"
