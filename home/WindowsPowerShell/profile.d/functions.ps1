
##
# Useful functions
Function Test-IsAdministrator 
{
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    $user_principal = New-Object Security.Principal.WindowsPrincipal $user
    $role_admin = [Security.Principal.WindowsBuiltinRole]::Administrator
    $user_principal.IsInRole($role_admin)
}

