##
# Load posh-git module and start the ssh agent
# https://github.com/dahlbyk/posh-git
if ((Get-Command "git" -ErrorAction SilentlyContinue) -And
    (Get-Module -ListAvailable -Name "Posh-Git"))
{
    Import-Module Posh-Git
}

