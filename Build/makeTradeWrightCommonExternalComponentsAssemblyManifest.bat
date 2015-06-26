@echo off
setlocal

echo =================================
echo Making assembly manifest for TradeWright.Common.ExternalComponents

%TW-PROJECTS-DRIVE%
path %TW-PROJECTS-DRIVE%%TW-PROJECTS-PATH%\Build\Subscripts;%PATH%

call setMyVersion.bat

generateManifest /Ass:TradeWright.Common.ExternalComponents,%VB6-BUILD-MAJOR%.%VB6-BUILD-MINOR%.0.%VB6-BUILD-REVISION%,"TradeWright Common ExternalComponents",TradeWrightCommonExternalComponents.txt ^
                 /Out:..\Bin\TradeWright.Common.ExternalComponents\TradeWright.Common.ExternalComponents.manifest ^
                 /Inline
if errorlevel 1 goto :err

echo Manifest generated
exit /B

:err
echo Manifest generation failed
exit /B 1
