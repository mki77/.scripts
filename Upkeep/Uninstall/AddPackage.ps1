$AppxPackage = @(
'DesktopAppInstaller.AppxBundle'
'NoDialCalculator.AppxBundle'
#'WindowsCalculator.AppxBundle'
)
ForEach ($f in $AppxPackage) {Add-AppxPackage -Path .\$f}
Start-Sleep -s 5
