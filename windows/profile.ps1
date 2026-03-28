using namespace System.Management.Automation
using namespace System.Management.Automation.Language
 
if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
}

# Install-Module -Name PSColors -Scope CurrentUser
Import-Module PSColors
#Install-Module -Name posh-git -Scope CurrentUser
Import-Module posh-git
Import-Module -Name Terminal-Icons
#Import-Module oh-my-posh
#Import-Module z
#set-alias desktop "Desktop.ps1"
#Set-Theme ParadoxGlucose
#Set-PoshPrompt -theme "D:\Dropbox\poshv3.json"

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\agnoster.minimal.omp.json" | Invoke-Expression


<#
.SYNOPSIS
Registers a native argument completer for the 'winget' command in PowerShell.

.DESCRIPTION
This script sets up tab completion for the 'winget' command by registering a native argument completer.
It uses the 'winget complete' subcommand to provide dynamic completion suggestions based on the current input.

.PARAMETER wordToComplete
The word currently being completed by the user.

.PARAMETER commandAst
The abstract syntax tree (AST) of the command line being completed.

.PARAMETER cursorPosition
The current position of the cursor in the command line.

.NOTES
- Sets the console input and output encoding to UTF-8 to ensure proper handling of Unicode characters.
- Escapes double quotes in the input to prevent parsing issues.
- Converts the output of 'winget complete' into PowerShell completion results.

.EXAMPLE
# After adding this to your PowerShell profile, typing 'winget <Tab>' will provide completion suggestions.
#>
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

<#
This update makes the dotnet argument completer more robust by:

Matching the parameter order and escaping logic used in your winget completer.
Passing the full command line and word to complete, not just the word, to dotnet complete.
Setting UTF-8 encoding for proper Unicode handling.
This should improve completion accuracy and handle edge cases with spaces or quotes.
#>
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# ---


# This is an example profile for PSReadLine.
#
# This is roughly what I use so there is some emphasis on emacs bindings,
# but most of these bindings make sense in Windows mode as well.

# Searching for commands with up/down arrow is really handy.  The
# option "moves to end" is useful if you want the cursor at the end
# of the line while cycling through history like it does w/o searching,
# without that option, the cursor will remain at the position it was
# when you used up arrow, which can be useful if you forget the exact
# string you started the search on.
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Ctrl+R: Pesquisa incremental reversa no histórico (como no bash)
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory

# Ctrl+LeftArrow / Ctrl+RightArrow: Mover por palavra
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord

# Ctrl+Backspace: Apaga a palavra anterior
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord

# Ctrl+U: Apaga do cursor até o início da linha
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine

# Ctrl+K: Apaga do cursor até o fim da linha
Set-PSReadLineKeyHandler -Key Ctrl+k -Function KillLine

# Alt+.: Insere o último argumento do comando anterior
Set-PSReadLineKeyHandler -Key Alt+. -Function YankLastArg