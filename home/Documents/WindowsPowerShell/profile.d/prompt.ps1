
##
# Configure the prompt
if (Get-Command "starship.exe" -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
} else {
    Function Prompt
    {
        $realLASTEXITCODE = $LASTEXITCODE

        $userForegroundColor='Cyan'
        $hostForegroundColor='Cyan'
        $pathForegroundColor='Yellow'

        if (Test-IsAdministrator) 
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
}
