@echo off
set OLDPATH=%PATH%
set PATH=C:\Program Files (x86)\ImageMagick-6.7.4-Q16;%PATH%
convert -version
