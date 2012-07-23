@echo off
pushd c:\temp\images
::for %f in (*.png) do  convert %f -resize 30% %~nf.gif
for %f in (*.png) do  convert %f -resize 25% %~nf.gif
popd