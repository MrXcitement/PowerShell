# profile.ps1 --- Default power shell config
#
# Mike Barker <mike@thebarkers.com>
# June 26th, 2015

# Notes:
# There are many different profile files used by powershell at
# startup. There are files for the system and for the user. The system
# profiles are placed in C:\Programs Files\WindowsPowerShell and the
# users profiles are located in the WindowsPowerShell folder under the
# users Documents folder. The profile files that can exist in both of
# these locations have a specific nameing convention.

# Default profile, loaded by both cmd and ISE powershell
# profile.ps1

# Default cmd powershell profile.
# Microsoft.PowerShell_profile.ps1

# Default ISE powershell profile.
# Microsoft.PowerShellISE_profile.ps1

##
# Useful functions

Function Elevate-Process
{
	$file, [string]$arguments = $args
	$psi = new-object System.Diagnostics.ProcessStartInfo $file
	$psi.Arguments = $arguments;
	$psi.Verb = "runas"
	$psi.WorkingDirectory = Get-Location
	[System.Diagnostics.Process]::Start($psi)
}
Set-Alias sudo Elevate-Process

Function Test-Administrator 
{
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

##
# Add the ability to administer VMWare ESXi hosts
$snapinName = "VMware.VimAutomation.Core"
Add-PSSnapin $snapinName -ErrorAction SilentlyContinue
if ((Get-PSSnapin -Name $snapinName -ErrorAction SilentlyContinue) -eq $null)
{
	Write-Warning "VMware SnapIn is not installed and has not been added to this session."
}

##
# Load posh-git module, set the prompt and start the ssh agent
# https://github.com/dahlbyk/posh-git
if (Get-Command "git.exe" -ErrorAction SilentlyContinue)
{
	if (-not (Get-Module -ListAvailable -Name "Posh-Git")) 
	{
		Write-Warning "Posh-Git is not installed, trying to install now."
		sudo powershell -Wait -ArgumentList "-NoProfile -Command & {Install-Module Posh-Git}"
	}

	if (Get-Module -ListAvailable -Name "posh-git")
	{
		Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
		Import-Module posh-git

		Pop-Location
		$env:path += ";" + (Get-Item "Env:ProgramFiles").Value + "\Git\usr\bin"
		Start-SshAgent -Quiet
	}
}


##
# Configure the prompt
Function Prompt
{
	$realLASTEXITCODE = $LASTEXITCODE
    $currBackgroundColor = (get-host).ui.rawui.BackgroundColor

    $userForegroundColor='Cyan'
    $hostForegroundColor='Cyan'
    $pathForegroundColor='Yellow'

	If (Test-Administrator) {
        $userForegroundColor='Yellow'
        $hostForegroundColor='Yellow' 
        (get-host).ui.rawui.BackgroundColor = 'Red'
    }
    Write-Host($env:USERNAME) -noNewLine -ForegroundColor $userForegroundColor
	Write-Host("@") -noNewLine -ForegroundColor White
	Write-Host($env:COMPUTERNAME) -noNewLine -ForegroundColor $hostForegroundColor
	Write-Host(" in ") -nonewline -ForegroundColor White
	Write-Host($PWD) -nonewline -ForegroundColor $pathForegroundColor
	If (Test-Administrator) {
        (get-host).ui.rawui.BackgroundColor = $currBackgroundColor
    }

	If (Get-Module posh-git) { Write-VcsStatus }
	Write-Host("")

	$global:LASTEXITCODE = $realLASTEXITCODE
	return "> "
}



##
# Change to home directory
cd ~
