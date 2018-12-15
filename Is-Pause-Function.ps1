# Moustafa Mohsen 15-12-2018
Function Apause(){
    param (
        [Parameter(Mandatory=$false)][string]$message,
        [Parameter(Mandatory=$false)][int]$active
    )
    [int]$_pause = 1
    if ($active -eq 0 -or 1) {
        [int]$_pause = $active
    } 
    Write-Output $message
    isPause -$_pause
}

Write-Output '
=== did it paused?
'
isPause -pause '0'

echo "stop"
pause
