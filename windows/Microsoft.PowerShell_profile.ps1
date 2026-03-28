using namespace System.Management.Automation
using namespace System.Management.Automation.Language
 
if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
}

function Import-ModuleIfAvailable {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (Get-Module -ListAvailable -Name $Name) {
        Import-Module -Name $Name -ErrorAction SilentlyContinue
    }
}

# Install-Module -Name PSColors -Scope CurrentUser
Import-ModuleIfAvailable -Name 'PSColors'
#Install-Module -Name posh-git -Scope CurrentUser
Import-ModuleIfAvailable -Name 'posh-git'
Import-ModuleIfAvailable -Name 'Terminal-Icons'
#Import-Module oh-my-posh
#Import-Module z
#set-alias desktop "Desktop.ps1"
#Set-Theme ParadoxGlucose
#Set-PoshPrompt -theme "D:\Dropbox\poshv3.json"

$ompTheme = Join-Path $env:POSH_THEMES_PATH 'my_bubbles.omp.json'
if (Get-Command 'oh-my-posh' -ErrorAction SilentlyContinue) {
    if (Test-Path $ompTheme) {
        oh-my-posh init pwsh --config $ompTheme | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
    }
}


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
    param($wordToComplete, $commandAst, $cursorPosition)
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    dotnet complete --position $cursorPosition -- "$Local:ast" | ForEach-Object {
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
if (Get-Command 'Set-PSReadLineOption' -ErrorAction SilentlyContinue) {
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows

    # Ctrl+R: Pesquisa incremental reversa no hist\u00f3rico (como no bash)
    Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory

    # Ctrl+LeftArrow / Ctrl+RightArrow: Mover por palavra
    Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
    Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord

    # Ctrl+Backspace: Apaga a palavra anterior
    Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord

    # Ctrl+U: Apaga do cursor at\u00e9 o in\u00edcio da linha
    Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine

    # Ctrl+K: Apaga do cursor at\u00e9 o fim da linha
    Set-PSReadLineKeyHandler -Key Ctrl+k -Function KillLine

    # Alt+.: Insere o \u00faltimo argumento do comando anterior
    Set-PSReadLineKeyHandler -Key Alt+. -Function YankLastArg
}