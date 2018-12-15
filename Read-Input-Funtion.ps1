# Moustafa Mohsen 15-12-2018
function ReadInput() {
    # ==== usage example
    #$var = ReadInput -message "please enter value" -default "default value"
    # === No parameter is Mandatory
    param (
        [string]$message = "Values is",
        [string]$default = "",
        [boolean]$active = 1,
        [boolean]$view = 0

    )
    if ($active -eq $true) {  
        # if there is a default change massage style
        if (-not [string]::IsNullOrEmpty($default)) {
            [string]$message = "$message (default is [$default])"
        }
        # read host
        $result = Read-Host $message;
        # if input is empty read, reslut default value
        if ([string]::IsNullOrEmpty($result)) {
            $result = $default
        }
        # return value
        if ($view) {
            Write-Host "You Entered:$result"
        }
        return $result

    }else{
        if ($view) {
            Write-Host "You Entered:$default"
        }
        return $default
    }
}