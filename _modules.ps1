
##
# Install modules and import those that need to be
$modules = @{
    # Powershell Community Extensions
    # https://github.com/Pscx/Pscx
    'Pscx' = @{'import' = $False
               'import_params' = @{}
               'install_params' = @{'-Scope'='CurrentUser'
                                    '-AllowClobber'=$True}}
    # VSSetup
    # https://www.powershellgallery.com/packages/VSSetup/2.0.1.32208
    'VSSetup' = @{'import' = $false
                  'import_params' = @{}
                  'install_params' = @{'-Scope' = 'CurrentUser'}}
    # PSReadLine (Note: now included with PowerShell 5+)
    # https://github.com/lzybkr/PSReadLine
    'PSReadline' = @{'import' = $True
                     'import_params' = @{}
                     'install_params' = @{'-Scope' = 'CurrentUser'}}
    # PSSudo
    # https://github.com/ecsousa/PSSudo
    'PSSudo'  =  @{'import' = $False
                   'import_params' = @{}
                   'install_params' = @{'-Scope' = 'CurrentUser'}}
    # Posh-Git
    # https://github.com/dahlbyk/posh-git
    'Posh-Git' = @{'import' = $False
                   'import_params' = @{}
                   'install_params' = @{'-Scope'='CurrentUser'
                                        '-AllowClobber'=$True}}
    # Jump.Location
    # https://github.com/tkellogg/Jump-Location
    'Jump.Location' = @{'import' = $True
                        'import_params' = @{}
                        'install_params' = @{'-Scope'='CurrentUser'}}
    # VMware.PowerClI
    # https://blogs.vmware.com/powercli/
    'VMware.PowerCLI' = @{'import'=$False
                          'import_params' = @{}
                          'install_params' = @{'-Scope'='CurrentUser'}}
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
        if (!($install_params['-Scope'] -eq 'CurrentUser') -And 
            !(Test-IsAdministrator))
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

