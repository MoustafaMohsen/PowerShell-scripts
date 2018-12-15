function DeleteSelf() {
    $Path= $MyInvocation.ScriptName
    Write-Host $Path 
    Write-Host "== Script is self distructing"
    Remove-Item $Path -force
}