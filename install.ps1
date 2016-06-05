# install.cmd -- Install the PowerShell profile files
# Use powershell to run a process elevated and then use mklink to create
# a symlink to the profile files

# Mike Barker <mike@thebarkers.com>
# June 5th, 2016

# Change log:
# 2016.06.05
# * First release.

md -Force -Path $env:userprofile\Documents\WindowsPowerShell
cmd /c mklink $env:userprofile\Documents\WindowsPowerShell\profile.ps1 $PSScriptRoot\profile.ps1
cmd /c mklink $env:userprofile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 $PSScriptRoot\Microsoft.PowerShell_profile.ps1
cmd /c mklink $env:userprofile\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1 $PSScriptRoot\Microsoft.PowerShellISE_profile.ps1

