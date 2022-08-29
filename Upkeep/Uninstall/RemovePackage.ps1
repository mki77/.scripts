$Pkgs=@(
"Clipchamp.Clipchamp"
"Microsoft.549981C3F5F10"
"Microsoft.BingNews"
"Microsoft.BingWeather"
"Microsoft.DesktopAppInstaller"
"Microsoft.GamingApp"
"Microsoft.GetHelp"
"Microsoft.Getstarted"
"Microsoft.HEIFImageExtension"
"Microsoft.HEVCVideoExtension"
"Microsoft.MicrosoftOfficeHub"
"Microsoft.MicrosoftSolitaireCollection"
"Microsoft.MicrosoftStickyNotes"
"Microsoft.Paint"
"Microsoft.People"
"Microsoft.PowerAutomateDesktop"
"Microsoft.RawImageExtension"
"Microsoft.ScreenSketch"
"Microsoft.SecHealthUI"
"Microsoft.StorePurchaseApp"
"Microsoft.Todos"
"Microsoft.VP9VideoExtensions"
"Microsoft.WebMediaExtensions"
"Microsoft.WebpImageExtension"
"Microsoft.Windows.Photos"
"Microsoft.WindowsAlarms"
"Microsoft.WindowsCalculator"
"Microsoft.WindowsCamera"
"microsoft.windowscommunicationsapps"
"Microsoft.WindowsFeedbackHub"
"Microsoft.WindowsMaps"
"Microsoft.WindowsNotepad"
"Microsoft.WindowsSoundRecorder"
"Microsoft.WindowsStore"
"Microsoft.WindowsTerminal"
"Microsoft.Xbox.TCUI"
"Microsoft.XboxGameOverlay"
"Microsoft.XboxGamingOverlay"
"Microsoft.XboxIdentityProvider"
"Microsoft.XboxSpeechToTextOverlay"
"Microsoft.YourPhone"
"Microsoft.ZuneMusic"
"Microsoft.ZuneVideo"
"MicrosoftCorporationII.MicrosoftFamily"
"MicrosoftCorporationII.QuickAssist"
"MicrosoftWindows.Client.WebExperience"
# No longer exist in 11
"Microsoft.Microsoft3DViewer"
"Microsoft.MixedReality.Portal"
"Microsoft.MSPaint"
"Microsoft.Office.OneNote"
"Microsoft.SkypeApp"
"Microsoft.Wallet"
"Microsoft.XboxApp"
)
foreach ($Name in $Pkgs) {
$Package="*$Name*"
Get-AppxPackage | 
Where-Object {$_.PackageFullName -like $Package} | Remove-AppxPackage
Get-AppxPackage -AllUsers | 
Where-Object {$_.PackageFullName -like $Package} | Remove-AppxPackage -AllUsers
Get-AppxProvisionedPackage -Online | 
Where-Object {$_.PackageName -like $Package}     | Remove-AppxProvisionedPackage -Online
}
# Get-AppxProvisionedPackage -Online | ? DisplayName -notmatch 'Installer' | ? DisplayName -notmatch 'Store' | ForEach-Object {Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
# Get-Content .\Apps.txt | ForEach-Object {Remove-AppxPackage $_ -AllUsers}
