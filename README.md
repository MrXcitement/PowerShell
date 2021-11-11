# PowerShell Profile (Both console and ISE versions)
This repository tracks my personal PowerShell profile files.

## Install
Use the supplied install script to link these files into your personal
PowerShell profiles folder. The script must be run with elevated permissions to
create the symbolic links.

The install script will create links to the files in this repositories
PowerShell profile folder in the ```home``` folder of this repository.

```powershell
.\install.ps1
```

## Description
There are two main PowerShell versions that this repository works with.

- The 'original' Windows PowerShell v5.1
- The cross platform PowerShell Core 7.1+

There are many different profile files used by PowerShell at startup.

There are files for the system and for the user.

The profile files that can exist in any of these folders have a specific naming convention.

```profile.ps1```

The default profile, loaded by both the console and ISE PowerShell

```Microsoft.PowerShell_profile.ps1```

The default console PowerShell profile.

```Microsoft.PowerShellISE_profile.ps1```

The default ISE PowerShell profile.

More information about the PowerShell profiles can be found here:
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
