# install.cmd -- Install the PowerShell profile files
# Use powershell to run a process elevated and then use mklink to create
# a symlink to the profile files

# Mike Barker <mike@thebarkers.com>
# June 5th, 2016

# Change log:
# 2016.06.05
# * First release.
# 2018.12.18
# * The default installation location may change if onedrive is installed.
#   Change the mklink commands to use the correct $profile variable to create links in the correct folder.
# 2019.05.09 MRB
# * Moved files under home/Documents/WindowsPowerShell

# $Profile                           Current User,Current Host
# $Profile.CurrentUserCurrentHost    Current User,Current Host
# $Profile.CurrentUserAllHosts       Current User,All Hosts
# $Profile.AllUsersCurrentHost       All Users, Current Host
# $Profile.AllUsersAllHosts          All Users, All Hosts

$files = Get-ChildItem ".\home\Documents\WindowsPowerShell\*.ps1"

mkdir -Force -Path $env:userprofile\Documents\WindowsPowerShell

foreach ($file in $files) {
    $link = $env:userprofile + "\Documents\WindowsPowerShell\" + $file.Name
    cmd /c mklink $link $file 
}
