# install.ps1 -- Install the git config files

# Mike Barker <mike@thebarkers.com>
# November 10th, 2021

# Install-Item - Install a file/folder to the user's home folder
Function Install-Item([string]$source, [string]$target) {

    # Backup the source file/folder, if it exists and is not a link
    if ((Test-Path $source) -And (-Not (Test-SymbolicLink $source))) {
        # backup the file/folder
        Write-Warning "Backup $($source) $($source).backup"
        Move-Item -Path $source -Destination "$($source).backup"
    }

    # Create a symlink to the target file/folder, if it does not exist
    if (-Not (Test-Path $source)) {
        Write-Output "Linking: $($source) to $($target)"
        New-SymbolicLink $source $target | Out-Null
    }
}

# New-SymbolicLink - Create a new symbolic link file
Function New-SymbolicLink([string]$link, [string]$target) {
    New-Item -ItemType SymbolicLink -Path $link -Value $target -Force
}

# Test-Elevated - Test if the current powershell session is being run with elevated permisions
Function Test-Elevated() {
    return [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'
}

# Test-SymbolicLink - Test if the path is a symbolic link file
Function Test-SymbolicLink([string]$path) {
    $file = Get-Item $path -Force -ea SilentlyContinue
    Return [bool]($file.LinkType -eq "SymbolicLink")
}

# Verify the script is being run with elevated permisions
if (-Not (Test-Elevated)) {
    throw "This script must be run 'Elevated' as an Administrator"
}

# The full path to the CurrentUserCurrentHost profile files.
$profile_root = Split-Path -Parent -Path $PROFILE.CurrentUserCurrentHost

# The name of the folder that holds the profile files
$profile_dir = Split-Path -Leaf -Path $profile_root

# Create the profile dir if it does not allready exist
New-Item -Type Directory -ErrorAction Ignore -Path "$profile_root"

# Get the files and folders in this repositories profile directory
$items = Get-ChildItem ".\home\$profile_dir\*.ps1"
$items += Get-ChildItem -Directory ".\home\$profile_dir\"

# Install the files and folders to the profile root
foreach ($file in $items) {
    $link = "$profile_root\$($file.Name)"
    $source = $file.FullName
    Install-Item $link $source
}
