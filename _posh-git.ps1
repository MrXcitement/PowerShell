##
# Load posh-git module and start the ssh agent
# https://github.com/dahlbyk/posh-git
if ((Get-Command "git.exe" -ErrorAction SilentlyContinue) -And 
    (Get-Module -ListAvailable -Name "posh-git"))
{
    Write-Output "Import module posh-git"
    Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
    Import-Module posh-git
    Pop-Location
    Start-SshAgent -Quiet
}

