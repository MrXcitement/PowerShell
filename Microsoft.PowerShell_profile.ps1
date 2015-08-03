# Microsoft.Powershell_profile.ps1 --- Default power shell config
#
# Mike Barker <mike@thebarkers.com>
# June 26th, 2015

##
# Add the ability to administer VMWare ESXi hosts
Add-PSSnapin VMware.VimAutomation.Core

##
# Load posh-git module, set the prompt and start the ssh agent
# https://github.com/dahlbyk/posh-git
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
Import-Module posh-git

# Configure the prompt
Function Prompt
{
    $realLASTEXITCODE = $LASTEXITCODE
    Write-Host("[" + $env:USERNAME + "@" + $env:COMPUTERNAME + "]") -nonewline
    Write-Host($PWD) -nonewline
    Write-VcsStatus
    $global:LASTEXITCODE = $realLASTEXITCODE

    return "`n> "
}
Pop-Location
Start-SshAgent -Quiet


##
# Add elevated powershell function and alias to sudo
# http://blogs.technet.com/b/heyscriptingguy/archive/2015/07/30/launch-elevated-powershell-shell.aspx
Function Start-ElevatedPowerShell
{
	$file, [string]$arguments = $args
	Start-Process $file -Arguments $arguments -Verb Runas -WorkingDirectory (Get-Location)
}
Set-Alias -Name sudo -Value Start-ElevatedPowerShell | out-null

##
# Change to home directory
cd ~
