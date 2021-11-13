##
# Useful functions

Function Test-Administrator() {
    if ($IsWindows) {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        $user_principal = New-Object Security.Principal.WindowsPrincipal $user
        $role_admin = [Security.Principal.WindowsBuiltinRole]::Administrator
        return $user_principal.IsInRole($role_admin)
    } else {
        return ((id -u) -eq 0)
    }
}
