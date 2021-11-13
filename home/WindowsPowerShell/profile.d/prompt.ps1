##
# Configure the prompt using the following format:
# username@hostname currentdir [git status]
# > _
Function Prompt
{
    $realLASTEXITCODE = $LASTEXITCODE

    $defaultForegroundColor = 'Gray'
    $userForegroundColor = 'Cyan'
    $hostForegroundColor = 'Cyan'
    $pathForegroundColor = 'Yellow'
    if (Test-IsAdministrator)
    {
        $userForegroundColor = 'Red'
        $hostForegroundColor = 'Red'
    }

    Write-Host($env:USERNAME) -noNewLine -ForegroundColor $userForegroundColor
    Write-Host("@") -noNewLine -ForegroundColor $defaultForegroundColor
    Write-Host($env:COMPUTERNAME) -noNewLine -ForegroundColor $hostForegroundColor
    Write-Host(" in ") -nonewline -ForegroundColor $defaultForegroundColor
    Write-Host(Convert-Path($PWD)) -nonewline -ForegroundColor $pathForegroundColor
    if (Get-Module posh-git)
    {
        Write-Host -noNewLine (Write-VcsStatus)
    }
    Write-Host("")

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "$('>' * ($nestedPromptLevel + 1)) "
}

# If the starship prompt utility is installed, use it
if (Get-Command starship -ErrorAction Ignore) {
    Invoke-Expression (&starship init powershell)
}
