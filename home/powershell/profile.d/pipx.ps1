# pipx.ps1 -- configure the environment for the pipx tool

# Mike Barker <mike@thebarkers.com>
# November 17th, 2023

if (Get-Command pipx -ErrorAction SilentlyContinue) {
    Set-PathVariable -AddPath "$Env:USERPROFILE\.local\bin"
}
