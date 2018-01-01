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
Function Test-Administrator 
{
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

##
# Install modules and import those that need to be
$modules = @{
    # Powershell Community Extensions
    # https://github.com/Pscx/Pscx
    'Pscx' = @{'import'=$False;
               'import_params'=@{};
               'install_params'=@{'-Scope'='CurrentUser';
                                  '-AllowClobber'=$True}}
    # PSReadLine (Note: now included with PowerShell 5+)
    # https://github.com/lzybkr/PSReadLine
    'PSReadline' = @{'import'=$True;
                     'import_params'=@{};
                     'install_params'=@{'-Scope'='CurrentUser'}}
    # PSSudo
    # https://github.com/ecsousa/PSSudo
    'PSSudo' = @{'import'=$False;
                 'import_params'=@{};
                 'install_params'=@{'-Scope'='CurrentUser'}}
    # Posh-Git
    # https://github.com/dahlbyk/posh-git
    'Posh-Git' = @{'import'=$False;
                   'import_params'=@{};
                   'install_params'=@{'-Scope'='CurrentUser';
                                      '-AllowClobber'=$True}}
    # VMware.PowerClI
    # https://blogs.vmware.com/powercli/
    'VMware.PowerCLI' = @{'import'=$False;
                          'import_params' = @{};
                          'install_params' = @{'-Scope'='CurrentUser';}}
}

# Install/Import the modules defined above
ForEach ($module in $modules.GetEnumerator())
{
    $name = $module.Name
    $import = $module.Value['import']
    $install_params = $module.Value['install_params']
    $import_params = $module.Value['import_params']

    if (!(Get-Module -ListAvailable -Name $name))
    {
        Write-Warning "Module $name is not installed"
        if (($install_params['-Scope'] -eq 'CurrentUser') -And !(Test-Administrator))
        {
            Write-Warning "You must run this script elevated to install module $name" 
            continue
        }
        if (!(Find-Module $name))
        {
            Write-Warning "Unable to find module $name"
        }
        else
        {
            Write-Output "Installing module $name"
            Install-Module $name @install_params
        }
    } 
    if ($import -And !(Get-Module -Name $name))
    {
        Write-Output "Importing module $name"
        Import-Module $name @import_params
    }
}


##
# Add the ability to administer VMWare ESXi hosts
# $snapinName = "VMware.VimAutomation.Core"
# Add-PSSnapin $snapinName -ErrorAction SilentlyContinue
# if ((Get-PSSnapin -Name $snapinName -ErrorAction SilentlyContinue) -eq $null)
# {
# 	Write-Warning "VMware SnapIn is not installed and has not been added to this session."
# }

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
    # $env:path += ";" + (Get-Item "Env:ProgramFiles").Value + "\Git\usr\bin"
    Start-SshAgent -Quiet
}

##
# Configure the prompt
Function Prompt
{
    $realLASTEXITCODE = $LASTEXITCODE

    $userForegroundColor='Cyan'
    $hostForegroundColor='Cyan'
    $pathForegroundColor='Yellow'

    if (Test-Administrator) 
    {
        $userForegroundColor='Red'
        $hostForegroundColor='Red' 
    }
    Write-Host($env:USERNAME) -noNewLine -ForegroundColor $userForegroundColor
    Write-Host("@") -noNewLine -ForegroundColor White
    Write-Host($env:COMPUTERNAME) -noNewLine -ForegroundColor $hostForegroundColor
    Write-Host(" in ") -nonewline -ForegroundColor White
    Write-Host(Convert-Path($PWD)) -nonewline -ForegroundColor $pathForegroundColor

    if (Get-Module posh-git) 
    { 
        Write-VcsStatus 
    }
    Write-Host("")
    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

##
# Change to home directory
cd ~
