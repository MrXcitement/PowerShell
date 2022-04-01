# Configure the PsFzf Module

# Mike Barker <mike@thebarkers.com>
# April 1, 2022

if (Get-Module -ListAvailable 'PSFzf') {
    Import-Module 'PSFzf'
    Set-PsFzfOption -TabExpansion
    Set-PsFzfOption -EnableAliasFuzzyEdit
    Set-PsFzfOption -EnableAliasFuzzyGitLocation
    Set-PsFzfOption -EnableAliasFuzzyHistory
    Set-PsFzfOption -EnableAliasFuzzyKillProcess
    Set-PsFzfOption -EnableAliasFuzzySetLocation
}
