# install.cmd -- Install the PowerShell profile files
# Use powershell to run a process elevated and then use mklink to create
# a symlink to the profile files

# Mike Barker <mike@thebarkers.com>
# June 5th, 2016

# Change log:
# 2016.06.05
# * First release.

$files = "_functions.ps1",
         "_modules.ps1",
         "_posh-git.ps1",
         "_prompt.ps1",
         "_psreadline.ps1",
         "profile.ps1",
         "Microsoft.Powershell_profile.ps1",
         "Microsoft.PowershellISE_profile.ps1"

md -Force -Path $env:userprofile\Documents\WindowsPowerShell

foreach ($file in $files) {
    cmd /c mklink $env:userprofile\Documents\WindowsPowerShell\$file $PSScriptRoot\$file
}
