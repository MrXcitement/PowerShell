##
# Configure the PSReadLine command line editing experience
if (Get-Module 'PSReadLine') {
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    if (Get-Module 'PSFzf') {
        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    } else {
        Set-PSReadLineKeyHandler -Key Tab -Function Complete
    }
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
}


